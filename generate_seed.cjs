const fs = require('fs');
const crypto = require('crypto');

function genUUID() {
    return crypto.randomUUID();
}

function randInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
}

function randElement(arr) {
    return arr[randInt(0, arr.length - 1)];
}

const users = [
    { id: genUUID(), email: 'alice.sales@example.com', name: 'Alice Smith', job: 'Sales Manager' },
    { id: genUUID(), email: 'bob.account@example.com', name: 'Bob Johnson', job: 'Account Manager' },
    { id: genUUID(), email: 'charlie.tech@example.com', name: 'Charlie Davis', job: 'Lead Developer' }
];

const industries = ['Technology', 'Healthcare', 'Finance', 'Retail', 'Real Estate', 'Logistics', 'Education'];
const leadSources = ['Website', 'Referral', 'Cold Call', 'Social Media', 'Trade Show'];
const leadStages = ['cold', 'warm', 'hot', 'proposal', 'negotiation', 'converted', 'lost'];
const lossReasons = ['Budget', 'Competitor', 'No Response', 'Timing', 'Not a Good Fit'];

const servicesData = [
    { id: genUUID(), name: 'KIBO', parent: null },
    { id: genUUID(), name: 'AI Sales App', parent: null },
    { id: genUUID(), name: 'Website Development', parent: null },
    { id: genUUID(), name: 'Hosting', parent: null },
    { id: genUUID(), name: 'SEO', parent: null },
    { id: genUUID(), name: 'Meta Ads Management', parent: null },
    { id: genUUID(), name: 'Google Ads Management', parent: null },
    { id: genUUID(), name: 'Broadcast Messaging', parent: null },
];

const companies = [
    'Acme Corp', 'Globex Corporation', 'Soylent Corp', 'Initech', 'Umbrella Corporation', 
    'Stark Industries', 'Wayne Enterprises', 'Cyberdyne Systems', 'Massive Dynamic', 
    'Genco Pura Olive Oil', 'LexCorp', 'Oceanic Airlines', 'Wonka Industries', 'Oscorp', 
    'Hooli', 'Pied Piper', 'Dunder Mifflin', 'Aperture Science', 'Veidt Enterprises', 
    'Gringotts', 'Ollivanders', 'Virtucon', 'MomCorp', 'Slurm', 'Nuka-Cola'
];

let sql = `
-- ==========================================
-- DEMO SEED DATA FOR SOLV CRM & ERP
-- ==========================================
-- WARNING: This script assumes tables are empty or will insert ignoring conflicts.

-- 1. Create Users
-- We insert into auth.users directly. Note: these users cannot log in.
`;

users.forEach(u => {
    sql += `INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at) 
VALUES ('${u.id}', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', '${u.email}', '', now(), now(), now())
ON CONFLICT (id) DO NOTHING;\n`;
    
    // We update/insert into profiles
    sql += `INSERT INTO public.profiles (id, full_name, email, job_title, created_at, updated_at) 
VALUES ('${u.id}', '${u.name}', '${u.email}', '${u.job}', now(), now())
ON CONFLICT (id) DO UPDATE SET full_name = EXCLUDED.full_name, job_title = EXCLUDED.job_title;\n`;
});

sql += `\n-- 2. Services\n`;
servicesData.forEach(s => {
    sql += `INSERT INTO public.services (id, name, created_at, updated_at) VALUES ('${s.id}', '${s.name}', now(), now()) ON CONFLICT DO NOTHING;\n`;
});

const customers = [];
sql += `\n-- 3. Customers, Sales & Customer Services\n`;
for (let i = 0; i < 15; i++) {
    const cId = genUUID();
    const cName = companies[i];
    const am = randElement(users).id;
    customers.push({ id: cId, name: cName });
    
    sql += `INSERT INTO public.customers (id, name, contact_email, industry, account_manager_id, status, created_at) 
VALUES ('${cId}', '${cName}', 'contact@${cName.replace(/\\s+/g, '').toLowerCase()}.com', '${randElement(industries)}', '${am}', 'active', now() - interval '${randInt(10, 100)} days') ON CONFLICT (id) DO NOTHING;\n`;

    // 1-3 services per customer
    const srvCount = randInt(1, 3);
    const assignedServices = new Set();
    for(let j=0; j<srvCount; j++) {
        assignedServices.add(randElement(servicesData));
    }

    assignedServices.forEach(srv => {
        const isRetainer = Math.random() > 0.5;
        const val = isRetainer ? randInt(200, 1500) : randInt(1000, 10000);
        const billType = isRetainer ? 'retainer' : 'one-off';
        
        sql += `INSERT INTO public.sales (customer_id, service_id, description, billing_type, value, status, start_date, created_at) 
VALUES ('${cId}', '${srv.id}', '${srv.name}', '${billType}', ${val}, 'active', current_date, now() - interval '${randInt(1, 30)} days');\n`;

        sql += `INSERT INTO public.customer_services (customer_id, service_id, status, start_date, created_at) 
VALUES ('${cId}', '${srv.id}', 'active', current_date, now());\n`;
    });
}

