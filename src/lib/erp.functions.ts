import { createServerFn } from "@tanstack/react-start";
import { requireSupabaseAuth } from "@/integrations/supabase/auth-middleware";
import { z } from "zod";

// ============ ROLES / PROFILE ============
export const getMyRoles = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { data: roles } = await context.supabase
      .from("user_roles")
      .select("role")
      .eq("user_id", context.userId);
    const { data: profile } = await context.supabase
      .from("profiles")
      .select("full_name,email")
      .eq("id", context.userId)
      .maybeSingle();
    return {
      roles: (roles ?? []).map((r) => r.role as string),
      email: profile?.email ?? "",
      fullName: profile?.full_name ?? "",
    };
  });

// ============ DASHBOARD ============
export const getDashboardStats = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const [customers, projects, tickets, leads] = await Promise.all([
      context.supabase
        .from("customers")
        .select("*", { count: "exact", head: true })
        .is("deleted_at", null),
      context.supabase
        .from("projects")
        .select("*", { count: "exact", head: true })
        .is("deleted_at", null)
        .neq("status", "completed"),
      context.supabase
        .from("tickets")
        .select("*", { count: "exact", head: true })
        .is("deleted_at", null)
        .not("status", "in", "(resolved,closed)"),
      context.supabase
        .from("leads")
        .select("*", { count: "exact", head: true })
        .is("deleted_at", null)
        .gte(
          "created_at",
          new Date(new Date().getFullYear(), new Date().getMonth(), 1).toISOString(),
        ),
    ]);
    const { data: pipeline } = await context.supabase
      .from("leads")
      .select("stage, created_at, converted_at")
      .is("deleted_at", null);
    const stages = ["cold", "warm", "hot", "converted"] as string[];
    const pipelineCounts = stages.map((s) => ({
      stage: s,
      count: (pipeline ?? []).filter((r) => (r.stage as string) === s).length,
    }));

    const convertedLeads = (pipeline ?? []).filter(l => l.stage === 'converted');
    const lostLeadsCount = (pipeline ?? []).filter(l => l.stage === 'lost').length;
    const convertedLeadsCount = convertedLeads.length;
    const totalLeads = (pipeline ?? []).length;
    
    const conversionRate = totalLeads > 0 ? Math.round((convertedLeadsCount / totalLeads) * 100) : 0;
    const lostRate = totalLeads > 0 ? Math.round((lostLeadsCount / totalLeads) * 100) : 0;
    
    let totalDaysToConvert = 0;
    let leadsWithValidDates = 0;
    convertedLeads.forEach(l => {
      if (l.created_at && l.converted_at) {
        const diffTime = Math.abs(new Date(l.converted_at).getTime() - new Date(l.created_at).getTime());
        const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
        totalDaysToConvert += diffDays;
        leadsWithValidDates++;
      }
    });
    const avgTimeToConvert = leadsWithValidDates > 0 ? Math.round(totalDaysToConvert / leadsWithValidDates) : 0;
    const { data: openTickets } = await context.supabase
      .from("tickets")
      .select(
        "id,ticket_code,title,priority,status,created_at,customer_id,project_id, customers(name), projects(name)",
      )
      .is("deleted_at", null)
      .not("status", "in", "(resolved,closed)")
      .order("created_at", { ascending: false })
      .limit(8);
    return {
      customersCount: customers.count ?? 0,
      projectsCount: projects.count ?? 0,
      ticketsCount: tickets.count ?? 0,
      leadsCount: leads.count ?? 0,
      pipelineCounts,
      openTickets: openTickets ?? [],
      leadPerformance: {
        conversionRate,
        lostRate,
        avgTimeToConvert,
        newLeadsThisMonth: leads.count ?? 0,
      }
    };
  });

export const getLeadsSeries = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { data } = await context.supabase
      .from("leads")
      .select("created_at,value,stage")
      .is("deleted_at", null)
      .order("created_at");
    const byDay: Record<string, { date: string; count: number; value: number }> = {};
    (data ?? []).forEach((l) => {
      const d = new Date(l.created_at).toISOString().slice(0, 10);
      byDay[d] = byDay[d] ?? { date: d, count: 0, value: 0 };
      byDay[d].count += 1;
      byDay[d].value += Number(l.value ?? 0);
    });
    const series = Object.values(byDay).slice(-30);
    const total = (data ?? []).length;
    const won = (data ?? []).filter((l) => (l.stage as string) === "converted").length;
    const totalValue = (data ?? []).reduce((s, l) => s + Number(l.value ?? 0), 0);
    return { series, totalValue, conversionRate: total ? Math.round((won / total) * 100) : 0 };
  });

// ============ CUSTOMERS ============
export const listCustomers = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { data } = await context.supabase
      .from("customers")
      .select(
        "id,name,industry,status,last_contact_at,estimated_value,account_manager_id, account_manager:profiles!account_manager_id(full_name), sales(value)",
      )
      .is("deleted_at", null)
      .order("created_at", { ascending: false });
    return data ?? [];
  });

