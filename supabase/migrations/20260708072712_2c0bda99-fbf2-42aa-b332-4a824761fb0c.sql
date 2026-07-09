
-- =========== ENUMS ===========
CREATE TYPE public.app_role AS ENUM ('admin','sales','project_manager','support','hr');
CREATE TYPE public.customer_status AS ENUM ('cold','warm','hot','converted','lost','active');
CREATE TYPE public.lead_stage AS ENUM ('lead','qualified','proposal','negotiation','won','lost');
CREATE TYPE public.project_status AS ENUM ('planning','in_progress','testing','completed','on_hold','overdue');
CREATE TYPE public.ticket_status AS ENUM ('new','assigned','in_progress','waiting','resolved','closed');
CREATE TYPE public.ticket_priority AS ENUM ('low','medium','high','urgent');

-- =========== UPDATED_AT HELPER ===========
CREATE OR REPLACE FUNCTION public.tg_set_updated_at()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN NEW.updated_at = now(); RETURN NEW; END; $$;

-- =========== PROFILES ===========
CREATE TABLE public.profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name TEXT,
  email TEXT,
  avatar_url TEXT,
  job_title TEXT,
  phone TEXT,
  leave_status TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at TIMESTAMPTZ
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.profiles TO authenticated;
GRANT ALL ON public.profiles TO service_role;
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
CREATE TRIGGER trg_profiles_upd BEFORE UPDATE ON public.profiles FOR EACH ROW EXECUTE FUNCTION public.tg_set_updated_at();

-- =========== USER ROLES ===========
CREATE TABLE public.user_roles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  role app_role NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(user_id, role)
);
GRANT SELECT ON public.user_roles TO authenticated;
GRANT ALL ON public.user_roles TO service_role;
ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;

CREATE OR REPLACE FUNCTION public.has_role(_user_id UUID, _role app_role)
RETURNS BOOLEAN LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public
AS $$ SELECT EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = _user_id AND role = _role) $$;

CREATE OR REPLACE FUNCTION public.is_admin(_uid UUID)
RETURNS BOOLEAN LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public
AS $$ SELECT public.has_role(_uid, 'admin') $$;

-- profiles policies
CREATE POLICY "profiles_select_all_auth" ON public.profiles FOR SELECT TO authenticated USING (true);
CREATE POLICY "profiles_update_own" ON public.profiles FOR UPDATE TO authenticated USING (id = auth.uid());
CREATE POLICY "profiles_admin_all" ON public.profiles FOR ALL TO authenticated USING (public.is_admin(auth.uid())) WITH CHECK (public.is_admin(auth.uid()));

-- user_roles policies
CREATE POLICY "roles_select_own" ON public.user_roles FOR SELECT TO authenticated USING (user_id = auth.uid() OR public.is_admin(auth.uid()));
CREATE POLICY "roles_admin_manage" ON public.user_roles FOR ALL TO authenticated USING (public.is_admin(auth.uid())) WITH CHECK (public.is_admin(auth.uid()));

-- =========== TRIGGER: auto-create profile + first user = admin ===========
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
DECLARE user_count INT;
BEGIN
  INSERT INTO public.profiles (id, email, full_name)
  VALUES (NEW.id, NEW.email, COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.email));
  SELECT COUNT(*) INTO user_count FROM auth.users;
  IF user_count = 1 THEN
    INSERT INTO public.user_roles (user_id, role) VALUES (NEW.id, 'admin');
  ELSE
    INSERT INTO public.user_roles (user_id, role) VALUES (NEW.id, 'sales');
  END IF;
  RETURN NEW;
