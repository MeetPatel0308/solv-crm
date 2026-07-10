
-- ==========================================
-- DEMO SEED DATA FOR SOLV CRM & ERP
-- ==========================================
-- WARNING: This script assumes tables are empty or will insert ignoring conflicts.

-- 1. Create Users
-- We insert into auth.users directly. Note: these users cannot log in.
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at) 
VALUES ('955126bf-a3df-4d47-8812-747adbc7e961', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'alice.sales@example.com', '', now(), now(), now())
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.profiles (id, full_name, email, job_title, created_at, updated_at) 
VALUES ('955126bf-a3df-4d47-8812-747adbc7e961', 'Alice Smith', 'alice.sales@example.com', 'Sales Manager', now(), now())
ON CONFLICT (id) DO UPDATE SET full_name = EXCLUDED.full_name, job_title = EXCLUDED.job_title;
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at) 
VALUES ('0e9f255a-3b7c-4508-95fd-cfd2b9ff42af', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'bob.account@example.com', '', now(), now(), now())
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.profiles (id, full_name, email, job_title, created_at, updated_at) 
VALUES ('0e9f255a-3b7c-4508-95fd-cfd2b9ff42af', 'Bob Johnson', 'bob.account@example.com', 'Account Manager', now(), now())
ON CONFLICT (id) DO UPDATE SET full_name = EXCLUDED.full_name, job_title = EXCLUDED.job_title;
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at) 
VALUES ('b63a5145-cbca-4b3a-b631-bc0b46a792ae', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'charlie.tech@example.com', '', now(), now(), now())
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.profiles (id, full_name, email, job_title, created_at, updated_at) 
VALUES ('b63a5145-cbca-4b3a-b631-bc0b46a792ae', 'Charlie Davis', 'charlie.tech@example.com', 'Lead Developer', now(), now())
ON CONFLICT (id) DO UPDATE SET full_name = EXCLUDED.full_name, job_title = EXCLUDED.job_title;

-- 2. Services
INSERT INTO public.services (id, name, created_at, updated_at) VALUES ('f5c175c7-b950-4223-9bb4-e8989dad28ab', 'KIBO', now(), now()) ON CONFLICT DO NOTHING;
INSERT INTO public.services (id, name, created_at, updated_at) VALUES ('eb6eba4f-fb1c-48cc-940d-81f72b789918', 'AI Sales App', now(), now()) ON CONFLICT DO NOTHING;
INSERT INTO public.services (id, name, created_at, updated_at) VALUES ('730e827d-cd83-481f-ba75-d25865adf928', 'Website Development', now(), now()) ON CONFLICT DO NOTHING;
INSERT INTO public.services (id, name, created_at, updated_at) VALUES ('b079400f-263e-451d-a90b-33333df24b70', 'Hosting', now(), now()) ON CONFLICT DO NOTHING;
INSERT INTO public.services (id, name, created_at, updated_at) VALUES ('c1d8d30b-5027-4154-8450-31414fe9e525', 'SEO', now(), now()) ON CONFLICT DO NOTHING;
INSERT INTO public.services (id, name, created_at, updated_at) VALUES ('5cb08880-4d0c-4eb4-9c46-24402b266d2b', 'Meta Ads Management', now(), now()) ON CONFLICT DO NOTHING;
INSERT INTO public.services (id, name, created_at, updated_at) VALUES ('d790350c-4a34-44fc-8896-9977099d933f', 'Google Ads Management', now(), now()) ON CONFLICT DO NOTHING;
INSERT INTO public.services (id, name, created_at, updated_at) VALUES ('5bb5df8b-294c-463c-a2bb-d94abc82460f', 'Broadcast Messaging', now(), now()) ON CONFLICT DO NOTHING;

