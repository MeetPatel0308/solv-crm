# solv. — Build Plan

A single-tenant ERP/CRM with Dashboard, CRM, Projects, Tickets, Reports, HR, and Settings. Minimal Linear/Notion-style UI, black sidebar, green accent.

## Phase 1 — Foundation

- Enable Lovable Cloud (Postgres + Auth + Storage).
- Design system: update `src/styles.css` — white surfaces, black sidebar token, green (#22C55E) primary accent, soft shadows, rounded cards, modern sans-serif.
- App shell: `_authenticated` layout with black `Sidebar` (Dashboard, CRM, Projects, Tickets, Reports, HR, Settings), top bar (search, notifications, profile, green "Create New" menu).
- Auth: `/auth` (email/password + Google) and `/reset-password`. Managed `_authenticated/route.tsx` gate.

## Phase 2 — Database & RBAC

Tables (UUID PK, `created_at`, `updated_at`, `deleted_at`):
`profiles`, `user_roles` (enum: admin|sales|project_manager|support|hr), `customers`, `leads`, `projects`, `project_members`, `tickets`, `ticket_comments`, `ticket_attachments`, `services` (self-ref `parent_id`), `customer_services`, `customer_timeline_events`, `project_timeline_events`, `activities`, `notifications`.

- `has_role()` SECURITY DEFINER function.
- RLS policies enforcing the permission matrix (Admin = full; Sales = CRM full + own tickets read; PM = Projects full + related tickets; Support = Tickets full + read customers/projects; HR = HR only).
- Trigger: auto-create `profiles` row on signup; first user → admin.
- Storage bucket `ticket-attachments` (private) with RLS; signed URLs on read.

## Phase 3 — Modules

1. **Dashboard** — KPI cards, pipeline summary, leads chart (Recharts), open tickets table, upcoming events, notifications. Widgets filtered by role.
2. **CRM** — Customer list (search/filter/sort/pagination), Customer profile (timeline, assigned team, active services, KPIs). Leads sub-view.
3. **Projects** — List + KPIs, donut by status (Recharts), Project detail (horizontal timeline, tickets table, team).
4. **Tickets** — Table, detail with comments, attachments (upload to Supabase Storage folder `tickets/{id}/`, metadata row, signed URL download), activity history.
5. **Reports** — Role-scoped: conversion, sales by user, avg time to convert, ticket counts, project status distribution. Filters.
6. **HR / Team** — Employees, roles, workload (ticket + project counts), leave status.
7. **Settings** — Services catalog CRUD (tree with sub-products), user role management.

## Phase 4 — Cross-cutting

- Global "Create New" modal (Customer, Project, Lead, Ticket).
- Global search (Cmd-K) across role-permitted entities.
- Notifications: DB triggers insert into `notifications`; bell dropdown in top bar.
- Activity audit trail via triggers on key tables.
- Loading, empty, and error states everywhere; Zod form validation.

## Technical Notes

- TanStack Start + Query, server functions with `requireSupabaseAuth` for all reads/writes.
- Recharts for the few charts.
- shadcn Sidebar, Table, Dialog, Command (search), DropdownMenu, Badge.
- Route structure: everything except `/auth` under `_authenticated/`.

## Scope Note

This is a large MVP; I'll ship Phase 1–2 plus Dashboard, CRM, Projects, Tickets, and Settings→Services in the first pass, then Reports and HR. Confirm and I'll start.
