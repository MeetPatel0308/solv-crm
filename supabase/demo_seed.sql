
-- ==========================================
-- DEMO SEED DATA FOR SOLV CRM & ERP
-- ==========================================
-- WARNING: This script assumes tables are empty or will insert ignoring conflicts.

-- 1. Create Users
-- We insert into auth.users directly. Note: these users cannot log in.
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at) 
VALUES ('27cf9846-05d3-4a66-b9e9-1986b5c035d1', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'alice.sales@example.com', '', now(), now(), now())
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.profiles (id, full_name, email, job_title, created_at, updated_at) 
VALUES ('27cf9846-05d3-4a66-b9e9-1986b5c035d1', 'Alice Smith', 'alice.sales@example.com', 'Sales Manager', now(), now())
ON CONFLICT (id) DO UPDATE SET full_name = EXCLUDED.full_name, job_title = EXCLUDED.job_title;
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at) 
VALUES ('7368914a-b52b-40ab-85fd-b1c842996ea8', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'bob.account@example.com', '', now(), now(), now())
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.profiles (id, full_name, email, job_title, created_at, updated_at) 
VALUES ('7368914a-b52b-40ab-85fd-b1c842996ea8', 'Bob Johnson', 'bob.account@example.com', 'Account Manager', now(), now())
ON CONFLICT (id) DO UPDATE SET full_name = EXCLUDED.full_name, job_title = EXCLUDED.job_title;
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at) 
VALUES ('515419a2-5e51-4a50-959f-44ae235587ce', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'charlie.tech@example.com', '', now(), now(), now())
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.profiles (id, full_name, email, job_title, created_at, updated_at) 
VALUES ('515419a2-5e51-4a50-959f-44ae235587ce', 'Charlie Davis', 'charlie.tech@example.com', 'Lead Developer', now(), now())
ON CONFLICT (id) DO UPDATE SET full_name = EXCLUDED.full_name, job_title = EXCLUDED.job_title;

-- 2. Services
INSERT INTO public.services (id, name, created_at, updated_at) VALUES ('dedcdba1-2120-4888-b929-3402dd424cf1', 'KIBO', now(), now()) ON CONFLICT DO NOTHING;
INSERT INTO public.services (id, name, created_at, updated_at) VALUES ('4d9b2c79-01e0-41e4-bce9-771318d269be', 'AI Sales App', now(), now()) ON CONFLICT DO NOTHING;
INSERT INTO public.services (id, name, created_at, updated_at) VALUES ('85b67dc1-79d7-4dea-86f4-cd55ed57fff1', 'Website Development', now(), now()) ON CONFLICT DO NOTHING;
INSERT INTO public.services (id, name, created_at, updated_at) VALUES ('1ae9852f-860c-462f-a894-d16f7f3899bb', 'Hosting', now(), now()) ON CONFLICT DO NOTHING;
INSERT INTO public.services (id, name, created_at, updated_at) VALUES ('7812b8ad-1d1d-4a03-83a7-222a1f12e48e', 'SEO', now(), now()) ON CONFLICT DO NOTHING;
INSERT INTO public.services (id, name, created_at, updated_at) VALUES ('65c29448-d21d-409d-9464-855d434534b8', 'Meta Ads Management', now(), now()) ON CONFLICT DO NOTHING;
INSERT INTO public.services (id, name, created_at, updated_at) VALUES ('8d8efdd6-e012-41a7-9ffa-c46a1ba8f576', 'Google Ads Management', now(), now()) ON CONFLICT DO NOTHING;
INSERT INTO public.services (id, name, created_at, updated_at) VALUES ('2418401d-2d6a-4d6b-96ed-9ee7498d19cd', 'Broadcast Messaging', now(), now()) ON CONFLICT DO NOTHING;