export const getCustomer = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: { id: string }) => z.object({ id: z.string().uuid() }).parse(d))
  .handler(async ({ data, context }) => {
    const { data: customer } = await context.supabase
      .from("customers")
      .select("*, account_manager:profiles!account_manager_id(full_name,email)")
      .eq("id", data.id)
      .maybeSingle();
    if (!customer) throw new Error("Customer not found");
    const [{ data: services }, { data: openTickets }, { data: allTickets }, { data: projects }, { data: sales }] = await Promise.all([
      context.supabase
        .from("customer_services")
        .select("*, services(name,parent_id)")
        .eq("customer_id", data.id),
      context.supabase
        .from("tickets")
        .select("id,ticket_code,title,priority,status")
        .eq("customer_id", data.id)
        .is("deleted_at", null)
        .not("status", "in", "(resolved,closed)"),
      context.supabase
        .from("tickets")
        .select("id,title,created_at,resolved_at")
        .eq("customer_id", data.id)
        .is("deleted_at", null),
      context.supabase
        .from("projects")
        .select("id,name,created_at")
        .eq("customer_id", data.id)
        .is("deleted_at", null),
      context.supabase
        .from("sales")
        .select("*")
        .eq("customer_id", data.id)
        .order("created_at", { ascending: false }),
      context.supabase
        .from("leads")
        .select("id, converted_at")
        .eq("customer_id", data.id)
        .order("converted_at", { ascending: false }),
    ]);

    const synthesizedTimeline: any[] = [];
    
    if (customer.created_at) {
      synthesizedTimeline.push({
        id: `created-${customer.id}`,
        stage: "Customer Created",
        description: "Customer profile was created",
        event_at: customer.created_at,
        assignee: null
      });
    }
    const { data: allCustomerLeads } = await context.supabase
      .from("leads")
      .select("id, name, converted_at, deleted_at, stage, is_conversion_finalized")
      .eq("customer_id", data.id);
      
    // Safely find the converted lead in JS to avoid any PostgREST enum/boolean OR syntax issues
    const convertedLead = (allCustomerLeads || [])
      .filter(l => l.stage === "converted" || l.is_conversion_finalized)
      .sort((a, b) => {
        if (!a.converted_at) return 1;
        if (!b.converted_at) return -1;
        return new Date(b.converted_at).getTime() - new Date(a.converted_at).getTime();
      })[0];

    let hasInitialSale = false;


    if (projects) {
      projects.forEach(p => {
        synthesizedTimeline.push({
          id: `proj-${p.id}`,
          stage: "Project Created",
          description: p.name,
          event_at: p.created_at,
          assignee: null,
          link: { type: "project", id: p.id, active: true }
        });
      });
    }

    if (allTickets) {
      allTickets.forEach(t => {
        synthesizedTimeline.push({
          id: `ticket-created-${t.id}`,
          stage: "Ticket Created",
          description: t.title,
          event_at: t.created_at,
          assignee: null,
          link: { type: "ticket", id: t.id, active: true }
        });
        if (t.resolved_at) {
          synthesizedTimeline.push({
            id: `ticket-resolved-${t.id}`,
            stage: "Ticket Resolved",
            description: t.title,
            event_at: t.resolved_at,
            assignee: null,
            link: { type: "ticket", id: t.id, active: true }
          });
        }
      });
    }

    if (sales) {
      sales.forEach(s => {
        const isInitialSale = s.description === "Sale added from lead" || s.description === "Converted from lead";
        if (isInitialSale) hasInitialSale = true;
        
        let stage = "Service Added";
        let description = `${s.description} added as a ${s.billing_type === 'retainer' ? 'Retainer' : 'One-Off Service'} ($${s.value}${s.billing_type === 'retainer' ? '/month' : ''})`;
        let link = undefined;

        if (isInitialSale && convertedLead) {
          stage = s.description === "Sale added from lead" ? "Initial sale created from Lead" : "Converted from Lead";
          description = convertedLead.name;
          link = { type: "lead", id: convertedLead.id, active: convertedLead.deleted_at == null };
        } else if (isInitialSale && !convertedLead) {
          description = "Converted from an archived lead";
        }

        synthesizedTimeline.push({
          id: `sale-${s.id}`,
          stage,
          description,
          event_at: s.created_at,
          assignee: null,
          value: s.value,
          link
        });
      });
    }

    if (convertedLead?.converted_at && !hasInitialSale) {
      synthesizedTimeline.push({
        id: `converted-${customer.id}`,
        stage: "Converted from Lead",
        description: convertedLead.name,
        event_at: convertedLead.converted_at,
        assignee: null,
        link: { type: "lead", id: convertedLead.id, active: convertedLead.deleted_at == null }
      });
    }

    synthesizedTimeline.sort((a, b) => new Date(b.event_at).getTime() - new Date(a.event_at).getTime());

    return {
      customer,
      timeline: synthesizedTimeline,
      services: services ?? [],
      openTickets: openTickets ?? [],
      sales: sales ?? [],
      projects: projects ?? [],
    };
  });

export const createCustomer = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: { name: string; industry: string | null; contactEmail: string | null }) =>
    z
      .object({
        name: z.string().min(1),
        industry: z.string().nullable(),
        contactEmail: z.preprocess(
          (val) => (val === "" ? null : val),
          z.string().email().nullable(),
        ),
      })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const { data: row, error } = await context.supabase
      .from("customers")
      .insert({
        name: data.name,
        industry: data.industry,
        contact_email: data.contactEmail,
        created_by: context.userId,
      })
      .select("id")
      .single();
    if (error) throw new Error(error.message);
    return row;
  });

