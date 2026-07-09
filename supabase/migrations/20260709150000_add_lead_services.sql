-- Create lead_services table
CREATE TABLE IF NOT EXISTS public.lead_services (
    id UUID DEFAULT extensions.uuid_generate_v4() PRIMARY KEY,
    lead_id UUID NOT NULL REFERENCES public.leads(id) ON DELETE CASCADE,
    service_id UUID NOT NULL REFERENCES public.services(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Enable RLS
ALTER TABLE public.lead_services ENABLE ROW LEVEL SECURITY;

-- Create policies for lead_services
CREATE POLICY "Enable read access for authenticated users" 
    ON public.lead_services FOR SELECT 
    TO authenticated 
    USING (true);

CREATE POLICY "Enable insert access for authenticated users" 
    ON public.lead_services FOR INSERT 
    TO authenticated 
    WITH CHECK (true);

CREATE POLICY "Enable update access for authenticated users" 
    ON public.lead_services FOR UPDATE 
    TO authenticated 
    USING (true);

CREATE POLICY "Enable delete access for authenticated users" 
    ON public.lead_services FOR DELETE 
    TO authenticated 
    USING (true);
