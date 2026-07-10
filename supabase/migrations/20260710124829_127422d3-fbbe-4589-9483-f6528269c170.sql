
-- =====================================================================
-- 1. Move is_admin / has_role to a private schema (not exposed by PostgREST)
-- =====================================================================
CREATE SCHEMA IF NOT EXISTS private;
GRANT USAGE ON SCHEMA private TO authenticated, service_role;

CREATE OR REPLACE FUNCTION private.has_role(_user_id uuid, _role public.app_role)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$ SELECT EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = _user_id AND role = _role) $$;

CREATE OR REPLACE FUNCTION private.is_admin(_uid uuid)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$ SELECT private.has_role(_uid, 'admin'::public.app_role) $$;

REVOKE ALL ON FUNCTION private.has_role(uuid, public.app_role) FROM PUBLIC;
REVOKE ALL ON FUNCTION private.is_admin(uuid) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION private.has_role(uuid, public.app_role) TO authenticated, service_role;
GRANT EXECUTE ON FUNCTION private.is_admin(uuid) TO authenticated, service_role;

-- =====================================================================
-- 2. Drop and recreate all policies that reference public.is_admin / public.has_role,
--    switching them to the private.* versions.
-- =====================================================================

-- activities
DROP POLICY IF EXISTS "act_read_admin" ON public.activities;
CREATE POLICY "act_read_admin" ON public.activities FOR SELECT TO authenticated
  USING (private.is_admin(auth.uid()));

-- user_roles
DROP POLICY IF EXISTS "roles_admin_manage" ON public.user_roles;
DROP POLICY IF EXISTS "roles_select_own" ON public.user_roles;
CREATE POLICY "roles_admin_manage" ON public.user_roles FOR ALL TO authenticated
  USING (private.is_admin(auth.uid())) WITH CHECK (private.is_admin(auth.uid()));
CREATE POLICY "roles_select_own" ON public.user_roles FOR SELECT TO authenticated
  USING ((user_id = auth.uid()) OR private.is_admin(auth.uid()));

-- profiles
DROP POLICY IF EXISTS "profiles_admin_all" ON public.profiles;
DROP POLICY IF EXISTS "profiles_select_all_auth" ON public.profiles;
DROP POLICY IF EXISTS "profiles_update_own" ON public.profiles;
CREATE POLICY "profiles_admin_all" ON public.profiles FOR ALL TO authenticated
  USING (private.is_admin(auth.uid())) WITH CHECK (private.is_admin(auth.uid()));
CREATE POLICY "profiles_select_all_auth" ON public.profiles FOR SELECT TO authenticated
  USING (true);
CREATE POLICY "profiles_update_own" ON public.profiles FOR UPDATE TO authenticated
  USING (id = auth.uid());

-- services
DROP POLICY IF EXISTS "services_admin_write" ON public.services;
CREATE POLICY "services_admin_write" ON public.services FOR ALL TO authenticated
  USING (private.is_admin(auth.uid())) WITH CHECK (private.is_admin(auth.uid()));

-- customers
DROP POLICY IF EXISTS "customers_read" ON public.customers;
DROP POLICY IF EXISTS "customers_write" ON public.customers;
CREATE POLICY "customers_read" ON public.customers FOR SELECT TO authenticated
  USING (private.is_admin(auth.uid()) OR private.has_role(auth.uid(),'sales'::public.app_role)
      OR private.has_role(auth.uid(),'project_manager'::public.app_role)
      OR private.has_role(auth.uid(),'support'::public.app_role));
CREATE POLICY "customers_write" ON public.customers FOR ALL TO authenticated
  USING (private.is_admin(auth.uid()) OR private.has_role(auth.uid(),'sales'::public.app_role))
  WITH CHECK (private.is_admin(auth.uid()) OR private.has_role(auth.uid(),'sales'::public.app_role));