-- 3. Customers, Sales & Customer Services
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('2f6d8ab1-692e-48b1-b97a-cae0c03889a0', 'Acme Corp', 'contact@acme corp.com', 'Retail', '7368914a-b52b-40ab-85fd-b1c842996ea8', 'active', now() - interval '17 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('2f6d8ab1-692e-48b1-b97a-cae0c03889a0', '2418401d-2d6a-4d6b-96ed-9ee7498d19cd', 'Broadcast Messaging', 'retainer', 1145, 'active', current_date, now() - interval '25 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('2f6d8ab1-692e-48b1-b97a-cae0c03889a0', '2418401d-2d6a-4d6b-96ed-9ee7498d19cd', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('ccd49e36-d29b-4956-8bd8-5c81c9f55820', 'Globex Corporation', 'contact@globex corporation.com', 'Healthcare', '7368914a-b52b-40ab-85fd-b1c842996ea8', 'active', now() - interval '65 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('ccd49e36-d29b-4956-8bd8-5c81c9f55820', '2418401d-2d6a-4d6b-96ed-9ee7498d19cd', 'Broadcast Messaging', 'one-off', 4371, 'active', current_date, now() - interval '5 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('ccd49e36-d29b-4956-8bd8-5c81c9f55820', '2418401d-2d6a-4d6b-96ed-9ee7498d19cd', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('ccd49e36-d29b-4956-8bd8-5c81c9f55820', '8d8efdd6-e012-41a7-9ffa-c46a1ba8f576', 'Google Ads Management', 'retainer', 1453, 'active', current_date, now() - interval '30 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('ccd49e36-d29b-4956-8bd8-5c81c9f55820', '8d8efdd6-e012-41a7-9ffa-c46a1ba8f576', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('ccd49e36-d29b-4956-8bd8-5c81c9f55820', 'dedcdba1-2120-4888-b929-3402dd424cf1', 'KIBO', 'retainer', 1217, 'active', current_date, now() - interval '5 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('ccd49e36-d29b-4956-8bd8-5c81c9f55820', 'dedcdba1-2120-4888-b929-3402dd424cf1', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('d7b304d8-7629-4c4a-9c97-040237f13e74', 'Soylent Corp', 'contact@soylent corp.com', 'Logistics', '27cf9846-05d3-4a66-b9e9-1986b5c035d1', 'active', now() - interval '65 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('d7b304d8-7629-4c4a-9c97-040237f13e74', '65c29448-d21d-409d-9464-855d434534b8', 'Meta Ads Management', 'retainer', 841, 'active', current_date, now() - interval '5 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('d7b304d8-7629-4c4a-9c97-040237f13e74', '65c29448-d21d-409d-9464-855d434534b8', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('d7b304d8-7629-4c4a-9c97-040237f13e74', 'dedcdba1-2120-4888-b929-3402dd424cf1', 'KIBO', 'retainer', 1183, 'active', current_date, now() - interval '15 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('d7b304d8-7629-4c4a-9c97-040237f13e74', 'dedcdba1-2120-4888-b929-3402dd424cf1', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('7ffff323-2693-4854-957d-df0dc228b4af', 'Initech', 'contact@initech.com', 'Finance', '7368914a-b52b-40ab-85fd-b1c842996ea8', 'active', now() - interval '65 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('7ffff323-2693-4854-957d-df0dc228b4af', 'dedcdba1-2120-4888-b929-3402dd424cf1', 'KIBO', 'one-off', 8137, 'active', current_date, now() - interval '13 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('7ffff323-2693-4854-957d-df0dc228b4af', 'dedcdba1-2120-4888-b929-3402dd424cf1', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('e16faced-5bdc-498f-9508-2071108a140b', 'Umbrella Corporation', 'contact@umbrella corporation.com', 'Finance', '515419a2-5e51-4a50-959f-44ae235587ce', 'active', now() - interval '67 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('e16faced-5bdc-498f-9508-2071108a140b', '65c29448-d21d-409d-9464-855d434534b8', 'Meta Ads Management', 'retainer', 1113, 'active', current_date, now() - interval '30 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('e16faced-5bdc-498f-9508-2071108a140b', '65c29448-d21d-409d-9464-855d434534b8', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('e16faced-5bdc-498f-9508-2071108a140b', '85b67dc1-79d7-4dea-86f4-cd55ed57fff1', 'Website Development', 'one-off', 1066, 'active', current_date, now() - interval '11 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('e16faced-5bdc-498f-9508-2071108a140b', '85b67dc1-79d7-4dea-86f4-cd55ed57fff1', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('d17f64ce-dab7-4903-8402-06d17232618d', 'Stark Industries', 'contact@stark industries.com', 'Logistics', '515419a2-5e51-4a50-959f-44ae235587ce', 'active', now() - interval '73 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('d17f64ce-dab7-4903-8402-06d17232618d', '2418401d-2d6a-4d6b-96ed-9ee7498d19cd', 'Broadcast Messaging', 'one-off', 8024, 'active', current_date, now() - interval '25 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('d17f64ce-dab7-4903-8402-06d17232618d', '2418401d-2d6a-4d6b-96ed-9ee7498d19cd', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('d17f64ce-dab7-4903-8402-06d17232618d', '7812b8ad-1d1d-4a03-83a7-222a1f12e48e', 'SEO', 'one-off', 9847, 'active', current_date, now() - interval '13 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('d17f64ce-dab7-4903-8402-06d17232618d', '7812b8ad-1d1d-4a03-83a7-222a1f12e48e', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('60251034-bf9c-49a1-b67c-657d67b86c3f', 'Wayne Enterprises', 'contact@wayne enterprises.com', 'Real Estate', '7368914a-b52b-40ab-85fd-b1c842996ea8', 'active', now() - interval '83 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('60251034-bf9c-49a1-b67c-657d67b86c3f', '85b67dc1-79d7-4dea-86f4-cd55ed57fff1', 'Website Development', 'one-off', 4439, 'active', current_date, now() - interval '23 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('60251034-bf9c-49a1-b67c-657d67b86c3f', '85b67dc1-79d7-4dea-86f4-cd55ed57fff1', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('580d7ba3-f6c8-4c11-bc99-959495e68071', 'Cyberdyne Systems', 'contact@cyberdyne systems.com', 'Retail', '7368914a-b52b-40ab-85fd-b1c842996ea8', 'active', now() - interval '31 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('580d7ba3-f6c8-4c11-bc99-959495e68071', '2418401d-2d6a-4d6b-96ed-9ee7498d19cd', 'Broadcast Messaging', 'one-off', 4922, 'active', current_date, now() - interval '7 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('580d7ba3-f6c8-4c11-bc99-959495e68071', '2418401d-2d6a-4d6b-96ed-9ee7498d19cd', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('214a5314-5b6b-4226-b90a-608370de630a', 'Massive Dynamic', 'contact@massive dynamic.com', 'Education', '515419a2-5e51-4a50-959f-44ae235587ce', 'active', now() - interval '86 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('214a5314-5b6b-4226-b90a-608370de630a', '2418401d-2d6a-4d6b-96ed-9ee7498d19cd', 'Broadcast Messaging', 'retainer', 622, 'active', current_date, now() - interval '22 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('214a5314-5b6b-4226-b90a-608370de630a', '2418401d-2d6a-4d6b-96ed-9ee7498d19cd', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('214a5314-5b6b-4226-b90a-608370de630a', '1ae9852f-860c-462f-a894-d16f7f3899bb', 'Hosting', 'one-off', 8326, 'active', current_date, now() - interval '2 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('214a5314-5b6b-4226-b90a-608370de630a', '1ae9852f-860c-462f-a894-d16f7f3899bb', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('12ce7e37-f2f6-4ecf-a828-57c0b1229267', 'Genco Pura Olive Oil', 'contact@genco pura olive oil.com', 'Real Estate', '515419a2-5e51-4a50-959f-44ae235587ce', 'active', now() - interval '96 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('12ce7e37-f2f6-4ecf-a828-57c0b1229267', '1ae9852f-860c-462f-a894-d16f7f3899bb', 'Hosting', 'one-off', 4867, 'active', current_date, now() - interval '10 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('12ce7e37-f2f6-4ecf-a828-57c0b1229267', '1ae9852f-860c-462f-a894-d16f7f3899bb', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('12ce7e37-f2f6-4ecf-a828-57c0b1229267', '4d9b2c79-01e0-41e4-bce9-771318d269be', 'AI Sales App', 'one-off', 2050, 'active', current_date, now() - interval '9 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('12ce7e37-f2f6-4ecf-a828-57c0b1229267', '4d9b2c79-01e0-41e4-bce9-771318d269be', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('1a6a6ba5-ce5c-43a1-b38f-e581ed173db6', 'LexCorp', 'contact@lexcorp.com', 'Healthcare', '7368914a-b52b-40ab-85fd-b1c842996ea8', 'active', now() - interval '37 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('1a6a6ba5-ce5c-43a1-b38f-e581ed173db6', '2418401d-2d6a-4d6b-96ed-9ee7498d19cd', 'Broadcast Messaging', 'retainer', 1373, 'active', current_date, now() - interval '24 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('1a6a6ba5-ce5c-43a1-b38f-e581ed173db6', '2418401d-2d6a-4d6b-96ed-9ee7498d19cd', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('1a6a6ba5-ce5c-43a1-b38f-e581ed173db6', '8d8efdd6-e012-41a7-9ffa-c46a1ba8f576', 'Google Ads Management', 'one-off', 5029, 'active', current_date, now() - interval '27 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('1a6a6ba5-ce5c-43a1-b38f-e581ed173db6', '8d8efdd6-e012-41a7-9ffa-c46a1ba8f576', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('1a6a6ba5-ce5c-43a1-b38f-e581ed173db6', '7812b8ad-1d1d-4a03-83a7-222a1f12e48e', 'SEO', 'retainer', 578, 'active', current_date, now() - interval '3 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('1a6a6ba5-ce5c-43a1-b38f-e581ed173db6', '7812b8ad-1d1d-4a03-83a7-222a1f12e48e', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('121e13fd-eae6-4ce3-850c-9c31cac5dd9b', 'Oceanic Airlines', 'contact@oceanic airlines.com', 'Education', '7368914a-b52b-40ab-85fd-b1c842996ea8', 'active', now() - interval '83 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('121e13fd-eae6-4ce3-850c-9c31cac5dd9b', '7812b8ad-1d1d-4a03-83a7-222a1f12e48e', 'SEO', 'one-off', 8334, 'active', current_date, now() - interval '26 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('121e13fd-eae6-4ce3-850c-9c31cac5dd9b', '7812b8ad-1d1d-4a03-83a7-222a1f12e48e', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('121e13fd-eae6-4ce3-850c-9c31cac5dd9b', '85b67dc1-79d7-4dea-86f4-cd55ed57fff1', 'Website Development', 'one-off', 7692, 'active', current_date, now() - interval '7 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('121e13fd-eae6-4ce3-850c-9c31cac5dd9b', '85b67dc1-79d7-4dea-86f4-cd55ed57fff1', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('ee3c79ec-13f6-4e65-b59e-0337b12b29d5', 'Wonka Industries', 'contact@wonka industries.com', 'Retail', '515419a2-5e51-4a50-959f-44ae235587ce', 'active', now() - interval '87 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('ee3c79ec-13f6-4e65-b59e-0337b12b29d5', '65c29448-d21d-409d-9464-855d434534b8', 'Meta Ads Management', 'retainer', 907, 'active', current_date, now() - interval '18 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('ee3c79ec-13f6-4e65-b59e-0337b12b29d5', '65c29448-d21d-409d-9464-855d434534b8', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('ee3c79ec-13f6-4e65-b59e-0337b12b29d5', '4d9b2c79-01e0-41e4-bce9-771318d269be', 'AI Sales App', 'one-off', 7248, 'active', current_date, now() - interval '13 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('ee3c79ec-13f6-4e65-b59e-0337b12b29d5', '4d9b2c79-01e0-41e4-bce9-771318d269be', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('ce6914e9-9fc6-4489-8aa2-0aab39a6a60a', 'Oscorp', 'contact@oscorp.com', 'Logistics', '515419a2-5e51-4a50-959f-44ae235587ce', 'active', now() - interval '80 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('ce6914e9-9fc6-4489-8aa2-0aab39a6a60a', '4d9b2c79-01e0-41e4-bce9-771318d269be', 'AI Sales App', 'retainer', 664, 'active', current_date, now() - interval '21 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('ce6914e9-9fc6-4489-8aa2-0aab39a6a60a', '4d9b2c79-01e0-41e4-bce9-771318d269be', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('ce6914e9-9fc6-4489-8aa2-0aab39a6a60a', 'dedcdba1-2120-4888-b929-3402dd424cf1', 'KIBO', 'one-off', 3710, 'active', current_date, now() - interval '7 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('ce6914e9-9fc6-4489-8aa2-0aab39a6a60a', 'dedcdba1-2120-4888-b929-3402dd424cf1', 'active', current_date, now());
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('68e6e1a6-9bca-4371-8700-12a0816765e0', 'Hooli', 'contact@hooli.com', 'Healthcare', '515419a2-5e51-4a50-959f-44ae235587ce', 'active', now() - interval '24 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('68e6e1a6-9bca-4371-8700-12a0816765e0', '7812b8ad-1d1d-4a03-83a7-222a1f12e48e', 'SEO', 'one-off', 5443, 'active', current_date, now() - interval '6 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('68e6e1a6-9bca-4371-8700-12a0816765e0', '7812b8ad-1d1d-4a03-83a7-222a1f12e48e', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('68e6e1a6-9bca-4371-8700-12a0816765e0', 'dedcdba1-2120-4888-b929-3402dd424cf1', 'KIBO', 'retainer', 597, 'active', current_date, now() - interval '4 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('68e6e1a6-9bca-4371-8700-12a0816765e0', 'dedcdba1-2120-4888-b929-3402dd424cf1', 'active', current_date, now());
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('68e6e1a6-9bca-4371-8700-12a0816765e0', '1ae9852f-860c-462f-a894-d16f7f3899bb', 'Hosting', 'retainer', 997, 'active', current_date, now() - interval '25 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('68e6e1a6-9bca-4371-8700-12a0816765e0', '1ae9852f-860c-462f-a894-d16f7f3899bb', 'active', current_date, now());

-- 4. Leads & Lead Services
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('5f37e05d-ce71-4d89-8d53-b277b12af3d7', 'Contact 15', 'Pied Piper (Lead)', 'contact15@example.com', 'negotiation', 4303, 'Website', '515419a2-5e51-4a50-959f-44ae235587ce', NULL, NULL, NULL, now() - interval '21 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('5f37e05d-ce71-4d89-8d53-b277b12af3d7', '85b67dc1-79d7-4dea-86f4-cd55ed57fff1') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('5f37e05d-ce71-4d89-8d53-b277b12af3d7', '2418401d-2d6a-4d6b-96ed-9ee7498d19cd') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('5f37e05d-ce71-4d89-8d53-b277b12af3d7', '65c29448-d21d-409d-9464-855d434534b8') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('029ef61f-0b66-4c68-ae2c-d84222f4230b', 'Contact 16', 'Dunder Mifflin (Lead)', 'contact16@example.com', 'lost', 3801, 'Cold Call', '27cf9846-05d3-4a66-b9e9-1986b5c035d1', NULL, now() - interval '10 days', 'Timing', now() - interval '20 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('029ef61f-0b66-4c68-ae2c-d84222f4230b', '1ae9852f-860c-462f-a894-d16f7f3899bb') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('ce63c65e-71aa-41b3-9a45-59d51477f8d0', 'Contact 17', 'LexCorp', 'contact17@example.com', 'converted', 1795, 'Cold Call', '7368914a-b52b-40ab-85fd-b1c842996ea8', now() - interval '5 days', NULL, NULL, now() - interval '31 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('ce63c65e-71aa-41b3-9a45-59d51477f8d0', 'dedcdba1-2120-4888-b929-3402dd424cf1') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('ce63c65e-71aa-41b3-9a45-59d51477f8d0', '2418401d-2d6a-4d6b-96ed-9ee7498d19cd') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('72a2b11c-b326-458d-b203-915fb94034a7', 'Contact 18', 'Veidt Enterprises (Lead)', 'contact18@example.com', 'cold', 3603, 'Social Media', '27cf9846-05d3-4a66-b9e9-1986b5c035d1', NULL, NULL, NULL, now() - interval '25 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('72a2b11c-b326-458d-b203-915fb94034a7', 'dedcdba1-2120-4888-b929-3402dd424cf1') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('72a2b11c-b326-458d-b203-915fb94034a7', '8d8efdd6-e012-41a7-9ffa-c46a1ba8f576') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('72a2b11c-b326-458d-b203-915fb94034a7', '4d9b2c79-01e0-41e4-bce9-771318d269be') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('3acb376c-0bb3-40be-8603-ceb62b40db9a', 'Contact 19', 'Gringotts (Lead)', 'contact19@example.com', 'converted', 4738, 'Trade Show', '27cf9846-05d3-4a66-b9e9-1986b5c035d1', now() - interval '9 days', NULL, NULL, now() - interval '27 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('3acb376c-0bb3-40be-8603-ceb62b40db9a', '7812b8ad-1d1d-4a03-83a7-222a1f12e48e') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('40bbeb46-6d15-4810-83fc-0d621ea74069', 'Contact 20', 'Initech', 'contact20@example.com', 'cold', 4657, 'Website', '27cf9846-05d3-4a66-b9e9-1986b5c035d1', NULL, NULL, NULL, now() - interval '30 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('40bbeb46-6d15-4810-83fc-0d621ea74069', '8d8efdd6-e012-41a7-9ffa-c46a1ba8f576') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('40bbeb46-6d15-4810-83fc-0d621ea74069', '7812b8ad-1d1d-4a03-83a7-222a1f12e48e') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('7f181cf7-dd5d-49e1-9509-cbe7a083387b', 'Contact 21', 'Virtucon (Lead)', 'contact21@example.com', 'cold', 701, 'Social Media', '515419a2-5e51-4a50-959f-44ae235587ce', NULL, NULL, NULL, now() - interval '13 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('7f181cf7-dd5d-49e1-9509-cbe7a083387b', '7812b8ad-1d1d-4a03-83a7-222a1f12e48e') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('7f181cf7-dd5d-49e1-9509-cbe7a083387b', '85b67dc1-79d7-4dea-86f4-cd55ed57fff1') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('b36fad77-f502-482f-865e-6a04ae0fbe29', 'Contact 22', 'MomCorp (Lead)', 'contact22@example.com', 'proposal', 1833, 'Referral', '27cf9846-05d3-4a66-b9e9-1986b5c035d1', NULL, NULL, NULL, now() - interval '36 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('b36fad77-f502-482f-865e-6a04ae0fbe29', '7812b8ad-1d1d-4a03-83a7-222a1f12e48e') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('b36fad77-f502-482f-865e-6a04ae0fbe29', 'dedcdba1-2120-4888-b929-3402dd424cf1') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('28be7fe4-0564-4767-9199-c64b24bf61a3', 'Contact 23', 'Slurm (Lead)', 'contact23@example.com', 'proposal', 2203, 'Website', '27cf9846-05d3-4a66-b9e9-1986b5c035d1', NULL, NULL, NULL, now() - interval '39 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('28be7fe4-0564-4767-9199-c64b24bf61a3', '7812b8ad-1d1d-4a03-83a7-222a1f12e48e') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('3ebe4a75-4b22-46e2-a161-c07a72cdd2a1', 'Contact 24', 'Nuka-Cola (Lead)', 'contact24@example.com', 'cold', 2122, 'Social Media', '27cf9846-05d3-4a66-b9e9-1986b5c035d1', NULL, NULL, NULL, now() - interval '30 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('3ebe4a75-4b22-46e2-a161-c07a72cdd2a1', '1ae9852f-860c-462f-a894-d16f7f3899bb') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('3ebe4a75-4b22-46e2-a161-c07a72cdd2a1', '4d9b2c79-01e0-41e4-bce9-771318d269be') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('59dff5d0-1a64-4854-88f0-14e734986783', 'Contact 25', 'Acme Corp (Lead)', 'contact25@example.com', 'proposal', 2233, 'Cold Call', '27cf9846-05d3-4a66-b9e9-1986b5c035d1', NULL, NULL, NULL, now() - interval '37 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('59dff5d0-1a64-4854-88f0-14e734986783', '7812b8ad-1d1d-4a03-83a7-222a1f12e48e') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('dea8c581-a80e-4579-bcc1-cac50ed22f13', 'Contact 26', 'Globex Corporation (Lead)', 'contact26@example.com', 'hot', 3774, 'Referral', '7368914a-b52b-40ab-85fd-b1c842996ea8', NULL, NULL, NULL, now() - interval '34 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('dea8c581-a80e-4579-bcc1-cac50ed22f13', '7812b8ad-1d1d-4a03-83a7-222a1f12e48e') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('dea8c581-a80e-4579-bcc1-cac50ed22f13', '4d9b2c79-01e0-41e4-bce9-771318d269be') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('dea8c581-a80e-4579-bcc1-cac50ed22f13', 'dedcdba1-2120-4888-b929-3402dd424cf1') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('acc022c5-c97c-43fb-8929-577128297caa', 'Contact 27', 'Soylent Corp (Lead)', 'contact27@example.com', 'negotiation', 1928, 'Website', '7368914a-b52b-40ab-85fd-b1c842996ea8', NULL, NULL, NULL, now() - interval '37 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('acc022c5-c97c-43fb-8929-577128297caa', '85b67dc1-79d7-4dea-86f4-cd55ed57fff1') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('acc022c5-c97c-43fb-8929-577128297caa', 'dedcdba1-2120-4888-b929-3402dd424cf1') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('c1d47cd5-c160-47b9-975a-452dd1a9551f', 'Contact 28', 'Initech (Lead)', 'contact28@example.com', 'warm', 2204, 'Cold Call', '7368914a-b52b-40ab-85fd-b1c842996ea8', NULL, NULL, NULL, now() - interval '20 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('c1d47cd5-c160-47b9-975a-452dd1a9551f', '65c29448-d21d-409d-9464-855d434534b8') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('c1d47cd5-c160-47b9-975a-452dd1a9551f', '85b67dc1-79d7-4dea-86f4-cd55ed57fff1') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('c1d47cd5-c160-47b9-975a-452dd1a9551f', '8d8efdd6-e012-41a7-9ffa-c46a1ba8f576') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('95b86a33-f150-4b21-85f5-d9d55ab3b773', 'Contact 29', 'Umbrella Corporation (Lead)', 'contact29@example.com', 'cold', 4622, 'Social Media', '7368914a-b52b-40ab-85fd-b1c842996ea8', NULL, NULL, NULL, now() - interval '19 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('95b86a33-f150-4b21-85f5-d9d55ab3b773', '65c29448-d21d-409d-9464-855d434534b8') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('95b86a33-f150-4b21-85f5-d9d55ab3b773', '7812b8ad-1d1d-4a03-83a7-222a1f12e48e') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('95b86a33-f150-4b21-85f5-d9d55ab3b773', '85b67dc1-79d7-4dea-86f4-cd55ed57fff1') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('c7d3f524-0bf4-4086-84ad-2ecb696a2c62', 'Contact 30', 'Stark Industries (Lead)', 'contact30@example.com', 'hot', 4611, 'Social Media', '7368914a-b52b-40ab-85fd-b1c842996ea8', NULL, NULL, NULL, now() - interval '34 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('c7d3f524-0bf4-4086-84ad-2ecb696a2c62', '1ae9852f-860c-462f-a894-d16f7f3899bb') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('9b986ab2-7a1e-4542-8eda-b980f19babbe', 'Contact 31', 'Wayne Enterprises (Lead)', 'contact31@example.com', 'cold', 3295, 'Social Media', '515419a2-5e51-4a50-959f-44ae235587ce', NULL, NULL, NULL, now() - interval '12 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('9b986ab2-7a1e-4542-8eda-b980f19babbe', '7812b8ad-1d1d-4a03-83a7-222a1f12e48e') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('276dd20c-e0e7-4fcc-88b8-8efdf041dd9a', 'Contact 32', 'Cyberdyne Systems (Lead)', 'contact32@example.com', 'hot', 541, 'Referral', '515419a2-5e51-4a50-959f-44ae235587ce', NULL, NULL, NULL, now() - interval '25 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('276dd20c-e0e7-4fcc-88b8-8efdf041dd9a', '2418401d-2d6a-4d6b-96ed-9ee7498d19cd') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('e2f576ca-2925-48e6-b5de-978aa4f8e731', 'Contact 33', 'Massive Dynamic (Lead)', 'contact33@example.com', 'lost', 2161, 'Cold Call', '515419a2-5e51-4a50-959f-44ae235587ce', NULL, now() - interval '5 days', 'Timing', now() - interval '25 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('e2f576ca-2925-48e6-b5de-978aa4f8e731', '7812b8ad-1d1d-4a03-83a7-222a1f12e48e') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('b14c4bfc-2870-4362-b877-0eff734ca5aa', 'Contact 34', 'Genco Pura Olive Oil (Lead)', 'contact34@example.com', 'converted', 1514, 'Cold Call', '27cf9846-05d3-4a66-b9e9-1986b5c035d1', now() - interval '2 days', NULL, NULL, now() - interval '19 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('b14c4bfc-2870-4362-b877-0eff734ca5aa', '8d8efdd6-e012-41a7-9ffa-c46a1ba8f576') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('defaa3b2-293b-445c-a993-3811290b10ef', 'Contact 35', 'LexCorp (Lead)', 'contact35@example.com', 'hot', 969, 'Website', '515419a2-5e51-4a50-959f-44ae235587ce', NULL, NULL, NULL, now() - interval '11 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('defaa3b2-293b-445c-a993-3811290b10ef', '4d9b2c79-01e0-41e4-bce9-771318d269be') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('e0bb772a-25fa-4fc0-b4c8-f608ac549f11', 'Contact 36', 'Oceanic Airlines (Lead)', 'contact36@example.com', 'proposal', 3083, 'Website', '27cf9846-05d3-4a66-b9e9-1986b5c035d1', NULL, NULL, NULL, now() - interval '21 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('e0bb772a-25fa-4fc0-b4c8-f608ac549f11', '1ae9852f-860c-462f-a894-d16f7f3899bb') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('e0bb772a-25fa-4fc0-b4c8-f608ac549f11', '8d8efdd6-e012-41a7-9ffa-c46a1ba8f576') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('ae3823da-0fde-4f54-a71e-1de2c1ea2a45', 'Contact 37', 'Wonka Industries (Lead)', 'contact37@example.com', 'converted', 4964, 'Trade Show', '7368914a-b52b-40ab-85fd-b1c842996ea8', now() - interval '3 days', NULL, NULL, now() - interval '36 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('ae3823da-0fde-4f54-a71e-1de2c1ea2a45', 'dedcdba1-2120-4888-b929-3402dd424cf1') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('d0eb1406-3da7-43d6-8a2a-80c108ab69d4', 'Contact 38', 'Oscorp (Lead)', 'contact38@example.com', 'negotiation', 3314, 'Social Media', '7368914a-b52b-40ab-85fd-b1c842996ea8', NULL, NULL, NULL, now() - interval '20 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('d0eb1406-3da7-43d6-8a2a-80c108ab69d4', '1ae9852f-860c-462f-a894-d16f7f3899bb') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('a66014b4-a86b-4600-8bc9-0c9f11a82061', 'Contact 39', 'Genco Pura Olive Oil', 'contact39@example.com', 'negotiation', 4050, 'Cold Call', '515419a2-5e51-4a50-959f-44ae235587ce', NULL, NULL, NULL, now() - interval '12 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('a66014b4-a86b-4600-8bc9-0c9f11a82061', 'dedcdba1-2120-4888-b929-3402dd424cf1') ON CONFLICT DO NOTHING;

-- 5. Projects
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('2afe63e4-8030-4e72-907b-cded9907c880', '12ce7e37-f2f6-4ecf-a828-57c0b1229267', 'Implementation Project 1', 'completed', current_date + interval '6 days', now() - interval '2 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.project_members (project_id, user_id) VALUES ('2afe63e4-8030-4e72-907b-cded9907c880', '515419a2-5e51-4a50-959f-44ae235587ce') ON CONFLICT DO NOTHING;
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('6ad9bb21-212d-45ca-9b6b-3eca7328de9a', '7ffff323-2693-4854-957d-df0dc228b4af', 'Implementation Project 2', 'in_progress', current_date + interval '5 days', now() - interval '12 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.project_members (project_id, user_id) VALUES ('6ad9bb21-212d-45ca-9b6b-3eca7328de9a', '7368914a-b52b-40ab-85fd-b1c842996ea8') ON CONFLICT DO NOTHING;
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('8ec1d3fb-3f6b-41cd-acd5-48ab8d80bbea', 'd7b304d8-7629-4c4a-9c97-040237f13e74', 'Implementation Project 3', 'completed', current_date + interval '30 days', now() - interval '16 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.project_members (project_id, user_id) VALUES ('8ec1d3fb-3f6b-41cd-acd5-48ab8d80bbea', '27cf9846-05d3-4a66-b9e9-1986b5c035d1') ON CONFLICT DO NOTHING;
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('4ce36417-25b5-4371-a4fd-20759d299a76', 'ce6914e9-9fc6-4489-8aa2-0aab39a6a60a', 'Implementation Project 4', 'in_progress', current_date + interval '27 days', now() - interval '18 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.project_members (project_id, user_id) VALUES ('4ce36417-25b5-4371-a4fd-20759d299a76', '515419a2-5e51-4a50-959f-44ae235587ce') ON CONFLICT DO NOTHING;
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('7e602b71-fca1-4fc2-953d-fe8f3785161c', '580d7ba3-f6c8-4c11-bc99-959495e68071', 'Implementation Project 5', 'review', current_date + interval '30 days', now() - interval '3 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.project_members (project_id, user_id) VALUES ('7e602b71-fca1-4fc2-953d-fe8f3785161c', '7368914a-b52b-40ab-85fd-b1c842996ea8') ON CONFLICT DO NOTHING;
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('275128a8-36d9-4ee5-9036-d9aaf8db88eb', 'ee3c79ec-13f6-4e65-b59e-0337b12b29d5', 'Implementation Project 6', 'review', current_date + interval '17 days', now() - interval '12 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.project_members (project_id, user_id) VALUES ('275128a8-36d9-4ee5-9036-d9aaf8db88eb', '515419a2-5e51-4a50-959f-44ae235587ce') ON CONFLICT DO NOTHING;
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('0a01f4d9-9666-4fa5-9703-21ae5dce46e4', 'ce6914e9-9fc6-4489-8aa2-0aab39a6a60a', 'Implementation Project 7', 'in_progress', current_date + interval '16 days', now() - interval '12 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.project_members (project_id, user_id) VALUES ('0a01f4d9-9666-4fa5-9703-21ae5dce46e4', '27cf9846-05d3-4a66-b9e9-1986b5c035d1') ON CONFLICT DO NOTHING;
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('64e6bf4e-7aa5-4374-8319-64b243da0efd', '60251034-bf9c-49a1-b67c-657d67b86c3f', 'Implementation Project 8', 'in_progress', current_date + interval '5 days', now() - interval '17 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.project_members (project_id, user_id) VALUES ('64e6bf4e-7aa5-4374-8319-64b243da0efd', '7368914a-b52b-40ab-85fd-b1c842996ea8') ON CONFLICT DO NOTHING;
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('833a75bb-5f94-4f4a-bd41-a11ce91ee5d1', 'd7b304d8-7629-4c4a-9c97-040237f13e74', 'Implementation Project 9', 'in_progress', current_date + interval '9 days', now() - interval '10 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.project_members (project_id, user_id) VALUES ('833a75bb-5f94-4f4a-bd41-a11ce91ee5d1', '7368914a-b52b-40ab-85fd-b1c842996ea8') ON CONFLICT DO NOTHING;
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('887a11b8-6b16-4c4e-b0e1-cf84e8f33f7f', '2f6d8ab1-692e-48b1-b97a-cae0c03889a0', 'Implementation Project 10', 'review', current_date + interval '26 days', now() - interval '20 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.project_members (project_id, user_id) VALUES ('887a11b8-6b16-4c4e-b0e1-cf84e8f33f7f', '7368914a-b52b-40ab-85fd-b1c842996ea8') ON CONFLICT DO NOTHING;
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('69cd5149-becd-4384-829e-583918d15e63', '12ce7e37-f2f6-4ecf-a828-57c0b1229267', 'Implementation Project 11', 'planning', current_date + interval '26 days', now() - interval '17 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.project_members (project_id, user_id) VALUES ('69cd5149-becd-4384-829e-583918d15e63', '515419a2-5e51-4a50-959f-44ae235587ce') ON CONFLICT DO NOTHING;
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('c975415f-dda0-49eb-9b4e-f5d5692e2c9e', 'e16faced-5bdc-498f-9508-2071108a140b', 'Implementation Project 12', 'review', current_date + interval '20 days', now() - interval '16 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.project_members (project_id, user_id) VALUES ('c975415f-dda0-49eb-9b4e-f5d5692e2c9e', '27cf9846-05d3-4a66-b9e9-1986b5c035d1') ON CONFLICT DO NOTHING;
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('f160fd4a-c212-4b09-864d-045b6583efac', '60251034-bf9c-49a1-b67c-657d67b86c3f', 'Implementation Project 13', 'completed', current_date + interval '13 days', now() - interval '10 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.project_members (project_id, user_id) VALUES ('f160fd4a-c212-4b09-864d-045b6583efac', '27cf9846-05d3-4a66-b9e9-1986b5c035d1') ON CONFLICT DO NOTHING;
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('c05f3677-0497-49e3-b3a9-eaac695e0ba1', '580d7ba3-f6c8-4c11-bc99-959495e68071', 'Implementation Project 14', 'completed', current_date + interval '7 days', now() - interval '3 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.project_members (project_id, user_id) VALUES ('c05f3677-0497-49e3-b3a9-eaac695e0ba1', '27cf9846-05d3-4a66-b9e9-1986b5c035d1') ON CONFLICT DO NOTHING;
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('19aed65e-d521-4823-a994-4c0d07944eb9', '60251034-bf9c-49a1-b67c-657d67b86c3f', 'Implementation Project 15', 'review', current_date + interval '26 days', now() - interval '13 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.project_members (project_id, user_id) VALUES ('19aed65e-d521-4823-a994-4c0d07944eb9', '7368914a-b52b-40ab-85fd-b1c842996ea8') ON CONFLICT DO NOTHING;

-- 6. Tickets
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('7d9ea231-ff3a-4447-97af-524c1dba1683', '68e6e1a6-9bca-4371-8700-12a0816765e0', NULL, 'Support Request 1', 'Client needs help with configuration.', 'open', 'high', '27cf9846-05d3-4a66-b9e9-1986b5c035d1', '7368914a-b52b-40ab-85fd-b1c842996ea8', NULL, now() - interval '4 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('17d7de03-fc9f-4980-b8ac-52bde37de18d', 'd17f64ce-dab7-4903-8402-06d17232618d', NULL, 'Support Request 2', 'Client needs help with configuration.', 'waiting', 'critical', '27cf9846-05d3-4a66-b9e9-1986b5c035d1', '7368914a-b52b-40ab-85fd-b1c842996ea8', NULL, now() - interval '9 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('4a2bb66b-4383-4a33-adf1-4b732c7772b2', '2f6d8ab1-692e-48b1-b97a-cae0c03889a0', '7e602b71-fca1-4fc2-953d-fe8f3785161c', 'Support Request 3', 'Client needs help with configuration.', 'in_progress', 'medium', '27cf9846-05d3-4a66-b9e9-1986b5c035d1', '515419a2-5e51-4a50-959f-44ae235587ce', NULL, now() - interval '6 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('777a39af-b869-42ce-89fc-7ae33c1151e3', '121e13fd-eae6-4ce3-850c-9c31cac5dd9b', NULL, 'Support Request 4', 'Client needs help with configuration.', 'resolved', 'low', '27cf9846-05d3-4a66-b9e9-1986b5c035d1', '7368914a-b52b-40ab-85fd-b1c842996ea8', now() - interval '2 days', now() - interval '15 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('f7b8d12c-033a-44b6-bc49-53e15c577e10', '7ffff323-2693-4854-957d-df0dc228b4af', '2afe63e4-8030-4e72-907b-cded9907c880', 'Support Request 5', 'Client needs help with configuration.', 'in_progress', 'medium', '27cf9846-05d3-4a66-b9e9-1986b5c035d1', '515419a2-5e51-4a50-959f-44ae235587ce', NULL, now() - interval '5 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('580fc645-7bdd-4458-bdcd-b9d7bd101069', '121e13fd-eae6-4ce3-850c-9c31cac5dd9b', '4ce36417-25b5-4371-a4fd-20759d299a76', 'Support Request 6', 'Client needs help with configuration.', 'in_progress', 'low', '27cf9846-05d3-4a66-b9e9-1986b5c035d1', '27cf9846-05d3-4a66-b9e9-1986b5c035d1', NULL, now() - interval '4 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('d41b2c8a-ded7-424e-bd9f-c4749d5d77e1', 'd17f64ce-dab7-4903-8402-06d17232618d', '275128a8-36d9-4ee5-9036-d9aaf8db88eb', 'Support Request 7', 'Client needs help with configuration.', 'open', 'critical', '27cf9846-05d3-4a66-b9e9-1986b5c035d1', '7368914a-b52b-40ab-85fd-b1c842996ea8', NULL, now() - interval '2 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('be50a511-5d1c-4abf-9796-5cf165208688', 'ccd49e36-d29b-4956-8bd8-5c81c9f55820', NULL, 'Support Request 8', 'Client needs help with configuration.', 'waiting', 'high', '27cf9846-05d3-4a66-b9e9-1986b5c035d1', '7368914a-b52b-40ab-85fd-b1c842996ea8', NULL, now() - interval '6 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('0b1ffd52-0417-4430-9d9d-eb6df7271224', '7ffff323-2693-4854-957d-df0dc228b4af', '8ec1d3fb-3f6b-41cd-acd5-48ab8d80bbea', 'Support Request 9', 'Client needs help with configuration.', 'waiting', 'critical', '27cf9846-05d3-4a66-b9e9-1986b5c035d1', '7368914a-b52b-40ab-85fd-b1c842996ea8', NULL, now() - interval '5 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('27d4c604-50e8-42e8-bafb-da24162776d9', '2f6d8ab1-692e-48b1-b97a-cae0c03889a0', '69cd5149-becd-4384-829e-583918d15e63', 'Support Request 10', 'Client needs help with configuration.', 'resolved', 'critical', '27cf9846-05d3-4a66-b9e9-1986b5c035d1', '7368914a-b52b-40ab-85fd-b1c842996ea8', now() - interval '1 days', now() - interval '7 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('a32e4ffd-225d-467f-a7a3-50424d428c17', '2f6d8ab1-692e-48b1-b97a-cae0c03889a0', '6ad9bb21-212d-45ca-9b6b-3eca7328de9a', 'Support Request 11', 'Client needs help with configuration.', 'open', 'medium', '27cf9846-05d3-4a66-b9e9-1986b5c035d1', '7368914a-b52b-40ab-85fd-b1c842996ea8', NULL, now() - interval '14 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('935e7566-615d-488c-b7af-8ce351ea6f3b', '121e13fd-eae6-4ce3-850c-9c31cac5dd9b', '8ec1d3fb-3f6b-41cd-acd5-48ab8d80bbea', 'Support Request 12', 'Client needs help with configuration.', 'in_progress', 'low', '27cf9846-05d3-4a66-b9e9-1986b5c035d1', '7368914a-b52b-40ab-85fd-b1c842996ea8', NULL, now() - interval '9 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('f69a4129-3373-454a-852c-d8d311d39c7d', '60251034-bf9c-49a1-b67c-657d67b86c3f', NULL, 'Support Request 13', 'Client needs help with configuration.', 'in_progress', 'high', '27cf9846-05d3-4a66-b9e9-1986b5c035d1', '515419a2-5e51-4a50-959f-44ae235587ce', NULL, now() - interval '1 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('8031713b-a5e8-4d73-82e0-87d3709a446c', 'ce6914e9-9fc6-4489-8aa2-0aab39a6a60a', NULL, 'Support Request 14', 'Client needs help with configuration.', 'in_progress', 'high', '27cf9846-05d3-4a66-b9e9-1986b5c035d1', '27cf9846-05d3-4a66-b9e9-1986b5c035d1', NULL, now() - interval '8 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('bbf2e93d-c98d-479f-9999-04eda150f57f', 'ee3c79ec-13f6-4e65-b59e-0337b12b29d5', NULL, 'Support Request 15', 'Client needs help with configuration.', 'open', 'low', '27cf9846-05d3-4a66-b9e9-1986b5c035d1', '7368914a-b52b-40ab-85fd-b1c842996ea8', NULL, now() - interval '1 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('89482bb8-8f9b-4aa9-9390-f9fd9fb3da47', '7ffff323-2693-4854-957d-df0dc228b4af', '19aed65e-d521-4823-a994-4c0d07944eb9', 'Support Request 16', 'Client needs help with configuration.', 'waiting', 'low', '27cf9846-05d3-4a66-b9e9-1986b5c035d1', '7368914a-b52b-40ab-85fd-b1c842996ea8', NULL, now() - interval '12 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('92cabf4e-af73-4428-a6ff-3b2b48337c66', 'd7b304d8-7629-4c4a-9c97-040237f13e74', NULL, 'Support Request 17', 'Client needs help with configuration.', 'resolved', 'high', '27cf9846-05d3-4a66-b9e9-1986b5c035d1', '7368914a-b52b-40ab-85fd-b1c842996ea8', now() - interval '1 days', now() - interval '8 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('ab788630-35c2-497b-8443-30b9eceaa013', 'e16faced-5bdc-498f-9508-2071108a140b', NULL, 'Support Request 18', 'Client needs help with configuration.', 'open', 'medium', '27cf9846-05d3-4a66-b9e9-1986b5c035d1', '7368914a-b52b-40ab-85fd-b1c842996ea8', NULL, now() - interval '13 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('8c72fda0-69f0-4978-bd5d-5216aae3ec63', '12ce7e37-f2f6-4ecf-a828-57c0b1229267', NULL, 'Support Request 19', 'Client needs help with configuration.', 'waiting', 'medium', '27cf9846-05d3-4a66-b9e9-1986b5c035d1', '27cf9846-05d3-4a66-b9e9-1986b5c035d1', NULL, now() - interval '7 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('f8bceefa-8cc0-4a8e-9e0e-091da4e7f937', '2f6d8ab1-692e-48b1-b97a-cae0c03889a0', '69cd5149-becd-4384-829e-583918d15e63', 'Support Request 20', 'Client needs help with configuration.', 'in_progress', 'high', '27cf9846-05d3-4a66-b9e9-1986b5c035d1', '27cf9846-05d3-4a66-b9e9-1986b5c035d1', NULL, now() - interval '5 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('35f06d51-1ede-4702-854e-560019ae367b', '580d7ba3-f6c8-4c11-bc99-959495e68071', NULL, 'Support Request 21', 'Client needs help with configuration.', 'open', 'high', '27cf9846-05d3-4a66-b9e9-1986b5c035d1', '27cf9846-05d3-4a66-b9e9-1986b5c035d1', NULL, now() - interval '14 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('2cfa1135-1848-41e8-bcb9-20f02ea216ce', 'd7b304d8-7629-4c4a-9c97-040237f13e74', NULL, 'Support Request 22', 'Client needs help with configuration.', 'waiting', 'medium', '27cf9846-05d3-4a66-b9e9-1986b5c035d1', '515419a2-5e51-4a50-959f-44ae235587ce', NULL, now() - interval '12 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('cf31ac56-4a80-4caa-be99-1ea42eb9a1a9', '2f6d8ab1-692e-48b1-b97a-cae0c03889a0', 'c975415f-dda0-49eb-9b4e-f5d5692e2c9e', 'Support Request 23', 'Client needs help with configuration.', 'in_progress', 'high', '27cf9846-05d3-4a66-b9e9-1986b5c035d1', '7368914a-b52b-40ab-85fd-b1c842996ea8', NULL, now() - interval '2 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('f9465d03-5b7e-4259-9f02-a03f1ce41566', '7ffff323-2693-4854-957d-df0dc228b4af', NULL, 'Support Request 24', 'Client needs help with configuration.', 'open', 'critical', '27cf9846-05d3-4a66-b9e9-1986b5c035d1', '27cf9846-05d3-4a66-b9e9-1986b5c035d1', NULL, now() - interval '2 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('3f9e6be7-958e-4214-884a-c303f19e7ed9', '214a5314-5b6b-4226-b90a-608370de630a', NULL, 'Support Request 25', 'Client needs help with configuration.', 'waiting', 'medium', '27cf9846-05d3-4a66-b9e9-1986b5c035d1', '7368914a-b52b-40ab-85fd-b1c842996ea8', NULL, now() - interval '15 days') ON CONFLICT (id) DO NOTHING;