export const deleteCustomer = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: { id: string }) => z.object({ id: z.string().uuid() }).parse(d))
  .handler(async ({ data, context }) => {
    const { error } = await context.supabase
      .from("customers")
      .update({ deleted_at: new Date().toISOString() })
      .eq("id", data.id);
    if (error) throw new Error(error.message);
    return { ok: true };
  });

// ============ LEADS ============
export const listLeads = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { data } = await context.supabase
      .from("leads")
      .select("*, lead_services(id, service_id, services(id, name))")
      .is("deleted_at", null)
      .order("created_at", { ascending: false });
    return data ?? [];
  });

const leadStageEnum = z.enum(["lead_created", "cold", "warm", "hot", "proposal", "negotiation", "converted", "lost"]);
const leadSourceEnum = z.enum(["email", "ads", "referral"]);

export const createLead = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator(
    (d: {
      name: string;
      contact_name?: string | null;
      company: string | null;
      email: string | null;
      phone: string | null;
      value: number;
      stage: string;
      source: string;
      customer_id?: string | null;
      service_ids?: string[];
      assigned_to?: string | null;
      notes?: string | null;
    }) =>
      z
        .object({
          name: z.string().min(1),
          contact_name: z.string().nullable().optional(),
          company: z.string().nullable(),
          email: z.preprocess(
            (val) => {
              if (val == null || val === "") return null;
              const s = String(val).trim();
              return z.string().email().safeParse(s).success ? s : null;
            },
            z.string().email().nullable(),
          ),
          phone: z.string().nullable(),
          value: z.number().nonnegative(),
          stage: leadStageEnum,
          source: leadSourceEnum,
          customer_id: z.string().uuid().nullable().optional(),
          service_ids: z.array(z.string().uuid()).optional(),
          assigned_to: z.string().uuid().nullable().optional(),
          notes: z.string().nullable().optional(),
        })
        .parse(d),
  )
  .handler(async ({ data, context }) => {
    const finalCustomerId = data.customer_id; // Will be null for New Company

    const { data: row, error } = await context.supabase
      .from("leads")
      .insert({
        name: data.name,
        contact_name: data.contact_name,
        company: data.company,
        email: data.email,
        phone: data.phone,
        value: data.value,
        stage: data.stage as never,
        source: data.source as never,
        customer_id: finalCustomerId,
        created_by: context.userId,
        assigned_to: data.assigned_to,
        notes: data.notes,
        lead_created_at: data.stage === "lead_created" ? new Date().toISOString() : null,
        cold_at: data.stage === "cold" ? new Date().toISOString() : null,
        warm_at: data.stage === "warm" ? new Date().toISOString() : null,
        hot_at: data.stage === "hot" ? new Date().toISOString() : null,
        proposal_at: data.stage === "proposal" ? new Date().toISOString() : null,
        negotiation_at: data.stage === "negotiation" ? new Date().toISOString() : null,
        lost_at: data.stage === "lost" ? new Date().toISOString() : null,
        converted_at: data.stage === "converted" ? new Date().toISOString() : null,
      })
      .select("id")
      .single();
    if (error) throw new Error(error.message);

    // Save interested services to lead_services
    if (data.service_ids && data.service_ids.length > 0) {
      const { error: srvErr } = await context.supabase
        .from("lead_services")
        .insert(
          data.service_ids.map((id) => ({
            lead_id: row.id,
            service_id: id,
          }))
        );
      if (srvErr) throw new Error(srvErr.message);
    }
    return row;
  });

export const updateLead = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator(
    (d: {
      id: string;
      name: string;
      contact_name?: string | null;
      company: string | null;
      email: string | null;
      phone: string | null;
      stage: string;
      source: string;
      notes: string | null;
      customer_id?: string | null;
      service_ids?: string[];
    }) =>
      z
        .object({
          id: z.string().uuid(),
          name: z.string().min(1),
          contact_name: z.string().nullable().optional(),
          company: z.string().nullable(),
          email: z.preprocess((val) => (val === "" ? null : val), z.string().email().nullable()),
          phone: z.string().nullable(),
          value: z.number().nonnegative(),
          stage: leadStageEnum,
          source: leadSourceEnum,
          notes: z.string().nullable(),
          customer_id: z.string().uuid().nullable().optional(),
          service_ids: z.array(z.string().uuid()).optional(),
        })
        .parse(d),
  )
  .handler(async ({ data, context }) => {
    const { data: existing } = await context.supabase
      .from("leads")
      .select("stage,lead_created_at,cold_at,warm_at,hot_at,proposal_at,negotiation_at,lost_at,converted_at")
      .eq("id", data.id)
      .maybeSingle();

    const isNewStage = (stage: string) => data.stage === stage && existing?.stage !== stage;
    const now = new Date().toISOString();

    const { error } = await context.supabase
      .from("leads")
      .update({
        name: data.name,
        contact_name: data.contact_name,
        company: data.company,
        email: data.email,
        phone: data.phone,
        value: data.value,
        stage: data.stage as never,
        source: data.source as never,
        notes: data.notes,
        ...(data.customer_id !== undefined ? { customer_id: data.customer_id } : {}),
        lead_created_at: isNewStage("lead_created") ? now : existing?.lead_created_at,
        cold_at: isNewStage("cold") ? now : existing?.cold_at,
        warm_at: isNewStage("warm") ? now : existing?.warm_at,
        hot_at: isNewStage("hot") ? now : existing?.hot_at,
        proposal_at: isNewStage("proposal") ? now : existing?.proposal_at,
        negotiation_at: isNewStage("negotiation") ? now : existing?.negotiation_at,
        lost_at: isNewStage("lost") ? now : existing?.lost_at,
        converted_at: isNewStage("converted") ? now : existing?.converted_at,
      })
      .eq("id", data.id);
    if (error) throw new Error(error.message);

    if (data.service_ids) {
      await context.supabase.from("lead_services").delete().eq("lead_id", data.id);
      if (data.service_ids.length > 0) {
        const { error: srvErr } = await context.supabase
          .from("lead_services")
          .insert(
            data.service_ids.map((id) => ({
              lead_id: data.id,
              service_id: id,
            }))
          );
        if (srvErr) throw new Error(srvErr.message);
      }
    }

    return { ok: true };
  });