-- customer_services
DROP POLICY IF EXISTS "cs_read" ON public.customer_services;
DROP POLICY IF EXISTS "cs_write" ON public.customer_services;
CREATE POLICY "cs_read" ON public.customer_services FOR SELECT TO authenticated
  USING (private.is_admin(auth.uid()) OR private.has_role(auth.uid(),'sales'::public.app_role)
      OR private.has_role(auth.uid(),'project_manager'::public.app_role)
      OR private.has_role(auth.uid(),'support'::public.app_role));
CREATE POLICY "cs_write" ON public.customer_services FOR ALL TO authenticated
  USING (private.is_admin(auth.uid()) OR private.has_role(auth.uid(),'sales'::public.app_role))
  WITH CHECK (private.is_admin(auth.uid()) OR private.has_role(auth.uid(),'sales'::public.app_role));

-- customer_timeline_events
DROP POLICY IF EXISTS "cte_read" ON public.customer_timeline_events;
DROP POLICY IF EXISTS "cte_write" ON public.customer_timeline_events;
CREATE POLICY "cte_read" ON public.customer_timeline_events FOR SELECT TO authenticated
  USING (private.is_admin(auth.uid()) OR private.has_role(auth.uid(),'sales'::public.app_role)
      OR private.has_role(auth.uid(),'project_manager'::public.app_role)
      OR private.has_role(auth.uid(),'support'::public.app_role));
CREATE POLICY "cte_write" ON public.customer_timeline_events FOR ALL TO authenticated
  USING (private.is_admin(auth.uid()) OR private.has_role(auth.uid(),'sales'::public.app_role))
  WITH CHECK (private.is_admin(auth.uid()) OR private.has_role(auth.uid(),'sales'::public.app_role));

-- leads
DROP POLICY IF EXISTS "leads_read" ON public.leads;
DROP POLICY IF EXISTS "leads_write" ON public.leads;
CREATE POLICY "leads_read" ON public.leads FOR SELECT TO authenticated
  USING (private.is_admin(auth.uid()) OR private.has_role(auth.uid(),'sales'::public.app_role));
CREATE POLICY "leads_write" ON public.leads FOR ALL TO authenticated
  USING (private.is_admin(auth.uid()) OR private.has_role(auth.uid(),'sales'::public.app_role))
  WITH CHECK (private.is_admin(auth.uid()) OR private.has_role(auth.uid(),'sales'::public.app_role));

-- projects
DROP POLICY IF EXISTS "projects_read" ON public.projects;
DROP POLICY IF EXISTS "projects_write" ON public.projects;
CREATE POLICY "projects_read" ON public.projects FOR SELECT TO authenticated
  USING (private.is_admin(auth.uid()) OR private.has_role(auth.uid(),'project_manager'::public.app_role)
      OR private.has_role(auth.uid(),'support'::public.app_role));
CREATE POLICY "projects_write" ON public.projects FOR ALL TO authenticated
  USING (private.is_admin(auth.uid()) OR private.has_role(auth.uid(),'project_manager'::public.app_role))
  WITH CHECK (private.is_admin(auth.uid()) OR private.has_role(auth.uid(),'project_manager'::public.app_role));

-- project_members
DROP POLICY IF EXISTS "pm_read" ON public.project_members;
DROP POLICY IF EXISTS "pm_write" ON public.project_members;
CREATE POLICY "pm_read" ON public.project_members FOR SELECT TO authenticated
  USING (private.is_admin(auth.uid()) OR private.has_role(auth.uid(),'project_manager'::public.app_role)
      OR private.has_role(auth.uid(),'support'::public.app_role) OR (user_id = auth.uid()));
CREATE POLICY "pm_write" ON public.project_members FOR ALL TO authenticated
  USING (private.is_admin(auth.uid()) OR private.has_role(auth.uid(),'project_manager'::public.app_role))
  WITH CHECK (private.is_admin(auth.uid()) OR private.has_role(auth.uid(),'project_manager'::public.app_role));

