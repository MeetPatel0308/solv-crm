
-- ==========================================
-- DEMO SEED DATA FOR SOLV CRM & ERP
-- ==========================================
-- WARNING: This script assumes tables are empty or will insert ignoring conflicts.

-- 1. Create Users
-- We insert into auth.users directly. Note: these users cannot log in.
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at) 
VALUES ('b750744d-5144-4685-b27e-324c93788185', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'alice.sales@example.com', '', now(), now(), now())
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.profiles (id, full_name, email, job_title, created_at, updated_at) 
VALUES ('b750744d-5144-4685-b27e-324c93788185', 'Alice Smith', 'alice.sales@example.com', 'Sales Manager', now(), now())
ON CONFLICT (id) DO UPDATE SET full_name = EXCLUDED.full_name, job_title = EXCLUDED.job_title;
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at) 
VALUES ('d50078c7-ec2d-47f1-b7d4-d4a4d40b3e66', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'bob.account@example.com', '', now(), now(), now())
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.profiles (id, full_name, email, job_title, created_at, updated_at) 
VALUES ('d50078c7-ec2d-47f1-b7d4-d4a4d40b3e66', 'Bob Johnson', 'bob.account@example.com', 'Account Manager', now(), now())
ON CONFLICT (id) DO UPDATE SET full_name = EXCLUDED.full_name, job_title = EXCLUDED.job_title;
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at) 
VALUES ('195b23e7-a8d2-4cbd-a4a2-9c437e8bc923', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'charlie.tech@example.com', '', now(), now(), now())
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.profiles (id, full_name, email, job_title, created_at, updated_at) 
VALUES ('195b23e7-a8d2-4cbd-a4a2-9c437e8bc923', 'Charlie Davis', 'charlie.tech@example.com', 'Lead Developer', now(), now())
ON CONFLICT (id) DO UPDATE SET full_name = EXCLUDED.full_name, job_title = EXCLUDED.job_title;

-- 2. Services
INSERT INTO public.services (id, name, created_at, updated_at) VALUES ('30970cdc-c058-4913-aef2-84dc49e82c91', 'KIBO', now(), now()) ON CONFLICT DO NOTHING;
INSERT INTO public.services (id, name, created_at, updated_at) VALUES ('1bf9e124-6487-417f-b9ba-a31d25fb3b2c', 'AI Sales App', now(), now()) ON CONFLICT DO NOTHING;
INSERT INTO public.services (id, name, created_at, updated_at) VALUES ('9151711d-9d8f-4fe9-80d5-097a9fc18fc8', 'Website Development', now(), now()) ON CONFLICT DO NOTHING;
INSERT INTO public.services (id, name, created_at, updated_at) VALUES ('28773438-7a5d-47b8-98d2-258fc28b4594', 'Hosting', now(), now()) ON CONFLICT DO NOTHING;
INSERT INTO public.services (id, name, created_at, updated_at) VALUES ('12df9177-1979-4dc3-9d42-5b34631f1a3c', 'SEO', now(), now()) ON CONFLICT DO NOTHING;
INSERT INTO public.services (id, name, created_at, updated_at) VALUES ('e82477e5-8f6a-4e2a-b099-4f248d20732d', 'Meta Ads Management', now(), now()) ON CONFLICT DO NOTHING;
INSERT INTO public.services (id, name, created_at, updated_at) VALUES ('37bd3a3c-d940-4f3e-89e9-47b7c8c941cc', 'Google Ads Management', now(), now()) ON CONFLICT DO NOTHING;
INSERT INTO public.services (id, name, created_at, updated_at) VALUES ('44092069-1a31-4604-894f-2280ee57400b', 'Broadcast Messaging', now(), now()) ON CONFLICT DO NOTHING;