END; $$;
CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- =========== SERVICES CATALOG ===========
CREATE TABLE public.services (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT,
  parent_id UUID REFERENCES public.services(id) ON DELETE CASCADE,
  active BOOLEAN NOT NULL DEFAULT true,
  sort_order INT NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at TIMESTAMPTZ
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.services TO authenticated;
GRANT ALL ON public.services TO service_role;
ALTER TABLE public.services ENABLE ROW LEVEL SECURITY;
CREATE TRIGGER trg_services_upd BEFORE UPDATE ON public.services FOR EACH ROW EXECUTE FUNCTION public.tg_set_updated_at();
CREATE POLICY "services_select_auth" ON public.services FOR SELECT TO authenticated USING (deleted_at IS NULL);
CREATE POLICY "services_admin_write" ON public.services FOR ALL TO authenticated USING (public.is_admin(auth.uid())) WITH CHECK (public.is_admin(auth.uid()));

-- =========== CUSTOMERS ===========
CREATE TABLE public.customers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  industry TEXT,
  status customer_status NOT NULL DEFAULT 'cold',
  contact_email TEXT,
  contact_phone TEXT,
  website TEXT,
  estimated_value NUMERIC(12,2) DEFAULT 0,
  account_manager_id UUID REFERENCES public.profiles(id),
  last_contact_at TIMESTAMPTZ,
  created_by UUID REFERENCES public.profiles(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at TIMESTAMPTZ
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.customers TO authenticated;
GRANT ALL ON public.customers TO service_role;
ALTER TABLE public.customers ENABLE ROW LEVEL SECURITY;
CREATE TRIGGER trg_customers_upd BEFORE UPDATE ON public.customers FOR EACH ROW EXECUTE FUNCTION public.tg_set_updated_at();
-- Admin + Sales full, PM/Support read
CREATE POLICY "customers_read" ON public.customers FOR SELECT TO authenticated USING (
  public.is_admin(auth.uid())
  OR public.has_role(auth.uid(),'sales')
  OR public.has_role(auth.uid(),'project_manager')
  OR public.has_role(auth.uid(),'support')
);
CREATE POLICY "customers_write" ON public.customers FOR ALL TO authenticated USING (
  public.is_admin(auth.uid()) OR public.has_role(auth.uid(),'sales')
) WITH CHECK (
  public.is_admin(auth.uid()) OR public.has_role(auth.uid(),'sales')
);

-- =========== CUSTOMER SERVICES ===========
CREATE TABLE public.customer_services (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_id UUID NOT NULL REFERENCES public.customers(id) ON DELETE CASCADE,
  service_id UUID NOT NULL REFERENCES public.services(id) ON DELETE CASCADE,
  status TEXT NOT NULL DEFAULT 'active',
  start_date DATE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(customer_id, service_id)
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.customer_services TO authenticated;
GRANT ALL ON public.customer_services TO service_role;
ALTER TABLE public.customer_services ENABLE ROW LEVEL SECURITY;
CREATE POLICY "cs_read" ON public.customer_services FOR SELECT TO authenticated USING (
  public.is_admin(auth.uid()) OR public.has_role(auth.uid(),'sales')
  OR public.has_role(auth.uid(),'project_manager') OR public.has_role(auth.uid(),'support')
);
CREATE POLICY "cs_write" ON public.customer_services FOR ALL TO authenticated USING (
  public.is_admin(auth.uid()) OR public.has_role(auth.uid(),'sales')
) WITH CHECK (
  public.is_admin(auth.uid()) OR public.has_role(auth.uid(),'sales')
);

-- =========== CUSTOMER TIMELINE EVENTS ===========
CREATE TABLE public.customer_timeline_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_id UUID NOT NULL REFERENCES public.customers(id) ON DELETE CASCADE,
  stage TEXT NOT NULL,
  description TEXT,
  assigned_to UUID REFERENCES public.profiles(id),
  event_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.customer_timeline_events TO authenticated;
GRANT ALL ON public.customer_timeline_events TO service_role;
ALTER TABLE public.customer_timeline_events ENABLE ROW LEVEL SECURITY;
CREATE POLICY "cte_read" ON public.customer_timeline_events FOR SELECT TO authenticated USING (
  public.is_admin(auth.uid()) OR public.has_role(auth.uid(),'sales')
  OR public.has_role(auth.uid(),'project_manager') OR public.has_role(auth.uid(),'support')
);
CREATE POLICY "cte_write" ON public.customer_timeline_events FOR ALL TO authenticated USING (
  public.is_admin(auth.uid()) OR public.has_role(auth.uid(),'sales')
) WITH CHECK (
  public.is_admin(auth.uid()) OR public.has_role(auth.uid(),'sales')
);

-- =========== LEADS ===========
CREATE TABLE public.leads (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  company TEXT,
  email TEXT,
  phone TEXT,
  stage lead_stage NOT NULL DEFAULT 'lead',
  value NUMERIC(12,2) DEFAULT 0,
  source TEXT,
  assigned_to UUID REFERENCES public.profiles(id),
  customer_id UUID REFERENCES public.customers(id),
  notes TEXT,
  created_by UUID REFERENCES public.profiles(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  converted_at TIMESTAMPTZ,
  deleted_at TIMESTAMPTZ
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.leads TO authenticated;
GRANT ALL ON public.leads TO service_role;
ALTER TABLE public.leads ENABLE ROW LEVEL SECURITY;
CREATE TRIGGER trg_leads_upd BEFORE UPDATE ON public.leads FOR EACH ROW EXECUTE FUNCTION public.tg_set_updated_at();
CREATE POLICY "leads_read" ON public.leads FOR SELECT TO authenticated USING (
  public.is_admin(auth.uid()) OR public.has_role(auth.uid(),'sales')
);
CREATE POLICY "leads_write" ON public.leads FOR ALL TO authenticated USING (
  public.is_admin(auth.uid()) OR public.has_role(auth.uid(),'sales')
) WITH CHECK (
  public.is_admin(auth.uid()) OR public.has_role(auth.uid(),'sales')
);

-- =========== PROJECTS ===========
CREATE TABLE public.projects (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT,
  customer_id UUID REFERENCES public.customers(id) ON DELETE SET NULL,
  status project_status NOT NULL DEFAULT 'planning',
  progress INT NOT NULL DEFAULT 0 CHECK (progress BETWEEN 0 AND 100),
  start_date DATE,
  deadline DATE,
  project_manager_id UUID REFERENCES public.profiles(id),
  created_by UUID REFERENCES public.profiles(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at TIMESTAMPTZ
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.projects TO authenticated;
GRANT ALL ON public.projects TO service_role;
ALTER TABLE public.projects ENABLE ROW LEVEL SECURITY;
CREATE TRIGGER trg_projects_upd BEFORE UPDATE ON public.projects FOR EACH ROW EXECUTE FUNCTION public.tg_set_updated_at();
CREATE POLICY "projects_read" ON public.projects FOR SELECT TO authenticated USING (
  public.is_admin(auth.uid()) OR public.has_role(auth.uid(),'project_manager')
  OR public.has_role(auth.uid(),'support')
);
CREATE POLICY "projects_write" ON public.projects FOR ALL TO authenticated USING (
  public.is_admin(auth.uid()) OR public.has_role(auth.uid(),'project_manager')
) WITH CHECK (
  public.is_admin(auth.uid()) OR public.has_role(auth.uid(),'project_manager')
);

-- =========== PROJECT MEMBERS ===========
CREATE TABLE public.project_members (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES public.projects(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  role_label TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(project_id, user_id)
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.project_members TO authenticated;
GRANT ALL ON public.project_members TO service_role;
ALTER TABLE public.project_members ENABLE ROW LEVEL SECURITY;
CREATE POLICY "pm_read" ON public.project_members FOR SELECT TO authenticated USING (
  public.is_admin(auth.uid()) OR public.has_role(auth.uid(),'project_manager')
  OR public.has_role(auth.uid(),'support') OR user_id = auth.uid()
);
CREATE POLICY "pm_write" ON public.project_members FOR ALL TO authenticated USING (
  public.is_admin(auth.uid()) OR public.has_role(auth.uid(),'project_manager')
) WITH CHECK (
  public.is_admin(auth.uid()) OR public.has_role(auth.uid(),'project_manager')
);

-- =========== PROJECT TIMELINE EVENTS ===========
CREATE TABLE public.project_timeline_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES public.projects(id) ON DELETE CASCADE,
  stage TEXT NOT NULL,
  notes TEXT,
  completed_by UUID REFERENCES public.profiles(id),
  event_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.project_timeline_events TO authenticated;
GRANT ALL ON public.project_timeline_events TO service_role;
ALTER TABLE public.project_timeline_events ENABLE ROW LEVEL SECURITY;
CREATE POLICY "pte_read" ON public.project_timeline_events FOR SELECT TO authenticated USING (
  public.is_admin(auth.uid()) OR public.has_role(auth.uid(),'project_manager') OR public.has_role(auth.uid(),'support')
);
CREATE POLICY "pte_write" ON public.project_timeline_events FOR ALL TO authenticated USING (
  public.is_admin(auth.uid()) OR public.has_role(auth.uid(),'project_manager')
) WITH CHECK (
  public.is_admin(auth.uid()) OR public.has_role(auth.uid(),'project_manager')
);

-- =========== TICKETS ===========
CREATE TABLE public.tickets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  ticket_code TEXT UNIQUE,
  title TEXT NOT NULL,
  description TEXT,
  customer_id UUID REFERENCES public.customers(id) ON DELETE SET NULL,
  project_id UUID REFERENCES public.projects(id) ON DELETE SET NULL,
  priority ticket_priority NOT NULL DEFAULT 'medium',
  status ticket_status NOT NULL DEFAULT 'new',
  assigned_to UUID REFERENCES public.profiles(id),
  created_by UUID REFERENCES public.profiles(id),
  due_date DATE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  resolved_at TIMESTAMPTZ,
  deleted_at TIMESTAMPTZ
);
CREATE SEQUENCE public.tickets_seq START 1000;
CREATE OR REPLACE FUNCTION public.set_ticket_code()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN IF NEW.ticket_code IS NULL THEN NEW.ticket_code := 'T-' || nextval('public.tickets_seq'); END IF; RETURN NEW; END; $$;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.tickets TO authenticated;
GRANT ALL ON public.tickets TO service_role;
GRANT USAGE ON SEQUENCE public.tickets_seq TO authenticated;
ALTER TABLE public.tickets ENABLE ROW LEVEL SECURITY;
CREATE TRIGGER trg_tickets_upd BEFORE UPDATE ON public.tickets FOR EACH ROW EXECUTE FUNCTION public.tg_set_updated_at();
CREATE TRIGGER trg_tickets_code BEFORE INSERT ON public.tickets FOR EACH ROW EXECUTE FUNCTION public.set_ticket_code();
CREATE POLICY "tickets_read" ON public.tickets FOR SELECT TO authenticated USING (
  public.is_admin(auth.uid()) OR public.has_role(auth.uid(),'support')
  OR public.has_role(auth.uid(),'project_manager') OR public.has_role(auth.uid(),'sales')
);
CREATE POLICY "tickets_write" ON public.tickets FOR ALL TO authenticated USING (
  public.is_admin(auth.uid()) OR public.has_role(auth.uid(),'support') OR public.has_role(auth.uid(),'project_manager')
) WITH CHECK (
  public.is_admin(auth.uid()) OR public.has_role(auth.uid(),'support') OR public.has_role(auth.uid(),'project_manager')
);

-- =========== TICKET COMMENTS ===========
CREATE TABLE public.ticket_comments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  ticket_id UUID NOT NULL REFERENCES public.tickets(id) ON DELETE CASCADE,
  author_id UUID REFERENCES public.profiles(id),
  body TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.ticket_comments TO authenticated;
GRANT ALL ON public.ticket_comments TO service_role;
ALTER TABLE public.ticket_comments ENABLE ROW LEVEL SECURITY;
CREATE POLICY "tc_read" ON public.ticket_comments FOR SELECT TO authenticated USING (
  public.is_admin(auth.uid()) OR public.has_role(auth.uid(),'support')
  OR public.has_role(auth.uid(),'project_manager') OR public.has_role(auth.uid(),'sales')
);
CREATE POLICY "tc_write" ON public.ticket_comments FOR INSERT TO authenticated WITH CHECK (
  author_id = auth.uid() AND (
    public.is_admin(auth.uid()) OR public.has_role(auth.uid(),'support') OR public.has_role(auth.uid(),'project_manager')
  )
);

-- =========== TICKET ATTACHMENTS ===========
CREATE TABLE public.ticket_attachments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  ticket_id UUID NOT NULL REFERENCES public.tickets(id) ON DELETE CASCADE,
  file_name TEXT NOT NULL,
  storage_path TEXT NOT NULL,
  content_type TEXT,
  size_bytes BIGINT,
  uploaded_by UUID REFERENCES public.profiles(id),
  uploaded_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.ticket_attachments TO authenticated;
GRANT ALL ON public.ticket_attachments TO service_role;
ALTER TABLE public.ticket_attachments ENABLE ROW LEVEL SECURITY;
CREATE POLICY "ta_read" ON public.ticket_attachments FOR SELECT TO authenticated USING (
  public.is_admin(auth.uid()) OR public.has_role(auth.uid(),'support')
  OR public.has_role(auth.uid(),'project_manager') OR public.has_role(auth.uid(),'sales')
);
CREATE POLICY "ta_write" ON public.ticket_attachments FOR ALL TO authenticated USING (
  public.is_admin(auth.uid()) OR public.has_role(auth.uid(),'support') OR public.has_role(auth.uid(),'project_manager')
) WITH CHECK (
  public.is_admin(auth.uid()) OR public.has_role(auth.uid(),'support') OR public.has_role(auth.uid(),'project_manager')
);

-- =========== ACTIVITIES ===========
CREATE TABLE public.activities (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  actor_id UUID REFERENCES public.profiles(id),
  entity_type TEXT NOT NULL,
  entity_id UUID,
  action TEXT NOT NULL,
  metadata JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT ON public.activities TO authenticated;
GRANT ALL ON public.activities TO service_role;
ALTER TABLE public.activities ENABLE ROW LEVEL SECURITY;
CREATE POLICY "act_read_admin" ON public.activities FOR SELECT TO authenticated USING (public.is_admin(auth.uid()));
CREATE POLICY "act_insert" ON public.activities FOR INSERT TO authenticated WITH CHECK (actor_id = auth.uid());

-- =========== NOTIFICATIONS ===========
CREATE TABLE public.notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  body TEXT,
  link TEXT,
  read_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.notifications TO authenticated;
GRANT ALL ON public.notifications TO service_role;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
CREATE POLICY "notif_own" ON public.notifications FOR ALL TO authenticated USING (user_id = auth.uid()) WITH CHECK (user_id = auth.uid());

-- =========== SEED SERVICES ===========
INSERT INTO public.services (name, sort_order) VALUES
 ('Website Development', 1),
 ('Hosting', 2),
 ('Marketing', 3),
 ('Sales App', 4);
INSERT INTO public.services (name, parent_id, sort_order)
SELECT 'KIBO', NULL, 5;
