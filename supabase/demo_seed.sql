
-- ==========================================
-- DEMO SEED DATA FOR SOLV CRM & ERP
-- ==========================================
-- WARNING: This script assumes tables are empty or will insert ignoring conflicts.

-- 1. Create Users
-- We insert into auth.users directly. Note: these users cannot log in.
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at) 
VALUES ('b1eb441d-746d-420f-9600-48aa10f81a04', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'alice.sales@example.com', '', now(), now(), now())
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.profiles (id, full_name, email, job_title, created_at, updated_at) 
VALUES ('b1eb441d-746d-420f-9600-48aa10f81a04', 'Alice Smith', 'alice.sales@example.com', 'Sales Manager', now(), now())
ON CONFLICT (id) DO UPDATE SET full_name = EXCLUDED.full_name, job_title = EXCLUDED.job_title;
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at) 
VALUES ('ff83ba29-7621-45a6-8a24-8e2f6f6268aa', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'bob.account@example.com', '', now(), now(), now())
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.profiles (id, full_name, email, job_title, created_at, updated_at) 
VALUES ('ff83ba29-7621-45a6-8a24-8e2f6f6268aa', 'Bob Johnson', 'bob.account@example.com', 'Account Manager', now(), now())
ON CONFLICT (id) DO UPDATE SET full_name = EXCLUDED.full_name, job_title = EXCLUDED.job_title;
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at) 
VALUES ('8fed7298-cbca-4301-9fdd-8894ff4223a7', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'charlie.tech@example.com', '', now(), now(), now())
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.profiles (id, full_name, email, job_title, created_at, updated_at) 
VALUES ('8fed7298-cbca-4301-9fdd-8894ff4223a7', 'Charlie Davis', 'charlie.tech@example.com', 'Lead Developer', now(), now())
ON CONFLICT (id) DO UPDATE SET full_name = EXCLUDED.full_name, job_title = EXCLUDED.job_title;

-- 2. Services
INSERT INTO public.services (id, name, created_at, updated_at) VALUES ('999426a8-7e15-4917-9a28-001db2efc9cb', 'KIBO', now(), now()) ON CONFLICT DO NOTHING;
INSERT INTO public.services (id, name, created_at, updated_at) VALUES ('5d803265-e44f-4f68-8272-d6fec4edbb02', 'AI Sales App', now(), now()) ON CONFLICT DO NOTHING;
INSERT INTO public.services (id, name, created_at, updated_at) VALUES ('d259cbaa-2b5e-49c2-839e-07c757d79b98', 'Website Development', now(), now()) ON CONFLICT DO NOTHING;
INSERT INTO public.services (id, name, created_at, updated_at) VALUES ('b390b768-17dc-4fcb-9566-dab252e00cf2', 'Hosting', now(), now()) ON CONFLICT DO NOTHING;
INSERT INTO public.services (id, name, created_at, updated_at) VALUES ('1e4cbb00-1287-4a1b-ac26-a09d2a3be0b1', 'SEO', now(), now()) ON CONFLICT DO NOTHING;
INSERT INTO public.services (id, name, created_at, updated_at) VALUES ('1ce0f3ee-b9de-41c4-b558-362ff50299f4', 'Meta Ads Management', now(), now()) ON CONFLICT DO NOTHING;
INSERT INTO public.services (id, name, created_at, updated_at) VALUES ('090a356a-c1d5-4005-bc85-0f839c2240cb', 'Google Ads Management', now(), now()) ON CONFLICT DO NOTHING;
INSERT INTO public.services (id, name, created_at, updated_at) VALUES ('2c9323d9-efc8-4434-9d91-e6e66c6e8796', 'Broadcast Messaging', now(), now()) ON CONFLICT DO NOTHING;

