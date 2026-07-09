-- Add is_conversion_finalized flag to leads
ALTER TABLE public.leads
ADD COLUMN is_conversion_finalized BOOLEAN NOT NULL DEFAULT false;