export const updateLeadDates = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: { 
    id: string; 
    lead_created_at?: string | null;
    cold_at?: string | null; 
    warm_at?: string | null; 
    hot_at?: string | null; 
    proposal_at?: string | null;
    negotiation_at?: string | null;
    converted_at?: string | null; 
    lost_at?: string | null; 
    stage?: string;
  }) => {
    const dateValue = z.preprocess(
      (value) => (value === "" ? null : value),
      z
        .string()
        .nullable()
        .refine((value) => {
          if (value === null) return true;
          const date = new Date(value);
          const year = date.getUTCFullYear();
          return !Number.isNaN(date.getTime()) && year >= 1900 && year <= 2999;
        }, "Enter a valid date between 1900 and 2999"),
    );

    return z.object({
      id: z.string().uuid(),
      lead_created_at: dateValue.optional(),
      cold_at: dateValue.optional(),
      warm_at: dateValue.optional(),
      hot_at: dateValue.optional(),
      proposal_at: dateValue.optional(),
      negotiation_at: dateValue.optional(),
      converted_at: dateValue.optional(),
      lost_at: dateValue.optional(),
      stage: z.string().optional(),
    }).parse(d);
  })
  .handler(async ({ data, context }) => {
    const { id, ...dates } = data;
    const { error } = await context.supabase
      .from("leads")
      .update(dates as any)
      .eq("id", id);
    if (error) throw new Error(error.message);
    return { ok: true };
  });

export const deleteLead = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: { id: string }) => z.object({ id: z.string().uuid() }).parse(d))
  .handler(async ({ data, context }) => {
    const { error } = await context.supabase
      .from("leads")
      .update({ deleted_at: new Date().toISOString() })
      .eq("id", data.id);
    if (error) throw new Error(error.message);
    return { ok: true };
  });

export const getLead = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: { id: string }) => z.object({ id: z.string().uuid() }).parse(d))
  .handler(async ({ data, context }) => {
    const { data: lead } = await context.supabase
      .from("leads")
      .select("*, assigned_member:profiles!leads_assigned_to_fkey(full_name,email), customer:customers(id, name, status)")
      .eq("id", data.id)
      .maybeSingle();
    if (!lead) throw new Error("Lead not found");

    // Fetch interested services for this lead
    const { data: srvs } = await context.supabase
      .from("lead_services")
      .select("*, services(name,parent_id)")
      .eq("lead_id", data.id);
    const services = srvs ?? [];
    
    return { lead, services };
  });

export const markLeadAsLost = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: { id: string; reason: string; notes?: string }) => z.object({
    id: z.string().uuid(),
    reason: z.string().min(1),
    notes: z.string().optional()
  }).parse(d))
  .handler(async ({ data, context }) => {
    const { data: lead } = await context.supabase.from("leads").select("notes").eq("id", data.id).single();
    let updatedNotes = lead?.notes || "";
    if (data.notes) {
      updatedNotes = updatedNotes ? `${updatedNotes}\n\n[Lost]: ${data.notes}` : `[Lost]: ${data.notes}`;
    }

    const { error } = await context.supabase
      .from("leads")
      .update({ 
        stage: "lost", 
        lost_at: new Date().toISOString(),
        loss_reason: data.reason,
        notes: updatedNotes
      })
      .eq("id", data.id);
    if (error) throw new Error(error.message);
    return { ok: true };
  });

export const reopenLead = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: { id: string }) => z.object({ id: z.string().uuid() }).parse(d))
  .handler(async ({ data, context }) => {
    const { error } = await context.supabase
      .from("leads")
      .update({ 
        stage: "cold",
        lost_at: null,
        loss_reason: null
      } as any)
      .eq("id", data.id);
    if (error) throw new Error(error.message);
    return { ok: true };
  });