-- 3. Customers, Sales & Customer Services
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('a53577e1-3aba-4d13-a7fd-fb4e5b41bfa0', 'Acme Corp', 'contact@acme corp.com', 'Real Estate', 'ff83ba29-7621-45a6-8a24-8e2f6f6268aa', 'active', now() - interval '62 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('a53577e1-3aba-4d13-a7fd-fb4e5b41bfa0', 'd259cbaa-2b5e-49c2-839e-07c757d79b98', 'Website Development', 'one-off', 1789, 'active', current_date, now() - interval '29 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('a53577e1-3aba-4d13-a7fd-fb4e5b41bfa0', 'd259cbaa-2b5e-49c2-839e-07c757d79b98', 'active', current_date, now()) ON CONFLICT ON CONSTRAINT customer_services_customer_id_service_id_key DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('a53577e1-3aba-4d13-a7fd-fb4e5b41bfa0', '1e4cbb00-1287-4a1b-ac26-a09d2a3be0b1', 'SEO', 'retainer', 245, 'active', current_date, now() - interval '14 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('a53577e1-3aba-4d13-a7fd-fb4e5b41bfa0', '1e4cbb00-1287-4a1b-ac26-a09d2a3be0b1', 'active', current_date, now()) ON CONFLICT ON CONSTRAINT customer_services_customer_id_service_id_key DO NOTHING;
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('3cf22c56-6adb-41b2-b470-099c86cb7c1a', 'Globex Corporation', 'contact@globex corporation.com', 'Healthcare', 'b1eb441d-746d-420f-9600-48aa10f81a04', 'active', now() - interval '43 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('3cf22c56-6adb-41b2-b470-099c86cb7c1a', 'b390b768-17dc-4fcb-9566-dab252e00cf2', 'Hosting', 'one-off', 6563, 'active', current_date, now() - interval '3 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('3cf22c56-6adb-41b2-b470-099c86cb7c1a', 'b390b768-17dc-4fcb-9566-dab252e00cf2', 'active', current_date, now()) ON CONFLICT ON CONSTRAINT customer_services_customer_id_service_id_key DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('3cf22c56-6adb-41b2-b470-099c86cb7c1a', '090a356a-c1d5-4005-bc85-0f839c2240cb', 'Google Ads Management', 'retainer', 819, 'active', current_date, now() - interval '2 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('3cf22c56-6adb-41b2-b470-099c86cb7c1a', '090a356a-c1d5-4005-bc85-0f839c2240cb', 'active', current_date, now()) ON CONFLICT ON CONSTRAINT customer_services_customer_id_service_id_key DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('3cf22c56-6adb-41b2-b470-099c86cb7c1a', '1e4cbb00-1287-4a1b-ac26-a09d2a3be0b1', 'SEO', 'retainer', 1352, 'active', current_date, now() - interval '4 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('3cf22c56-6adb-41b2-b470-099c86cb7c1a', '1e4cbb00-1287-4a1b-ac26-a09d2a3be0b1', 'active', current_date, now()) ON CONFLICT ON CONSTRAINT customer_services_customer_id_service_id_key DO NOTHING;
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('1b90c958-0a34-4723-b086-2bb93fdad45c', 'Soylent Corp', 'contact@soylent corp.com', 'Finance', 'ff83ba29-7621-45a6-8a24-8e2f6f6268aa', 'active', now() - interval '68 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('1b90c958-0a34-4723-b086-2bb93fdad45c', '1ce0f3ee-b9de-41c4-b558-362ff50299f4', 'Meta Ads Management', 'one-off', 6952, 'active', current_date, now() - interval '12 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('1b90c958-0a34-4723-b086-2bb93fdad45c', '1ce0f3ee-b9de-41c4-b558-362ff50299f4', 'active', current_date, now()) ON CONFLICT ON CONSTRAINT customer_services_customer_id_service_id_key DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('1b90c958-0a34-4723-b086-2bb93fdad45c', '999426a8-7e15-4917-9a28-001db2efc9cb', 'KIBO', 'retainer', 792, 'active', current_date, now() - interval '11 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('1b90c958-0a34-4723-b086-2bb93fdad45c', '999426a8-7e15-4917-9a28-001db2efc9cb', 'active', current_date, now()) ON CONFLICT ON CONSTRAINT customer_services_customer_id_service_id_key DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('1b90c958-0a34-4723-b086-2bb93fdad45c', 'b390b768-17dc-4fcb-9566-dab252e00cf2', 'Hosting', 'one-off', 3793, 'active', current_date, now() - interval '30 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('1b90c958-0a34-4723-b086-2bb93fdad45c', 'b390b768-17dc-4fcb-9566-dab252e00cf2', 'active', current_date, now()) ON CONFLICT ON CONSTRAINT customer_services_customer_id_service_id_key DO NOTHING;
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('d5f6e3f8-3e39-4548-9f85-d19283880edd', 'Initech', 'contact@initech.com', 'Logistics', 'ff83ba29-7621-45a6-8a24-8e2f6f6268aa', 'active', now() - interval '95 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('d5f6e3f8-3e39-4548-9f85-d19283880edd', '090a356a-c1d5-4005-bc85-0f839c2240cb', 'Google Ads Management', 'retainer', 579, 'active', current_date, now() - interval '12 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('d5f6e3f8-3e39-4548-9f85-d19283880edd', '090a356a-c1d5-4005-bc85-0f839c2240cb', 'active', current_date, now()) ON CONFLICT ON CONSTRAINT customer_services_customer_id_service_id_key DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('d5f6e3f8-3e39-4548-9f85-d19283880edd', 'b390b768-17dc-4fcb-9566-dab252e00cf2', 'Hosting', 'retainer', 1286, 'active', current_date, now() - interval '6 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('d5f6e3f8-3e39-4548-9f85-d19283880edd', 'b390b768-17dc-4fcb-9566-dab252e00cf2', 'active', current_date, now()) ON CONFLICT ON CONSTRAINT customer_services_customer_id_service_id_key DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('d5f6e3f8-3e39-4548-9f85-d19283880edd', '5d803265-e44f-4f68-8272-d6fec4edbb02', 'AI Sales App', 'one-off', 8995, 'active', current_date, now() - interval '6 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('d5f6e3f8-3e39-4548-9f85-d19283880edd', '5d803265-e44f-4f68-8272-d6fec4edbb02', 'active', current_date, now()) ON CONFLICT ON CONSTRAINT customer_services_customer_id_service_id_key DO NOTHING;
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('d577d59f-b25e-41dd-84e8-67569bf26259', 'Umbrella Corporation', 'contact@umbrella corporation.com', 'Education', '8fed7298-cbca-4301-9fdd-8894ff4223a7', 'active', now() - interval '11 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('d577d59f-b25e-41dd-84e8-67569bf26259', '1ce0f3ee-b9de-41c4-b558-362ff50299f4', 'Meta Ads Management', 'retainer', 1468, 'active', current_date, now() - interval '13 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('d577d59f-b25e-41dd-84e8-67569bf26259', '1ce0f3ee-b9de-41c4-b558-362ff50299f4', 'active', current_date, now()) ON CONFLICT ON CONSTRAINT customer_services_customer_id_service_id_key DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('d577d59f-b25e-41dd-84e8-67569bf26259', '2c9323d9-efc8-4434-9d91-e6e66c6e8796', 'Broadcast Messaging', 'one-off', 8851, 'active', current_date, now() - interval '19 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('d577d59f-b25e-41dd-84e8-67569bf26259', '2c9323d9-efc8-4434-9d91-e6e66c6e8796', 'active', current_date, now()) ON CONFLICT ON CONSTRAINT customer_services_customer_id_service_id_key DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('d577d59f-b25e-41dd-84e8-67569bf26259', '090a356a-c1d5-4005-bc85-0f839c2240cb', 'Google Ads Management', 'one-off', 2690, 'active', current_date, now() - interval '20 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('d577d59f-b25e-41dd-84e8-67569bf26259', '090a356a-c1d5-4005-bc85-0f839c2240cb', 'active', current_date, now()) ON CONFLICT ON CONSTRAINT customer_services_customer_id_service_id_key DO NOTHING;
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('2bd9e247-43c8-4670-8045-725e62b38e95', 'Stark Industries', 'contact@stark industries.com', 'Finance', '8fed7298-cbca-4301-9fdd-8894ff4223a7', 'active', now() - interval '88 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('2bd9e247-43c8-4670-8045-725e62b38e95', 'd259cbaa-2b5e-49c2-839e-07c757d79b98', 'Website Development', 'retainer', 1479, 'active', current_date, now() - interval '21 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('2bd9e247-43c8-4670-8045-725e62b38e95', 'd259cbaa-2b5e-49c2-839e-07c757d79b98', 'active', current_date, now()) ON CONFLICT ON CONSTRAINT customer_services_customer_id_service_id_key DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('2bd9e247-43c8-4670-8045-725e62b38e95', '1ce0f3ee-b9de-41c4-b558-362ff50299f4', 'Meta Ads Management', 'retainer', 859, 'active', current_date, now() - interval '23 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('2bd9e247-43c8-4670-8045-725e62b38e95', '1ce0f3ee-b9de-41c4-b558-362ff50299f4', 'active', current_date, now()) ON CONFLICT ON CONSTRAINT customer_services_customer_id_service_id_key DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('2bd9e247-43c8-4670-8045-725e62b38e95', '5d803265-e44f-4f68-8272-d6fec4edbb02', 'AI Sales App', 'retainer', 825, 'active', current_date, now() - interval '30 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('2bd9e247-43c8-4670-8045-725e62b38e95', '5d803265-e44f-4f68-8272-d6fec4edbb02', 'active', current_date, now()) ON CONFLICT ON CONSTRAINT customer_services_customer_id_service_id_key DO NOTHING;
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('6bba8827-7f63-4262-b2c5-716ccafa6f4d', 'Wayne Enterprises', 'contact@wayne enterprises.com', 'Technology', 'b1eb441d-746d-420f-9600-48aa10f81a04', 'active', now() - interval '18 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('6bba8827-7f63-4262-b2c5-716ccafa6f4d', '2c9323d9-efc8-4434-9d91-e6e66c6e8796', 'Broadcast Messaging', 'retainer', 862, 'active', current_date, now() - interval '24 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('6bba8827-7f63-4262-b2c5-716ccafa6f4d', '2c9323d9-efc8-4434-9d91-e6e66c6e8796', 'active', current_date, now()) ON CONFLICT ON CONSTRAINT customer_services_customer_id_service_id_key DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('6bba8827-7f63-4262-b2c5-716ccafa6f4d', '090a356a-c1d5-4005-bc85-0f839c2240cb', 'Google Ads Management', 'one-off', 3006, 'active', current_date, now() - interval '30 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('6bba8827-7f63-4262-b2c5-716ccafa6f4d', '090a356a-c1d5-4005-bc85-0f839c2240cb', 'active', current_date, now()) ON CONFLICT ON CONSTRAINT customer_services_customer_id_service_id_key DO NOTHING;
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('de9aaa36-ad18-4ce5-9ce5-2df3dde4430a', 'Cyberdyne Systems', 'contact@cyberdyne systems.com', 'Logistics', '8fed7298-cbca-4301-9fdd-8894ff4223a7', 'active', now() - interval '90 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('de9aaa36-ad18-4ce5-9ce5-2df3dde4430a', '2c9323d9-efc8-4434-9d91-e6e66c6e8796', 'Broadcast Messaging', 'one-off', 2842, 'active', current_date, now() - interval '11 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('de9aaa36-ad18-4ce5-9ce5-2df3dde4430a', '2c9323d9-efc8-4434-9d91-e6e66c6e8796', 'active', current_date, now()) ON CONFLICT ON CONSTRAINT customer_services_customer_id_service_id_key DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('de9aaa36-ad18-4ce5-9ce5-2df3dde4430a', 'd259cbaa-2b5e-49c2-839e-07c757d79b98', 'Website Development', 'one-off', 5881, 'active', current_date, now() - interval '6 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('de9aaa36-ad18-4ce5-9ce5-2df3dde4430a', 'd259cbaa-2b5e-49c2-839e-07c757d79b98', 'active', current_date, now()) ON CONFLICT ON CONSTRAINT customer_services_customer_id_service_id_key DO NOTHING;
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('c34749b3-ab98-4c68-8af8-f28dc8b4017e', 'Massive Dynamic', 'contact@massive dynamic.com', 'Education', 'ff83ba29-7621-45a6-8a24-8e2f6f6268aa', 'active', now() - interval '23 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('c34749b3-ab98-4c68-8af8-f28dc8b4017e', '999426a8-7e15-4917-9a28-001db2efc9cb', 'KIBO', 'retainer', 247, 'active', current_date, now() - interval '14 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('c34749b3-ab98-4c68-8af8-f28dc8b4017e', '999426a8-7e15-4917-9a28-001db2efc9cb', 'active', current_date, now()) ON CONFLICT ON CONSTRAINT customer_services_customer_id_service_id_key DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('c34749b3-ab98-4c68-8af8-f28dc8b4017e', '5d803265-e44f-4f68-8272-d6fec4edbb02', 'AI Sales App', 'one-off', 1296, 'active', current_date, now() - interval '15 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('c34749b3-ab98-4c68-8af8-f28dc8b4017e', '5d803265-e44f-4f68-8272-d6fec4edbb02', 'active', current_date, now()) ON CONFLICT ON CONSTRAINT customer_services_customer_id_service_id_key DO NOTHING;
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('c4b73686-223b-462d-8a36-0edbedc6fbf6', 'Genco Pura Olive Oil', 'contact@genco pura olive oil.com', 'Healthcare', 'b1eb441d-746d-420f-9600-48aa10f81a04', 'active', now() - interval '27 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('c4b73686-223b-462d-8a36-0edbedc6fbf6', 'b390b768-17dc-4fcb-9566-dab252e00cf2', 'Hosting', 'retainer', 1072, 'active', current_date, now() - interval '27 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('c4b73686-223b-462d-8a36-0edbedc6fbf6', 'b390b768-17dc-4fcb-9566-dab252e00cf2', 'active', current_date, now()) ON CONFLICT ON CONSTRAINT customer_services_customer_id_service_id_key DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('c4b73686-223b-462d-8a36-0edbedc6fbf6', '5d803265-e44f-4f68-8272-d6fec4edbb02', 'AI Sales App', 'retainer', 833, 'active', current_date, now() - interval '29 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('c4b73686-223b-462d-8a36-0edbedc6fbf6', '5d803265-e44f-4f68-8272-d6fec4edbb02', 'active', current_date, now()) ON CONFLICT ON CONSTRAINT customer_services_customer_id_service_id_key DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('c4b73686-223b-462d-8a36-0edbedc6fbf6', '2c9323d9-efc8-4434-9d91-e6e66c6e8796', 'Broadcast Messaging', 'retainer', 1005, 'active', current_date, now() - interval '21 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('c4b73686-223b-462d-8a36-0edbedc6fbf6', '2c9323d9-efc8-4434-9d91-e6e66c6e8796', 'active', current_date, now()) ON CONFLICT ON CONSTRAINT customer_services_customer_id_service_id_key DO NOTHING;
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('b079540a-d0d7-48a3-a430-9303df6f9599', 'LexCorp', 'contact@lexcorp.com', 'Technology', 'ff83ba29-7621-45a6-8a24-8e2f6f6268aa', 'active', now() - interval '74 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('b079540a-d0d7-48a3-a430-9303df6f9599', '1ce0f3ee-b9de-41c4-b558-362ff50299f4', 'Meta Ads Management', 'one-off', 9280, 'active', current_date, now() - interval '6 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('b079540a-d0d7-48a3-a430-9303df6f9599', '1ce0f3ee-b9de-41c4-b558-362ff50299f4', 'active', current_date, now()) ON CONFLICT ON CONSTRAINT customer_services_customer_id_service_id_key DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('b079540a-d0d7-48a3-a430-9303df6f9599', 'b390b768-17dc-4fcb-9566-dab252e00cf2', 'Hosting', 'retainer', 674, 'active', current_date, now() - interval '27 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('b079540a-d0d7-48a3-a430-9303df6f9599', 'b390b768-17dc-4fcb-9566-dab252e00cf2', 'active', current_date, now()) ON CONFLICT ON CONSTRAINT customer_services_customer_id_service_id_key DO NOTHING;
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('da125edb-a8e1-40b3-ac9d-497a4328418c', 'Oceanic Airlines', 'contact@oceanic airlines.com', 'Technology', '8fed7298-cbca-4301-9fdd-8894ff4223a7', 'active', now() - interval '93 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('da125edb-a8e1-40b3-ac9d-497a4328418c', 'd259cbaa-2b5e-49c2-839e-07c757d79b98', 'Website Development', 'retainer', 803, 'active', current_date, now() - interval '5 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('da125edb-a8e1-40b3-ac9d-497a4328418c', 'd259cbaa-2b5e-49c2-839e-07c757d79b98', 'active', current_date, now()) ON CONFLICT ON CONSTRAINT customer_services_customer_id_service_id_key DO NOTHING;
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('9cf2bdbd-eba1-4d69-88b1-b276dff0fc42', 'Wonka Industries', 'contact@wonka industries.com', 'Education', '8fed7298-cbca-4301-9fdd-8894ff4223a7', 'active', now() - interval '94 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('9cf2bdbd-eba1-4d69-88b1-b276dff0fc42', '1e4cbb00-1287-4a1b-ac26-a09d2a3be0b1', 'SEO', 'one-off', 1432, 'active', current_date, now() - interval '30 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('9cf2bdbd-eba1-4d69-88b1-b276dff0fc42', '1e4cbb00-1287-4a1b-ac26-a09d2a3be0b1', 'active', current_date, now()) ON CONFLICT ON CONSTRAINT customer_services_customer_id_service_id_key DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('9cf2bdbd-eba1-4d69-88b1-b276dff0fc42', '5d803265-e44f-4f68-8272-d6fec4edbb02', 'AI Sales App', 'retainer', 468, 'active', current_date, now() - interval '4 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('9cf2bdbd-eba1-4d69-88b1-b276dff0fc42', '5d803265-e44f-4f68-8272-d6fec4edbb02', 'active', current_date, now()) ON CONFLICT ON CONSTRAINT customer_services_customer_id_service_id_key DO NOTHING;
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('9c1687aa-8f53-4eed-b80f-2d3e848a8947', 'Oscorp', 'contact@oscorp.com', 'Education', '8fed7298-cbca-4301-9fdd-8894ff4223a7', 'active', now() - interval '81 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('9c1687aa-8f53-4eed-b80f-2d3e848a8947', '5d803265-e44f-4f68-8272-d6fec4edbb02', 'AI Sales App', 'retainer', 811, 'active', current_date, now() - interval '21 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('9c1687aa-8f53-4eed-b80f-2d3e848a8947', '5d803265-e44f-4f68-8272-d6fec4edbb02', 'active', current_date, now()) ON CONFLICT ON CONSTRAINT customer_services_customer_id_service_id_key DO NOTHING;
INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('e05b53b0-f808-4748-bf8e-e64c90e8b2de', 'Hooli', 'contact@hooli.com', 'Real Estate', '8fed7298-cbca-4301-9fdd-8894ff4223a7', 'active', now() - interval '51 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('e05b53b0-f808-4748-bf8e-e64c90e8b2de', '1ce0f3ee-b9de-41c4-b558-362ff50299f4', 'Meta Ads Management', 'retainer', 800, 'active', current_date, now() - interval '8 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('e05b53b0-f808-4748-bf8e-e64c90e8b2de', '1ce0f3ee-b9de-41c4-b558-362ff50299f4', 'active', current_date, now()) ON CONFLICT ON CONSTRAINT customer_services_customer_id_service_id_key DO NOTHING;
INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('e05b53b0-f808-4748-bf8e-e64c90e8b2de', '090a356a-c1d5-4005-bc85-0f839c2240cb', 'Google Ads Management', 'retainer', 706, 'active', current_date, now() - interval '2 days');
INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('e05b53b0-f808-4748-bf8e-e64c90e8b2de', '090a356a-c1d5-4005-bc85-0f839c2240cb', 'active', current_date, now()) ON CONFLICT ON CONSTRAINT customer_services_customer_id_service_id_key DO NOTHING;

-- 4. Leads & Lead Services
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('cc739cf6-8d5a-482d-9bf4-69511ef56863', 'Contact 15', 'Pied Piper (Lead)', 'contact15@example.com', 'cold', 4189, 'Trade Show', 'b1eb441d-746d-420f-9600-48aa10f81a04', NULL, NULL, NULL, now() - interval '33 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('cc739cf6-8d5a-482d-9bf4-69511ef56863', '1ce0f3ee-b9de-41c4-b558-362ff50299f4') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('1d6323de-5339-403e-8bc2-001dada12d03', 'Contact 16', 'Dunder Mifflin (Lead)', 'contact16@example.com', 'hot', 2113, 'Trade Show', '8fed7298-cbca-4301-9fdd-8894ff4223a7', NULL, NULL, NULL, now() - interval '14 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('1d6323de-5339-403e-8bc2-001dada12d03', '5d803265-e44f-4f68-8272-d6fec4edbb02') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('c16aebaa-a237-4cf1-ba86-247d77297ef2', 'Contact 17', 'Aperture Science (Lead)', 'contact17@example.com', 'converted', 4808, 'Website', '8fed7298-cbca-4301-9fdd-8894ff4223a7', now() - interval '6 days', NULL, NULL, now() - interval '17 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('c16aebaa-a237-4cf1-ba86-247d77297ef2', 'b390b768-17dc-4fcb-9566-dab252e00cf2') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('c16aebaa-a237-4cf1-ba86-247d77297ef2', 'd259cbaa-2b5e-49c2-839e-07c757d79b98') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('de946da4-7129-4b9b-a893-eb5713b4d301', 'Contact 18', 'Acme Corp', 'contact18@example.com', 'converted', 2474, 'Cold Call', '8fed7298-cbca-4301-9fdd-8894ff4223a7', now() - interval '1 days', NULL, NULL, now() - interval '33 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('de946da4-7129-4b9b-a893-eb5713b4d301', '2c9323d9-efc8-4434-9d91-e6e66c6e8796') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('de946da4-7129-4b9b-a893-eb5713b4d301', 'd259cbaa-2b5e-49c2-839e-07c757d79b98') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('7664115f-dbca-404f-bb5d-8d258508dfad', 'Contact 19', 'Gringotts (Lead)', 'contact19@example.com', 'cold', 2888, 'Social Media', '8fed7298-cbca-4301-9fdd-8894ff4223a7', NULL, NULL, NULL, now() - interval '20 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('7664115f-dbca-404f-bb5d-8d258508dfad', '1ce0f3ee-b9de-41c4-b558-362ff50299f4') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('901c7a5a-19a1-417d-a775-e56b1763e051', 'Contact 20', 'Cyberdyne Systems', 'contact20@example.com', 'hot', 2349, 'Trade Show', '8fed7298-cbca-4301-9fdd-8894ff4223a7', NULL, NULL, NULL, now() - interval '29 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('901c7a5a-19a1-417d-a775-e56b1763e051', 'd259cbaa-2b5e-49c2-839e-07c757d79b98') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('901c7a5a-19a1-417d-a775-e56b1763e051', '1e4cbb00-1287-4a1b-ac26-a09d2a3be0b1') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('8bf71c55-be83-48f4-917b-a0096efa6e5f', 'Contact 21', 'Virtucon (Lead)', 'contact21@example.com', 'warm', 2757, 'Cold Call', 'ff83ba29-7621-45a6-8a24-8e2f6f6268aa', NULL, NULL, NULL, now() - interval '36 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('8bf71c55-be83-48f4-917b-a0096efa6e5f', 'd259cbaa-2b5e-49c2-839e-07c757d79b98') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('8bf71c55-be83-48f4-917b-a0096efa6e5f', '999426a8-7e15-4917-9a28-001db2efc9cb') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('8bf71c55-be83-48f4-917b-a0096efa6e5f', '1ce0f3ee-b9de-41c4-b558-362ff50299f4') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('484189a3-6d9d-4872-b04d-cae6d94b64c1', 'Contact 22', 'MomCorp (Lead)', 'contact22@example.com', 'proposal', 2943, 'Social Media', '8fed7298-cbca-4301-9fdd-8894ff4223a7', NULL, NULL, NULL, now() - interval '19 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('484189a3-6d9d-4872-b04d-cae6d94b64c1', 'b390b768-17dc-4fcb-9566-dab252e00cf2') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('484189a3-6d9d-4872-b04d-cae6d94b64c1', '2c9323d9-efc8-4434-9d91-e6e66c6e8796') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('e31cf471-da7b-4ff7-aae7-75e803d0eea0', 'Contact 23', 'Slurm (Lead)', 'contact23@example.com', 'cold', 1190, 'Cold Call', '8fed7298-cbca-4301-9fdd-8894ff4223a7', NULL, NULL, NULL, now() - interval '20 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('e31cf471-da7b-4ff7-aae7-75e803d0eea0', '2c9323d9-efc8-4434-9d91-e6e66c6e8796') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('e31cf471-da7b-4ff7-aae7-75e803d0eea0', '1e4cbb00-1287-4a1b-ac26-a09d2a3be0b1') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('e31cf471-da7b-4ff7-aae7-75e803d0eea0', '1ce0f3ee-b9de-41c4-b558-362ff50299f4') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('b8ad668e-911f-4019-a35a-04ad8fdbf936', 'Contact 24', 'Nuka-Cola (Lead)', 'contact24@example.com', 'warm', 4591, 'Social Media', 'ff83ba29-7621-45a6-8a24-8e2f6f6268aa', NULL, NULL, NULL, now() - interval '11 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('b8ad668e-911f-4019-a35a-04ad8fdbf936', '090a356a-c1d5-4005-bc85-0f839c2240cb') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('b8ad668e-911f-4019-a35a-04ad8fdbf936', '5d803265-e44f-4f68-8272-d6fec4edbb02') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('d6e16d60-d449-4b99-88dd-b5f8486dcaea', 'Contact 25', 'Acme Corp (Lead)', 'contact25@example.com', 'cold', 1927, 'Referral', '8fed7298-cbca-4301-9fdd-8894ff4223a7', NULL, NULL, NULL, now() - interval '15 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('d6e16d60-d449-4b99-88dd-b5f8486dcaea', 'd259cbaa-2b5e-49c2-839e-07c757d79b98') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('d6e16d60-d449-4b99-88dd-b5f8486dcaea', '5d803265-e44f-4f68-8272-d6fec4edbb02') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('116daf72-6295-4de6-abca-df1e8d0d6d97', 'Contact 26', 'Globex Corporation (Lead)', 'contact26@example.com', 'warm', 1932, 'Cold Call', 'b1eb441d-746d-420f-9600-48aa10f81a04', NULL, NULL, NULL, now() - interval '16 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('116daf72-6295-4de6-abca-df1e8d0d6d97', 'd259cbaa-2b5e-49c2-839e-07c757d79b98') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('116daf72-6295-4de6-abca-df1e8d0d6d97', '090a356a-c1d5-4005-bc85-0f839c2240cb') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('116daf72-6295-4de6-abca-df1e8d0d6d97', '2c9323d9-efc8-4434-9d91-e6e66c6e8796') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('b4870c69-03ab-40fc-a44d-6153ccc5d63f', 'Contact 27', 'Soylent Corp (Lead)', 'contact27@example.com', 'lost', 1482, 'Referral', 'ff83ba29-7621-45a6-8a24-8e2f6f6268aa', NULL, now() - interval '3 days', 'Timing', now() - interval '33 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('b4870c69-03ab-40fc-a44d-6153ccc5d63f', '1e4cbb00-1287-4a1b-ac26-a09d2a3be0b1') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('8a76628a-9cac-4e7b-abe8-9e481a2f0a1d', 'Contact 28', 'Initech (Lead)', 'contact28@example.com', 'converted', 2950, 'Trade Show', '8fed7298-cbca-4301-9fdd-8894ff4223a7', now() - interval '5 days', NULL, NULL, now() - interval '28 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('8a76628a-9cac-4e7b-abe8-9e481a2f0a1d', 'b390b768-17dc-4fcb-9566-dab252e00cf2') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('ddc9298f-e3fa-4e71-b0c5-ce5e23873072', 'Contact 29', 'Umbrella Corporation (Lead)', 'contact29@example.com', 'warm', 3975, 'Social Media', '8fed7298-cbca-4301-9fdd-8894ff4223a7', NULL, NULL, NULL, now() - interval '18 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('ddc9298f-e3fa-4e71-b0c5-ce5e23873072', 'd259cbaa-2b5e-49c2-839e-07c757d79b98') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('485d78d1-bd04-4ded-b164-7e9c64084c16', 'Contact 30', 'Stark Industries (Lead)', 'contact30@example.com', 'warm', 4377, 'Social Media', '8fed7298-cbca-4301-9fdd-8894ff4223a7', NULL, NULL, NULL, now() - interval '30 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('485d78d1-bd04-4ded-b164-7e9c64084c16', '999426a8-7e15-4917-9a28-001db2efc9cb') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('485d78d1-bd04-4ded-b164-7e9c64084c16', '090a356a-c1d5-4005-bc85-0f839c2240cb') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('485d78d1-bd04-4ded-b164-7e9c64084c16', 'd259cbaa-2b5e-49c2-839e-07c757d79b98') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('2d31ab58-7f3b-4094-92d7-77a8941aa27c', 'Contact 31', 'Wayne Enterprises (Lead)', 'contact31@example.com', 'lost', 4133, 'Cold Call', 'ff83ba29-7621-45a6-8a24-8e2f6f6268aa', NULL, now() - interval '4 days', 'Timing', now() - interval '29 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('2d31ab58-7f3b-4094-92d7-77a8941aa27c', '1ce0f3ee-b9de-41c4-b558-362ff50299f4') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('2d31ab58-7f3b-4094-92d7-77a8941aa27c', 'd259cbaa-2b5e-49c2-839e-07c757d79b98') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('e223cfe2-6f70-43bc-97be-c3faabdedc1b', 'Contact 32', 'Cyberdyne Systems (Lead)', 'contact32@example.com', 'proposal', 2856, 'Website', 'b1eb441d-746d-420f-9600-48aa10f81a04', NULL, NULL, NULL, now() - interval '21 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('e223cfe2-6f70-43bc-97be-c3faabdedc1b', '2c9323d9-efc8-4434-9d91-e6e66c6e8796') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('e223cfe2-6f70-43bc-97be-c3faabdedc1b', '1ce0f3ee-b9de-41c4-b558-362ff50299f4') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('e223cfe2-6f70-43bc-97be-c3faabdedc1b', '999426a8-7e15-4917-9a28-001db2efc9cb') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('22602208-a63b-4ee8-b77d-b3ad2aefb448', 'Contact 33', 'Massive Dynamic', 'contact33@example.com', 'proposal', 4074, 'Trade Show', 'b1eb441d-746d-420f-9600-48aa10f81a04', NULL, NULL, NULL, now() - interval '30 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('22602208-a63b-4ee8-b77d-b3ad2aefb448', '5d803265-e44f-4f68-8272-d6fec4edbb02') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('22602208-a63b-4ee8-b77d-b3ad2aefb448', '999426a8-7e15-4917-9a28-001db2efc9cb') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('f20deca4-2c57-4419-9f14-d5ce94ee645a', 'Contact 34', 'Umbrella Corporation', 'contact34@example.com', 'proposal', 1178, 'Referral', 'b1eb441d-746d-420f-9600-48aa10f81a04', NULL, NULL, NULL, now() - interval '19 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('f20deca4-2c57-4419-9f14-d5ce94ee645a', '090a356a-c1d5-4005-bc85-0f839c2240cb') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('f20deca4-2c57-4419-9f14-d5ce94ee645a', '999426a8-7e15-4917-9a28-001db2efc9cb') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('472144da-6b5e-4910-9c1f-e209e1acae4e', 'Contact 35', 'Wayne Enterprises', 'contact35@example.com', 'cold', 2962, 'Social Media', 'b1eb441d-746d-420f-9600-48aa10f81a04', NULL, NULL, NULL, now() - interval '30 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('472144da-6b5e-4910-9c1f-e209e1acae4e', '2c9323d9-efc8-4434-9d91-e6e66c6e8796') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('472144da-6b5e-4910-9c1f-e209e1acae4e', 'b390b768-17dc-4fcb-9566-dab252e00cf2') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('3b48e8f2-a28c-4f75-86d9-f3a9c20e8d0a', 'Contact 36', 'Oceanic Airlines (Lead)', 'contact36@example.com', 'hot', 700, 'Cold Call', '8fed7298-cbca-4301-9fdd-8894ff4223a7', NULL, NULL, NULL, now() - interval '22 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('3b48e8f2-a28c-4f75-86d9-f3a9c20e8d0a', '1ce0f3ee-b9de-41c4-b558-362ff50299f4') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('545ad130-c39d-4c4e-900d-9e4fc4df840b', 'Contact 37', 'Genco Pura Olive Oil', 'contact37@example.com', 'hot', 819, 'Trade Show', '8fed7298-cbca-4301-9fdd-8894ff4223a7', NULL, NULL, NULL, now() - interval '39 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('545ad130-c39d-4c4e-900d-9e4fc4df840b', '5d803265-e44f-4f68-8272-d6fec4edbb02') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('545ad130-c39d-4c4e-900d-9e4fc4df840b', 'd259cbaa-2b5e-49c2-839e-07c757d79b98') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('bc996139-0f73-4b07-a93f-560ab2d9b103', 'Contact 38', 'Stark Industries', 'contact38@example.com', 'converted', 4716, 'Trade Show', 'ff83ba29-7621-45a6-8a24-8e2f6f6268aa', now() - interval '4 days', NULL, NULL, now() - interval '13 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('bc996139-0f73-4b07-a93f-560ab2d9b103', 'b390b768-17dc-4fcb-9566-dab252e00cf2') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('bc996139-0f73-4b07-a93f-560ab2d9b103', '090a356a-c1d5-4005-bc85-0f839c2240cb') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('bc996139-0f73-4b07-a93f-560ab2d9b103', '2c9323d9-efc8-4434-9d91-e6e66c6e8796') ON CONFLICT DO NOTHING;
INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('1a15b787-4edc-477f-abd2-992600b16ebd', 'Contact 39', 'Hooli (Lead)', 'contact39@example.com', 'proposal', 3435, 'Cold Call', 'ff83ba29-7621-45a6-8a24-8e2f6f6268aa', NULL, NULL, NULL, now() - interval '18 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('1a15b787-4edc-477f-abd2-992600b16ebd', 'd259cbaa-2b5e-49c2-839e-07c757d79b98') ON CONFLICT DO NOTHING;
INSERT INTO public.lead_services (lead_id, service_id) VALUES ('1a15b787-4edc-477f-abd2-992600b16ebd', '5d803265-e44f-4f68-8272-d6fec4edbb02') ON CONFLICT DO NOTHING;

-- 5. Projects
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('7bead47e-82a1-4d7f-9747-28e3e33dfc1d', '3cf22c56-6adb-41b2-b470-099c86cb7c1a', 'Implementation Project 1', 'testing', current_date + interval '28 days', now() - interval '1 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.project_members (project_id, user_id) VALUES ('7bead47e-82a1-4d7f-9747-28e3e33dfc1d', 'b1eb441d-746d-420f-9600-48aa10f81a04') ON CONFLICT DO NOTHING;
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('eaad913c-b53a-4c83-a791-f148bc38d987', 'd577d59f-b25e-41dd-84e8-67569bf26259', 'Implementation Project 2', 'testing', current_date + interval '5 days', now() - interval '3 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.project_members (project_id, user_id) VALUES ('eaad913c-b53a-4c83-a791-f148bc38d987', '8fed7298-cbca-4301-9fdd-8894ff4223a7') ON CONFLICT DO NOTHING;
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('1358fcde-fe7d-4e03-8ada-3f0921a13ab6', 'd5f6e3f8-3e39-4548-9f85-d19283880edd', 'Implementation Project 3', 'planning', current_date + interval '6 days', now() - interval '9 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.project_members (project_id, user_id) VALUES ('1358fcde-fe7d-4e03-8ada-3f0921a13ab6', 'ff83ba29-7621-45a6-8a24-8e2f6f6268aa') ON CONFLICT DO NOTHING;
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('f1251d49-11bc-4fd4-b45c-ae8781327735', 'b079540a-d0d7-48a3-a430-9303df6f9599', 'Implementation Project 4', 'planning', current_date + interval '8 days', now() - interval '15 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.project_members (project_id, user_id) VALUES ('f1251d49-11bc-4fd4-b45c-ae8781327735', '8fed7298-cbca-4301-9fdd-8894ff4223a7') ON CONFLICT DO NOTHING;
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('ffa4cadf-84c6-4a68-8ac0-70265ad4edde', '1b90c958-0a34-4723-b086-2bb93fdad45c', 'Implementation Project 5', 'completed', current_date + interval '23 days', now() - interval '1 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.project_members (project_id, user_id) VALUES ('ffa4cadf-84c6-4a68-8ac0-70265ad4edde', '8fed7298-cbca-4301-9fdd-8894ff4223a7') ON CONFLICT DO NOTHING;
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('116a8051-6cfc-4c4b-80a6-4340e82c3ed1', 'e05b53b0-f808-4748-bf8e-e64c90e8b2de', 'Implementation Project 6', 'planning', current_date + interval '26 days', now() - interval '9 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.project_members (project_id, user_id) VALUES ('116a8051-6cfc-4c4b-80a6-4340e82c3ed1', 'b1eb441d-746d-420f-9600-48aa10f81a04') ON CONFLICT DO NOTHING;
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('5a79d23e-ca36-47e1-8936-6099ac587fe9', '2bd9e247-43c8-4670-8045-725e62b38e95', 'Implementation Project 7', 'in_progress', current_date + interval '5 days', now() - interval '20 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.project_members (project_id, user_id) VALUES ('5a79d23e-ca36-47e1-8936-6099ac587fe9', 'ff83ba29-7621-45a6-8a24-8e2f6f6268aa') ON CONFLICT DO NOTHING;
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('56aec0ed-50e0-4002-8d0e-f62044019dda', 'a53577e1-3aba-4d13-a7fd-fb4e5b41bfa0', 'Implementation Project 8', 'completed', current_date + interval '19 days', now() - interval '17 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.project_members (project_id, user_id) VALUES ('56aec0ed-50e0-4002-8d0e-f62044019dda', 'ff83ba29-7621-45a6-8a24-8e2f6f6268aa') ON CONFLICT DO NOTHING;
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('d8deede8-decd-4803-ac61-d2a524aa503c', 'da125edb-a8e1-40b3-ac9d-497a4328418c', 'Implementation Project 9', 'testing', current_date + interval '9 days', now() - interval '2 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.project_members (project_id, user_id) VALUES ('d8deede8-decd-4803-ac61-d2a524aa503c', 'ff83ba29-7621-45a6-8a24-8e2f6f6268aa') ON CONFLICT DO NOTHING;
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('1ab52e45-fa0d-4dd8-b660-0d84f9138144', '3cf22c56-6adb-41b2-b470-099c86cb7c1a', 'Implementation Project 10', 'testing', current_date + interval '30 days', now() - interval '17 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.project_members (project_id, user_id) VALUES ('1ab52e45-fa0d-4dd8-b660-0d84f9138144', 'ff83ba29-7621-45a6-8a24-8e2f6f6268aa') ON CONFLICT DO NOTHING;
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('ae471e55-3b26-4c4e-bbc8-86b00ea9bc3d', 'e05b53b0-f808-4748-bf8e-e64c90e8b2de', 'Implementation Project 11', 'in_progress', current_date + interval '25 days', now() - interval '16 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.project_members (project_id, user_id) VALUES ('ae471e55-3b26-4c4e-bbc8-86b00ea9bc3d', 'b1eb441d-746d-420f-9600-48aa10f81a04') ON CONFLICT DO NOTHING;
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('365bd960-df92-4eaf-b42a-3b899cb1959c', 'd577d59f-b25e-41dd-84e8-67569bf26259', 'Implementation Project 12', 'in_progress', current_date + interval '12 days', now() - interval '14 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.project_members (project_id, user_id) VALUES ('365bd960-df92-4eaf-b42a-3b899cb1959c', '8fed7298-cbca-4301-9fdd-8894ff4223a7') ON CONFLICT DO NOTHING;
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('147db378-6052-44a7-a774-c9bbf6edb0fd', 'b079540a-d0d7-48a3-a430-9303df6f9599', 'Implementation Project 13', 'completed', current_date + interval '9 days', now() - interval '15 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.project_members (project_id, user_id) VALUES ('147db378-6052-44a7-a774-c9bbf6edb0fd', 'b1eb441d-746d-420f-9600-48aa10f81a04') ON CONFLICT DO NOTHING;
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('d032f711-1e7a-47ff-99a7-f3b0d449b65f', '9c1687aa-8f53-4eed-b80f-2d3e848a8947', 'Implementation Project 14', 'testing', current_date + interval '17 days', now() - interval '15 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.project_members (project_id, user_id) VALUES ('d032f711-1e7a-47ff-99a7-f3b0d449b65f', 'ff83ba29-7621-45a6-8a24-8e2f6f6268aa') ON CONFLICT DO NOTHING;
INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('773b031c-e004-47e5-ae80-7fdcc5d9c6fe', 'e05b53b0-f808-4748-bf8e-e64c90e8b2de', 'Implementation Project 15', 'planning', current_date + interval '12 days', now() - interval '17 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.project_members (project_id, user_id) VALUES ('773b031c-e004-47e5-ae80-7fdcc5d9c6fe', 'b1eb441d-746d-420f-9600-48aa10f81a04') ON CONFLICT DO NOTHING;

-- 6. Tickets
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('0eef99f9-5841-4c85-a355-7f724a9b8d18', 'de9aaa36-ad18-4ce5-9ce5-2df3dde4430a', NULL, 'Support Request 1', 'Client needs help with configuration.', 'waiting', 'low', 'b1eb441d-746d-420f-9600-48aa10f81a04', 'b1eb441d-746d-420f-9600-48aa10f81a04', NULL, now() - interval '12 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('2c22606d-0aae-4236-b754-3afecbbe538c', 'd5f6e3f8-3e39-4548-9f85-d19283880edd', NULL, 'Support Request 2', 'Client needs help with configuration.', 'waiting', 'low', 'b1eb441d-746d-420f-9600-48aa10f81a04', '8fed7298-cbca-4301-9fdd-8894ff4223a7', NULL, now() - interval '13 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('fcf29918-810a-469b-bdc9-0e9eb94e815f', '3cf22c56-6adb-41b2-b470-099c86cb7c1a', NULL, 'Support Request 3', 'Client needs help with configuration.', 'resolved', 'low', 'b1eb441d-746d-420f-9600-48aa10f81a04', 'b1eb441d-746d-420f-9600-48aa10f81a04', now() - interval '2 days', now() - interval '3 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('05e911db-340f-4ec2-b7f9-a28cb552e52c', 'b079540a-d0d7-48a3-a430-9303df6f9599', '365bd960-df92-4eaf-b42a-3b899cb1959c', 'Support Request 4', 'Client needs help with configuration.', 'in_progress', 'high', 'b1eb441d-746d-420f-9600-48aa10f81a04', 'b1eb441d-746d-420f-9600-48aa10f81a04', NULL, now() - interval '11 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('a5d47127-4780-41cf-8291-26a43efd25d7', 'c4b73686-223b-462d-8a36-0edbedc6fbf6', '1ab52e45-fa0d-4dd8-b660-0d84f9138144', 'Support Request 5', 'Client needs help with configuration.', 'in_progress', 'high', 'b1eb441d-746d-420f-9600-48aa10f81a04', 'b1eb441d-746d-420f-9600-48aa10f81a04', NULL, now() - interval '7 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('d0038f07-d066-4e8c-ae80-d14727d67c3f', 'c34749b3-ab98-4c68-8af8-f28dc8b4017e', '5a79d23e-ca36-47e1-8936-6099ac587fe9', 'Support Request 6', 'Client needs help with configuration.', 'in_progress', 'low', 'b1eb441d-746d-420f-9600-48aa10f81a04', 'ff83ba29-7621-45a6-8a24-8e2f6f6268aa', NULL, now() - interval '10 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('9f69a9b1-fb5c-4d24-9543-3a533b5ec722', '6bba8827-7f63-4262-b2c5-716ccafa6f4d', NULL, 'Support Request 7', 'Client needs help with configuration.', 'new', 'urgent', 'b1eb441d-746d-420f-9600-48aa10f81a04', '8fed7298-cbca-4301-9fdd-8894ff4223a7', NULL, now() - interval '14 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('e404d26e-aa59-4496-8df8-34042a3f5faa', 'd577d59f-b25e-41dd-84e8-67569bf26259', NULL, 'Support Request 8', 'Client needs help with configuration.', 'in_progress', 'low', 'b1eb441d-746d-420f-9600-48aa10f81a04', 'b1eb441d-746d-420f-9600-48aa10f81a04', NULL, now() - interval '5 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('82233acc-7eaa-4037-b868-2f6f3fd1d927', '9cf2bdbd-eba1-4d69-88b1-b276dff0fc42', NULL, 'Support Request 9', 'Client needs help with configuration.', 'waiting', 'urgent', 'b1eb441d-746d-420f-9600-48aa10f81a04', '8fed7298-cbca-4301-9fdd-8894ff4223a7', NULL, now() - interval '9 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('43656bc0-fae7-4f01-9b23-446c95abd813', 'd5f6e3f8-3e39-4548-9f85-d19283880edd', NULL, 'Support Request 10', 'Client needs help with configuration.', 'new', 'low', 'b1eb441d-746d-420f-9600-48aa10f81a04', 'ff83ba29-7621-45a6-8a24-8e2f6f6268aa', NULL, now() - interval '10 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('839be35f-b840-445e-b320-7f64e3c08dab', '1b90c958-0a34-4723-b086-2bb93fdad45c', NULL, 'Support Request 11', 'Client needs help with configuration.', 'new', 'high', 'b1eb441d-746d-420f-9600-48aa10f81a04', '8fed7298-cbca-4301-9fdd-8894ff4223a7', NULL, now() - interval '14 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('010944c7-bba4-43e3-aede-5ded9b6375d6', 'da125edb-a8e1-40b3-ac9d-497a4328418c', '773b031c-e004-47e5-ae80-7fdcc5d9c6fe', 'Support Request 12', 'Client needs help with configuration.', 'in_progress', 'medium', 'b1eb441d-746d-420f-9600-48aa10f81a04', 'ff83ba29-7621-45a6-8a24-8e2f6f6268aa', NULL, now() - interval '12 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('5eb49ffe-f87e-4d00-94ad-b66f30e02c35', '1b90c958-0a34-4723-b086-2bb93fdad45c', NULL, 'Support Request 13', 'Client needs help with configuration.', 'in_progress', 'medium', 'b1eb441d-746d-420f-9600-48aa10f81a04', 'b1eb441d-746d-420f-9600-48aa10f81a04', NULL, now() - interval '7 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('d502d520-87f1-4aad-9885-59f8adbd426d', '9cf2bdbd-eba1-4d69-88b1-b276dff0fc42', NULL, 'Support Request 14', 'Client needs help with configuration.', 'resolved', 'low', 'b1eb441d-746d-420f-9600-48aa10f81a04', 'ff83ba29-7621-45a6-8a24-8e2f6f6268aa', now() - interval '2 days', now() - interval '9 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('79a88712-4d43-4a1e-8afe-c79241291dcc', '9cf2bdbd-eba1-4d69-88b1-b276dff0fc42', NULL, 'Support Request 15', 'Client needs help with configuration.', 'in_progress', 'medium', 'b1eb441d-746d-420f-9600-48aa10f81a04', '8fed7298-cbca-4301-9fdd-8894ff4223a7', NULL, now() - interval '9 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('20e98323-3bc3-4ffe-8486-f28b9bee7f23', 'e05b53b0-f808-4748-bf8e-e64c90e8b2de', 'd8deede8-decd-4803-ac61-d2a524aa503c', 'Support Request 16', 'Client needs help with configuration.', 'in_progress', 'medium', 'b1eb441d-746d-420f-9600-48aa10f81a04', '8fed7298-cbca-4301-9fdd-8894ff4223a7', NULL, now() - interval '6 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('aa261c59-ac66-45c5-be74-9bb28079b936', '6bba8827-7f63-4262-b2c5-716ccafa6f4d', NULL, 'Support Request 17', 'Client needs help with configuration.', 'new', 'urgent', 'b1eb441d-746d-420f-9600-48aa10f81a04', '8fed7298-cbca-4301-9fdd-8894ff4223a7', NULL, now() - interval '6 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('5eb166d5-a340-4286-bd92-c318083d44ea', '1b90c958-0a34-4723-b086-2bb93fdad45c', '1358fcde-fe7d-4e03-8ada-3f0921a13ab6', 'Support Request 18', 'Client needs help with configuration.', 'resolved', 'low', 'b1eb441d-746d-420f-9600-48aa10f81a04', 'b1eb441d-746d-420f-9600-48aa10f81a04', now() - interval '4 days', now() - interval '6 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('3a3b2eac-be96-4932-984b-e8c8a96c1fae', 'de9aaa36-ad18-4ce5-9ce5-2df3dde4430a', 'd032f711-1e7a-47ff-99a7-f3b0d449b65f', 'Support Request 19', 'Client needs help with configuration.', 'in_progress', 'medium', 'b1eb441d-746d-420f-9600-48aa10f81a04', 'ff83ba29-7621-45a6-8a24-8e2f6f6268aa', NULL, now() - interval '2 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('0f8c7332-1b13-40db-a698-0e5b5e65299d', 'b079540a-d0d7-48a3-a430-9303df6f9599', '5a79d23e-ca36-47e1-8936-6099ac587fe9', 'Support Request 20', 'Client needs help with configuration.', 'new', 'urgent', 'b1eb441d-746d-420f-9600-48aa10f81a04', 'ff83ba29-7621-45a6-8a24-8e2f6f6268aa', NULL, now() - interval '12 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('db3bfc94-6f5f-4fb9-aa23-6cd31d0395cb', 'da125edb-a8e1-40b3-ac9d-497a4328418c', NULL, 'Support Request 21', 'Client needs help with configuration.', 'waiting', 'low', 'b1eb441d-746d-420f-9600-48aa10f81a04', 'b1eb441d-746d-420f-9600-48aa10f81a04', NULL, now() - interval '8 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('dc4d6faa-51a4-4866-b4af-b8947502cedd', '2bd9e247-43c8-4670-8045-725e62b38e95', 'ffa4cadf-84c6-4a68-8ac0-70265ad4edde', 'Support Request 22', 'Client needs help with configuration.', 'new', 'high', 'b1eb441d-746d-420f-9600-48aa10f81a04', 'ff83ba29-7621-45a6-8a24-8e2f6f6268aa', NULL, now() - interval '1 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('2b86dbba-ef66-4aa3-9e28-3659b971b60f', 'e05b53b0-f808-4748-bf8e-e64c90e8b2de', '7bead47e-82a1-4d7f-9747-28e3e33dfc1d', 'Support Request 23', 'Client needs help with configuration.', 'waiting', 'low', 'b1eb441d-746d-420f-9600-48aa10f81a04', 'ff83ba29-7621-45a6-8a24-8e2f6f6268aa', NULL, now() - interval '5 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('ab5cde82-9b55-4fde-95a0-3570aedf21f8', '9c1687aa-8f53-4eed-b80f-2d3e848a8947', NULL, 'Support Request 24', 'Client needs help with configuration.', 'waiting', 'urgent', 'b1eb441d-746d-420f-9600-48aa10f81a04', 'b1eb441d-746d-420f-9600-48aa10f81a04', NULL, now() - interval '6 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('aa00953b-87a4-4b3b-b1fc-4300180dc858', 'a53577e1-3aba-4d13-a7fd-fb4e5b41bfa0', NULL, 'Support Request 25', 'Client needs help with configuration.', 'in_progress', 'high', 'b1eb441d-746d-420f-9600-48aa10f81a04', 'ff83ba29-7621-45a6-8a24-8e2f6f6268aa', NULL, now() - interval '13 days') ON CONFLICT (id) DO NOTHING;
