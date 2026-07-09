import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { useState } from "react";
import { getLead, updateLeadDates, updateLead, convertLeadToCustomer, getMyRoles } from "@/lib/erp.functions";
import { Card } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { toast } from "sonner";
import { Link } from "@tanstack/react-router";
import { ArrowLeft, User, Building, Mail, Phone, Handshake, DollarSign, Target } from "lucide-react";

export const Route = createFileRoute("/_authenticated/leads/$leadId")({
  head: () => ({ meta: [{ title: "Lead Profile — solv." }] }),
  component: LeadProfile,
});

const STAGES = [
  { key: "lead_created", label: "Lead Created", dateField: "lead_created_at" },
  { key: "cold", label: "Cold", dateField: "cold_at" },
  { key: "warm", label: "Warm", dateField: "warm_at" },
  { key: "hot", label: "Hot", dateField: "hot_at" },
  { key: "proposal", label: "Proposal", dateField: "proposal_at" },
  { key: "negotiation", label: "Negotiation", dateField: "negotiation_at" },
  { key: "converted", label: "Converted", dateField: "converted_at" },
];

function LeadProfile() {
  const { leadId } = Route.useParams();
  const qc = useQueryClient();

  const rolesFn = useServerFn(getMyRoles);
  const { data: rolesData } = useQuery({
    queryKey: ["my-roles"],
    queryFn: () => rolesFn(),
  });
  const isAdmin = rolesData?.roles?.includes("admin") ?? false;

  const fn = useServerFn(getLead);
  const { data, isLoading } = useQuery({
    queryKey: ["lead", leadId],
    queryFn: () => fn({ data: { id: leadId } }),
  });

  const updateFn = useServerFn(updateLeadDates);
  const m = useMutation({
    mutationFn: (vars: { field: string; value: string; stage: string }) =>
      updateFn({
        data: {
          id: leadId,
          [vars.field]: vars.value,
          stage: vars.stage,
        },
      }),
    onSuccess: () => {
      toast.success("Timeline updated");
      qc.invalidateQueries({ queryKey: ["lead", leadId] });
      qc.invalidateQueries({ queryKey: ["leads"] });
    },
    onError: (e: Error) => toast.error(e.message),
  });

  if (isLoading) return <div className="p-8">Loading lead profile...</div>;
  if (!data?.lead) return <div className="p-8">Lead not found</div>;

  const { lead, services } = data;
  const isLocked = lead.stage === "converted" && !isAdmin;
  const isLost = lead.stage === "lost";

  const stages = [...STAGES];
  if (isLost) {
    stages[6] = { key: "lost", label: "Lost", dateField: "lost_at" };
  }

  const handleDateChange = (field: string, value: string, stageKey: string) => {
    if (isLocked) return;
    if (!value) return;
    // Guard against intermediate/invalid values from date input (e.g., year > 9999)
    const match = /^(\d{4})-(\d{2})-(\d{2})$/.exec(value);
    if (!match) return;
    const year = Number(match[1]);
    if (year < 1900 || year > 2999) return;
    const d = new Date(`${value}T00:00:00.000Z`);
    if (isNaN(d.getTime())) return;
    m.mutate({ field, value: d.toISOString(), stage: stageKey });
  };

  const formatDateForInput = (iso?: string | null) => {
    if (!iso) return "";
    return new Date(iso).toISOString().split("T")[0];
  };

  return (
    <div className="p-8 max-w-6xl mx-auto space-y-6">
      <div className="flex items-center gap-4">
        <Button variant="ghost" size="icon" asChild>
          <Link to="/leads">
            <ArrowLeft className="h-4 w-4" />
          </Link>
        </Button>
        <div>
          <h1 className="text-3xl font-bold tracking-tight">{lead.name}</h1>
          <p className="text-muted-foreground flex items-center gap-2 mt-1">
            <Building className="h-4 w-4" /> {lead.company || "No Company Specified"}
          </p>
        </div>
      </div>

      <Card className={`p-6 border-l-4 ${isLost ? "border-l-red-500" : lead.stage === "converted" ? "border-l-emerald-500" : "border-l-brand"}`}>
        <div className="flex items-center justify-between mb-8">
          <div>
            <h3 className="text-lg font-semibold">Lead Pipeline</h3>
            <p className="text-sm text-muted-foreground mt-1">
              {lead.stage === "converted" 
                ? (isAdmin ? "Converted (Admin Override Enabled)" : "Converted (Locked)")
                : isLost 
                  ? "Lead Lost" 
                  : "Active Lead"}
            </p>
          </div>
          <Badge variant="outline" className="capitalize px-4 py-1 text-sm">{lead.stage.replace("_", " ")}</Badge>
        </div>

        <div className="flex flex-col md:flex-row gap-4 items-start md:items-center justify-between overflow-x-auto pb-4">
          {stages.map((st, i) => {
            const val = (lead as any)[st.dateField];
            const isActive = lead.stage === st.key;
            const hasPassed = !!val;
            return (
              <div key={st.key} className="flex-1 flex flex-col relative min-w-[110px]">
                <div className="flex items-center mb-3">
                  <div className={`h-4 w-4 rounded-full border-2 z-10 ${
                    isActive || hasPassed 
                      ? st.key === "lost" ? "bg-red-500 border-red-500" : "bg-brand border-brand" 
                      : "bg-background border-muted"
                  }`} />
                  {i < stages.length - 1 && (
                    <div className={`absolute top-2 left-4 right-[-10px] h-[2px] -z-0 ${
                      hasPassed ? (st.key === "lost" ? "bg-red-500" : "bg-brand") : "bg-muted"
                    }`} style={{ width: 'calc(100% - 10px)' }} />
                  )}
                </div>
                <Label className={`text-[10px] uppercase mb-2 font-semibold ${isActive ? "text-foreground" : "text-muted-foreground"}`}>
                  {st.label}
                </Label>
                <Input
                  type="date"
                  className="h-8 text-[11px] px-2 w-[120px]"
                  value={formatDateForInput(val)}
                  disabled={isLocked || m.isPending}
                  onChange={(e) => handleDateChange(st.dateField, e.target.value, st.key)}
                />
              </div>
            );
          })}
        </div>
      </Card>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <Card className="p-6 space-y-4">
          <h3 className="text-lg font-semibold border-b pb-2">Profile Information</h3>
          
          <div className="space-y-4">
            <div className="flex items-start gap-3">
              <User className="h-5 w-5 text-muted-foreground mt-0.5" />
              <div>
                <p className="text-sm font-medium">Primary Contact</p>
                <p className="text-sm text-muted-foreground">{lead.name}</p>
              </div>
            </div>

            <div className="flex items-start gap-3">
              <Mail className="h-5 w-5 text-muted-foreground mt-0.5" />
              <div>
                <p className="text-sm font-medium">Email</p>
                <p className="text-sm text-muted-foreground">{lead.email || "—"}</p>
              </div>
            </div>

            <div className="flex items-start gap-3">
              <Phone className="h-5 w-5 text-muted-foreground mt-0.5" />
              <div>
                <p className="text-sm font-medium">Phone</p>
                <p className="text-sm text-muted-foreground">{lead.phone || "—"}</p>
              </div>
            </div>

            <div className="flex items-start gap-3">
              <Target className="h-5 w-5 text-muted-foreground mt-0.5" />
              <div>
                <p className="text-sm font-medium">Lead Source</p>
                <p className="text-sm text-muted-foreground capitalize">{lead.source || "—"}</p>
              </div>
            </div>

            <div className="flex items-start gap-3">
              <Handshake className="h-5 w-5 text-muted-foreground mt-0.5" />
              <div>
                <p className="text-sm font-medium">Assigned Team Member</p>
                <p className="text-sm text-muted-foreground">
                  {lead.assigned_member ? (lead.assigned_member.full_name || lead.assigned_member.email) : "Unassigned"}
                </p>
              </div>
            </div>

            <div className="flex items-start gap-3">
              <DollarSign className="h-5 w-5 text-muted-foreground mt-0.5" />
              <div>
                <p className="text-sm font-medium">Estimated Value</p>
                <p className="text-sm text-muted-foreground">${Number(lead.value || 0).toLocaleString()}</p>
              </div>
            </div>
          </div>
        </Card>

        <div className="space-y-6">
          <Card className="p-6">
            <h3 className="text-lg font-semibold border-b pb-2 mb-4">Interested Products / Services</h3>
            {services.length === 0 ? (
              <p className="text-sm text-muted-foreground">No services selected.</p>
            ) : (
              <ul className="space-y-2">
                {services.map((s: any) => (
                  <li key={s.id} className="flex items-center gap-2 text-sm">
                    <div className="h-2 w-2 bg-brand rounded-full" />
                    {s.services?.name}
                  </li>
                ))}
              </ul>
            )}
          </Card>

          <Card className="p-6">
            <h3 className="text-lg font-semibold border-b pb-2 mb-4">Notes</h3>
            <Textarea 
              readOnly 
              value={lead.notes || "No notes provided."} 
              className="resize-none border-none shadow-none focus-visible:ring-0 p-0 bg-transparent text-sm"
            />
          </Card>
        </div>
      </div>

      {lead.stage === "converted" && (
        <ConvertSection lead={lead} services={services} />
      )}
    </div>
  );
}