-- 3. Customers, Sales & Customer Services
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('0e203a2c-9961-4a20-8f2a-512784f896bb', 'Acme Corp', 'contact@acme corp.com', 'Real Estate', '955126bf-a3df-4d47-8812-747adbc7e961', 'active', now() - interval '13 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('0e203a2c-9961-4a20-8f2a-512784f896bb', 'eb6eba4f-fb1c-48cc-940d-81f72b789918', 'AI Sales App', 'retainer', 1093, 'active', current_date, now() - interval '18 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('0e203a2c-9961-4a20-8f2a-512784f896bb', 'eb6eba4f-fb1c-48cc-940d-81f72b789918', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('0e203a2c-9961-4a20-8f2a-512784f896bb', 'b079400f-263e-451d-a90b-33333df24b70', 'Hosting', 'retainer', 741, 'active', current_date, now() - interval '30 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('0e203a2c-9961-4a20-8f2a-512784f896bb', 'b079400f-263e-451d-a90b-33333df24b70', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('637c74e5-4d3e-4360-a1d1-90cf149841ac', 'Globex Corporation', 'contact@globex corporation.com', 'Finance', '955126bf-a3df-4d47-8812-747adbc7e961', 'active', now() - interval '52 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('637c74e5-4d3e-4360-a1d1-90cf149841ac', 'd790350c-4a34-44fc-8896-9977099d933f', 'Google Ads Management', 'retainer', 1351, 'active', current_date, now() - interval '4 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('637c74e5-4d3e-4360-a1d1-90cf149841ac', 'd790350c-4a34-44fc-8896-9977099d933f', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('637c74e5-4d3e-4360-a1d1-90cf149841ac', 'b079400f-263e-451d-a90b-33333df24b70', 'Hosting', 'one-off', 3700, 'active', current_date, now() - interval '15 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('637c74e5-4d3e-4360-a1d1-90cf149841ac', 'b079400f-263e-451d-a90b-33333df24b70', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('637c74e5-4d3e-4360-a1d1-90cf149841ac', '730e827d-cd83-481f-ba75-d25865adf928', 'Website Development', 'retainer', 531, 'active', current_date, now() - interval '6 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('637c74e5-4d3e-4360-a1d1-90cf149841ac', '730e827d-cd83-481f-ba75-d25865adf928', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('e4d2ec47-f1fb-4a18-8ebf-195d8f550967', 'Soylent Corp', 'contact@soylent corp.com', 'Education', '955126bf-a3df-4d47-8812-747adbc7e961', 'active', now() - interval '64 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('e4d2ec47-f1fb-4a18-8ebf-195d8f550967', 'c1d8d30b-5027-4154-8450-31414fe9e525', 'SEO', 'one-off', 5922, 'active', current_date, now() - interval '18 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('e4d2ec47-f1fb-4a18-8ebf-195d8f550967', 'c1d8d30b-5027-4154-8450-31414fe9e525', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('e4d2ec47-f1fb-4a18-8ebf-195d8f550967', 'eb6eba4f-fb1c-48cc-940d-81f72b789918', 'AI Sales App', 'one-off', 7127, 'active', current_date, now() - interval '26 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('e4d2ec47-f1fb-4a18-8ebf-195d8f550967', 'eb6eba4f-fb1c-48cc-940d-81f72b789918', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('e4d2ec47-f1fb-4a18-8ebf-195d8f550967', 'f5c175c7-b950-4223-9bb4-e8989dad28ab', 'KIBO', 'retainer', 1441, 'active', current_date, now() - interval '8 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('e4d2ec47-f1fb-4a18-8ebf-195d8f550967', 'f5c175c7-b950-4223-9bb4-e8989dad28ab', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('964d9373-b616-418b-894f-57f827951e18', 'Initech', 'contact@initech.com', 'Real Estate', 'b63a5145-cbca-4b3a-b631-bc0b46a792ae', 'active', now() - interval '65 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('964d9373-b616-418b-894f-57f827951e18', '5cb08880-4d0c-4eb4-9c46-24402b266d2b', 'Meta Ads Management', 'one-off', 4683, 'active', current_date, now() - interval '27 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('964d9373-b616-418b-894f-57f827951e18', '5cb08880-4d0c-4eb4-9c46-24402b266d2b', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('964d9373-b616-418b-894f-57f827951e18', 'f5c175c7-b950-4223-9bb4-e8989dad28ab', 'KIBO', 'one-off', 7159, 'active', current_date, now() - interval '16 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('964d9373-b616-418b-894f-57f827951e18', 'f5c175c7-b950-4223-9bb4-e8989dad28ab', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('6528f4c0-3064-4abb-a1dd-0b20b9770b6b', 'Umbrella Corporation', 'contact@umbrella corporation.com', 'Healthcare', '955126bf-a3df-4d47-8812-747adbc7e961', 'active', now() - interval '85 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('6528f4c0-3064-4abb-a1dd-0b20b9770b6b', '5cb08880-4d0c-4eb4-9c46-24402b266d2b', 'Meta Ads Management', 'one-off', 7304, 'active', current_date, now() - interval '5 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('6528f4c0-3064-4abb-a1dd-0b20b9770b6b', '5cb08880-4d0c-4eb4-9c46-24402b266d2b', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('d0a514f5-58e2-4c2a-ac2f-5a221479f1bc', 'Stark Industries', 'contact@stark industries.com', 'Technology', '0e9f255a-3b7c-4508-95fd-cfd2b9ff42af', 'active', now() - interval '33 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('d0a514f5-58e2-4c2a-ac2f-5a221479f1bc', 'f5c175c7-b950-4223-9bb4-e8989dad28ab', 'KIBO', 'one-off', 5278, 'active', current_date, now() - interval '15 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('d0a514f5-58e2-4c2a-ac2f-5a221479f1bc', 'f5c175c7-b950-4223-9bb4-e8989dad28ab', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('d0a514f5-58e2-4c2a-ac2f-5a221479f1bc', '730e827d-cd83-481f-ba75-d25865adf928', 'Website Development', 'retainer', 1144, 'active', current_date, now() - interval '14 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('d0a514f5-58e2-4c2a-ac2f-5a221479f1bc', '730e827d-cd83-481f-ba75-d25865adf928', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('68d3e665-01da-4931-a295-e39f67e0c7ab', 'Wayne Enterprises', 'contact@wayne enterprises.com', 'Healthcare', 'b63a5145-cbca-4b3a-b631-bc0b46a792ae', 'active', now() - interval '95 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('68d3e665-01da-4931-a295-e39f67e0c7ab', 'c1d8d30b-5027-4154-8450-31414fe9e525', 'SEO', 'one-off', 6788, 'active', current_date, now() - interval '21 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('68d3e665-01da-4931-a295-e39f67e0c7ab', 'c1d8d30b-5027-4154-8450-31414fe9e525', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('cda4105e-5623-4e2d-b817-a430e7d5ef9d', 'Cyberdyne Systems', 'contact@cyberdyne systems.com', 'Technology', '955126bf-a3df-4d47-8812-747adbc7e961', 'active', now() - interval '38 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('cda4105e-5623-4e2d-b817-a430e7d5ef9d', '5bb5df8b-294c-463c-a2bb-d94abc82460f', 'Broadcast Messaging', 'one-off', 4121, 'active', current_date, now() - interval '22 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('cda4105e-5623-4e2d-b817-a430e7d5ef9d', '5bb5df8b-294c-463c-a2bb-d94abc82460f', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('cda4105e-5623-4e2d-b817-a430e7d5ef9d', '5cb08880-4d0c-4eb4-9c46-24402b266d2b', 'Meta Ads Management', 'retainer', 860, 'active', current_date, now() - interval '28 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('cda4105e-5623-4e2d-b817-a430e7d5ef9d', '5cb08880-4d0c-4eb4-9c46-24402b266d2b', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('492f20c8-a30f-4b94-a1a5-5e950c382fb0', 'Massive Dynamic', 'contact@massive dynamic.com', 'Real Estate', '955126bf-a3df-4d47-8812-747adbc7e961', 'active', now() - interval '16 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('492f20c8-a30f-4b94-a1a5-5e950c382fb0', 'c1d8d30b-5027-4154-8450-31414fe9e525', 'SEO', 'retainer', 800, 'active', current_date, now() - interval '15 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('492f20c8-a30f-4b94-a1a5-5e950c382fb0', 'c1d8d30b-5027-4154-8450-31414fe9e525', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('492f20c8-a30f-4b94-a1a5-5e950c382fb0', '730e827d-cd83-481f-ba75-d25865adf928', 'Website Development', 'one-off', 6424, 'active', current_date, now() - interval '8 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('492f20c8-a30f-4b94-a1a5-5e950c382fb0', '730e827d-cd83-481f-ba75-d25865adf928', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('5131e7e4-247b-4304-be55-cef0dceae9b4', 'Genco Pura Olive Oil', 'contact@genco pura olive oil.com', 'Logistics', '0e9f255a-3b7c-4508-95fd-cfd2b9ff42af', 'active', now() - interval '62 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('5131e7e4-247b-4304-be55-cef0dceae9b4', 'd790350c-4a34-44fc-8896-9977099d933f', 'Google Ads Management', 'one-off', 1021, 'active', current_date, now() - interval '17 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('5131e7e4-247b-4304-be55-cef0dceae9b4', 'd790350c-4a34-44fc-8896-9977099d933f', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('95b1fe0a-2fda-4aeb-9855-8eb7a0608172', 'LexCorp', 'contact@lexcorp.com', 'Retail', '0e9f255a-3b7c-4508-95fd-cfd2b9ff42af', 'active', now() - interval '20 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('95b1fe0a-2fda-4aeb-9855-8eb7a0608172', 'd790350c-4a34-44fc-8896-9977099d933f', 'Google Ads Management', 'one-off', 9372, 'active', current_date, now() - interval '29 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('95b1fe0a-2fda-4aeb-9855-8eb7a0608172', 'd790350c-4a34-44fc-8896-9977099d933f', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('cdde504e-90bd-40ba-8278-c35898fe0136', 'Oceanic Airlines', 'contact@oceanic airlines.com', 'Healthcare', '0e9f255a-3b7c-4508-95fd-cfd2b9ff42af', 'active', now() - interval '45 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('cdde504e-90bd-40ba-8278-c35898fe0136', '730e827d-cd83-481f-ba75-d25865adf928', 'Website Development', 'retainer', 201, 'active', current_date, now() - interval '29 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('cdde504e-90bd-40ba-8278-c35898fe0136', '730e827d-cd83-481f-ba75-d25865adf928', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('cdde504e-90bd-40ba-8278-c35898fe0136', 'f5c175c7-b950-4223-9bb4-e8989dad28ab', 'KIBO', 'retainer', 860, 'active', current_date, now() - interval '14 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('cdde504e-90bd-40ba-8278-c35898fe0136', 'f5c175c7-b950-4223-9bb4-e8989dad28ab', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('560e81d1-3983-4641-abf5-aa6a0791ec0a', 'Wonka Industries', 'contact@wonka industries.com', 'Technology', '955126bf-a3df-4d47-8812-747adbc7e961', 'active', now() - interval '65 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('560e81d1-3983-4641-abf5-aa6a0791ec0a', 'f5c175c7-b950-4223-9bb4-e8989dad28ab', 'KIBO', 'retainer', 1216, 'active', current_date, now() - interval '12 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('560e81d1-3983-4641-abf5-aa6a0791ec0a', 'f5c175c7-b950-4223-9bb4-e8989dad28ab', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('471237b9-cb41-4421-bae5-580b0d7d2611', 'Oscorp', 'contact@oscorp.com', 'Logistics', '955126bf-a3df-4d47-8812-747adbc7e961', 'active', now() - interval '99 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('471237b9-cb41-4421-bae5-580b0d7d2611', '730e827d-cd83-481f-ba75-d25865adf928', 'Website Development', 'retainer', 1207, 'active', current_date, now() - interval '24 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('471237b9-cb41-4421-bae5-580b0d7d2611', '730e827d-cd83-481f-ba75-d25865adf928', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('9e1c678c-f396-4baa-91fb-1ad667592a73', 'Hooli', 'contact@hooli.com', 'Logistics', '0e9f255a-3b7c-4508-95fd-cfd2b9ff42af', 'active', now() - interval '80 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('9e1c678c-f396-4baa-91fb-1ad667592a73', '5bb5df8b-294c-463c-a2bb-d94abc82460f', 'Broadcast Messaging', 'one-off', 8699, 'active', current_date, now() - interval '13 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('9e1c678c-f396-4baa-91fb-1ad667592a73', '5bb5df8b-294c-463c-a2bb-d94abc82460f', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('9e1c678c-f396-4baa-91fb-1ad667592a73', 'd790350c-4a34-44fc-8896-9977099d933f', 'Google Ads Management', 'one-off', 9112, 'active', current_date, now() - interval '20 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('9e1c678c-f396-4baa-91fb-1ad667592a73', 'd790350c-4a34-44fc-8896-9977099d933f', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('9e1c678c-f396-4baa-91fb-1ad667592a73', 'eb6eba4f-fb1c-48cc-940d-81f72b789918', 'AI Sales App', 'retainer', 798, 'active', current_date, now() - interval '21 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('9e1c678c-f396-4baa-91fb-1ad667592a73', 'eb6eba4f-fb1c-48cc-940d-81f72b789918', 'active', current_date, now());

-- 4. Leads & Lead Services
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('b5bf72c0-988f-4a4b-9db4-b918d2b44c75', 'Contact 15', 'Oceanic Airlines', 'contact15@example.com', 'converted', 3277, 'Cold Call', 'b63a5145-cbca-4b3a-b631-bc0b46a792ae', now() - interval '3 days', NULL, NULL, now() - interval '22 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('b5bf72c0-988f-4a4b-9db4-b918d2b44c75', 'f5c175c7-b950-4223-9bb4-e8989dad28ab') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('b5bf72c0-988f-4a4b-9db4-b918d2b44c75', 'd790350c-4a34-44fc-8896-9977099d933f') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('d215b617-2ae0-402c-9402-7853ddb45163', 'Contact 16', 'Dunder Mifflin (Lead)', 'contact16@example.com', 'cold', 607, 'Referral', '955126bf-a3df-4d47-8812-747adbc7e961', NULL, NULL, NULL, now() - interval '39 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('d215b617-2ae0-402c-9402-7853ddb45163', '5bb5df8b-294c-463c-a2bb-d94abc82460f') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('5c02e478-6fc8-41e3-bad4-da16ce768381', 'Contact 17', 'Aperture Science (Lead)', 'contact17@example.com', 'hot', 3780, 'Social Media', '0e9f255a-3b7c-4508-95fd-cfd2b9ff42af', NULL, NULL, NULL, now() - interval '35 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('5c02e478-6fc8-41e3-bad4-da16ce768381', 'f5c175c7-b950-4223-9bb4-e8989dad28ab') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('5c02e478-6fc8-41e3-bad4-da16ce768381', 'c1d8d30b-5027-4154-8450-31414fe9e525') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('ed0b4ee9-3c78-43e6-a17e-fe94909164f3', 'Contact 18', 'Veidt Enterprises (Lead)', 'contact18@example.com', 'negotiation', 2171, 'Referral', '955126bf-a3df-4d47-8812-747adbc7e961', NULL, NULL, NULL, now() - interval '38 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('ed0b4ee9-3c78-43e6-a17e-fe94909164f3', 'c1d8d30b-5027-4154-8450-31414fe9e525') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('ed0b4ee9-3c78-43e6-a17e-fe94909164f3', 'eb6eba4f-fb1c-48cc-940d-81f72b789918') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('a13d8944-cb3c-4afb-94fa-48606a97bc27', 'Contact 19', 'Gringotts (Lead)', 'contact19@example.com', 'warm', 694, 'Website', '955126bf-a3df-4d47-8812-747adbc7e961', NULL, NULL, NULL, now() - interval '21 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('a13d8944-cb3c-4afb-94fa-48606a97bc27', 'd790350c-4a34-44fc-8896-9977099d933f') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('a13d8944-cb3c-4afb-94fa-48606a97bc27', '730e827d-cd83-481f-ba75-d25865adf928') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('db6f7731-bb66-4abb-828a-f636c45e0710', 'Contact 20', 'Ollivanders (Lead)', 'contact20@example.com', 'proposal', 4458, 'Cold Call', 'b63a5145-cbca-4b3a-b631-bc0b46a792ae', NULL, NULL, NULL, now() - interval '20 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('db6f7731-bb66-4abb-828a-f636c45e0710', 'c1d8d30b-5027-4154-8450-31414fe9e525') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('4a3bea1a-b2cd-4645-974e-418bc04df99d', 'Contact 21', 'Hooli', 'contact21@example.com', 'lost', 4918, 'Cold Call', 'b63a5145-cbca-4b3a-b631-bc0b46a792ae', NULL, now() - interval '9 days', 'Budget', now() - interval '26 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('4a3bea1a-b2cd-4645-974e-418bc04df99d', 'f5c175c7-b950-4223-9bb4-e8989dad28ab') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('4a3bea1a-b2cd-4645-974e-418bc04df99d', '5cb08880-4d0c-4eb4-9c46-24402b266d2b') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('4a3bea1a-b2cd-4645-974e-418bc04df99d', 'b079400f-263e-451d-a90b-33333df24b70') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('1e7da069-cd8a-4ef2-bd40-433ac16ea4e0', 'Contact 22', 'MomCorp (Lead)', 'contact22@example.com', 'hot', 4866, 'Trade Show', '955126bf-a3df-4d47-8812-747adbc7e961', NULL, NULL, NULL, now() - interval '13 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('1e7da069-cd8a-4ef2-bd40-433ac16ea4e0', 'eb6eba4f-fb1c-48cc-940d-81f72b789918') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('74b2fb80-4038-4d0c-ba87-720bdf06168d', 'Contact 23', 'Slurm (Lead)', 'contact23@example.com', 'warm', 3303, 'Referral', '955126bf-a3df-4d47-8812-747adbc7e961', NULL, NULL, NULL, now() - interval '25 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('74b2fb80-4038-4d0c-ba87-720bdf06168d', 'eb6eba4f-fb1c-48cc-940d-81f72b789918') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('0d90e021-7b65-4e6a-b11a-e315fb3167dc', 'Contact 24', 'Nuka-Cola (Lead)', 'contact24@example.com', 'lost', 1894, 'Trade Show', '0e9f255a-3b7c-4508-95fd-cfd2b9ff42af', NULL, now() - interval '9 days', 'Not a Good Fit', now() - interval '20 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('0d90e021-7b65-4e6a-b11a-e315fb3167dc', 'f5c175c7-b950-4223-9bb4-e8989dad28ab') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('0d90e021-7b65-4e6a-b11a-e315fb3167dc', 'd790350c-4a34-44fc-8896-9977099d933f') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('0d90e021-7b65-4e6a-b11a-e315fb3167dc', '5cb08880-4d0c-4eb4-9c46-24402b266d2b') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('8720efb3-4ed5-48b4-83db-158e25182e1b', 'Contact 25', 'Wonka Industries', 'contact25@example.com', 'hot', 3824, 'Cold Call', '955126bf-a3df-4d47-8812-747adbc7e961', NULL, NULL, NULL, now() - interval '22 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('8720efb3-4ed5-48b4-83db-158e25182e1b', 'f5c175c7-b950-4223-9bb4-e8989dad28ab') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('4bba5e83-1c74-461b-ade3-d6accc97204c', 'Contact 26', 'Cyberdyne Systems', 'contact26@example.com', 'warm', 4402, 'Trade Show', '0e9f255a-3b7c-4508-95fd-cfd2b9ff42af', NULL, NULL, NULL, now() - interval '40 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('4bba5e83-1c74-461b-ade3-d6accc97204c', 'c1d8d30b-5027-4154-8450-31414fe9e525') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('a0fd7b48-466f-4a91-a565-9cea09cd3413', 'Contact 27', 'Soylent Corp (Lead)', 'contact27@example.com', 'converted', 3481, 'Website', '955126bf-a3df-4d47-8812-747adbc7e961', now() - interval '5 days', NULL, NULL, now() - interval '12 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('a0fd7b48-466f-4a91-a565-9cea09cd3413', 'c1d8d30b-5027-4154-8450-31414fe9e525') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('3d521f97-34a2-496c-b001-5ada84ef1506', 'Contact 28', 'Initech (Lead)', 'contact28@example.com', 'lost', 4534, 'Referral', '0e9f255a-3b7c-4508-95fd-cfd2b9ff42af', NULL, now() - interval '4 days', 'Budget', now() - interval '15 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('3d521f97-34a2-496c-b001-5ada84ef1506', '730e827d-cd83-481f-ba75-d25865adf928') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('3d521f97-34a2-496c-b001-5ada84ef1506', 'f5c175c7-b950-4223-9bb4-e8989dad28ab') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('3d521f97-34a2-496c-b001-5ada84ef1506', 'c1d8d30b-5027-4154-8450-31414fe9e525') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('492d48e7-b332-435b-babe-932fa3954919', 'Contact 29', 'Umbrella Corporation (Lead)', 'contact29@example.com', 'converted', 815, 'Social Media', '955126bf-a3df-4d47-8812-747adbc7e961', now() - interval '10 days', NULL, NULL, now() - interval '24 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('492d48e7-b332-435b-babe-932fa3954919', 'c1d8d30b-5027-4154-8450-31414fe9e525') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('492d48e7-b332-435b-babe-932fa3954919', '5bb5df8b-294c-463c-a2bb-d94abc82460f') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('c1d278bb-401f-4c2b-8ecf-3a23077068e3', 'Contact 30', 'Stark Industries (Lead)', 'contact30@example.com', 'negotiation', 4915, 'Referral', '0e9f255a-3b7c-4508-95fd-cfd2b9ff42af', NULL, NULL, NULL, now() - interval '38 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('c1d278bb-401f-4c2b-8ecf-3a23077068e3', 'b079400f-263e-451d-a90b-33333df24b70') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('c1d278bb-401f-4c2b-8ecf-3a23077068e3', '5bb5df8b-294c-463c-a2bb-d94abc82460f') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('771f8d80-211d-411e-b341-6224cc160fa2', 'Contact 31', 'Wayne Enterprises (Lead)', 'contact31@example.com', 'lost', 1039, 'Referral', '0e9f255a-3b7c-4508-95fd-cfd2b9ff42af', NULL, now() - interval '3 days', 'Competitor', now() - interval '18 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('771f8d80-211d-411e-b341-6224cc160fa2', 'eb6eba4f-fb1c-48cc-940d-81f72b789918') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('771f8d80-211d-411e-b341-6224cc160fa2', '5bb5df8b-294c-463c-a2bb-d94abc82460f') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('771f8d80-211d-411e-b341-6224cc160fa2', 'd790350c-4a34-44fc-8896-9977099d933f') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('00e149f4-d010-4940-a5c5-5b4568f5f2f8', 'Contact 32', 'Cyberdyne Systems (Lead)', 'contact32@example.com', 'negotiation', 1338, 'Trade Show', '955126bf-a3df-4d47-8812-747adbc7e961', NULL, NULL, NULL, now() - interval '29 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('00e149f4-d010-4940-a5c5-5b4568f5f2f8', 'eb6eba4f-fb1c-48cc-940d-81f72b789918') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('66ba48a7-6b5c-437e-9ac4-9077e0b5c241', 'Contact 33', 'Massive Dynamic (Lead)', 'contact33@example.com', 'converted', 3343, 'Trade Show', '0e9f255a-3b7c-4508-95fd-cfd2b9ff42af', now() - interval '2 days', NULL, NULL, now() - interval '35 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('66ba48a7-6b5c-437e-9ac4-9077e0b5c241', 'c1d8d30b-5027-4154-8450-31414fe9e525') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('66ba48a7-6b5c-437e-9ac4-9077e0b5c241', 'b079400f-263e-451d-a90b-33333df24b70') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('a7e12ce4-110e-4cf9-b462-979c41c3048e', 'Contact 34', 'Genco Pura Olive Oil (Lead)', 'contact34@example.com', 'warm', 4982, 'Referral', '955126bf-a3df-4d47-8812-747adbc7e961', NULL, NULL, NULL, now() - interval '27 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('a7e12ce4-110e-4cf9-b462-979c41c3048e', '5bb5df8b-294c-463c-a2bb-d94abc82460f') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('a7e12ce4-110e-4cf9-b462-979c41c3048e', 'f5c175c7-b950-4223-9bb4-e8989dad28ab') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('f1743872-0a22-4253-ba3e-531fb0b51bb2', 'Contact 35', 'LexCorp (Lead)', 'contact35@example.com', 'hot', 816, 'Trade Show', 'b63a5145-cbca-4b3a-b631-bc0b46a792ae', NULL, NULL, NULL, now() - interval '12 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('f1743872-0a22-4253-ba3e-531fb0b51bb2', 'eb6eba4f-fb1c-48cc-940d-81f72b789918') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('f1743872-0a22-4253-ba3e-531fb0b51bb2', '730e827d-cd83-481f-ba75-d25865adf928') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('7436ab50-a51b-4ad1-9e5a-f473bfdf7c36', 'Contact 36', 'Oceanic Airlines (Lead)', 'contact36@example.com', 'warm', 565, 'Trade Show', 'b63a5145-cbca-4b3a-b631-bc0b46a792ae', NULL, NULL, NULL, now() - interval '40 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('7436ab50-a51b-4ad1-9e5a-f473bfdf7c36', 'eb6eba4f-fb1c-48cc-940d-81f72b789918') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('d129af7f-9309-461d-b47b-e48008bf3a35', 'Contact 37', 'Wonka Industries (Lead)', 'contact37@example.com', 'warm', 1664, 'Social Media', '0e9f255a-3b7c-4508-95fd-cfd2b9ff42af', NULL, NULL, NULL, now() - interval '26 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('d129af7f-9309-461d-b47b-e48008bf3a35', '5bb5df8b-294c-463c-a2bb-d94abc82460f') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('7e5862ba-1f2b-418c-99b8-b2f5c8a513ec', 'Contact 38', 'Oscorp (Lead)', 'contact38@example.com', 'warm', 793, 'Social Media', 'b63a5145-cbca-4b3a-b631-bc0b46a792ae', NULL, NULL, NULL, now() - interval '33 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('7e5862ba-1f2b-418c-99b8-b2f5c8a513ec', 'd790350c-4a34-44fc-8896-9977099d933f') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('7e5862ba-1f2b-418c-99b8-b2f5c8a513ec', '5bb5df8b-294c-463c-a2bb-d94abc82460f') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('a94a5aa2-f249-43fd-bffd-77edd3a2a5a8', 'Contact 39', 'Hooli (Lead)', 'contact39@example.com', 'proposal', 4769, 'Website', '0e9f255a-3b7c-4508-95fd-cfd2b9ff42af', NULL, NULL, NULL, now() - interval '33 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('a94a5aa2-f249-43fd-bffd-77edd3a2a5a8', 'b079400f-263e-451d-a90b-33333df24b70') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('a94a5aa2-f249-43fd-bffd-77edd3a2a5a8', 'c1d8d30b-5027-4154-8450-31414fe9e525') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('a94a5aa2-f249-43fd-bffd-77edd3a2a5a8', 'd790350c-4a34-44fc-8896-9977099d933f') ON CONFLICT DO NOTHING;

-- 5. Projects
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('e8763893-f5a5-4283-8958-dfde595f3c7f', '5131e7e4-247b-4304-be55-cef0dceae9b4', 'Implementation Project 1', 'completed', current_date + interval '30 days', now() - interval '3 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.project_members (project_id, user_id) VALUES ('e8763893-f5a5-4283-8958-dfde595f3c7f', '0e9f255a-3b7c-4508-95fd-cfd2b9ff42af') ON CONFLICT DO NOTHING;
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('adf5c04c-de34-4dbe-b4e7-8c82ea6d8416', 'd0a514f5-58e2-4c2a-ac2f-5a221479f1bc', 'Implementation Project 2', 'planning', current_date + interval '19 days', now() - interval '18 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.project_members (project_id, user_id) VALUES ('adf5c04c-de34-4dbe-b4e7-8c82ea6d8416', 'b63a5145-cbca-4b3a-b631-bc0b46a792ae') ON CONFLICT DO NOTHING;
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('2855faf8-b4f2-477d-bea9-d0bf9e1a4b39', '6528f4c0-3064-4abb-a1dd-0b20b9770b6b', 'Implementation Project 3', 'in_progress', current_date + interval '5 days', now() - interval '9 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.project_members (project_id, user_id) VALUES ('2855faf8-b4f2-477d-bea9-d0bf9e1a4b39', 'b63a5145-cbca-4b3a-b631-bc0b46a792ae') ON CONFLICT DO NOTHING;
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('c253354e-cad6-4fb0-a2d6-da83dce24209', '637c74e5-4d3e-4360-a1d1-90cf149841ac', 'Implementation Project 4', 'in_progress', current_date + interval '26 days', now() - interval '18 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.project_members (project_id, user_id) VALUES ('c253354e-cad6-4fb0-a2d6-da83dce24209', '955126bf-a3df-4d47-8812-747adbc7e961') ON CONFLICT DO NOTHING;
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('67396742-17ea-4e5e-92b9-f2df3072fb93', 'cda4105e-5623-4e2d-b817-a430e7d5ef9d', 'Implementation Project 5', 'planning', current_date + interval '19 days', now() - interval '13 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.project_members (project_id, user_id) VALUES ('67396742-17ea-4e5e-92b9-f2df3072fb93', '955126bf-a3df-4d47-8812-747adbc7e961') ON CONFLICT DO NOTHING;
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('01db3d7a-3d61-4763-81fc-fcbfce6e5421', '9e1c678c-f396-4baa-91fb-1ad667592a73', 'Implementation Project 6', 'planning', current_date + interval '15 days', now() - interval '15 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.project_members (project_id, user_id) VALUES ('01db3d7a-3d61-4763-81fc-fcbfce6e5421', 'b63a5145-cbca-4b3a-b631-bc0b46a792ae') ON CONFLICT DO NOTHING;
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('374ae0b1-2e3d-4361-961b-70ac0b0d8cca', '0e203a2c-9961-4a20-8f2a-512784f896bb', 'Implementation Project 7', 'in_progress', current_date + interval '15 days', now() - interval '4 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.project_members (project_id, user_id) VALUES ('374ae0b1-2e3d-4361-961b-70ac0b0d8cca', '0e9f255a-3b7c-4508-95fd-cfd2b9ff42af') ON CONFLICT DO NOTHING;
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('5efbb82c-15df-4cfd-a2e7-bd99d5daff04', 'e4d2ec47-f1fb-4a18-8ebf-195d8f550967', 'Implementation Project 8', 'in_progress', current_date + interval '20 days', now() - interval '18 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.project_members (project_id, user_id) VALUES ('5efbb82c-15df-4cfd-a2e7-bd99d5daff04', '0e9f255a-3b7c-4508-95fd-cfd2b9ff42af') ON CONFLICT DO NOTHING;
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('5b5b5a3f-6e0f-4cd2-9a19-3fe6fe0007b5', '95b1fe0a-2fda-4aeb-9855-8eb7a0608172', 'Implementation Project 9', 'planning', current_date + interval '13 days', now() - interval '3 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.project_members (project_id, user_id) VALUES ('5b5b5a3f-6e0f-4cd2-9a19-3fe6fe0007b5', '0e9f255a-3b7c-4508-95fd-cfd2b9ff42af') ON CONFLICT DO NOTHING;
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('1469fe05-eded-49bb-b293-b3376deb1ace', '492f20c8-a30f-4b94-a1a5-5e950c382fb0', 'Implementation Project 10', 'testing', current_date + interval '11 days', now() - interval '10 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.project_members (project_id, user_id) VALUES ('1469fe05-eded-49bb-b293-b3376deb1ace', 'b63a5145-cbca-4b3a-b631-bc0b46a792ae') ON CONFLICT DO NOTHING;
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('73c8ac60-5449-4ead-ab94-abd5ecd8af1e', '471237b9-cb41-4421-bae5-580b0d7d2611', 'Implementation Project 11', 'testing', current_date + interval '13 days', now() - interval '4 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.project_members (project_id, user_id) VALUES ('73c8ac60-5449-4ead-ab94-abd5ecd8af1e', '0e9f255a-3b7c-4508-95fd-cfd2b9ff42af') ON CONFLICT DO NOTHING;
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('695b2771-2b5f-467e-89c8-01a7bf50f470', '492f20c8-a30f-4b94-a1a5-5e950c382fb0', 'Implementation Project 12', 'testing', current_date + interval '6 days', now() - interval '18 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.project_members (project_id, user_id) VALUES ('695b2771-2b5f-467e-89c8-01a7bf50f470', '955126bf-a3df-4d47-8812-747adbc7e961') ON CONFLICT DO NOTHING;
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('fbd0eb4e-ea26-4e6f-9385-c791d16110dc', '964d9373-b616-418b-894f-57f827951e18', 'Implementation Project 13', 'completed', current_date + interval '14 days', now() - interval '3 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.project_members (project_id, user_id) VALUES ('fbd0eb4e-ea26-4e6f-9385-c791d16110dc', 'b63a5145-cbca-4b3a-b631-bc0b46a792ae') ON CONFLICT DO NOTHING;
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('fa7e53ec-a27e-4f72-b80b-ad69a534f6cc', 'cda4105e-5623-4e2d-b817-a430e7d5ef9d', 'Implementation Project 14', 'planning', current_date + interval '14 days', now() - interval '19 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.project_members (project_id, user_id) VALUES ('fa7e53ec-a27e-4f72-b80b-ad69a534f6cc', '955126bf-a3df-4d47-8812-747adbc7e961') ON CONFLICT DO NOTHING;
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('f46aa48c-b8fc-4726-b88a-707fff9b7809', '471237b9-cb41-4421-bae5-580b0d7d2611', 'Implementation Project 15', 'in_progress', current_date + interval '11 days', now() - interval '9 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.project_members (project_id, user_id) VALUES ('f46aa48c-b8fc-4726-b88a-707fff9b7809', '0e9f255a-3b7c-4508-95fd-cfd2b9ff42af') ON CONFLICT DO NOTHING;

-- 6. Tickets
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('d10cc6a3-b0f9-4177-892c-323f2950e732', '560e81d1-3983-4641-abf5-aa6a0791ec0a', 'fbd0eb4e-ea26-4e6f-9385-c791d16110dc', 'Support Request 1', 'Client needs help with configuration.', 'resolved', 'low', '955126bf-a3df-4d47-8812-747adbc7e961', '955126bf-a3df-4d47-8812-747adbc7e961', now() - interval '4 days', now() - interval '14 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('f5b212ac-d1b7-4186-97e6-8fd168efde5d', '0e203a2c-9961-4a20-8f2a-512784f896bb', NULL, 'Support Request 2', 'Client needs help with configuration.', 'in_progress', 'medium', '955126bf-a3df-4d47-8812-747adbc7e961', 'b63a5145-cbca-4b3a-b631-bc0b46a792ae', NULL, now() - interval '12 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('3c1183b7-76b5-476c-a00f-b40ae779718e', '964d9373-b616-418b-894f-57f827951e18', NULL, 'Support Request 3', 'Client needs help with configuration.', 'new', 'urgent', '955126bf-a3df-4d47-8812-747adbc7e961', '955126bf-a3df-4d47-8812-747adbc7e961', NULL, now() - interval '4 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('ea17e6c0-d66c-4bfe-8093-2bb714bef5c5', '471237b9-cb41-4421-bae5-580b0d7d2611', NULL, 'Support Request 4', 'Client needs help with configuration.', 'resolved', 'high', '955126bf-a3df-4d47-8812-747adbc7e961', '955126bf-a3df-4d47-8812-747adbc7e961', now() - interval '5 days', now() - interval '8 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('67ddf4c7-9bf6-4e5b-81a4-abe938ab9b48', 'cda4105e-5623-4e2d-b817-a430e7d5ef9d', NULL, 'Support Request 5', 'Client needs help with configuration.', 'waiting', 'urgent', '955126bf-a3df-4d47-8812-747adbc7e961', 'b63a5145-cbca-4b3a-b631-bc0b46a792ae', NULL, now() - interval '15 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('feb26d0c-2fc7-43b0-95cf-7511f95f3939', '6528f4c0-3064-4abb-a1dd-0b20b9770b6b', 'c253354e-cad6-4fb0-a2d6-da83dce24209', 'Support Request 6', 'Client needs help with configuration.', 'new', 'low', '955126bf-a3df-4d47-8812-747adbc7e961', '0e9f255a-3b7c-4508-95fd-cfd2b9ff42af', NULL, now() - interval '1 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('b872216a-40f9-42d5-aeb1-d9a31b1033ff', '0e203a2c-9961-4a20-8f2a-512784f896bb', NULL, 'Support Request 7', 'Client needs help with configuration.', 'waiting', 'urgent', '955126bf-a3df-4d47-8812-747adbc7e961', '955126bf-a3df-4d47-8812-747adbc7e961', NULL, now() - interval '11 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('3c7f49eb-22eb-4030-80dd-28e9e93d6e70', '9e1c678c-f396-4baa-91fb-1ad667592a73', 'adf5c04c-de34-4dbe-b4e7-8c82ea6d8416', 'Support Request 8', 'Client needs help with configuration.', 'in_progress', 'medium', '955126bf-a3df-4d47-8812-747adbc7e961', 'b63a5145-cbca-4b3a-b631-bc0b46a792ae', NULL, now() - interval '5 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('e7fb1d2a-8559-47cf-9410-42759590f9f1', '560e81d1-3983-4641-abf5-aa6a0791ec0a', NULL, 'Support Request 9', 'Client needs help with configuration.', 'waiting', 'high', '955126bf-a3df-4d47-8812-747adbc7e961', '0e9f255a-3b7c-4508-95fd-cfd2b9ff42af', NULL, now() - interval '5 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('dc913fa8-d7a9-4ebb-a83c-eb20a0037f99', '5131e7e4-247b-4304-be55-cef0dceae9b4', '1469fe05-eded-49bb-b293-b3376deb1ace', 'Support Request 10', 'Client needs help with configuration.', 'waiting', 'urgent', '955126bf-a3df-4d47-8812-747adbc7e961', '955126bf-a3df-4d47-8812-747adbc7e961', NULL, now() - interval '15 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('be2e35eb-e8fd-4bf3-9367-198b6112947f', '6528f4c0-3064-4abb-a1dd-0b20b9770b6b', '2855faf8-b4f2-477d-bea9-d0bf9e1a4b39', 'Support Request 11', 'Client needs help with configuration.', 'resolved', 'medium', '955126bf-a3df-4d47-8812-747adbc7e961', 'b63a5145-cbca-4b3a-b631-bc0b46a792ae', now() - interval '1 days', now() - interval '5 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('260ec2d9-722c-457d-9d02-922271e9004c', 'cda4105e-5623-4e2d-b817-a430e7d5ef9d', 'fa7e53ec-a27e-4f72-b80b-ad69a534f6cc', 'Support Request 12', 'Client needs help with configuration.', 'resolved', 'urgent', '955126bf-a3df-4d47-8812-747adbc7e961', 'b63a5145-cbca-4b3a-b631-bc0b46a792ae', now() - interval '3 days', now() - interval '10 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('e8b0cdb5-31c6-423e-9dba-683455cedbaf', '95b1fe0a-2fda-4aeb-9855-8eb7a0608172', '695b2771-2b5f-467e-89c8-01a7bf50f470', 'Support Request 13', 'Client needs help with configuration.', 'resolved', 'low', '955126bf-a3df-4d47-8812-747adbc7e961', '0e9f255a-3b7c-4508-95fd-cfd2b9ff42af', now() - interval '4 days', now() - interval '3 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('58b83b39-7b67-4728-b3c2-5ab3d8db3c25', 'cda4105e-5623-4e2d-b817-a430e7d5ef9d', '374ae0b1-2e3d-4361-961b-70ac0b0d8cca', 'Support Request 14', 'Client needs help with configuration.', 'in_progress', 'urgent', '955126bf-a3df-4d47-8812-747adbc7e961', 'b63a5145-cbca-4b3a-b631-bc0b46a792ae', NULL, now() - interval '12 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('1ff03d22-6d93-4f0f-aea4-2746126fb9bb', '95b1fe0a-2fda-4aeb-9855-8eb7a0608172', '2855faf8-b4f2-477d-bea9-d0bf9e1a4b39', 'Support Request 15', 'Client needs help with configuration.', 'resolved', 'medium', '955126bf-a3df-4d47-8812-747adbc7e961', '955126bf-a3df-4d47-8812-747adbc7e961', now() - interval '1 days', now() - interval '11 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('9b6470dd-c768-499a-80af-7285b2c43742', '0e203a2c-9961-4a20-8f2a-512784f896bb', 'adf5c04c-de34-4dbe-b4e7-8c82ea6d8416', 'Support Request 16', 'Client needs help with configuration.', 'new', 'urgent', '955126bf-a3df-4d47-8812-747adbc7e961', '0e9f255a-3b7c-4508-95fd-cfd2b9ff42af', NULL, now() - interval '12 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('dcd7940d-a13e-4c8d-a7da-ac488b6e4af4', '0e203a2c-9961-4a20-8f2a-512784f896bb', NULL, 'Support Request 17', 'Client needs help with configuration.', 'new', 'low', '955126bf-a3df-4d47-8812-747adbc7e961', '0e9f255a-3b7c-4508-95fd-cfd2b9ff42af', NULL, now() - interval '3 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('28d3ce28-8b35-48cf-9a2a-ee4ce417e063', '5131e7e4-247b-4304-be55-cef0dceae9b4', NULL, 'Support Request 18', 'Client needs help with configuration.', 'resolved', 'urgent', '955126bf-a3df-4d47-8812-747adbc7e961', '0e9f255a-3b7c-4508-95fd-cfd2b9ff42af', now() - interval '5 days', now() - interval '11 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('0bf447b1-27f6-4479-9ae9-e8d5f66032be', '560e81d1-3983-4641-abf5-aa6a0791ec0a', NULL, 'Support Request 19', 'Client needs help with configuration.', 'new', 'low', '955126bf-a3df-4d47-8812-747adbc7e961', 'b63a5145-cbca-4b3a-b631-bc0b46a792ae', NULL, now() - interval '8 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('8bc4ebc7-1b82-4d6f-90b9-8221f533f0db', 'cdde504e-90bd-40ba-8278-c35898fe0136', NULL, 'Support Request 20', 'Client needs help with configuration.', 'resolved', 'medium', '955126bf-a3df-4d47-8812-747adbc7e961', '955126bf-a3df-4d47-8812-747adbc7e961', now() - interval '5 days', now() - interval '4 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('cd6e3cce-2177-4c38-9cd1-f7dc408270f7', '6528f4c0-3064-4abb-a1dd-0b20b9770b6b', NULL, 'Support Request 21', 'Client needs help with configuration.', 'new', 'low', '955126bf-a3df-4d47-8812-747adbc7e961', 'b63a5145-cbca-4b3a-b631-bc0b46a792ae', NULL, now() - interval '7 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('d21405df-535d-4239-abfa-87b16db86f91', '964d9373-b616-418b-894f-57f827951e18', NULL, 'Support Request 22', 'Client needs help with configuration.', 'waiting', 'urgent', '955126bf-a3df-4d47-8812-747adbc7e961', '0e9f255a-3b7c-4508-95fd-cfd2b9ff42af', NULL, now() - interval '3 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('689e4ca6-d18d-472f-b1ec-fee080fd0eb8', '95b1fe0a-2fda-4aeb-9855-8eb7a0608172', 'fbd0eb4e-ea26-4e6f-9385-c791d16110dc', 'Support Request 23', 'Client needs help with configuration.', 'in_progress', 'urgent', '955126bf-a3df-4d47-8812-747adbc7e961', 'b63a5145-cbca-4b3a-b631-bc0b46a792ae', NULL, now() - interval '11 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('300d9066-dbc5-4310-8bc4-c102f998fc37', '5131e7e4-247b-4304-be55-cef0dceae9b4', NULL, 'Support Request 24', 'Client needs help with configuration.', 'new', 'low', '955126bf-a3df-4d47-8812-747adbc7e961', '955126bf-a3df-4d47-8812-747adbc7e961', NULL, now() - interval '5 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('be7223d4-15de-4ff7-bc72-0d2bf469f6b5', '492f20c8-a30f-4b94-a1a5-5e950c382fb0', 'fa7e53ec-a27e-4f72-b80b-ad69a534f6cc', 'Support Request 25', 'Client needs help with configuration.', 'in_progress', 'low', '955126bf-a3df-4d47-8812-747adbc7e961', 'b63a5145-cbca-4b3a-b631-bc0b46a792ae', NULL, now() - interval '13 days') ON CONFLICT (id) DO NOTHING;
