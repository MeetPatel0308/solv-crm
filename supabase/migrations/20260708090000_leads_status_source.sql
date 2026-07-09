-- =========== LEADS: simplify stage to Cold/Warm/Hot/Converted ===========
-- Old pipeline stages (lead, qualified, proposal, negotiation, won, lost) are replaced
-- with a simpler temperature model to match how the CRM team actually tracks leads.

ALTER TABLE public.leads ALTER COLUMN stage DROP DEFAULT;

ALTER TYPE public.lead_stage RENAME TO lead_stage_old;
CREATE TYPE public.lead_stage AS ENUM ('cold','warm','hot','converted');

ALTER TABLE public.leads
  ALTER COLUMN stage TYPE public.lead_stage
  USING (
    CASE stage::text
      WHEN 'lead' THEN 'cold'
      WHEN 'qualified' THEN 'warm'
      WHEN 'proposal' THEN 'hot'
      WHEN 'negotiation' THEN 'hot'
      WHEN 'won' THEN 'converted'
      WHEN 'lost' THEN 'cold'
      ELSE 'cold'
    END
  )::public.lead_stage;

ALTER TABLE public.leads ALTER COLUMN stage SET DEFAULT 'cold';
DROP TYPE public.lead_stage_old;

-- =========== LEADS: structured source (Email / Ads / Referral) ===========
CREATE TYPE public.lead_source AS ENUM ('email','ads','referral');

ALTER TABLE public.leads
  ALTER COLUMN source TYPE public.lead_source
  USING (
    CASE lower(coalesce(source, ''))
      WHEN 'email' THEN 'email'
      WHEN 'ads' THEN 'ads'
      WHEN 'referral' THEN 'referral'
      ELSE NULL
    END
  )::public.lead_source;