-- project_timeline_events
DROP POLICY IF EXISTS "pte_read" ON public.project_timeline_events;
DROP POLICY IF EXISTS "pte_write" ON public.project_timeline_events;
CREATE POLICY "pte_read" ON public.project_timeline_events FOR SELECT TO authenticated
  USING (private.is_admin(auth.uid()) OR private.has_role(auth.uid(),'project_manager'::public.app_role)
      OR private.has_role(auth.uid(),'support'::public.app_role));
CREATE POLICY "pte_write" ON public.project_timeline_events FOR ALL TO authenticated
  USING (private.is_admin(auth.uid()) OR private.has_role(auth.uid(),'project_manager'::public.app_role))
  WITH CHECK (private.is_admin(auth.uid()) OR private.has_role(auth.uid(),'project_manager'::public.app_role));

-- tickets
DROP POLICY IF EXISTS "tickets_read" ON public.tickets;
DROP POLICY IF EXISTS "tickets_write" ON public.tickets;
CREATE POLICY "tickets_read" ON public.tickets FOR SELECT TO authenticated
  USING (private.is_admin(auth.uid()) OR private.has_role(auth.uid(),'support'::public.app_role)
      OR private.has_role(auth.uid(),'project_manager'::public.app_role)
      OR private.has_role(auth.uid(),'sales'::public.app_role));
CREATE POLICY "tickets_write" ON public.tickets FOR ALL TO authenticated
  USING (private.is_admin(auth.uid()) OR private.has_role(auth.uid(),'support'::public.app_role)
      OR private.has_role(auth.uid(),'project_manager'::public.app_role))
  WITH CHECK (private.is_admin(auth.uid()) OR private.has_role(auth.uid(),'support'::public.app_role)
      OR private.has_role(auth.uid(),'project_manager'::public.app_role));

-- ticket_comments
DROP POLICY IF EXISTS "tc_read" ON public.ticket_comments;
DROP POLICY IF EXISTS "tc_write" ON public.ticket_comments;
CREATE POLICY "tc_read" ON public.ticket_comments FOR SELECT TO authenticated
  USING (private.is_admin(auth.uid()) OR private.has_role(auth.uid(),'support'::public.app_role)
      OR private.has_role(auth.uid(),'project_manager'::public.app_role)
      OR private.has_role(auth.uid(),'sales'::public.app_role));
CREATE POLICY "tc_write" ON public.ticket_comments FOR INSERT TO authenticated
  WITH CHECK ((author_id = auth.uid()) AND (private.is_admin(auth.uid())
      OR private.has_role(auth.uid(),'support'::public.app_role)
      OR private.has_role(auth.uid(),'project_manager'::public.app_role)));

-- ticket_attachments
DROP POLICY IF EXISTS "ta_read" ON public.ticket_attachments;
DROP POLICY IF EXISTS "ta_write" ON public.ticket_attachments;
CREATE POLICY "ta_read" ON public.ticket_attachments FOR SELECT TO authenticated
  USING (private.is_admin(auth.uid()) OR private.has_role(auth.uid(),'support'::public.app_role)
      OR private.has_role(auth.uid(),'project_manager'::public.app_role)
      OR private.has_role(auth.uid(),'sales'::public.app_role));
CREATE POLICY "ta_write" ON public.ticket_attachments FOR ALL TO authenticated
  USING (private.is_admin(auth.uid()) OR private.has_role(auth.uid(),'support'::public.app_role)
      OR private.has_role(auth.uid(),'project_manager'::public.app_role))
  WITH CHECK (private.is_admin(auth.uid()) OR private.has_role(auth.uid(),'support'::public.app_role)
      OR private.has_role(auth.uid(),'project_manager'::public.app_role));

-- storage.objects policies
DROP POLICY IF EXISTS "ticket_attach_delete" ON storage.objects;
DROP POLICY IF EXISTS "ticket_attach_read" ON storage.objects;
DROP POLICY IF EXISTS "ticket_attach_write" ON storage.objects;
CREATE POLICY "ticket_attach_delete" ON storage.objects FOR DELETE TO authenticated
  USING ((bucket_id = 'ticket-attachments') AND (private.is_admin(auth.uid())
      OR private.has_role(auth.uid(),'support'::public.app_role)
      OR private.has_role(auth.uid(),'project_manager'::public.app_role)));