sql += `\n-- 4. Leads & Lead Services\n`;
for (let i = 15; i < 40; i++) {
    const lId = genUUID();
    const isExisting = Math.random() > 0.8;
    const cName = isExisting ? randElement(customers).name : companies[i % companies.length] + ' (Lead)';
    const stage = randElement(leadStages);
    const sp = randElement(users).id;
    
    let convertedAt = 'NULL';
    let lostAt = 'NULL';
    let lossReason = 'NULL';
    if (stage === 'converted') convertedAt = `now() - interval '${randInt(1, 10)} days'`;
    if (stage === 'lost') {
        lostAt = `now() - interval '${randInt(1, 10)} days'`;
        lossReason = `'${randElement(lossReasons)}'`;
    }

    sql += `INSERT INTO public.leads (id, name, company, email, stage, value, source, assigned_to, converted_at, lost_at, loss_reason, created_at) 
VALUES ('${lId}', 'Contact ${i}', '${cName}', 'contact${i}@example.com', '${stage}', ${randInt(500, 5000)}, '${randElement(leadSources)}', '${sp}', ${convertedAt}, ${lostAt}, ${lossReason}, now() - interval '${randInt(11, 40)} days') ON CONFLICT (id) DO NOTHING;\n`;

    const srvCount = randInt(1, 3);
    const assignedServices = new Set();
    for(let j=0; j<srvCount; j++) {
        assignedServices.add(randElement(servicesData));
    }
    assignedServices.forEach(srv => {
        sql += `INSERT INTO public.lead_services (lead_id, service_id) VALUES ('${lId}', '${srv.id}') ON CONFLICT DO NOTHING;\n`;
    });
}

sql += `\n-- 5. Projects\n`;
const projects = [];
const projStatuses = ['planning', 'in_progress', 'testing', 'completed'];
for (let i = 0; i < 15; i++) {
    const pId = genUUID();
    const cId = randElement(customers).id;
    const stat = randElement(projStatuses);
    projects.push(pId);

    sql += `INSERT INTO public.projects (id, customer_id, name, status, deadline, created_at) 
VALUES ('${pId}', '${cId}', 'Implementation Project ${i+1}', '${stat}', current_date + interval '${randInt(5, 30)} days', now() - interval '${randInt(1, 20)} days') ON CONFLICT (id) DO NOTHING;\n`;

    sql += `INSERT INTO public.project_members (project_id, user_id) VALUES ('${pId}', '${randElement(users).id}') ON CONFLICT DO NOTHING;\n`;
}

sql += `\n-- 6. Tickets\n`;
const ticketStatuses = ['new', 'in_progress', 'waiting', 'resolved'];
const priorities = ['low', 'medium', 'high', 'urgent'];
for (let i = 0; i < 25; i++) {
    const tId = genUUID();
    const cId = randElement(customers).id;
    const pId = Math.random() > 0.5 ? `'${randElement(projects)}'` : 'NULL';
    const stat = randElement(ticketStatuses);
    
    let resolvedAt = 'NULL';
    if (stat === 'resolved') resolvedAt = `now() - interval '${randInt(1, 5)} days'`;

    sql += `INSERT INTO public.tickets (id, customer_id, project_id, title, description, status, priority, created_by, assigned_to, resolved_at, created_at) 
VALUES ('${tId}', '${cId}', ${pId}, 'Support Request ${i+1}', 'Client needs help with configuration.', '${stat}', '${randElement(priorities)}', '${users[0].id}', '${randElement(users).id}', ${resolvedAt}, now() - interval '${randInt(1, 15)} days') ON CONFLICT (id) DO NOTHING;\n`;
}

fs.writeFileSync('supabase/demo_seed.sql', sql);
console.log("demo_seed.sql generated");
