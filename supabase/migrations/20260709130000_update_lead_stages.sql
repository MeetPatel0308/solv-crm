
ALTER TYPE public.lead_stage RENAME TO lead_stage_old;
CREATE TYPE public.lead_stage AS ENUM ('cold', 'warm', 'hot', 'converted', 'lost');

ALTER TABLE public.leads 
  ALTER COLUMN stage TYPE public.lead_stage 
  USING (
    CASE stage::text 
      WHEN 'lead' THEN 'cold'::public.lead_stage
      WHEN 'qualified' THEN 'warm'::public.lead_stage
      WHEN 'proposal' THEN 'hot'::public.lead_stage
      WHEN 'negotiation' THEN 'hot'::public.lead_stage
      WHEN 'won' THEN 'converted'::public.lead_stage
      WHEN 'lost' THEN 'lost'::public.lead_stage
      ELSE 'cold'::public.lead_stage
    END
  );

DROP TYPE public.lead_stage_old;

ALTER TABLE public.leads ADD COLUMN cold_at TIMESTAMPTZ;
ALTER TABLE public.leads ADD COLUMN warm_at TIMESTAMPTZ;
ALTER TABLE public.leads ADD COLUMN hot_at TIMESTAMPTZ;
ALTER TABLE public.leads ADD COLUMN lost_at TIMESTAMPTZ;

-- Reload schema cache
NOTIFY pgrst, 'reload schema';