-- 3. Customers, Sales & Customer Services
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('1a54f644-e8e4-4c42-941a-2fca70bd2bc4', 'Acme Corp', 'contact@acme corp.com', 'Finance', 'd50078c7-ec2d-47f1-b7d4-d4a4d40b3e66', 'active', now() - interval '100 days');
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('1a54f644-e8e4-4c42-941a-2fca70bd2bc4', '28773438-7a5d-47b8-98d2-258fc28b4594', 'Hosting', 'one-off', 5148, 'active', current_date, now() - interval '22 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('1a54f644-e8e4-4c42-941a-2fca70bd2bc4', '28773438-7a5d-47b8-98d2-258fc28b4594', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('1a54f644-e8e4-4c42-941a-2fca70bd2bc4', '1bf9e124-6487-417f-b9ba-a31d25fb3b2c', 'AI Sales App', 'one-off', 8347, 'active', current_date, now() - interval '20 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('1a54f644-e8e4-4c42-941a-2fca70bd2bc4', '1bf9e124-6487-417f-b9ba-a31d25fb3b2c', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('1a54f644-e8e4-4c42-941a-2fca70bd2bc4', '12df9177-1979-4dc3-9d42-5b34631f1a3c', 'SEO', 'retainer', 776, 'active', current_date, now() - interval '5 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('1a54f644-e8e4-4c42-941a-2fca70bd2bc4', '12df9177-1979-4dc3-9d42-5b34631f1a3c', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('492aaa47-dc97-465c-9727-1ad772c5b79a', 'Globex Corporation', 'contact@globex corporation.com', 'Retail', 'd50078c7-ec2d-47f1-b7d4-d4a4d40b3e66', 'active', now() - interval '78 days');
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('492aaa47-dc97-465c-9727-1ad772c5b79a', '28773438-7a5d-47b8-98d2-258fc28b4594', 'Hosting', 'retainer', 424, 'active', current_date, now() - interval '3 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('492aaa47-dc97-465c-9727-1ad772c5b79a', '28773438-7a5d-47b8-98d2-258fc28b4594', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('492aaa47-dc97-465c-9727-1ad772c5b79a', '44092069-1a31-4604-894f-2280ee57400b', 'Broadcast Messaging', 'one-off', 1526, 'active', current_date, now() - interval '28 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('492aaa47-dc97-465c-9727-1ad772c5b79a', '44092069-1a31-4604-894f-2280ee57400b', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('d0c883ae-60af-4c4c-8970-c5f54d0a1e5c', 'Soylent Corp', 'contact@soylent corp.com', 'Technology', '195b23e7-a8d2-4cbd-a4a2-9c437e8bc923', 'active', now() - interval '84 days');
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('d0c883ae-60af-4c4c-8970-c5f54d0a1e5c', '12df9177-1979-4dc3-9d42-5b34631f1a3c', 'SEO', 'one-off', 7988, 'active', current_date, now() - interval '4 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('d0c883ae-60af-4c4c-8970-c5f54d0a1e5c', '12df9177-1979-4dc3-9d42-5b34631f1a3c', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('d0c883ae-60af-4c4c-8970-c5f54d0a1e5c', '9151711d-9d8f-4fe9-80d5-097a9fc18fc8', 'Website Development', 'retainer', 1492, 'active', current_date, now() - interval '27 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('d0c883ae-60af-4c4c-8970-c5f54d0a1e5c', '9151711d-9d8f-4fe9-80d5-097a9fc18fc8', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('e62a5d2d-e355-4817-bcf2-b0aeac8f303f', 'Initech', 'contact@initech.com', 'Education', '195b23e7-a8d2-4cbd-a4a2-9c437e8bc923', 'active', now() - interval '14 days');
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('e62a5d2d-e355-4817-bcf2-b0aeac8f303f', '28773438-7a5d-47b8-98d2-258fc28b4594', 'Hosting', 'one-off', 5248, 'active', current_date, now() - interval '1 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('e62a5d2d-e355-4817-bcf2-b0aeac8f303f', '28773438-7a5d-47b8-98d2-258fc28b4594', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('a2dddc85-8b3f-4921-b058-8744543bc221', 'Umbrella Corporation', 'contact@umbrella corporation.com', 'Finance', 'd50078c7-ec2d-47f1-b7d4-d4a4d40b3e66', 'active', now() - interval '72 days');
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('a2dddc85-8b3f-4921-b058-8744543bc221', '37bd3a3c-d940-4f3e-89e9-47b7c8c941cc', 'Google Ads Management', 'one-off', 1847, 'active', current_date, now() - interval '19 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('a2dddc85-8b3f-4921-b058-8744543bc221', '37bd3a3c-d940-4f3e-89e9-47b7c8c941cc', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('6541b743-003b-4585-9e64-c1d2584a6efc', 'Stark Industries', 'contact@stark industries.com', 'Education', 'd50078c7-ec2d-47f1-b7d4-d4a4d40b3e66', 'active', now() - interval '43 days');
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('6541b743-003b-4585-9e64-c1d2584a6efc', '1bf9e124-6487-417f-b9ba-a31d25fb3b2c', 'AI Sales App', 'one-off', 4718, 'active', current_date, now() - interval '20 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('6541b743-003b-4585-9e64-c1d2584a6efc', '1bf9e124-6487-417f-b9ba-a31d25fb3b2c', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('6541b743-003b-4585-9e64-c1d2584a6efc', '30970cdc-c058-4913-aef2-84dc49e82c91', 'KIBO', 'retainer', 895, 'active', current_date, now() - interval '17 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('6541b743-003b-4585-9e64-c1d2584a6efc', '30970cdc-c058-4913-aef2-84dc49e82c91', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('6541b743-003b-4585-9e64-c1d2584a6efc', '12df9177-1979-4dc3-9d42-5b34631f1a3c', 'SEO', 'one-off', 6780, 'active', current_date, now() - interval '11 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('6541b743-003b-4585-9e64-c1d2584a6efc', '12df9177-1979-4dc3-9d42-5b34631f1a3c', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('1dc96a7a-3336-4f35-9078-b11053eb59ed', 'Wayne Enterprises', 'contact@wayne enterprises.com', 'Real Estate', 'd50078c7-ec2d-47f1-b7d4-d4a4d40b3e66', 'active', now() - interval '64 days');
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('1dc96a7a-3336-4f35-9078-b11053eb59ed', '44092069-1a31-4604-894f-2280ee57400b', 'Broadcast Messaging', 'retainer', 270, 'active', current_date, now() - interval '24 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('1dc96a7a-3336-4f35-9078-b11053eb59ed', '44092069-1a31-4604-894f-2280ee57400b', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('1dc96a7a-3336-4f35-9078-b11053eb59ed', '28773438-7a5d-47b8-98d2-258fc28b4594', 'Hosting', 'one-off', 2281, 'active', current_date, now() - interval '2 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('1dc96a7a-3336-4f35-9078-b11053eb59ed', '28773438-7a5d-47b8-98d2-258fc28b4594', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('48d16a7e-c707-4b10-90a7-d3e4a37ed566', 'Cyberdyne Systems', 'contact@cyberdyne systems.com', 'Education', 'd50078c7-ec2d-47f1-b7d4-d4a4d40b3e66', 'active', now() - interval '59 days');
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('48d16a7e-c707-4b10-90a7-d3e4a37ed566', '30970cdc-c058-4913-aef2-84dc49e82c91', 'KIBO', 'retainer', 709, 'active', current_date, now() - interval '12 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('48d16a7e-c707-4b10-90a7-d3e4a37ed566', '30970cdc-c058-4913-aef2-84dc49e82c91', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('48d16a7e-c707-4b10-90a7-d3e4a37ed566', '44092069-1a31-4604-894f-2280ee57400b', 'Broadcast Messaging', 'retainer', 1376, 'active', current_date, now() - interval '1 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('48d16a7e-c707-4b10-90a7-d3e4a37ed566', '44092069-1a31-4604-894f-2280ee57400b', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('658a9b36-5d19-4a82-888d-6ad17f0beb37', 'Massive Dynamic', 'contact@massive dynamic.com', 'Retail', 'd50078c7-ec2d-47f1-b7d4-d4a4d40b3e66', 'active', now() - interval '20 days');
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('658a9b36-5d19-4a82-888d-6ad17f0beb37', '1bf9e124-6487-417f-b9ba-a31d25fb3b2c', 'AI Sales App', 'retainer', 1295, 'active', current_date, now() - interval '6 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('658a9b36-5d19-4a82-888d-6ad17f0beb37', '1bf9e124-6487-417f-b9ba-a31d25fb3b2c', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('658a9b36-5d19-4a82-888d-6ad17f0beb37', '37bd3a3c-d940-4f3e-89e9-47b7c8c941cc', 'Google Ads Management', 'retainer', 304, 'active', current_date, now() - interval '25 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('658a9b36-5d19-4a82-888d-6ad17f0beb37', '37bd3a3c-d940-4f3e-89e9-47b7c8c941cc', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('8f345d18-10e2-4258-9228-f0fddf7677a7', 'Genco Pura Olive Oil', 'contact@genco pura olive oil.com', 'Real Estate', 'b750744d-5144-4685-b27e-324c93788185', 'active', now() - interval '28 days');
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('8f345d18-10e2-4258-9228-f0fddf7677a7', '9151711d-9d8f-4fe9-80d5-097a9fc18fc8', 'Website Development', 'one-off', 1516, 'active', current_date, now() - interval '13 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('8f345d18-10e2-4258-9228-f0fddf7677a7', '9151711d-9d8f-4fe9-80d5-097a9fc18fc8', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('8f345d18-10e2-4258-9228-f0fddf7677a7', '30970cdc-c058-4913-aef2-84dc49e82c91', 'KIBO', 'one-off', 2534, 'active', current_date, now() - interval '2 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('8f345d18-10e2-4258-9228-f0fddf7677a7', '30970cdc-c058-4913-aef2-84dc49e82c91', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('8f345d18-10e2-4258-9228-f0fddf7677a7', '28773438-7a5d-47b8-98d2-258fc28b4594', 'Hosting', 'one-off', 6196, 'active', current_date, now() - interval '16 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('8f345d18-10e2-4258-9228-f0fddf7677a7', '28773438-7a5d-47b8-98d2-258fc28b4594', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('255b420e-c5ad-4e90-beec-07a7ed0b19e8', 'LexCorp', 'contact@lexcorp.com', 'Healthcare', 'd50078c7-ec2d-47f1-b7d4-d4a4d40b3e66', 'active', now() - interval '56 days');
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('255b420e-c5ad-4e90-beec-07a7ed0b19e8', 'e82477e5-8f6a-4e2a-b099-4f248d20732d', 'Meta Ads Management', 'retainer', 1369, 'active', current_date, now() - interval '29 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('255b420e-c5ad-4e90-beec-07a7ed0b19e8', 'e82477e5-8f6a-4e2a-b099-4f248d20732d', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('d3b55152-f9b4-4b3c-9dd0-9a0449c05ba2', 'Oceanic Airlines', 'contact@oceanic airlines.com', 'Retail', 'b750744d-5144-4685-b27e-324c93788185', 'active', now() - interval '81 days');
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('d3b55152-f9b4-4b3c-9dd0-9a0449c05ba2', '28773438-7a5d-47b8-98d2-258fc28b4594', 'Hosting', 'one-off', 8259, 'active', current_date, now() - interval '25 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('d3b55152-f9b4-4b3c-9dd0-9a0449c05ba2', '28773438-7a5d-47b8-98d2-258fc28b4594', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('d3b55152-f9b4-4b3c-9dd0-9a0449c05ba2', '12df9177-1979-4dc3-9d42-5b34631f1a3c', 'SEO', 'retainer', 1070, 'active', current_date, now() - interval '24 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('d3b55152-f9b4-4b3c-9dd0-9a0449c05ba2', '12df9177-1979-4dc3-9d42-5b34631f1a3c', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('d3b55152-f9b4-4b3c-9dd0-9a0449c05ba2', '30970cdc-c058-4913-aef2-84dc49e82c91', 'KIBO', 'one-off', 8338, 'active', current_date, now() - interval '24 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('d3b55152-f9b4-4b3c-9dd0-9a0449c05ba2', '30970cdc-c058-4913-aef2-84dc49e82c91', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('cfae116e-aee1-4a8e-b057-e8337f1975ee', 'Wonka Industries', 'contact@wonka industries.com', 'Retail', '195b23e7-a8d2-4cbd-a4a2-9c437e8bc923', 'active', now() - interval '57 days');
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('cfae116e-aee1-4a8e-b057-e8337f1975ee', '44092069-1a31-4604-894f-2280ee57400b', 'Broadcast Messaging', 'retainer', 1333, 'active', current_date, now() - interval '18 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('cfae116e-aee1-4a8e-b057-e8337f1975ee', '44092069-1a31-4604-894f-2280ee57400b', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('e9d0b187-e3b5-4219-8d68-5d1bfd321269', 'Oscorp', 'contact@oscorp.com', 'Real Estate', 'd50078c7-ec2d-47f1-b7d4-d4a4d40b3e66', 'active', now() - interval '85 days');
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('e9d0b187-e3b5-4219-8d68-5d1bfd321269', '44092069-1a31-4604-894f-2280ee57400b', 'Broadcast Messaging', 'one-off', 1188, 'active', current_date, now() - interval '10 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('e9d0b187-e3b5-4219-8d68-5d1bfd321269', '44092069-1a31-4604-894f-2280ee57400b', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('45ab4e2c-fd87-4087-95b0-e3b92faaaefa', 'Hooli', 'contact@hooli.com', 'Real Estate', '195b23e7-a8d2-4cbd-a4a2-9c437e8bc923', 'active', now() - interval '24 days');
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('45ab4e2c-fd87-4087-95b0-e3b92faaaefa', '28773438-7a5d-47b8-98d2-258fc28b4594', 'Hosting', 'one-off', 8257, 'active', current_date, now() - interval '3 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('45ab4e2c-fd87-4087-95b0-e3b92faaaefa', '28773438-7a5d-47b8-98d2-258fc28b4594', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('45ab4e2c-fd87-4087-95b0-e3b92faaaefa', '1bf9e124-6487-417f-b9ba-a31d25fb3b2c', 'AI Sales App', 'retainer', 1154, 'active', current_date, now() - interval '11 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('45ab4e2c-fd87-4087-95b0-e3b92faaaefa', '1bf9e124-6487-417f-b9ba-a31d25fb3b2c', 'active', current_date, now());

-- 4. Leads & Lead Services
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('41caf4af-7a1e-47c8-8ed1-60ce23dae8c9', 'Contact 15', 'Pied Piper (Lead)', 'contact15@example.com', 'warm', 4541, 'Cold Call', 'd50078c7-ec2d-47f1-b7d4-d4a4d40b3e66', NULL, NULL, NULL, now() - interval '38 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('41caf4af-7a1e-47c8-8ed1-60ce23dae8c9', '44092069-1a31-4604-894f-2280ee57400b');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('41caf4af-7a1e-47c8-8ed1-60ce23dae8c9', '12df9177-1979-4dc3-9d42-5b34631f1a3c');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('41caf4af-7a1e-47c8-8ed1-60ce23dae8c9', '28773438-7a5d-47b8-98d2-258fc28b4594');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('0edeccac-1b13-482a-94c0-2c255b6563c3', 'Contact 16', 'Dunder Mifflin (Lead)', 'contact16@example.com', 'converted', 2700, 'Cold Call', 'b750744d-5144-4685-b27e-324c93788185', now() - interval '6 days', NULL, NULL, now() - interval '39 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('0edeccac-1b13-482a-94c0-2c255b6563c3', '12df9177-1979-4dc3-9d42-5b34631f1a3c');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('0edeccac-1b13-482a-94c0-2c255b6563c3', '1bf9e124-6487-417f-b9ba-a31d25fb3b2c');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('693e2624-202e-499d-a874-847d5ae176d2', 'Contact 17', 'Aperture Science (Lead)', 'contact17@example.com', 'warm', 1960, 'Trade Show', 'd50078c7-ec2d-47f1-b7d4-d4a4d40b3e66', NULL, NULL, NULL, now() - interval '12 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('693e2624-202e-499d-a874-847d5ae176d2', '9151711d-9d8f-4fe9-80d5-097a9fc18fc8');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('693e2624-202e-499d-a874-847d5ae176d2', '12df9177-1979-4dc3-9d42-5b34631f1a3c');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('402ab831-f05f-44ac-a135-a50d043fd30a', 'Contact 18', 'LexCorp', 'contact18@example.com', 'cold', 2512, 'Cold Call', '195b23e7-a8d2-4cbd-a4a2-9c437e8bc923', NULL, NULL, NULL, now() - interval '22 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('402ab831-f05f-44ac-a135-a50d043fd30a', 'e82477e5-8f6a-4e2a-b099-4f248d20732d');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('402ab831-f05f-44ac-a135-a50d043fd30a', '9151711d-9d8f-4fe9-80d5-097a9fc18fc8');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('2fe0ff41-210d-406c-98c9-e215c875e0d6', 'Contact 19', 'Gringotts (Lead)', 'contact19@example.com', 'negotiation', 3633, 'Trade Show', 'b750744d-5144-4685-b27e-324c93788185', NULL, NULL, NULL, now() - interval '31 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('2fe0ff41-210d-406c-98c9-e215c875e0d6', '28773438-7a5d-47b8-98d2-258fc28b4594');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('faa0e320-4eaa-40d3-97ab-7a9c18296d8d', 'Contact 20', 'Ollivanders (Lead)', 'contact20@example.com', 'warm', 2374, 'Referral', 'd50078c7-ec2d-47f1-b7d4-d4a4d40b3e66', NULL, NULL, NULL, now() - interval '12 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('faa0e320-4eaa-40d3-97ab-7a9c18296d8d', '30970cdc-c058-4913-aef2-84dc49e82c91');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('faa0e320-4eaa-40d3-97ab-7a9c18296d8d', '28773438-7a5d-47b8-98d2-258fc28b4594');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('6be92eac-650a-4e32-b9f2-a79c249eb6d5', 'Contact 21', 'Virtucon (Lead)', 'contact21@example.com', 'proposal', 3713, 'Referral', '195b23e7-a8d2-4cbd-a4a2-9c437e8bc923', NULL, NULL, NULL, now() - interval '17 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('6be92eac-650a-4e32-b9f2-a79c249eb6d5', '9151711d-9d8f-4fe9-80d5-097a9fc18fc8');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('71eeb90e-e431-4194-afe8-f94eb2b45bcd', 'Contact 22', 'Wayne Enterprises', 'contact22@example.com', 'cold', 2689, 'Referral', 'd50078c7-ec2d-47f1-b7d4-d4a4d40b3e66', NULL, NULL, NULL, now() - interval '20 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('71eeb90e-e431-4194-afe8-f94eb2b45bcd', '1bf9e124-6487-417f-b9ba-a31d25fb3b2c');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('71eeb90e-e431-4194-afe8-f94eb2b45bcd', 'e82477e5-8f6a-4e2a-b099-4f248d20732d');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('743ba72d-6b41-49fe-bc11-d20ce90fe1cb', 'Contact 23', 'Slurm (Lead)', 'contact23@example.com', 'cold', 1937, 'Website', 'b750744d-5144-4685-b27e-324c93788185', NULL, NULL, NULL, now() - interval '12 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('743ba72d-6b41-49fe-bc11-d20ce90fe1cb', '37bd3a3c-d940-4f3e-89e9-47b7c8c941cc');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('743ba72d-6b41-49fe-bc11-d20ce90fe1cb', '1bf9e124-6487-417f-b9ba-a31d25fb3b2c');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('743ba72d-6b41-49fe-bc11-d20ce90fe1cb', '9151711d-9d8f-4fe9-80d5-097a9fc18fc8');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('3854bd5c-d248-497c-9adf-213c3e2d43ed', 'Contact 24', 'Nuka-Cola (Lead)', 'contact24@example.com', 'hot', 3390, 'Cold Call', 'd50078c7-ec2d-47f1-b7d4-d4a4d40b3e66', NULL, NULL, NULL, now() - interval '31 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('3854bd5c-d248-497c-9adf-213c3e2d43ed', '30970cdc-c058-4913-aef2-84dc49e82c91');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('899a339a-cd05-49b0-a38a-8236c1e06394', 'Contact 25', 'Acme Corp (Lead)', 'contact25@example.com', 'lost', 4344, 'Social Media', 'b750744d-5144-4685-b27e-324c93788185', NULL, now() - interval '5 days', 'Competitor', now() - interval '30 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('899a339a-cd05-49b0-a38a-8236c1e06394', '9151711d-9d8f-4fe9-80d5-097a9fc18fc8');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('b58940ee-30b5-4fc1-90e0-cd91e5aef5ab', 'Contact 26', 'Umbrella Corporation', 'contact26@example.com', 'negotiation', 3222, 'Cold Call', 'b750744d-5144-4685-b27e-324c93788185', NULL, NULL, NULL, now() - interval '14 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('b58940ee-30b5-4fc1-90e0-cd91e5aef5ab', '12df9177-1979-4dc3-9d42-5b34631f1a3c');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('b58940ee-30b5-4fc1-90e0-cd91e5aef5ab', '37bd3a3c-d940-4f3e-89e9-47b7c8c941cc');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('d8f16cd8-9aa3-45b1-87aa-090e1cd1d648', 'Contact 27', 'Soylent Corp (Lead)', 'contact27@example.com', 'warm', 750, 'Website', '195b23e7-a8d2-4cbd-a4a2-9c437e8bc923', NULL, NULL, NULL, now() - interval '23 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('d8f16cd8-9aa3-45b1-87aa-090e1cd1d648', '1bf9e124-6487-417f-b9ba-a31d25fb3b2c');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('d8f16cd8-9aa3-45b1-87aa-090e1cd1d648', '28773438-7a5d-47b8-98d2-258fc28b4594');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('65371d9b-3564-4cec-9f91-485db5fc206c', 'Contact 28', 'Initech (Lead)', 'contact28@example.com', 'lost', 1820, 'Trade Show', 'd50078c7-ec2d-47f1-b7d4-d4a4d40b3e66', NULL, now() - interval '8 days', 'No Response', now() - interval '25 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('65371d9b-3564-4cec-9f91-485db5fc206c', 'e82477e5-8f6a-4e2a-b099-4f248d20732d');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('65371d9b-3564-4cec-9f91-485db5fc206c', '12df9177-1979-4dc3-9d42-5b34631f1a3c');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('71e9fdde-5598-40fd-a26a-debc8adaec92', 'Contact 29', 'LexCorp', 'contact29@example.com', 'negotiation', 2020, 'Cold Call', 'b750744d-5144-4685-b27e-324c93788185', NULL, NULL, NULL, now() - interval '15 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('71e9fdde-5598-40fd-a26a-debc8adaec92', '12df9177-1979-4dc3-9d42-5b34631f1a3c');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('043d1736-e7fd-40bf-87c9-53592ddb0c36', 'Contact 30', 'Stark Industries (Lead)', 'contact30@example.com', 'warm', 4359, 'Cold Call', 'd50078c7-ec2d-47f1-b7d4-d4a4d40b3e66', NULL, NULL, NULL, now() - interval '31 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('043d1736-e7fd-40bf-87c9-53592ddb0c36', '37bd3a3c-d940-4f3e-89e9-47b7c8c941cc');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('043d1736-e7fd-40bf-87c9-53592ddb0c36', '28773438-7a5d-47b8-98d2-258fc28b4594');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('aa69b11c-a8d0-43c4-a4f0-aac5758aa39e', 'Contact 31', 'Wayne Enterprises (Lead)', 'contact31@example.com', 'cold', 782, 'Social Media', 'd50078c7-ec2d-47f1-b7d4-d4a4d40b3e66', NULL, NULL, NULL, now() - interval '30 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('aa69b11c-a8d0-43c4-a4f0-aac5758aa39e', '28773438-7a5d-47b8-98d2-258fc28b4594');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('d9ad19b9-adc1-4a8f-a9bd-e2becc2ef909', 'Contact 32', 'Cyberdyne Systems (Lead)', 'contact32@example.com', 'lost', 3558, 'Website', '195b23e7-a8d2-4cbd-a4a2-9c437e8bc923', NULL, now() - interval '8 days', 'Timing', now() - interval '21 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('d9ad19b9-adc1-4a8f-a9bd-e2becc2ef909', '44092069-1a31-4604-894f-2280ee57400b');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('d9ad19b9-adc1-4a8f-a9bd-e2becc2ef909', '9151711d-9d8f-4fe9-80d5-097a9fc18fc8');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('d9ad19b9-adc1-4a8f-a9bd-e2becc2ef909', 'e82477e5-8f6a-4e2a-b099-4f248d20732d');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('88f23ac4-0b28-4e2f-93e3-3813040adf6b', 'Contact 33', 'Cyberdyne Systems', 'contact33@example.com', 'warm', 4327, 'Referral', 'd50078c7-ec2d-47f1-b7d4-d4a4d40b3e66', NULL, NULL, NULL, now() - interval '39 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('88f23ac4-0b28-4e2f-93e3-3813040adf6b', '1bf9e124-6487-417f-b9ba-a31d25fb3b2c');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('88f23ac4-0b28-4e2f-93e3-3813040adf6b', '44092069-1a31-4604-894f-2280ee57400b');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('30020683-5c6c-4610-a29d-545e27741a83', 'Contact 34', 'Genco Pura Olive Oil (Lead)', 'contact34@example.com', 'cold', 1109, 'Website', 'd50078c7-ec2d-47f1-b7d4-d4a4d40b3e66', NULL, NULL, NULL, now() - interval '24 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('30020683-5c6c-4610-a29d-545e27741a83', '30970cdc-c058-4913-aef2-84dc49e82c91');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('30020683-5c6c-4610-a29d-545e27741a83', '9151711d-9d8f-4fe9-80d5-097a9fc18fc8');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('1151f233-ec20-4ea9-827e-a9acd7c5b4e8', 'Contact 35', 'LexCorp (Lead)', 'contact35@example.com', 'warm', 1554, 'Referral', 'b750744d-5144-4685-b27e-324c93788185', NULL, NULL, NULL, now() - interval '31 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('1151f233-ec20-4ea9-827e-a9acd7c5b4e8', '28773438-7a5d-47b8-98d2-258fc28b4594');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('1bbe4cf1-539b-48e5-bec2-8c7c979b4ab7', 'Contact 36', 'Oceanic Airlines (Lead)', 'contact36@example.com', 'warm', 1302, 'Website', '195b23e7-a8d2-4cbd-a4a2-9c437e8bc923', NULL, NULL, NULL, now() - interval '13 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('1bbe4cf1-539b-48e5-bec2-8c7c979b4ab7', '30970cdc-c058-4913-aef2-84dc49e82c91');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('22c1951b-483a-47d2-9350-b9525c0238ab', 'Contact 37', 'Wonka Industries (Lead)', 'contact37@example.com', 'hot', 2289, 'Social Media', 'b750744d-5144-4685-b27e-324c93788185', NULL, NULL, NULL, now() - interval '38 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('22c1951b-483a-47d2-9350-b9525c0238ab', '37bd3a3c-d940-4f3e-89e9-47b7c8c941cc');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('5cce16e4-3c56-4759-a22c-a535f0c73c4d', 'Contact 38', 'Oscorp (Lead)', 'contact38@example.com', 'negotiation', 3719, 'Website', 'b750744d-5144-4685-b27e-324c93788185', NULL, NULL, NULL, now() - interval '39 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('5cce16e4-3c56-4759-a22c-a535f0c73c4d', '37bd3a3c-d940-4f3e-89e9-47b7c8c941cc');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('5cce16e4-3c56-4759-a22c-a535f0c73c4d', '1bf9e124-6487-417f-b9ba-a31d25fb3b2c');
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('5a93b02c-9109-4610-beef-fc66f0aadf3d', 'Contact 39', 'Hooli (Lead)', 'contact39@example.com', 'lost', 642, 'Cold Call', 'd50078c7-ec2d-47f1-b7d4-d4a4d40b3e66', NULL, now() - interval '6 days', 'No Response', now() - interval '19 days');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('5a93b02c-9109-4610-beef-fc66f0aadf3d', '30970cdc-c058-4913-aef2-84dc49e82c91');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('5a93b02c-9109-4610-beef-fc66f0aadf3d', 'e82477e5-8f6a-4e2a-b099-4f248d20732d');
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('5a93b02c-9109-4610-beef-fc66f0aadf3d', '1bf9e124-6487-417f-b9ba-a31d25fb3b2c');

-- 5. Projects
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('4d9833f6-86bf-4b1a-b712-a52b3f93ab66', '6541b743-003b-4585-9e64-c1d2584a6efc', 'Implementation Project 1', 'review', current_date + interval '16 days', now() - interval '5 days');
INSERT INTO public.project_members (project_id, user_id) VALUES ('4d9833f6-86bf-4b1a-b712-a52b3f93ab66', 'b750744d-5144-4685-b27e-324c93788185');
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('341fa43f-a3e4-4e31-93b5-ed8cb169d85b', 'd0c883ae-60af-4c4c-8970-c5f54d0a1e5c', 'Implementation Project 2', 'planning', current_date + interval '9 days', now() - interval '10 days');
INSERT INTO public.project_members (project_id, user_id) VALUES ('341fa43f-a3e4-4e31-93b5-ed8cb169d85b', 'd50078c7-ec2d-47f1-b7d4-d4a4d40b3e66');
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('fd9c88a8-76c7-414b-b693-0b8098a985e8', 'e62a5d2d-e355-4817-bcf2-b0aeac8f303f', 'Implementation Project 3', 'in_progress', current_date + interval '7 days', now() - interval '19 days');
INSERT INTO public.project_members (project_id, user_id) VALUES ('fd9c88a8-76c7-414b-b693-0b8098a985e8', '195b23e7-a8d2-4cbd-a4a2-9c437e8bc923');
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('bdf8f49d-1adf-47f5-a044-04ee136c3757', '1a54f644-e8e4-4c42-941a-2fca70bd2bc4', 'Implementation Project 4', 'completed', current_date + interval '5 days', now() - interval '6 days');
INSERT INTO public.project_members (project_id, user_id) VALUES ('bdf8f49d-1adf-47f5-a044-04ee136c3757', 'b750744d-5144-4685-b27e-324c93788185');
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('9a3c5dbb-f633-44f7-8077-46f5f4fee51c', 'e9d0b187-e3b5-4219-8d68-5d1bfd321269', 'Implementation Project 5', 'in_progress', current_date + interval '22 days', now() - interval '1 days');
INSERT INTO public.project_members (project_id, user_id) VALUES ('9a3c5dbb-f633-44f7-8077-46f5f4fee51c', 'd50078c7-ec2d-47f1-b7d4-d4a4d40b3e66');
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('448817a0-6be6-4a42-b03e-3f34f5a58df8', '6541b743-003b-4585-9e64-c1d2584a6efc', 'Implementation Project 6', 'completed', current_date + interval '27 days', now() - interval '10 days');
INSERT INTO public.project_members (project_id, user_id) VALUES ('448817a0-6be6-4a42-b03e-3f34f5a58df8', '195b23e7-a8d2-4cbd-a4a2-9c437e8bc923');
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('d8bbc4a6-96e1-46d9-97b8-1b722cbe2e5e', '492aaa47-dc97-465c-9727-1ad772c5b79a', 'Implementation Project 7', 'completed', current_date + interval '9 days', now() - interval '12 days');
INSERT INTO public.project_members (project_id, user_id) VALUES ('d8bbc4a6-96e1-46d9-97b8-1b722cbe2e5e', 'b750744d-5144-4685-b27e-324c93788185');
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('6e028e59-d763-49cb-acb3-6981a7bdb15b', '45ab4e2c-fd87-4087-95b0-e3b92faaaefa', 'Implementation Project 8', 'in_progress', current_date + interval '27 days', now() - interval '16 days');
INSERT INTO public.project_members (project_id, user_id) VALUES ('6e028e59-d763-49cb-acb3-6981a7bdb15b', 'd50078c7-ec2d-47f1-b7d4-d4a4d40b3e66');
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('37bb6dc3-10e7-4757-9ecd-b58068da1651', 'd3b55152-f9b4-4b3c-9dd0-9a0449c05ba2', 'Implementation Project 9', 'completed', current_date + interval '20 days', now() - interval '8 days');
INSERT INTO public.project_members (project_id, user_id) VALUES ('37bb6dc3-10e7-4757-9ecd-b58068da1651', 'b750744d-5144-4685-b27e-324c93788185');
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('371d2a5a-3298-4a39-8548-e564840a52b3', 'e9d0b187-e3b5-4219-8d68-5d1bfd321269', 'Implementation Project 10', 'completed', current_date + interval '16 days', now() - interval '13 days');
INSERT INTO public.project_members (project_id, user_id) VALUES ('371d2a5a-3298-4a39-8548-e564840a52b3', '195b23e7-a8d2-4cbd-a4a2-9c437e8bc923');
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('cc06c973-c011-4d5e-b40f-92ef442334ad', 'd0c883ae-60af-4c4c-8970-c5f54d0a1e5c', 'Implementation Project 11', 'completed', current_date + interval '11 days', now() - interval '7 days');
INSERT INTO public.project_members (project_id, user_id) VALUES ('cc06c973-c011-4d5e-b40f-92ef442334ad', 'd50078c7-ec2d-47f1-b7d4-d4a4d40b3e66');
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('6c67c4ca-9af0-4e80-a219-709605105483', '45ab4e2c-fd87-4087-95b0-e3b92faaaefa', 'Implementation Project 12', 'review', current_date + interval '28 days', now() - interval '10 days');
INSERT INTO public.project_members (project_id, user_id) VALUES ('6c67c4ca-9af0-4e80-a219-709605105483', '195b23e7-a8d2-4cbd-a4a2-9c437e8bc923');
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('f591dac6-54b7-469f-94a5-d98c1068140c', 'cfae116e-aee1-4a8e-b057-e8337f1975ee', 'Implementation Project 13', 'review', current_date + interval '10 days', now() - interval '10 days');
INSERT INTO public.project_members (project_id, user_id) VALUES ('f591dac6-54b7-469f-94a5-d98c1068140c', 'b750744d-5144-4685-b27e-324c93788185');
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('2e2ed9a8-e745-45e6-b37f-09f8d1db4449', 'd3b55152-f9b4-4b3c-9dd0-9a0449c05ba2', 'Implementation Project 14', 'completed', current_date + interval '8 days', now() - interval '20 days');
INSERT INTO public.project_members (project_id, user_id) VALUES ('2e2ed9a8-e745-45e6-b37f-09f8d1db4449', '195b23e7-a8d2-4cbd-a4a2-9c437e8bc923');
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('3990c2de-5000-4ac7-b3c8-8766622b93b4', 'a2dddc85-8b3f-4921-b058-8744543bc221', 'Implementation Project 15', 'in_progress', current_date + interval '21 days', now() - interval '17 days');
INSERT INTO public.project_members (project_id, user_id) VALUES ('3990c2de-5000-4ac7-b3c8-8766622b93b4', '195b23e7-a8d2-4cbd-a4a2-9c437e8bc923');

-- 6. Tickets
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('282f08eb-b2e5-4037-bbda-2b31056904ea', '8f345d18-10e2-4258-9228-f0fddf7677a7', '6e028e59-d763-49cb-acb3-6981a7bdb15b', 'Support Request 1', 'Client needs help with configuration.', 'open', 'low', 'b750744d-5144-4685-b27e-324c93788185', 'b750744d-5144-4685-b27e-324c93788185', NULL, now() - interval '7 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('afdd370e-04e6-4c1c-8c58-d27c4f9a6815', '8f345d18-10e2-4258-9228-f0fddf7677a7', NULL, 'Support Request 2', 'Client needs help with configuration.', 'open', 'high', 'b750744d-5144-4685-b27e-324c93788185', 'd50078c7-ec2d-47f1-b7d4-d4a4d40b3e66', NULL, now() - interval '2 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('225292ef-5c57-457f-9d4f-5b38b32cf2b7', 'e9d0b187-e3b5-4219-8d68-5d1bfd321269', '37bb6dc3-10e7-4757-9ecd-b58068da1651', 'Support Request 3', 'Client needs help with configuration.', 'open', 'low', 'b750744d-5144-4685-b27e-324c93788185', 'd50078c7-ec2d-47f1-b7d4-d4a4d40b3e66', NULL, now() - interval '10 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('54ce2e98-38b4-4940-a803-b8f6a8df61f6', '48d16a7e-c707-4b10-90a7-d3e4a37ed566', '6e028e59-d763-49cb-acb3-6981a7bdb15b', 'Support Request 4', 'Client needs help with configuration.', 'in_progress', 'low', 'b750744d-5144-4685-b27e-324c93788185', 'b750744d-5144-4685-b27e-324c93788185', NULL, now() - interval '6 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('7d78232c-cbc5-4627-a6c2-aa6f49aaef40', '1a54f644-e8e4-4c42-941a-2fca70bd2bc4', 'cc06c973-c011-4d5e-b40f-92ef442334ad', 'Support Request 5', 'Client needs help with configuration.', 'open', 'medium', 'b750744d-5144-4685-b27e-324c93788185', 'd50078c7-ec2d-47f1-b7d4-d4a4d40b3e66', NULL, now() - interval '14 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('494f1fb7-e5be-473d-a55d-f54831d3172d', '492aaa47-dc97-465c-9727-1ad772c5b79a', NULL, 'Support Request 6', 'Client needs help with configuration.', 'waiting', 'critical', 'b750744d-5144-4685-b27e-324c93788185', '195b23e7-a8d2-4cbd-a4a2-9c437e8bc923', NULL, now() - interval '9 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('d16c8505-db07-4672-9059-e05ecc4307df', '1dc96a7a-3336-4f35-9078-b11053eb59ed', NULL, 'Support Request 7', 'Client needs help with configuration.', 'resolved', 'low', 'b750744d-5144-4685-b27e-324c93788185', '195b23e7-a8d2-4cbd-a4a2-9c437e8bc923', now() - interval '5 days', now() - interval '9 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('e76dbb7c-7462-4e9e-9975-5dd889ddd36b', '658a9b36-5d19-4a82-888d-6ad17f0beb37', NULL, 'Support Request 8', 'Client needs help with configuration.', 'resolved', 'low', 'b750744d-5144-4685-b27e-324c93788185', 'b750744d-5144-4685-b27e-324c93788185', now() - interval '3 days', now() - interval '2 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('6e69d6e9-88f1-4e49-8af3-60ea37e2032b', '1dc96a7a-3336-4f35-9078-b11053eb59ed', '9a3c5dbb-f633-44f7-8077-46f5f4fee51c', 'Support Request 9', 'Client needs help with configuration.', 'in_progress', 'high', 'b750744d-5144-4685-b27e-324c93788185', 'b750744d-5144-4685-b27e-324c93788185', NULL, now() - interval '3 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('852776b4-c1d5-43b2-9aef-0a1afcf33502', '45ab4e2c-fd87-4087-95b0-e3b92faaaefa', 'd8bbc4a6-96e1-46d9-97b8-1b722cbe2e5e', 'Support Request 10', 'Client needs help with configuration.', 'waiting', 'low', 'b750744d-5144-4685-b27e-324c93788185', 'b750744d-5144-4685-b27e-324c93788185', NULL, now() - interval '12 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('8dfac6c6-b26f-44ae-b314-32c0ad5ca7c6', 'cfae116e-aee1-4a8e-b057-e8337f1975ee', NULL, 'Support Request 11', 'Client needs help with configuration.', 'waiting', 'medium', 'b750744d-5144-4685-b27e-324c93788185', 'd50078c7-ec2d-47f1-b7d4-d4a4d40b3e66', NULL, now() - interval '1 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('9866ea47-d7a2-4eed-8aef-e797d3b60804', 'e62a5d2d-e355-4817-bcf2-b0aeac8f303f', '6c67c4ca-9af0-4e80-a219-709605105483', 'Support Request 12', 'Client needs help with configuration.', 'resolved', 'medium', 'b750744d-5144-4685-b27e-324c93788185', 'b750744d-5144-4685-b27e-324c93788185', now() - interval '3 days', now() - interval '3 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('7c31e8e8-6579-4a1e-b3be-33be78d84017', '1a54f644-e8e4-4c42-941a-2fca70bd2bc4', NULL, 'Support Request 13', 'Client needs help with configuration.', 'waiting', 'high', 'b750744d-5144-4685-b27e-324c93788185', 'd50078c7-ec2d-47f1-b7d4-d4a4d40b3e66', NULL, now() - interval '4 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('72fc076d-3465-4fa4-b93d-36e01cea82b5', 'e62a5d2d-e355-4817-bcf2-b0aeac8f303f', NULL, 'Support Request 14', 'Client needs help with configuration.', 'resolved', 'high', 'b750744d-5144-4685-b27e-324c93788185', 'b750744d-5144-4685-b27e-324c93788185', now() - interval '2 days', now() - interval '14 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('9fa3bb56-426f-4f1c-a6ec-86b936ba3b05', '1a54f644-e8e4-4c42-941a-2fca70bd2bc4', '341fa43f-a3e4-4e31-93b5-ed8cb169d85b', 'Support Request 15', 'Client needs help with configuration.', 'open', 'critical', 'b750744d-5144-4685-b27e-324c93788185', 'b750744d-5144-4685-b27e-324c93788185', NULL, now() - interval '7 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('2dcb1485-8b4f-4a78-861e-06b0e3c8395b', '492aaa47-dc97-465c-9727-1ad772c5b79a', 'f591dac6-54b7-469f-94a5-d98c1068140c', 'Support Request 16', 'Client needs help with configuration.', 'open', 'critical', 'b750744d-5144-4685-b27e-324c93788185', 'd50078c7-ec2d-47f1-b7d4-d4a4d40b3e66', NULL, now() - interval '3 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('cc73ac04-8cfd-408a-9c85-83e83b33c6f4', 'e9d0b187-e3b5-4219-8d68-5d1bfd321269', NULL, 'Support Request 17', 'Client needs help with configuration.', 'open', 'medium', 'b750744d-5144-4685-b27e-324c93788185', 'b750744d-5144-4685-b27e-324c93788185', NULL, now() - interval '1 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('c92476e1-5103-4eb6-9d98-7a12f0c302a8', 'a2dddc85-8b3f-4921-b058-8744543bc221', '6e028e59-d763-49cb-acb3-6981a7bdb15b', 'Support Request 18', 'Client needs help with configuration.', 'waiting', 'critical', 'b750744d-5144-4685-b27e-324c93788185', 'd50078c7-ec2d-47f1-b7d4-d4a4d40b3e66', NULL, now() - interval '11 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('fe26cf19-c27f-47a4-b7c4-c08be5da9b64', 'd0c883ae-60af-4c4c-8970-c5f54d0a1e5c', NULL, 'Support Request 19', 'Client needs help with configuration.', 'in_progress', 'high', 'b750744d-5144-4685-b27e-324c93788185', 'd50078c7-ec2d-47f1-b7d4-d4a4d40b3e66', NULL, now() - interval '1 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('2d0bf847-55f0-4ec9-8e26-8d2d04de4541', 'd3b55152-f9b4-4b3c-9dd0-9a0449c05ba2', NULL, 'Support Request 20', 'Client needs help with configuration.', 'in_progress', 'medium', 'b750744d-5144-4685-b27e-324c93788185', 'b750744d-5144-4685-b27e-324c93788185', NULL, now() - interval '1 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('c5d1ebc6-40b4-4ed9-bd3a-62bd57190924', 'a2dddc85-8b3f-4921-b058-8744543bc221', '37bb6dc3-10e7-4757-9ecd-b58068da1651', 'Support Request 21', 'Client needs help with configuration.', 'open', 'high', 'b750744d-5144-4685-b27e-324c93788185', 'b750744d-5144-4685-b27e-324c93788185', NULL, now() - interval '4 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('b27cf4f2-33f0-4950-9060-247985b0ea99', 'd3b55152-f9b4-4b3c-9dd0-9a0449c05ba2', NULL, 'Support Request 22', 'Client needs help with configuration.', 'in_progress', 'critical', 'b750744d-5144-4685-b27e-324c93788185', '195b23e7-a8d2-4cbd-a4a2-9c437e8bc923', NULL, now() - interval '9 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('751df1ff-d345-43c0-a689-6cc63475fe00', '6541b743-003b-4585-9e64-c1d2584a6efc', NULL, 'Support Request 23', 'Client needs help with configuration.', 'resolved', 'high', 'b750744d-5144-4685-b27e-324c93788185', '195b23e7-a8d2-4cbd-a4a2-9c437e8bc923', now() - interval '1 days', now() - interval '4 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('09c982e4-6448-4ca4-b6a6-ad8aabe6a99a', '45ab4e2c-fd87-4087-95b0-e3b92faaaefa', '9a3c5dbb-f633-44f7-8077-46f5f4fee51c', 'Support Request 24', 'Client needs help with configuration.', 'in_progress', 'low', 'b750744d-5144-4685-b27e-324c93788185', 'b750744d-5144-4685-b27e-324c93788185', NULL, now() - interval '3 days');
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('d8ca4d9c-0ed3-4dc7-9051-e73d2cccaf87', 'd3b55152-f9b4-4b3c-9dd0-9a0449c05ba2', NULL, 'Support Request 25', 'Client needs help with configuration.', 'in_progress', 'low', 'b750744d-5144-4685-b27e-324c93788185', 'b750744d-5144-4685-b27e-324c93788185', NULL, now() - interval '1 days');
