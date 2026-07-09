
ALTER TYPE public.lead_stage RENAME TO lead_stage_old;
CREATE TYPE public.lead_stage AS ENUM ('lead_created', 'cold', 'warm', 'hot', 'proposal', 'negotiation', 'converted', 'lost');

ALTER TABLE public.leads ALTER COLUMN stage DROP DEFAULT;

ALTER TABLE public.leads 
  ALTER COLUMN stage TYPE public.lead_stage 
  USING stage::text::public.lead_stage;

ALTER TABLE public.leads ALTER COLUMN stage SET DEFAULT 'lead_created'::public.lead_stage;

DROP TYPE public.lead_stage_old;

ALTER TABLE public.leads ADD COLUMN lead_created_at TIMESTAMPTZ DEFAULT now();
ALTER TABLE public.leads ADD COLUMN proposal_at TIMESTAMPTZ;
ALTER TABLE public.leads ADD COLUMN negotiation_at TIMESTAMPTZ;

-- Reload schema cache
NOTIFY pgrst, 'reload schema';
