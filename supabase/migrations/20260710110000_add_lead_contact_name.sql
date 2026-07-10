ALTER TABLE public.leads ADD COLUMN IF NOT EXISTS contact_name TEXT;ALTER TABLE public.customers ADD COLUMN IF NOT EXISTS contact_name TEXT;