export const convertLeadToCustomer = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: {
    leadId: string;
    salesData: { service_id: string; billing_type: string; value: number }[];
  }) => z.object({
    leadId: z.string().uuid(),
    salesData: z.array(z.object({
      service_id: z.string().uuid(),
      billing_type: z.string(),
      value: z.number().nonnegative(),
    })),
  }).parse(d))
  .handler(async ({ data, context }) => {
    const { data: lead } = await context.supabase
      .from("leads")
      .select("*")
      .eq("id", data.leadId)
      .single();
    if (!lead) throw new Error("Lead not found");

    let finalCustomerId = lead.customer_id;

    if (!finalCustomerId) {
      // New Company -> Create Customer Profile
      const { data: newCustomer, error: cErr } = await context.supabase
        .from("customers")
        .insert({
          name: lead.company || "Unknown Company",
          contact_name: lead.contact_name,
          status: "active",
          contact_email: lead.email,
          contact_phone: lead.phone,
          estimated_value: lead.value,
          account_manager_id: lead.assigned_to || context.userId,
        })
        .select("id")
        .single();
      if (cErr) throw new Error(cErr.message);
      finalCustomerId = newCustomer.id;

      // Link lead to new customer and mark finalized
      const { error: updErr1 } = await context.supabase.from("leads").update({
        customer_id: finalCustomerId,
        is_conversion_finalized: true,
        stage: "converted",
        converted_at: new Date().toISOString()
      } as any).eq("id", lead.id);
      if (updErr1) throw new Error("Failed to update lead: " + updErr1.message);
    } else {
      // Existing Customer -> Update Status/Value and mark finalized
      const { error: updErr2 } = await context.supabase.from("leads").update({
        is_conversion_finalized: true,
        stage: "converted",
        converted_at: new Date().toISOString()
      } as any).eq("id", lead.id);
      if (updErr2) throw new Error("Failed to update lead: " + updErr2.message);

      const { error: cUpdErr } = await context.supabase.from("customers").update({
        status: "active",
        estimated_value: (lead.value || 0), // Ideally we'd add to existing, but this suffices for now
      }).eq("id", finalCustomerId);
      if (cUpdErr) throw new Error("Failed to update customer: " + cUpdErr.message);
    }

    // Create Sales and Customer Services records for the finalized services
    if (data.salesData.length > 0) {
      const salesToInsert = data.salesData.map((s) => ({
        customer_id: finalCustomerId!,
        service_id: s.service_id,
        billing_type: s.billing_type,
        value: s.value,
        status: "active",
        start_date: new Date().toISOString().split("T")[0],
        description: lead.customer_id ? "Sale added from lead" : "Converted from lead",
      }));
      await context.supabase.from("sales").insert(salesToInsert);

      // Add to customer_services
      const servicesToInsert = data.salesData.map((s) => ({
        customer_id: finalCustomerId!,
        service_id: s.service_id,
        status: "active",
        start_date: new Date().toISOString().split("T")[0],
      }));
      await context.supabase.from("customer_services").insert(servicesToInsert);
    }

    return { ok: true, customerId: finalCustomerId };
  });

// ============ PROJECTS ============
export const listProjects = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { data } = await context.supabase
      .from("projects")
      .select(
        "id,name,status,progress,deadline, customers(name), project_manager:profiles!project_manager_id(full_name)",
      )
      .is("deleted_at", null)
      .order("created_at", { ascending: false });
    return data ?? [];
  });

export const getProject = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: { id: string }) => z.object({ id: z.string().uuid() }).parse(d))
  .handler(async ({ data, context }) => {
    const { data: project } = await context.supabase
      .from("projects")
      .select("*, customers(name), project_manager:profiles!project_manager_id(full_name)")
      .eq("id", data.id)
      .maybeSingle();
    if (!project) throw new Error("Project not found");
    const [{ data: tickets }, { data: timeline }, { data: members }] = await Promise.all([
      context.supabase
        .from("tickets")
        .select("id,ticket_code,title,priority,status,assigned_to,created_at")
        .eq("project_id", data.id)
        .is("deleted_at", null),
      context.supabase
        .from("project_timeline_events")
        .select("*, completed_by_profile:profiles!completed_by(full_name)")
        .eq("project_id", data.id)
        .order("event_at"),
      context.supabase
        .from("project_members")
        .select("*, user_profile:profiles!user_id(full_name,email)")
        .eq("project_id", data.id),
    ]);
    return { project, tickets: tickets ?? [], timeline: timeline ?? [], members: members ?? [] };
  });

export const createProject = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: { name: string; description: string | null; deadline: string | null; customer_id?: string | null; project_manager_id?: string | null }) =>
    z
      .object({
        name: z.string().min(1),
        description: z.string().nullable(),
        deadline: z.string().nullable(),
        customer_id: z.string().uuid().nullable().optional(),
        project_manager_id: z.string().uuid().nullable().optional(),
      })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const { data: row, error } = await context.supabase
      .from("projects")
      .insert({
        name: data.name,
        description: data.description,
        deadline: data.deadline,
        customer_id: data.customer_id || null,
        created_by: context.userId,
        project_manager_id: data.project_manager_id || context.userId,
      })
      .select("id")
      .single();
    if (error) throw new Error(error.message);
    return row;
  });

export const deleteProject = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: { id: string }) => z.object({ id: z.string().uuid() }).parse(d))
  .handler(async ({ data, context }) => {
    const { error } = await context.supabase
      .from("projects")
      .update({ deleted_at: new Date().toISOString() })
      .eq("id", data.id);
    if (error) throw new Error(error.message);
    return { ok: true };
  });

// ============ TICKETS ============
export const listTickets = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { data } = await context.supabase
      .from("tickets")
      .select(
        "id,ticket_code,title,priority,status,created_at, customers(name), projects(name), assignee:profiles!assigned_to(full_name)",
      )
      .is("deleted_at", null)
      .order("created_at", { ascending: false });
    return data ?? [];
  });