CREATE POLICY "ticket_attach_read" ON storage.objects FOR SELECT TO authenticated
  USING ((bucket_id = 'ticket-attachments') AND (private.is_admin(auth.uid())
      OR private.has_role(auth.uid(),'support'::public.app_role)
      OR private.has_role(auth.uid(),'project_manager'::public.app_role)
      OR private.has_role(auth.uid(),'sales'::public.app_role)));
CREATE POLICY "ticket_attach_write" ON storage.objects FOR INSERT TO authenticated
  WITH CHECK ((bucket_id = 'ticket-attachments') AND (private.is_admin(auth.uid())
      OR private.has_role(auth.uid(),'support'::public.app_role)
      OR private.has_role(auth.uid(),'project_manager'::public.app_role)));

-- Now safe to drop the public versions
DROP FUNCTION IF EXISTS public.is_admin(uuid);
DROP FUNCTION IF EXISTS public.has_role(uuid, public.app_role);

-- =====================================================================
-- 3. lead_services: replace open true policies with role-scoped ones
-- =====================================================================
DROP POLICY IF EXISTS "Enable delete access for authenticated users" ON public.lead_services;
DROP POLICY IF EXISTS "Enable insert access for authenticated users" ON public.lead_services;
DROP POLICY IF EXISTS "Enable read access for authenticated users" ON public.lead_services;
DROP POLICY IF EXISTS "Enable update access for authenticated users" ON public.lead_services;

CREATE POLICY "ls_read" ON public.lead_services FOR SELECT TO authenticated
  USING (private.is_admin(auth.uid()) OR private.has_role(auth.uid(),'sales'::public.app_role));
CREATE POLICY "ls_write" ON public.lead_services FOR ALL TO authenticated
  USING (private.is_admin(auth.uid()) OR private.has_role(auth.uid(),'sales'::public.app_role))
  WITH CHECK (private.is_admin(auth.uid()) OR private.has_role(auth.uid(),'sales'::public.app_role));

-- =====================================================================
-- 4. sales: replace open true policy with role-scoped ones
-- =====================================================================
DROP POLICY IF EXISTS "Enable full access for authenticated users" ON public.sales;

CREATE POLICY "sales_read" ON public.sales FOR SELECT TO authenticated
  USING (private.is_admin(auth.uid()) OR private.has_role(auth.uid(),'sales'::public.app_role));
CREATE POLICY "sales_write" ON public.sales FOR ALL TO authenticated
  USING (private.is_admin(auth.uid()) OR private.has_role(auth.uid(),'sales'::public.app_role))
  WITH CHECK (private.is_admin(auth.uid()) OR private.has_role(auth.uid(),'sales'::public.app_role));

-- =====================================================================
-- 5. profiles: hide email / phone / leave_status from generic authenticated reads
--    via column-level privileges. Admin server code uses service_role and is unaffected.
-- =====================================================================
REVOKE SELECT ON public.profiles FROM authenticated;
GRANT SELECT (id, full_name, avatar_url, job_title, deleted_at, created_at, updated_at)
  ON public.profiles TO authenticated;

-- =====================================================================
-- 6. ticket_comments: author-scoped UPDATE and DELETE policies
-- =====================================================================
DROP POLICY IF EXISTS "tc_update" ON public.ticket_comments;
DROP POLICY IF EXISTS "tc_delete" ON public.ticket_comments;
CREATE POLICY "tc_update" ON public.ticket_comments FOR UPDATE TO authenticated
  USING (author_id = auth.uid())
  WITH CHECK (author_id = auth.uid());
CREATE POLICY "tc_delete" ON public.ticket_comments FOR DELETE TO authenticated
  USING ((author_id = auth.uid()) OR private.is_admin(auth.uid()));
