
-- ==========================================
-- DEMO SEED DATA FOR SOLV CRM & ERP
-- ==========================================
-- WARNING: This script assumes tables are empty or will insert ignoring conflicts.

-- 1. Create Users
-- We insert into auth.users directly. Note: these users cannot log in.
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at) 
VALUES ('88c67cb6-eca6-4385-987b-36785d3c4231', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'alice.sales@example.com', '', now(), now(), now())
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.profiles (id, full_name, email, job_title, created_at, updated_at) 
VALUES ('88c67cb6-eca6-4385-987b-36785d3c4231', 'Alice Smith', 'alice.sales@example.com', 'Sales Manager', now(), now())
ON CONFLICT (id) DO UPDATE SET full_name = EXCLUDED.full_name, job_title = EXCLUDED.job_title;
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at) 
VALUES ('43e399c1-a1c1-4a88-ac66-889d6d425848', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'bob.account@example.com', '', now(), now(), now())
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.profiles (id, full_name, email, job_title, created_at, updated_at) 
VALUES ('43e399c1-a1c1-4a88-ac66-889d6d425848', 'Bob Johnson', 'bob.account@example.com', 'Account Manager', now(), now())
ON CONFLICT (id) DO UPDATE SET full_name = EXCLUDED.full_name, job_title = EXCLUDED.job_title;
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at) 
VALUES ('fdadd2f9-a794-4826-af13-2ae475f2a54c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'charlie.tech@example.com', '', now(), now(), now())
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.profiles (id, full_name, email, job_title, created_at, updated_at) 
VALUES ('fdadd2f9-a794-4826-af13-2ae475f2a54c', 'Charlie Davis', 'charlie.tech@example.com', 'Lead Developer', now(), now())
ON CONFLICT (id) DO UPDATE SET full_name = EXCLUDED.full_name, job_title = EXCLUDED.job_title;

-- 2. Services
INSERT INTO public.services (id, name, created_at, updated_at) VALUES ('14111771-8366-4b11-990f-d4ac5c23042f', 'KIBO', now(), now()) ON CONFLICT DO NOTHING;
INSERT INTO public.services (id, name, created_at, updated_at) VALUES ('6a785978-3b44-42cd-83f3-2c4b54b3ba8b', 'AI Sales App', now(), now()) ON CONFLICT DO NOTHING;
INSERT INTO public.services (id, name, created_at, updated_at) VALUES ('1389b058-bc71-4358-b965-32c93405d0cc', 'Website Development', now(), now()) ON CONFLICT DO NOTHING;
INSERT INTO public.services (id, name, created_at, updated_at) VALUES ('6d07a5ab-8992-42ed-b839-36fd308404c1', 'Hosting', now(), now()) ON CONFLICT DO NOTHING;
INSERT INTO public.services (id, name, created_at, updated_at) VALUES ('215a13db-85bc-40ad-b52e-4071cca84390', 'SEO', now(), now()) ON CONFLICT DO NOTHING;
INSERT INTO public.services (id, name, created_at, updated_at) VALUES ('9d03521c-add3-4009-9bca-7d32507804fa', 'Meta Ads Management', now(), now()) ON CONFLICT DO NOTHING;
INSERT INTO public.services (id, name, created_at, updated_at) VALUES ('a7e3ecea-0d61-4e1f-ab90-c6fdf3432255', 'Google Ads Management', now(), now()) ON CONFLICT DO NOTHING;
INSERT INTO public.services (id, name, created_at, updated_at) VALUES ('f6d10cc9-9841-4b73-9664-8e3f9196e7ff', 'Broadcast Messaging', now(), now()) ON CONFLICT DO NOTHING;

-- 3. Customers, Sales & Customer Services
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('c52f2699-501d-4955-a305-5d7297bd5513', 'Acme Corp', 'contact@acme corp.com', 'Finance', '88c67cb6-eca6-4385-987b-36785d3c4231', 'active', now() - interval '31 days');
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('c52f2699-501d-4955-a305-5d7297bd5513', '215a13db-85bc-40ad-b52e-4071cca84390', 'SEO', 'one-off', 2495, 'active', current_date, now() - interval '4 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('c52f2699-501d-4955-a305-5d7297bd5513', '215a13db-85bc-40ad-b52e-4071cca84390', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('c2370bfd-6567-4b0a-8d87-4b4c24220e90', 'Globex Corporation', 'contact@globex corporation.com', 'Healthcare', '43e399c1-a1c1-4a88-ac66-889d6d425848', 'active', now() - interval '87 days');
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('c2370bfd-6567-4b0a-8d87-4b4c24220e90', '215a13db-85bc-40ad-b52e-4071cca84390', 'SEO', 'one-off', 5553, 'active', current_date, now() - interval '16 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('c2370bfd-6567-4b0a-8d87-4b4c24220e90', '215a13db-85bc-40ad-b52e-4071cca84390', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('c2370bfd-6567-4b0a-8d87-4b4c24220e90', 'f6d10cc9-9841-4b73-9664-8e3f9196e7ff', 'Broadcast Messaging', 'retainer', 584, 'active', current_date, now() - interval '1 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('c2370bfd-6567-4b0a-8d87-4b4c24220e90', 'f6d10cc9-9841-4b73-9664-8e3f9196e7ff', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('c2370bfd-6567-4b0a-8d87-4b4c24220e90', '6a785978-3b44-42cd-83f3-2c4b54b3ba8b', 'AI Sales App', 'retainer', 1146, 'active', current_date, now() - interval '5 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('c2370bfd-6567-4b0a-8d87-4b4c24220e90', '6a785978-3b44-42cd-83f3-2c4b54b3ba8b', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('31cd80b1-7f01-4a9f-aed2-259a0af098d4', 'Soylent Corp', 'contact@soylent corp.com', 'Technology', '88c67cb6-eca6-4385-987b-36785d3c4231', 'active', now() - interval '28 days');
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('31cd80b1-7f01-4a9f-aed2-259a0af098d4', '9d03521c-add3-4009-9bca-7d32507804fa', 'Meta Ads Management', 'retainer', 577, 'active', current_date, now() - interval '5 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('31cd80b1-7f01-4a9f-aed2-259a0af098d4', '9d03521c-add3-4009-9bca-7d32507804fa', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('31cd80b1-7f01-4a9f-aed2-259a0af098d4', '14111771-8366-4b11-990f-d4ac5c23042f', 'KIBO', 'retainer', 1013, 'active', current_date, now() - interval '5 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('31cd80b1-7f01-4a9f-aed2-259a0af098d4', '14111771-8366-4b11-990f-d4ac5c23042f', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('de068994-bc6c-4bcf-9879-80e7dc0b2c57', 'Initech', 'contact@initech.com', 'Healthcare', '88c67cb6-eca6-4385-987b-36785d3c4231', 'active', now() - interval '54 days');
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('de068994-bc6c-4bcf-9879-80e7dc0b2c57', '6a785978-3b44-42cd-83f3-2c4b54b3ba8b', 'AI Sales App', 'one-off', 4664, 'active', current_date, now() - interval '29 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('de068994-bc6c-4bcf-9879-80e7dc0b2c57', '6a785978-3b44-42cd-83f3-2c4b54b3ba8b', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('de068994-bc6c-4bcf-9879-80e7dc0b2c57', '1389b058-bc71-4358-b965-32c93405d0cc', 'Website Development', 'retainer', 1490, 'active', current_date, now() - interval '14 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('de068994-bc6c-4bcf-9879-80e7dc0b2c57', '1389b058-bc71-4358-b965-32c93405d0cc', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('836b73ec-507d-4bb4-ac7f-c318a58dc0a5', 'Umbrella Corporation', 'contact@umbrella corporation.com', 'Retail', '43e399c1-a1c1-4a88-ac66-889d6d425848', 'active', now() - interval '59 days');
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('836b73ec-507d-4bb4-ac7f-c318a58dc0a5', '6a785978-3b44-42cd-83f3-2c4b54b3ba8b', 'AI Sales App', 'retainer', 555, 'active', current_date, now() - interval '5 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('836b73ec-507d-4bb4-ac7f-c318a58dc0a5', '6a785978-3b44-42cd-83f3-2c4b54b3ba8b', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('4b3ad919-bfed-4560-b0eb-da5a06a50e10', 'Stark Industries', 'contact@stark industries.com', 'Retail', '43e399c1-a1c1-4a88-ac66-889d6d425848', 'active', now() - interval '76 days');
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('4b3ad919-bfed-4560-b0eb-da5a06a50e10', '9d03521c-add3-4009-9bca-7d32507804fa', 'Meta Ads Management', 'retainer', 347, 'active', current_date, now() - interval '22 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('4b3ad919-bfed-4560-b0eb-da5a06a50e10', '9d03521c-add3-4009-9bca-7d32507804fa', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('bf79d99d-f439-4bba-9121-8075f9d559e8', 'Wayne Enterprises', 'contact@wayne enterprises.com', 'Healthcare', '88c67cb6-eca6-4385-987b-36785d3c4231', 'active', now() - interval '88 days');
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('bf79d99d-f439-4bba-9121-8075f9d559e8', '6a785978-3b44-42cd-83f3-2c4b54b3ba8b', 'AI Sales App', 'retainer', 811, 'active', current_date, now() - interval '24 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('bf79d99d-f439-4bba-9121-8075f9d559e8', '6a785978-3b44-42cd-83f3-2c4b54b3ba8b', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('bf79d99d-f439-4bba-9121-8075f9d559e8', 'a7e3ecea-0d61-4e1f-ab90-c6fdf3432255', 'Google Ads Management', 'one-off', 8613, 'active', current_date, now() - interval '7 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('bf79d99d-f439-4bba-9121-8075f9d559e8', 'a7e3ecea-0d61-4e1f-ab90-c6fdf3432255', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('0c212f74-feda-48c4-b720-7240adc94e43', 'Cyberdyne Systems', 'contact@cyberdyne systems.com', 'Real Estate', 'fdadd2f9-a794-4826-af13-2ae475f2a54c', 'active', now() - interval '37 days');
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('0c212f74-feda-48c4-b720-7240adc94e43', '6d07a5ab-8992-42ed-b839-36fd308404c1', 'Hosting', 'retainer', 632, 'active', current_date, now() - interval '26 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('0c212f74-feda-48c4-b720-7240adc94e43', '6d07a5ab-8992-42ed-b839-36fd308404c1', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('bfa0b86c-dfa9-4a9f-9d6b-9d6e71d0e30d', 'Massive Dynamic', 'contact@massive dynamic.com', 'Education', '88c67cb6-eca6-4385-987b-36785d3c4231', 'active', now() - interval '65 days');
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('bfa0b86c-dfa9-4a9f-9d6b-9d6e71d0e30d', '6d07a5ab-8992-42ed-b839-36fd308404c1', 'Hosting', 'one-off', 9416, 'active', current_date, now() - interval '21 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('bfa0b86c-dfa9-4a9f-9d6b-9d6e71d0e30d', '6d07a5ab-8992-42ed-b839-36fd308404c1', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('818d51aa-3da8-4ec5-a186-80ae46f4a140', 'Genco Pura Olive Oil', 'contact@genco pura olive oil.com', 'Logistics', 'fdadd2f9-a794-4826-af13-2ae475f2a54c', 'active', now() - interval '55 days');
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('818d51aa-3da8-4ec5-a186-80ae46f4a140', '6d07a5ab-8992-42ed-b839-36fd308404c1', 'Hosting', 'one-off', 4210, 'active', current_date, now() - interval '18 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('818d51aa-3da8-4ec5-a186-80ae46f4a140', '6d07a5ab-8992-42ed-b839-36fd308404c1', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('818d51aa-3da8-4ec5-a186-80ae46f4a140', '14111771-8366-4b11-990f-d4ac5c23042f', 'KIBO', 'retainer', 483, 'active', current_date, now() - interval '24 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('818d51aa-3da8-4ec5-a186-80ae46f4a140', '14111771-8366-4b11-990f-d4ac5c23042f', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('05daed82-2813-40c7-b775-96ee91f58772', 'LexCorp', 'contact@lexcorp.com', 'Finance', '88c67cb6-eca6-4385-987b-36785d3c4231', 'active', now() - interval '92 days');
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('05daed82-2813-40c7-b775-96ee91f58772', '6d07a5ab-8992-42ed-b839-36fd308404c1', 'Hosting', 'retainer', 674, 'active', current_date, now() - interval '11 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('05daed82-2813-40c7-b775-96ee91f58772', '6d07a5ab-8992-42ed-b839-36fd308404c1', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('05daed82-2813-40c7-b775-96ee91f58772', '9d03521c-add3-4009-9bca-7d32507804fa', 'Meta Ads Management', 'one-off', 7342, 'active', current_date, now() - interval '10 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('05daed82-2813-40c7-b775-96ee91f58772', '9d03521c-add3-4009-9bca-7d32507804fa', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('05daed82-2813-40c7-b775-96ee91f58772', 'f6d10cc9-9841-4b73-9664-8e3f9196e7ff', 'Broadcast Messaging', 'one-off', 7005, 'active', current_date, now() - interval '16 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('05daed82-2813-40c7-b775-96ee91f58772', 'f6d10cc9-9841-4b73-9664-8e3f9196e7ff', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('b1236ba5-0b5a-44c8-ae37-ca40cda75480', 'Oceanic Airlines', 'contact@oceanic airlines.com', 'Logistics', 'fdadd2f9-a794-4826-af13-2ae475f2a54c', 'active', now() - interval '80 days');
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('b1236ba5-0b5a-44c8-ae37-ca40cda75480', '6a785978-3b44-42cd-83f3-2c4b54b3ba8b', 'AI Sales App', 'retainer', 1241, 'active', current_date, now() - interval '22 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('b1236ba5-0b5a-44c8-ae37-ca40cda75480', '6a785978-3b44-42cd-83f3-2c4b54b3ba8b', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('33134382-5980-4a50-9843-cbf2123797a6', 'Wonka Industries', 'contact@wonka industries.com', 'Retail', 'fdadd2f9-a794-4826-af13-2ae475f2a54c', 'active', now() - interval '29 days');
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('33134382-5980-4a50-9843-cbf2123797a6', '14111771-8366-4b11-990f-d4ac5c23042f', 'KIBO', 'one-off', 6654, 'active', current_date, now() - interval '16 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('33134382-5980-4a50-9843-cbf2123797a6', '14111771-8366-4b11-990f-d4ac5c23042f', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('33134382-5980-4a50-9843-cbf2123797a6', 'a7e3ecea-0d61-4e1f-ab90-c6fdf3432255', 'Google Ads Management', 'one-off', 6999, 'active', current_date, now() - interval '25 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('33134382-5980-4a50-9843-cbf2123797a6', 'a7e3ecea-0d61-4e1f-ab90-c6fdf3432255', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('33134382-5980-4a50-9843-cbf2123797a6', '6d07a5ab-8992-42ed-b839-36fd308404c1', 'Hosting', 'retainer', 950, 'active', current_date, now() - interval '24 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('33134382-5980-4a50-9843-cbf2123797a6', '6d07a5ab-8992-42ed-b839-36fd308404c1', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('63fc56fd-9f22-43a6-96ab-ee5fc0624ec3', 'Oscorp', 'contact@oscorp.com', 'Healthcare', '43e399c1-a1c1-4a88-ac66-889d6d425848', 'active', now() - interval '53 days');
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('63fc56fd-9f22-43a6-96ab-ee5fc0624ec3', '14111771-8366-4b11-990f-d4ac5c23042f', 'KIBO', 'one-off', 4392, 'active', current_date, now() - interval '15 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('63fc56fd-9f22-43a6-96ab-ee5fc0624ec3', '14111771-8366-4b11-990f-d4ac5c23042f', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('62b62dbe-37f6-46fb-a780-3e513609d8cb', 'Hooli', 'contact@hooli.com', 'Healthcare', '88c67cb6-eca6-4385-987b-36785d3c4231', 'active', now() - interval '39 days');
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('62b62dbe-37f6-46fb-a780-3e513609d8cb', '6d07a5ab-8992-42ed-b839-36fd308404c1', 'Hosting', 'one-off', 5416, 'active', current_date, now() - interval '18 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('62b62dbe-37f6-46fb-a780-3e513609d8cb', '6d07a5ab-8992-42ed-b839-36fd308404c1', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('62b62dbe-37f6-46fb-a780-3e513609d8cb', 'f6d10cc9-9841-4b73-9664-8e3f9196e7ff', 'Broadcast Messaging', 'retainer', 767, 'active', current_date, now() - interval '2 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('62b62dbe-37f6-46fb-a780-3e513609d8cb', 'f6d10cc9-9841-4b73-9664-8e3f9196e7ff', 'active', current_date, now());

-- 4. Leads & Lead Services
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('e266acdd-1930-45d7-899e-aba04e4ff4ed', 'Contact 15', 'Pied Piper (Lead)', 'contact15@example.com', 'warm', 628, 'Social Media', 'fdadd2f9-a794-4826-af13-2ae475f2a54c', NULL, NULL, NULL, now() - interval '19 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('e266acdd-1930-45d7-899e-aba04e4ff4ed', 'a7e3ecea-0d61-4e1f-ab90-c6fdf3432255');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('e266acdd-1930-45d7-899e-aba04e4ff4ed', '6d07a5ab-8992-42ed-b839-36fd308404c1');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('14394f55-2234-4b3d-8f5d-92cf1f659aad', 'Contact 16', 'Dunder Mifflin (Lead)', 'contact16@example.com', 'warm', 2709, 'Trade Show', '43e399c1-a1c1-4a88-ac66-889d6d425848', NULL, NULL, NULL, now() - interval '18 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('14394f55-2234-4b3d-8f5d-92cf1f659aad', '6a785978-3b44-42cd-83f3-2c4b54b3ba8b');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('14394f55-2234-4b3d-8f5d-92cf1f659aad', '215a13db-85bc-40ad-b52e-4071cca84390');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('ef844b94-8977-4568-8a8c-cf4748e66620', 'Contact 17', 'Massive Dynamic', 'contact17@example.com', 'proposal', 4586, 'Referral', '88c67cb6-eca6-4385-987b-36785d3c4231', NULL, NULL, NULL, now() - interval '15 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('ef844b94-8977-4568-8a8c-cf4748e66620', '9d03521c-add3-4009-9bca-7d32507804fa');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('67d03439-f5ce-43c0-b86a-e1dd88d02292', 'Contact 18', 'Wayne Enterprises', 'contact18@example.com', 'hot', 2461, 'Social Media', '43e399c1-a1c1-4a88-ac66-889d6d425848', NULL, NULL, NULL, now() - interval '13 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('67d03439-f5ce-43c0-b86a-e1dd88d02292', '215a13db-85bc-40ad-b52e-4071cca84390');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('67d03439-f5ce-43c0-b86a-e1dd88d02292', '9d03521c-add3-4009-9bca-7d32507804fa');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('103a69f6-e72a-4cec-9982-4ad134b10e4d', 'Contact 19', 'LexCorp', 'contact19@example.com', 'lost', 2326, 'Referral', '43e399c1-a1c1-4a88-ac66-889d6d425848', NULL, now() - interval '3 days', 'No Response', now() - interval '11 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('103a69f6-e72a-4cec-9982-4ad134b10e4d', 'a7e3ecea-0d61-4e1f-ab90-c6fdf3432255');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('f7ec767d-a62c-478f-a896-b67e29fd17c9', 'Contact 20', 'Genco Pura Olive Oil', 'contact20@example.com', 'proposal', 1546, 'Cold Call', '43e399c1-a1c1-4a88-ac66-889d6d425848', NULL, NULL, NULL, now() - interval '26 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('f7ec767d-a62c-478f-a896-b67e29fd17c9', 'f6d10cc9-9841-4b73-9664-8e3f9196e7ff');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('f7ec767d-a62c-478f-a896-b67e29fd17c9', '6a785978-3b44-42cd-83f3-2c4b54b3ba8b');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('f7ec767d-a62c-478f-a896-b67e29fd17c9', '9d03521c-add3-4009-9bca-7d32507804fa');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('6a279144-638e-428f-9fb1-e4a9693b0f0b', 'Contact 21', 'Virtucon (Lead)', 'contact21@example.com', 'converted', 3168, 'Trade Show', 'fdadd2f9-a794-4826-af13-2ae475f2a54c', now() - interval '1 days', NULL, NULL, now() - interval '15 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('6a279144-638e-428f-9fb1-e4a9693b0f0b', '6a785978-3b44-42cd-83f3-2c4b54b3ba8b');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('6a279144-638e-428f-9fb1-e4a9693b0f0b', '1389b058-bc71-4358-b965-32c93405d0cc');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('e3e3080e-835f-4d78-ab15-b38c0561569e', 'Contact 22', 'Initech', 'contact22@example.com', 'lost', 1437, 'Social Media', 'fdadd2f9-a794-4826-af13-2ae475f2a54c', NULL, now() - interval '8 days', 'Budget', now() - interval '38 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('e3e3080e-835f-4d78-ab15-b38c0561569e', '215a13db-85bc-40ad-b52e-4071cca84390');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('7f9696e8-cd4d-47b6-9b67-75e8642f0776', 'Contact 23', 'Slurm (Lead)', 'contact23@example.com', 'cold', 1034, 'Referral', 'fdadd2f9-a794-4826-af13-2ae475f2a54c', NULL, NULL, NULL, now() - interval '40 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('7f9696e8-cd4d-47b6-9b67-75e8642f0776', 'a7e3ecea-0d61-4e1f-ab90-c6fdf3432255');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('7fdac2e9-b2a6-432d-99f0-e68aeb0c35ba', 'Contact 24', 'Nuka-Cola (Lead)', 'contact24@example.com', 'cold', 1885, 'Trade Show', '43e399c1-a1c1-4a88-ac66-889d6d425848', NULL, NULL, NULL, now() - interval '18 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('7fdac2e9-b2a6-432d-99f0-e68aeb0c35ba', '6a785978-3b44-42cd-83f3-2c4b54b3ba8b');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('7fdac2e9-b2a6-432d-99f0-e68aeb0c35ba', '14111771-8366-4b11-990f-d4ac5c23042f');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('885943d9-ac3d-4bea-aba4-fde2802b09e3', 'Contact 25', 'Acme Corp', 'contact25@example.com', 'converted', 2794, 'Referral', 'fdadd2f9-a794-4826-af13-2ae475f2a54c', now() - interval '6 days', NULL, NULL, now() - interval '13 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('885943d9-ac3d-4bea-aba4-fde2802b09e3', '14111771-8366-4b11-990f-d4ac5c23042f');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('885943d9-ac3d-4bea-aba4-fde2802b09e3', 'f6d10cc9-9841-4b73-9664-8e3f9196e7ff');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('2aeb727d-171a-418e-96f1-1997b42b337d', 'Contact 26', 'Globex Corporation (Lead)', 'contact26@example.com', 'lost', 3231, 'Referral', 'fdadd2f9-a794-4826-af13-2ae475f2a54c', NULL, now() - interval '2 days', 'Not a Good Fit', now() - interval '15 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('2aeb727d-171a-418e-96f1-1997b42b337d', 'f6d10cc9-9841-4b73-9664-8e3f9196e7ff');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('2aeb727d-171a-418e-96f1-1997b42b337d', '6d07a5ab-8992-42ed-b839-36fd308404c1');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('2aeb727d-171a-418e-96f1-1997b42b337d', '14111771-8366-4b11-990f-d4ac5c23042f');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('0608d6fe-30d9-4d3b-9b3f-4c31866cbef7', 'Contact 27', 'Soylent Corp (Lead)', 'contact27@example.com', 'hot', 3883, 'Referral', 'fdadd2f9-a794-4826-af13-2ae475f2a54c', NULL, NULL, NULL, now() - interval '31 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('0608d6fe-30d9-4d3b-9b3f-4c31866cbef7', '9d03521c-add3-4009-9bca-7d32507804fa');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('e4a36dfa-d6ff-4448-8731-f477b6dab1c9', 'Contact 28', 'Initech (Lead)', 'contact28@example.com', 'lost', 4080, 'Referral', '88c67cb6-eca6-4385-987b-36785d3c4231', NULL, now() - interval '6 days', 'No Response', now() - interval '33 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('e4a36dfa-d6ff-4448-8731-f477b6dab1c9', '9d03521c-add3-4009-9bca-7d32507804fa');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('e4a36dfa-d6ff-4448-8731-f477b6dab1c9', '1389b058-bc71-4358-b965-32c93405d0cc');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('e4a36dfa-d6ff-4448-8731-f477b6dab1c9', '14111771-8366-4b11-990f-d4ac5c23042f');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('55ad7cec-da3c-4899-852e-f3cece04378e', 'Contact 29', 'Umbrella Corporation (Lead)', 'contact29@example.com', 'warm', 4019, 'Website', 'fdadd2f9-a794-4826-af13-2ae475f2a54c', NULL, NULL, NULL, now() - interval '32 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('55ad7cec-da3c-4899-852e-f3cece04378e', 'a7e3ecea-0d61-4e1f-ab90-c6fdf3432255');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('55ad7cec-da3c-4899-852e-f3cece04378e', '215a13db-85bc-40ad-b52e-4071cca84390');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('7f296ed5-9323-4691-91b9-dd28c09cad66', 'Contact 30', 'Stark Industries (Lead)', 'contact30@example.com', 'warm', 2995, 'Referral', '88c67cb6-eca6-4385-987b-36785d3c4231', NULL, NULL, NULL, now() - interval '12 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('7f296ed5-9323-4691-91b9-dd28c09cad66', '14111771-8366-4b11-990f-d4ac5c23042f');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('7f296ed5-9323-4691-91b9-dd28c09cad66', '9d03521c-add3-4009-9bca-7d32507804fa');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('2fb00a66-ca89-40f5-a933-ac999532fa31', 'Contact 31', 'Wayne Enterprises (Lead)', 'contact31@example.com', 'negotiation', 4221, 'Social Media', '43e399c1-a1c1-4a88-ac66-889d6d425848', NULL, NULL, NULL, now() - interval '30 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('2fb00a66-ca89-40f5-a933-ac999532fa31', '6d07a5ab-8992-42ed-b839-36fd308404c1');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('2fb00a66-ca89-40f5-a933-ac999532fa31', '9d03521c-add3-4009-9bca-7d32507804fa');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('2fb00a66-ca89-40f5-a933-ac999532fa31', 'f6d10cc9-9841-4b73-9664-8e3f9196e7ff');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('cdd8c5e6-e1ef-4466-ba4f-b788f5ccf738', 'Contact 32', 'Cyberdyne Systems (Lead)', 'contact32@example.com', 'cold', 2174, 'Trade Show', '88c67cb6-eca6-4385-987b-36785d3c4231', NULL, NULL, NULL, now() - interval '34 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('cdd8c5e6-e1ef-4466-ba4f-b788f5ccf738', '6a785978-3b44-42cd-83f3-2c4b54b3ba8b');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('cdd8c5e6-e1ef-4466-ba4f-b788f5ccf738', 'a7e3ecea-0d61-4e1f-ab90-c6fdf3432255');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('cdd8c5e6-e1ef-4466-ba4f-b788f5ccf738', 'f6d10cc9-9841-4b73-9664-8e3f9196e7ff');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('aa8bd744-7b50-4c05-bb4f-45088b9a0507', 'Contact 33', 'Massive Dynamic (Lead)', 'contact33@example.com', 'converted', 2446, 'Social Media', 'fdadd2f9-a794-4826-af13-2ae475f2a54c', now() - interval '2 days', NULL, NULL, now() - interval '39 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('aa8bd744-7b50-4c05-bb4f-45088b9a0507', '1389b058-bc71-4358-b965-32c93405d0cc');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('aa8bd744-7b50-4c05-bb4f-45088b9a0507', '6a785978-3b44-42cd-83f3-2c4b54b3ba8b');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('a38f047b-3961-4462-8d86-49d144df2fab', 'Contact 34', 'Genco Pura Olive Oil (Lead)', 'contact34@example.com', 'cold', 539, 'Referral', '43e399c1-a1c1-4a88-ac66-889d6d425848', NULL, NULL, NULL, now() - interval '26 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('a38f047b-3961-4462-8d86-49d144df2fab', '1389b058-bc71-4358-b965-32c93405d0cc');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('d13f69f6-e8a2-43f8-b092-942ac406aef3', 'Contact 35', 'LexCorp (Lead)', 'contact35@example.com', 'lost', 2830, 'Cold Call', 'fdadd2f9-a794-4826-af13-2ae475f2a54c', NULL, now() - interval '5 days', 'No Response', now() - interval '37 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('d13f69f6-e8a2-43f8-b092-942ac406aef3', '6d07a5ab-8992-42ed-b839-36fd308404c1');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('d13f69f6-e8a2-43f8-b092-942ac406aef3', '1389b058-bc71-4358-b965-32c93405d0cc');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('4d4f3cf2-5244-4d6f-b1e6-1b319c8254a8', 'Contact 36', 'Oceanic Airlines (Lead)', 'contact36@example.com', 'converted', 2535, 'Website', '88c67cb6-eca6-4385-987b-36785d3c4231', now() - interval '1 days', NULL, NULL, now() - interval '31 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('4d4f3cf2-5244-4d6f-b1e6-1b319c8254a8', '9d03521c-add3-4009-9bca-7d32507804fa');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('4d4f3cf2-5244-4d6f-b1e6-1b319c8254a8', '14111771-8366-4b11-990f-d4ac5c23042f');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('4d4f3cf2-5244-4d6f-b1e6-1b319c8254a8', '215a13db-85bc-40ad-b52e-4071cca84390');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('14fd1621-2c4f-43aa-be29-6bae0d31d1a9', 'Contact 37', 'Wonka Industries (Lead)', 'contact37@example.com', 'cold', 1539, 'Trade Show', '43e399c1-a1c1-4a88-ac66-889d6d425848', NULL, NULL, NULL, now() - interval '20 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('14fd1621-2c4f-43aa-be29-6bae0d31d1a9', 'f6d10cc9-9841-4b73-9664-8e3f9196e7ff');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('14fd1621-2c4f-43aa-be29-6bae0d31d1a9', '1389b058-bc71-4358-b965-32c93405d0cc');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('ff659b95-8756-4c07-aaf1-3b285ccfc31a', 'Contact 38', 'Oscorp (Lead)', 'contact38@example.com', 'hot', 3142, 'Social Media', 'fdadd2f9-a794-4826-af13-2ae475f2a54c', NULL, NULL, NULL, now() - interval '11 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('ff659b95-8756-4c07-aaf1-3b285ccfc31a', 'a7e3ecea-0d61-4e1f-ab90-c6fdf3432255');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('ff659b95-8756-4c07-aaf1-3b285ccfc31a', '1389b058-bc71-4358-b965-32c93405d0cc');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('ff659b95-8756-4c07-aaf1-3b285ccfc31a', '14111771-8366-4b11-990f-d4ac5c23042f');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('7a744d3d-79c9-45a8-bb6c-98bf2f2787df', 'Contact 39', 'Oceanic Airlines', 'contact39@example.com', 'warm', 548, 'Website', 'fdadd2f9-a794-4826-af13-2ae475f2a54c', NULL, NULL, NULL, now() - interval '30 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('7a744d3d-79c9-45a8-bb6c-98bf2f2787df', 'a7e3ecea-0d61-4e1f-ab90-c6fdf3432255');

-- 5. Projects
INSERT INTO public.projects (id, customer_id, name, status, priority, due_date, created_at) 
VALUES ('ddc5b567-9ef2-40a6-890b-e3d56c4dca41', 'bf79d99d-f439-4bba-9121-8075f9d559e8', 'Implementation Project 1', 'completed', 'medium', current_date + interval '28 days', now() - interval '17 days');
INSERT INTO public.project_members (project_id, user_id) VALUES ('ddc5b567-9ef2-40a6-890b-e3d56c4dca41', '88c67cb6-eca6-4385-987b-36785d3c4231');
INSERT INTO public.projects (id, customer_id, name, status, priority, due_date, created_at) 
VALUES ('114f2949-1a60-4cc6-a52e-ca03f794db3f', '63fc56fd-9f22-43a6-96ab-ee5fc0624ec3', 'Implementation Project 2', 'completed', 'medium', current_date + interval '10 days', now() - interval '7 days');
INSERT INTO public.project_members (project_id, user_id) VALUES ('114f2949-1a60-4cc6-a52e-ca03f794db3f', '43e399c1-a1c1-4a88-ac66-889d6d425848');
INSERT INTO public.projects (id, customer_id, name, status, priority, due_date, created_at) 
VALUES ('b7de5bd0-1eb3-4790-aad4-001931092c1d', '0c212f74-feda-48c4-b720-7240adc94e43', 'Implementation Project 3', 'planning', 'medium', current_date + interval '14 days', now() - interval '10 days');
INSERT INTO public.project_members (project_id, user_id) VALUES ('b7de5bd0-1eb3-4790-aad4-001931092c1d', 'fdadd2f9-a794-4826-af13-2ae475f2a54c');
INSERT INTO public.projects (id, customer_id, name, status, priority, due_date, created_at) 
VALUES ('e8fed8e4-534c-4119-818b-8befae45c132', '62b62dbe-37f6-46fb-a780-3e513609d8cb', 'Implementation Project 4', 'completed', 'medium', current_date + interval '17 days', now() - interval '1 days');
INSERT INTO public.project_members (project_id, user_id) VALUES ('e8fed8e4-534c-4119-818b-8befae45c132', '88c67cb6-eca6-4385-987b-36785d3c4231');
INSERT INTO public.projects (id, customer_id, name, status, priority, due_date, created_at) 
VALUES ('c1d36b1c-88a6-4077-a1c6-6d5c967000ff', '62b62dbe-37f6-46fb-a780-3e513609d8cb', 'Implementation Project 5', 'review', 'medium', current_date + interval '5 days', now() - interval '8 days');
INSERT INTO public.project_members (project_id, user_id) VALUES ('c1d36b1c-88a6-4077-a1c6-6d5c967000ff', 'fdadd2f9-a794-4826-af13-2ae475f2a54c');
INSERT INTO public.projects (id, customer_id, name, status, priority, due_date, created_at) 
VALUES ('e774b02b-815d-46f7-81fc-7edadf8a4013', '4b3ad919-bfed-4560-b0eb-da5a06a50e10', 'Implementation Project 6', 'completed', 'medium', current_date + interval '25 days', now() - interval '13 days');
INSERT INTO public.project_members (project_id, user_id) VALUES ('e774b02b-815d-46f7-81fc-7edadf8a4013', '43e399c1-a1c1-4a88-ac66-889d6d425848');
INSERT INTO public.projects (id, customer_id, name, status, priority, due_date, created_at) 
VALUES ('250a6c03-e20c-4b2f-9ce9-6d567c6db629', 'c52f2699-501d-4955-a305-5d7297bd5513', 'Implementation Project 7', 'completed', 'medium', current_date + interval '22 days', now() - interval '8 days');
INSERT INTO public.project_members (project_id, user_id) VALUES ('250a6c03-e20c-4b2f-9ce9-6d567c6db629', 'fdadd2f9-a794-4826-af13-2ae475f2a54c');
INSERT INTO public.projects (id, customer_id, name, status, priority, due_date, created_at) 
VALUES ('6b51b63d-ce45-4441-b825-e4fcaeef4c8c', 'bf79d99d-f439-4bba-9121-8075f9d559e8', 'Implementation Project 8', 'review', 'medium', current_date + interval '13 days', now() - interval '12 days');
INSERT INTO public.project_members (project_id, user_id) VALUES ('6b51b63d-ce45-4441-b825-e4fcaeef4c8c', 'fdadd2f9-a794-4826-af13-2ae475f2a54c');
INSERT INTO public.projects (id, customer_id, name, status, priority, due_date, created_at) 
VALUES ('5c4084e1-9c2c-4839-9039-741906a101c2', '0c212f74-feda-48c4-b720-7240adc94e43', 'Implementation Project 9', 'review', 'medium', current_date + interval '14 days', now() - interval '17 days');
INSERT INTO public.project_members (project_id, user_id) VALUES ('5c4084e1-9c2c-4839-9039-741906a101c2', '88c67cb6-eca6-4385-987b-36785d3c4231');
INSERT INTO public.projects (id, customer_id, name, status, priority, due_date, created_at) 
VALUES ('831f5aec-50aa-4173-b22d-223eb474f4c9', 'de068994-bc6c-4bcf-9879-80e7dc0b2c57', 'Implementation Project 10', 'in_progress', 'medium', current_date + interval '20 days', now() - interval '17 days');
INSERT INTO public.project_members (project_id, user_id) VALUES ('831f5aec-50aa-4173-b22d-223eb474f4c9', 'fdadd2f9-a794-4826-af13-2ae475f2a54c');
INSERT INTO public.projects (id, customer_id, name, status, priority, due_date, created_at) 
VALUES ('5bb4482c-593a-4468-a507-c0e5a71eb965', 'de068994-bc6c-4bcf-9879-80e7dc0b2c57', 'Implementation Project 11', 'review', 'medium', current_date + interval '20 days', now() - interval '5 days');
INSERT INTO public.project_members (project_id, user_id) VALUES ('5bb4482c-593a-4468-a507-c0e5a71eb965', 'fdadd2f9-a794-4826-af13-2ae475f2a54c');
INSERT INTO public.projects (id, customer_id, name, status, priority, due_date, created_at) 
VALUES ('86da9908-3bef-4d35-85bd-a81c28e08609', 'de068994-bc6c-4bcf-9879-80e7dc0b2c57', 'Implementation Project 12', 'planning', 'medium', current_date + interval '10 days', now() - interval '18 days');
INSERT INTO public.project_members (project_id, user_id) VALUES ('86da9908-3bef-4d35-85bd-a81c28e08609', 'fdadd2f9-a794-4826-af13-2ae475f2a54c');
INSERT INTO public.projects (id, customer_id, name, status, priority, due_date, created_at) 
VALUES ('63d28eb2-e663-43dd-941c-56927b4144a7', 'b1236ba5-0b5a-44c8-ae37-ca40cda75480', 'Implementation Project 13', 'in_progress', 'medium', current_date + interval '6 days', now() - interval '15 days');
INSERT INTO public.project_members (project_id, user_id) VALUES ('63d28eb2-e663-43dd-941c-56927b4144a7', '88c67cb6-eca6-4385-987b-36785d3c4231');
INSERT INTO public.projects (id, customer_id, name, status, priority, due_date, created_at) 
VALUES ('0d9654a5-7692-4f36-831d-da9bd1d68e11', '31cd80b1-7f01-4a9f-aed2-259a0af098d4', 'Implementation Project 14', 'in_progress', 'medium', current_date + interval '21 days', now() - interval '15 days');
INSERT INTO public.project_members (project_id, user_id) VALUES ('0d9654a5-7692-4f36-831d-da9bd1d68e11', '43e399c1-a1c1-4a88-ac66-889d6d425848');
INSERT INTO public.projects (id, customer_id, name, status, priority, due_date, created_at) 
VALUES ('80b127a0-a745-486f-a9df-7a4f373f2c39', '836b73ec-507d-4bb4-ac7f-c318a58dc0a5', 'Implementation Project 15', 'in_progress', 'medium', current_date + interval '29 days', now() - interval '15 days');
INSERT INTO public.project_members (project_id, user_id) VALUES ('80b127a0-a745-486f-a9df-7a4f373f2c39', 'fdadd2f9-a794-4826-af13-2ae475f2a54c');

-- 6. Tickets
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('b577605b-79a4-4ade-9d72-22b796729ad0', 'c52f2699-501d-4955-a305-5d7297bd5513', NULL, 'Support Request 1', 'Client needs help with configuration.', 'in_progress', 'medium', '88c67cb6-eca6-4385-987b-36785d3c4231', 'fdadd2f9-a794-4826-af13-2ae475f2a54c', NULL, now() - interval '14 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('26c0bc65-7a8b-4a89-9054-2cd7070b69fc', '63fc56fd-9f22-43a6-96ab-ee5fc0624ec3', NULL, 'Support Request 2', 'Client needs help with configuration.', 'waiting', 'low', '88c67cb6-eca6-4385-987b-36785d3c4231', '88c67cb6-eca6-4385-987b-36785d3c4231', NULL, now() - interval '8 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('f16ffe0d-69cd-4ddb-8994-cea430f869aa', 'c52f2699-501d-4955-a305-5d7297bd5513', '0d9654a5-7692-4f36-831d-da9bd1d68e11', 'Support Request 3', 'Client needs help with configuration.', 'waiting', 'low', '88c67cb6-eca6-4385-987b-36785d3c4231', '43e399c1-a1c1-4a88-ac66-889d6d425848', NULL, now() - interval '7 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('aaa53aa6-2e86-4ddb-bb14-e21fe7612b92', '63fc56fd-9f22-43a6-96ab-ee5fc0624ec3', '5c4084e1-9c2c-4839-9039-741906a101c2', 'Support Request 4', 'Client needs help with configuration.', 'in_progress', 'high', '88c67cb6-eca6-4385-987b-36785d3c4231', 'fdadd2f9-a794-4826-af13-2ae475f2a54c', NULL, now() - interval '5 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('ae3cc0ac-40c2-469f-aadb-5593e52a14cd', '0c212f74-feda-48c4-b720-7240adc94e43', '114f2949-1a60-4cc6-a52e-ca03f794db3f', 'Support Request 5', 'Client needs help with configuration.', 'resolved', 'medium', '88c67cb6-eca6-4385-987b-36785d3c4231', 'fdadd2f9-a794-4826-af13-2ae475f2a54c', now() - interval '5 days', now() - interval '4 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('602ebde0-f7b4-4cd9-9c29-0b73c3056165', '836b73ec-507d-4bb4-ac7f-c318a58dc0a5', NULL, 'Support Request 6', 'Client needs help with configuration.', 'waiting', 'medium', '88c67cb6-eca6-4385-987b-36785d3c4231', '43e399c1-a1c1-4a88-ac66-889d6d425848', NULL, now() - interval '13 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('a6878593-8fd7-4766-ae89-7859a80c0056', '836b73ec-507d-4bb4-ac7f-c318a58dc0a5', '831f5aec-50aa-4173-b22d-223eb474f4c9', 'Support Request 7', 'Client needs help with configuration.', 'in_progress', 'high', '88c67cb6-eca6-4385-987b-36785d3c4231', '43e399c1-a1c1-4a88-ac66-889d6d425848', NULL, now() - interval '10 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('24902412-18b3-4537-bf99-538f98b77c26', '05daed82-2813-40c7-b775-96ee91f58772', '5c4084e1-9c2c-4839-9039-741906a101c2', 'Support Request 8', 'Client needs help with configuration.', 'open', 'medium', '88c67cb6-eca6-4385-987b-36785d3c4231', 'fdadd2f9-a794-4826-af13-2ae475f2a54c', NULL, now() - interval '12 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('b8918767-ff1f-4eee-b065-8960ef9ffe3f', 'b1236ba5-0b5a-44c8-ae37-ca40cda75480', NULL, 'Support Request 9', 'Client needs help with configuration.', 'waiting', 'low', '88c67cb6-eca6-4385-987b-36785d3c4231', '88c67cb6-eca6-4385-987b-36785d3c4231', NULL, now() - interval '6 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('61ed7ace-b92e-4409-9d0c-4caa3b9a6edd', '63fc56fd-9f22-43a6-96ab-ee5fc0624ec3', '250a6c03-e20c-4b2f-9ce9-6d567c6db629', 'Support Request 10', 'Client needs help with configuration.', 'resolved', 'high', '88c67cb6-eca6-4385-987b-36785d3c4231', '88c67cb6-eca6-4385-987b-36785d3c4231', now() - interval '2 days', now() - interval '3 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('673686cb-ca8b-4a93-beaa-568da2089437', '63fc56fd-9f22-43a6-96ab-ee5fc0624ec3', NULL, 'Support Request 11', 'Client needs help with configuration.', 'in_progress', 'low', '88c67cb6-eca6-4385-987b-36785d3c4231', 'fdadd2f9-a794-4826-af13-2ae475f2a54c', NULL, now() - interval '12 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('9103e68f-e1f8-43d5-b94c-962a3bf127e3', 'b1236ba5-0b5a-44c8-ae37-ca40cda75480', NULL, 'Support Request 12', 'Client needs help with configuration.', 'waiting', 'medium', '88c67cb6-eca6-4385-987b-36785d3c4231', '88c67cb6-eca6-4385-987b-36785d3c4231', NULL, now() - interval '6 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('dec04314-7396-4428-a4e2-d40bf2f1f305', 'c52f2699-501d-4955-a305-5d7297bd5513', 'e8fed8e4-534c-4119-818b-8befae45c132', 'Support Request 13', 'Client needs help with configuration.', 'open', 'critical', '88c67cb6-eca6-4385-987b-36785d3c4231', 'fdadd2f9-a794-4826-af13-2ae475f2a54c', NULL, now() - interval '13 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('f2e2e926-829f-4346-9a81-cc72fd8a2daf', '836b73ec-507d-4bb4-ac7f-c318a58dc0a5', '6b51b63d-ce45-4441-b825-e4fcaeef4c8c', 'Support Request 14', 'Client needs help with configuration.', 'open', 'low', '88c67cb6-eca6-4385-987b-36785d3c4231', '43e399c1-a1c1-4a88-ac66-889d6d425848', NULL, now() - interval '15 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('96c497c7-6fa4-4955-913c-52d124cb7286', 'c52f2699-501d-4955-a305-5d7297bd5513', NULL, 'Support Request 15', 'Client needs help with configuration.', 'waiting', 'low', '88c67cb6-eca6-4385-987b-36785d3c4231', '43e399c1-a1c1-4a88-ac66-889d6d425848', NULL, now() - interval '4 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('1388d96f-c3d6-47d8-945e-e5553ff7f15c', 'c2370bfd-6567-4b0a-8d87-4b4c24220e90', NULL, 'Support Request 16', 'Client needs help with configuration.', 'waiting', 'high', '88c67cb6-eca6-4385-987b-36785d3c4231', 'fdadd2f9-a794-4826-af13-2ae475f2a54c', NULL, now() - interval '1 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('46335776-381e-445d-83f9-9b8d3c6fb8a2', 'bfa0b86c-dfa9-4a9f-9d6b-9d6e71d0e30d', NULL, 'Support Request 17', 'Client needs help with configuration.', 'waiting', 'high', '88c67cb6-eca6-4385-987b-36785d3c4231', '88c67cb6-eca6-4385-987b-36785d3c4231', NULL, now() - interval '9 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('c225c37e-eb5c-4c49-ae68-0d02b8a44e85', '4b3ad919-bfed-4560-b0eb-da5a06a50e10', '6b51b63d-ce45-4441-b825-e4fcaeef4c8c', 'Support Request 18', 'Client needs help with configuration.', 'open', 'medium', '88c67cb6-eca6-4385-987b-36785d3c4231', '88c67cb6-eca6-4385-987b-36785d3c4231', NULL, now() - interval '13 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('cf3964b3-e7dd-47eb-9e47-44c744a832a2', 'de068994-bc6c-4bcf-9879-80e7dc0b2c57', NULL, 'Support Request 19', 'Client needs help with configuration.', 'resolved', 'critical', '88c67cb6-eca6-4385-987b-36785d3c4231', 'fdadd2f9-a794-4826-af13-2ae475f2a54c', now() - interval '4 days', now() - interval '2 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('41283200-3aa0-4f9f-8be4-739a0c997b29', 'bfa0b86c-dfa9-4a9f-9d6b-9d6e71d0e30d', '114f2949-1a60-4cc6-a52e-ca03f794db3f', 'Support Request 20', 'Client needs help with configuration.', 'waiting', 'high', '88c67cb6-eca6-4385-987b-36785d3c4231', 'fdadd2f9-a794-4826-af13-2ae475f2a54c', NULL, now() - interval '9 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('2395ce30-fe96-45dd-8dd6-59739f6ce1f7', '63fc56fd-9f22-43a6-96ab-ee5fc0624ec3', '63d28eb2-e663-43dd-941c-56927b4144a7', 'Support Request 21', 'Client needs help with configuration.', 'in_progress', 'low', '88c67cb6-eca6-4385-987b-36785d3c4231', '43e399c1-a1c1-4a88-ac66-889d6d425848', NULL, now() - interval '14 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('202b012e-b708-4ee1-b993-149194475e63', '62b62dbe-37f6-46fb-a780-3e513609d8cb', '831f5aec-50aa-4173-b22d-223eb474f4c9', 'Support Request 22', 'Client needs help with configuration.', 'in_progress', 'high', '88c67cb6-eca6-4385-987b-36785d3c4231', 'fdadd2f9-a794-4826-af13-2ae475f2a54c', NULL, now() - interval '13 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('75c16b07-cd97-4076-8e70-7b571ec510ad', '0c212f74-feda-48c4-b720-7240adc94e43', 'b7de5bd0-1eb3-4790-aad4-001931092c1d', 'Support Request 23', 'Client needs help with configuration.', 'in_progress', 'critical', '88c67cb6-eca6-4385-987b-36785d3c4231', '88c67cb6-eca6-4385-987b-36785d3c4231', NULL, now() - interval '10 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('c0c1ace5-fbc4-4d85-890b-6651759723b8', '62b62dbe-37f6-46fb-a780-3e513609d8cb', 'e8fed8e4-534c-4119-818b-8befae45c132', 'Support Request 24', 'Client needs help with configuration.', 'waiting', 'medium', '88c67cb6-eca6-4385-987b-36785d3c4231', 'fdadd2f9-a794-4826-af13-2ae475f2a54c', NULL, now() - interval '13 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('57c8c929-87c3-4132-a34e-4e055cd65f0a', '4b3ad919-bfed-4560-b0eb-da5a06a50e10', '5bb4482c-593a-4468-a507-c0e5a71eb965', 'Support Request 25', 'Client needs help with configuration.', 'resolved', 'low', '88c67cb6-eca6-4385-987b-36785d3c4231', 'fdadd2f9-a794-4826-af13-2ae475f2a54c', now() - interval '1 days', now() - interval '9 days');