export const getTicket = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: { id: string }) => z.object({ id: z.string().uuid() }).parse(d))
  .handler(async ({ data, context }) => {
    const { data: ticket } = await context.supabase
      .from("tickets")
      .select("*, customers(name), projects(name), assignee:profiles!assigned_to(full_name,email)")
      .eq("id", data.id)
      .maybeSingle();
    if (!ticket) throw new Error("Ticket not found");
    const [{ data: comments }, { data: attachments }] = await Promise.all([
      context.supabase
        .from("ticket_comments")
        .select("*, author:profiles!author_id(full_name)")
        .eq("ticket_id", data.id)
        .order("created_at"),
      context.supabase
        .from("ticket_attachments")
        .select("*")
        .eq("ticket_id", data.id)
        .order("uploaded_at", { ascending: false }),
    ]);
    // Signed URLs
    const signed = await Promise.all(
      (attachments ?? []).map(async (a) => {
        const { data: s } = await context.supabase.storage
          .from("ticket-attachments")
          .createSignedUrl(a.storage_path, 60 * 30);
        return { ...a, signed_url: s?.signedUrl ?? null };
      }),
    );
    return { ticket, comments: comments ?? [], attachments: signed };
  });

export const createTicket = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator(
    (d: {
      title: string;
      description: string | null;
      priority: string;
      customerId: string | null;
      projectId: string | null;
      startDate: string | null;
      endDate: string | null;
    }) =>
      z
        .object({
          title: z.string().min(1),
          description: z.string().nullable(),
          priority: z.enum(["low", "medium", "high", "urgent"]),
          customerId: z.string().uuid().nullable(),
          projectId: z.string().uuid().nullable(),
          startDate: z.string().nullable(),
          endDate: z.string().nullable(),
        })
        .parse(d),
  )
  .handler(async ({ data, context }) => {
    const { data: row, error } = await context.supabase
      .from("tickets")
      .insert({
        title: data.title,
        description: data.description,
        priority: data.priority as never,
        customer_id: data.customerId,
        project_id: data.projectId,
        start_date: data.startDate,
        end_date: data.endDate,
        due_date: data.endDate,
        created_by: context.userId,
      })
      .select("id")
      .single();
    if (error) throw new Error(error.message);
    return row;
  });

export const deleteTicket = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: { id: string }) => z.object({ id: z.string().uuid() }).parse(d))
  .handler(async ({ data, context }) => {
    const { error } = await context.supabase
      .from("tickets")
      .update({ deleted_at: new Date().toISOString() })
      .eq("id", data.id);
    if (error) throw new Error(error.message);
    return { ok: true };
  });

export const updateTicketStatus = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: { id: string; status: string }) =>
    z
      .object({
        id: z.string().uuid(),
        status: z.enum(["new", "assigned", "in_progress", "waiting", "resolved", "closed"]),
      })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const { error } = await context.supabase
      .from("tickets")
      .update({
        status: data.status as never,
        resolved_at: data.status === "resolved" ? new Date().toISOString() : null,
      })
      .eq("id", data.id);
    if (error) throw new Error(error.message);
    return { ok: true };
  });

export const addTicketComment = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: { ticketId: string; body: string }) =>
    z.object({ ticketId: z.string().uuid(), body: z.string().min(1) }).parse(d),
  )
  .handler(async ({ data, context }) => {
    const { error } = await context.supabase
      .from("ticket_comments")
      .insert({ ticket_id: data.ticketId, body: data.body, author_id: context.userId });
    if (error) throw new Error(error.message);
    return { ok: true };
  });

export const addTicketAttachment = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator(
    (d: {
      ticketId: string;
      fileName: string;
      storagePath: string;
      contentType: string | null;
      sizeBytes: number;
    }) =>
      z
        .object({
          ticketId: z.string().uuid(),
          fileName: z.string().min(1),
          storagePath: z.string().min(1),
          contentType: z.string().nullable(),
          sizeBytes: z.number().nonnegative(),
        })
        .parse(d),
  )
  .handler(async ({ data, context }) => {
    const { error } = await context.supabase.from("ticket_attachments").insert({
      ticket_id: data.ticketId,
      file_name: data.fileName,
      storage_path: data.storagePath,
      content_type: data.contentType,
      size_bytes: data.sizeBytes,
      uploaded_by: context.userId,
    });
    if (error) throw new Error(error.message);
    return { ok: true };
  });

// ============ SERVICES ============
export const listServices = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { data } = await context.supabase
      .from("services")
      .select("*")
      .is("deleted_at", null)
      .order("sort_order");
    return data ?? [];
  });

export const createCustomService = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: { name: string }) => z.object({ name: z.string().min(1) }).parse(d))
  .handler(async ({ data, context }) => {
    const { data: inserted, error } = await context.supabase
      .from("services")
      .insert({ name: data.name, active: true })
      .select("id")
      .single();
    if (error) throw new Error(error.message);
    return inserted.id;
  });