function ConvertSection({ lead, services }: { lead: any; services: any[] }) {
  const qc = useQueryClient();
  const nav = useNavigate({ from: Route.fullPath });
  const [salesData, setSalesData] = useState(
    services.map(s => ({
      service_id: s.service_id,
      service_name: s.services?.name,
      billing_type: "one-off",
      value: 0,
    }))
  );

  const isExistingCustomer = !!lead.customer_id;

  const convertFn = useServerFn(convertLeadToCustomer);
  const convertMut = useMutation({
    mutationFn: () => convertFn({ data: { leadId: lead.id, salesData } }),
    onSuccess: (res) => {
      toast.success(isExistingCustomer ? "Successfully added sale to Customer!" : "Successfully converted to Customer!");
      qc.invalidateQueries();
      nav({ to: `/crm/${res.customerId}` });
    },
    onError: (e: Error) => toast.error(e.message),
  });

  return (
    <Card className="p-6 border-brand border-2 shadow-lg">
      <div className="mb-6 border-b pb-4">
        <h3 className="text-xl font-bold">{isExistingCustomer ? "Add Sale to Customer" : "Convert to Customer"}</h3>
        <p className="text-sm text-muted-foreground mt-1">
          {isExistingCustomer 
            ? "Finalize the sale details. This will add the selected services to the existing Customer Profile and create Sales records." 
            : "Finalize the sale details. This will activate the Customer Profile and create Sales records for the selected services."}
        </p>
      </div>

      {salesData.length === 0 ? (
        <div className="text-sm text-muted-foreground mb-4">No services selected during lead creation.</div>
      ) : (
        <div className="space-y-4 mb-6">
          <Label>Confirm Sales Data</Label>
          {salesData.map((s, idx) => (
            <div key={s.service_id} className="flex gap-4 items-end bg-slate-50 p-3 rounded-md">
              <div className="flex-1">
                <p className="text-sm font-medium mb-1">{s.service_name}</p>
                <select
                  value={s.billing_type}
                  onChange={(e) => {
                    const next = [...salesData];
                    next[idx].billing_type = e.target.value;
                    setSalesData(next);
                  }}
                  className="w-full h-9 rounded-md border bg-background px-3 text-sm"
                >
                  <option value="one-off">One-Off</option>
                  <option value="retainer">Monthly Retainer</option>
                </select>
              </div>
              <div className="flex-1">
                <Label className="text-xs mb-1 block">Value</Label>
                <Input
                  type="number"
                  value={s.value}
                  onChange={(e) => {
                    const next = [...salesData];
                    next[idx].value = Number(e.target.value);
                    setSalesData(next);
                  }}
                />
              </div>
            </div>
          ))}
        </div>
      )}

      <div className="flex justify-end gap-3">
        <Button size="lg" disabled={convertMut.isPending} onClick={() => convertMut.mutate()}>
          {isExistingCustomer ? "Finalize Sale" : "Finalize Conversion"}
        </Button>
      </div>
    </Card>
  );
}