export const upsertService = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: { id?: string; name: string; parent_id: string | null; active: boolean }) =>
    z
      .object({
        id: z.string().uuid().optional(),
        name: z.string().min(1),
        parent_id: z.string().uuid().nullable(),
        active: z.boolean(),
      })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    if (data.id) {
      const { error } = await context.supabase
        .from("services")
        .update({ name: data.name, parent_id: data.parent_id, active: data.active })
        .eq("id", data.id);
      if (error) throw new Error(error.message);
    } else {
      const { error } = await context.supabase
        .from("services")
        .insert({ name: data.name, parent_id: data.parent_id, active: data.active });
      if (error) throw new Error(error.message);
    }
    return { ok: true };
  });

export const deleteService = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: { id: string }) => z.object({ id: z.string().uuid() }).parse(d))
  .handler(async ({ data, context }) => {
    const { error } = await context.supabase
      .from("services")
      .update({ deleted_at: new Date().toISOString() })
      .eq("id", data.id);
    if (error) throw new Error(error.message);
    return { ok: true };
  });

// ============ HR / TEAM ============
export const listTeam = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { data: profiles } = await context.supabase
      .from("profiles")
      .select("id,full_name,email,job_title,leave_status,avatar_url")
      .is("deleted_at", null);
    const { data: roles } = await context.supabase.from("user_roles").select("user_id,role");
    const { data: tickets } = await context.supabase
      .from("tickets")
      .select("assigned_to,status")
      .is("deleted_at", null);
    const { data: projects } = await context.supabase
      .from("projects")
      .select("project_manager_id,status")
      .is("deleted_at", null);
    return (profiles ?? []).map((p) => ({
      ...p,
      roles: (roles ?? []).filter((r) => r.user_id === p.id).map((r) => r.role),
      openTickets: (tickets ?? []).filter(
        (t) => t.assigned_to === p.id && !["resolved", "closed"].includes(t.status),
      ).length,
      activeProjects: (projects ?? []).filter(
        (pr) => pr.project_manager_id === p.id && pr.status !== "completed",
      ).length,
    }));
  });

export const setUserRole = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: { userId: string; role: string; enabled: boolean }) =>
    z
      .object({
        userId: z.string().uuid(),
        role: z.enum(["admin", "sales", "project_manager", "support", "hr"]),
        enabled: z.boolean(),
      })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const { data: adminRow } = await context.supabase
      .from("user_roles")
      .select("role")
      .eq("user_id", context.userId)
      .eq("role", "admin")
      .maybeSingle();
    if (!adminRow) throw new Error("Forbidden");
    if (data.enabled) {
      const { error } = await context.supabase
        .from("user_roles")
        .insert({ user_id: data.userId, role: data.role as never })
        .select();
      if (error && !error.message.includes("duplicate")) throw new Error(error.message);
    } else {
      const { error } = await context.supabase
        .from("user_roles")
        .delete()
        .eq("user_id", data.userId)
        .eq("role", data.role as never);
      if (error) throw new Error(error.message);
    }
    return { ok: true };
  });

// ============ REPORTS ============
export const getReports = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const [{ data: leads }, { data: projects }, { data: tickets }] = await Promise.all([
      context.supabase
        .from("leads")
        .select("stage,created_at,converted_at,value")
        .is("deleted_at", null),
      context.supabase.from("projects").select("status").is("deleted_at", null),
      context.supabase.from("tickets").select("status,priority").is("deleted_at", null),
    ]);
    const totalLeads = leads?.length ?? 0;
    const converted = (leads ?? []).filter((l) => (l.stage as string) === "converted").length;
    const conversion = totalLeads ? Math.round((converted / totalLeads) * 100) : 0;
    const avgDays = (() => {
      const done = (leads ?? []).filter((l) => l.converted_at);
      if (!done.length) return 0;
      const total = done.reduce(
        (s, l) => s + (new Date(l.converted_at!).getTime() - new Date(l.created_at).getTime()),
        0,
      );
      return Math.round(total / done.length / (1000 * 60 * 60 * 24));
    })();
    const projectStatus = [
      "planning",
      "in_progress",
      "testing",
      "completed",
      "on_hold",
      "overdue",
    ].map((s) => ({
      name: s,
      value: (projects ?? []).filter((p) => p.status === s).length,
    }));
    return {
      totalLeads,
      converted,
      conversion,
      avgDaysToConvert: avgDays,
      ticketCount: tickets?.length ?? 0,
      openTickets: (tickets ?? []).filter((t) => !["resolved", "closed"].includes(t.status)).length,
      projectStatus,
    };
  });

export const upsertCustomerTimelineEvent = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: { customerId: string; stage: string; eventAt: string }) =>
    z
      .object({
        customerId: z.string().uuid(),
        stage: z.string().min(1),
        eventAt: z.string(),
      })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const { data: existing } = await context.supabase
      .from("customer_timeline_events")
      .select("id")
      .eq("customer_id", data.customerId)
      .eq("stage", data.stage)
      .maybeSingle();

    if (existing) {
      const { error } = await context.supabase
        .from("customer_timeline_events")
        .update({ event_at: data.eventAt, assigned_to: context.userId })
        .eq("id", existing.id);
      if (error) throw new Error(error.message);
    } else {
      const { error } = await context.supabase.from("customer_timeline_events").insert({
        customer_id: data.customerId,
        stage: data.stage,
        event_at: data.eventAt,
        assigned_to: context.userId,
      });
      if (error) throw new Error(error.message);
    }
    return { ok: true };
  });

export const updateCustomerServices = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: { customerId: string; serviceIds: string[] }) =>
    z
      .object({
        customerId: z.string().uuid(),
        serviceIds: z.array(z.string().uuid()),
      })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const { error: deleteError } = await context.supabase
      .from("customer_services")
      .delete()
      .eq("customer_id", data.customerId);
    if (deleteError) throw new Error(deleteError.message);

    if (data.serviceIds.length > 0) {
      const inserts = data.serviceIds.map((sid) => ({
        customer_id: data.customerId,
        service_id: sid,
        status: "active",
      }));
      const { error: insertError } = await context.supabase
        .from("customer_services")
        .insert(inserts);
      if (insertError) throw new Error(insertError.message);
    }
    return { ok: true };
  });

export const updateCustomerServiceStatus = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator(
    (d: { id: string; status: string }) =>
      z
        .object({
          id: z.string().uuid(),
          status: z.string(),
        })
        .parse(d)
  )
  .handler(async ({ data, context }) => {
    const { error } = await context.supabase
      .from("customer_services")
      .update({ status: data.status })
      .eq("id", data.id);
    if (error) throw new Error(error.message);
    return { ok: true };
  });

export const updateProjectDeadline = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: { id: string; deadline: string | null }) =>
    z
      .object({
        id: z.string().uuid(),
        deadline: z.string().nullable(),
      })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const { error } = await context.supabase
      .from("projects")
      .update({ deadline: data.deadline })
      .eq("id", data.id);
    if (error) throw new Error(error.message);
    return { ok: true };
  });

export const addProjectMember = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: { project_id: string; user_id: string; role_label?: string }) =>
    z
      .object({
        project_id: z.string().uuid(),
        user_id: z.string().uuid(),
        role_label: z.string().optional(),
      })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const { error } = await context.supabase
      .from("project_members")
      .insert({ project_id: data.project_id, user_id: data.user_id, role_label: data.role_label || null });
    if (error) throw new Error(error.message);
    return { ok: true };
  });

export const removeProjectMember = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: { id: string }) =>
    z
      .object({
        id: z.string().uuid(),
      })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const { error } = await context.supabase
      .from("project_members")
      .delete()
      .eq("id", data.id);
    if (error) throw new Error(error.message);
    return { ok: true };
  });

export const updateProjectManager = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: { id: string; project_manager_id: string }) =>
    z
      .object({
        id: z.string().uuid(),
        project_manager_id: z.string().uuid(),
      })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const { error } = await context.supabase
      .from("projects")
      .update({ project_manager_id: data.project_manager_id })
      .eq("id", data.id);
    if (error) throw new Error(error.message);
    return { ok: true };
  });

export const updateProjectProgress = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: { id: string; progress: number }) =>
    z
      .object({
        id: z.string().uuid(),
        progress: z.number().min(0).max(100),
      })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const { error } = await context.supabase
      .from("projects")
      .update({ progress: data.progress })
      .eq("id", data.id);
    if (error) throw new Error(error.message);
    return { ok: true };
  });

export const createSale = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: { 
    customer_id: string; 
    description: string; 
    billing_type: "retainer" | "one-off"; 
    value: number; 
    status: "active" | "completed" | "cancelled"; 
    start_date: string;
  }) =>
    z.object({
      customer_id: z.string().uuid(),
      description: z.string().min(1),
      billing_type: z.enum(["retainer", "one-off"]),
      value: z.number().min(0),
      status: z.enum(["active", "completed", "cancelled"]),
      start_date: z.string()
    }).parse(d)
  )
  .handler(async ({ data, context }) => {
    const { error } = await context.supabase.from("sales").insert(data);
    if (error) throw new Error(error.message);
    return { ok: true };
  });

export const upsertProjectTimelineEvent = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: { projectId: string; stage: string; eventAt: string }) =>
    z
      .object({
        projectId: z.string().uuid(),
        stage: z.string().min(1),
        eventAt: z.string(),
      })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const { data: existing } = await context.supabase
      .from("project_timeline_events")
      .select("id")
      .eq("project_id", data.projectId)
      .eq("stage", data.stage)
      .maybeSingle();

    if (existing) {
      const { error } = await context.supabase
        .from("project_timeline_events")
        .update({ event_at: data.eventAt, completed_by: context.userId })
        .eq("id", existing.id);
      if (error) throw new Error(error.message);
    } else {
      const { error } = await context.supabase.from("project_timeline_events").insert({
        project_id: data.projectId,
        stage: data.stage,
        event_at: data.eventAt,
        completed_by: context.userId,
      });
      if (error) throw new Error(error.message);
    }

    let status: string | undefined;
    switch (data.stage) {
      case "Scope Approved": status = "planning"; break;
      case "Development Started":
      case "Review": status = "in_progress"; break;
      case "Testing": status = "testing"; break;
      case "Completed": status = "completed"; break;
      case "Deployed": status = "deployed"; break;
    }

    const { count } = await context.supabase
      .from("project_timeline_events")
      .select("*", { count: 'exact', head: true })
      .eq("project_id", data.projectId);

    const progress = count ? Math.round((count / 6) * 100) : 0;

    const updateData: any = { progress };
    if (status) updateData.status = status;

    await context.supabase
      .from("projects")
      .update(updateData)
      .eq("id", data.projectId);

    return { ok: true };
  });
