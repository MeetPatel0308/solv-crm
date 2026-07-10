import { createFileRoute } from "@tanstack/react-router";
import { useSuspenseQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { useState } from "react";
import { listLeads, updateLead, deleteLead, listServices } from "@/lib/erp.functions";
import { Card } from "@/components/ui/card";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogFooter,
} from "@/components/ui/dialog";
import { ConfirmDeleteButton } from "@/components/confirm-delete-button";
import { Link } from "@tanstack/react-router";
import { Pencil, ArrowRight } from "lucide-react";
import { toast } from "sonner";

export const Route = createFileRoute("/_authenticated/leads/")({
  head: () => ({ meta: [{ title: "Leads — solv." }] }),
  component: LeadsList,
});

const STAGE_STYLES: Record<string, string> = {
  lead_created: "bg-slate-100 text-slate-700",
  cold: "bg-blue-100 text-blue-700",
  warm: "bg-amber-100 text-amber-700",
  hot: "bg-orange-100 text-orange-700",
  proposal: "bg-purple-100 text-purple-700",
  negotiation: "bg-pink-100 text-pink-700",
  converted: "bg-emerald-100 text-emerald-700",
  lost: "bg-red-100 text-red-700",
};

const SOURCE_LABELS: Record<string, string> = {
  email: "Email",
  ads: "Ads",
  referral: "Referral",
};

function LeadsList() {
  const qc = useQueryClient();
  const fn = useServerFn(listLeads);
  const { data } = useSuspenseQuery({ queryKey: ["leads"], queryFn: () => fn() });
  const [q, setQ] = useState("");
  const [showAllServices, setShowAllServices] = useState(false);

  const deleteFn = useServerFn(deleteLead);
  const deleteMut = useMutation({
    mutationFn: (id: string) => deleteFn({ data: { id } }),
    onSuccess: () => {
      toast.success("Lead deleted");
      qc.invalidateQueries({ queryKey: ["leads"] });
      qc.invalidateQueries({ queryKey: ["dashboard-stats"] });
      qc.invalidateQueries({ queryKey: ["leads-series"] });
    },
    onError: (e: Error) => toast.error(e.message),
  });

  const getSrvs = useServerFn(listServices);
  const { data: availableServices = [] } = useSuspenseQuery({
    queryKey: ["services"],
    queryFn: () => getSrvs(),
  });

  const [editingLead, setEditingLead] = useState<any>(null);
  const updateMut = useMutation({
    mutationFn: (vars: any) => updateLead({ data: vars }),
    onSuccess: () => {
      toast.success("Lead updated");
      qc.invalidateQueries({ queryKey: ["leads"] });
      setEditingLead(null);
    },
    onError: (e: Error) => toast.error(e.message),
  });

  const filtered = data.filter(
    (l: any) =>
      l.name.toLowerCase().includes(q.toLowerCase()) ||
      (l.company ?? "").toLowerCase().includes(q.toLowerCase()),
  );

  const activeLeads = data.filter((l: any) => l.stage !== "converted" && l.stage !== "lost");
  
  const currentMonth = new Date().getMonth();
  const currentYear = new Date().getFullYear();
  const newThisMonth = data.filter((l: any) => {
    if (!l.created_at) return false;
    const d = new Date(l.created_at);
    return d.getMonth() === currentMonth && d.getFullYear() === currentYear;
  }).length;

  const convertedCount = data.filter((l: any) => l.stage === "converted").length;
  const lostCount = data.filter((l: any) => l.stage === "lost").length;
  const conversionRate = data.length === 0 ? 0 : Math.round((convertedCount / data.length) * 100);

  const serviceCounts: Record<string, number> = {};
  const summaryLeads = data.filter((l: any) => l.stage !== "lost");
  summaryLeads.forEach((l: any) => {
    l.lead_services?.forEach((ls: any) => {
      const name = ls.services?.name;
      if (name) {
        serviceCounts[name] = (serviceCounts[name] || 0) + 1;
      }
    });
  });
  
  const sortedServices = Object.entries(serviceCounts).sort((a, b) => {
    if (b[1] !== a[1]) return b[1] - a[1];
    return a[0].localeCompare(b[0]);
  });
  const displayedServices = showAllServices ? sortedServices : sortedServices.slice(0, 5);
  const topService = sortedServices.length > 0 ? sortedServices[0][0] : "None";

  return (
    <div className="p-6 md:p-8 space-y-6">
      <div>
        <h1 className="text-2xl font-semibold">Leads</h1>
        <p className="text-sm text-muted-foreground mt-1">
          Prospective customers and where they came from.
        </p>
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <Card className="p-4">
          <p className="text-sm font-medium text-muted-foreground">Active Leads</p>
          <p className="text-2xl font-bold mt-1">{activeLeads.length}</p>
        </Card>
        <Card className="p-4">
          <p className="text-sm font-medium text-muted-foreground">New This Month</p>
          <p className="text-2xl font-bold mt-1">{newThisMonth}</p>
        </Card>
        <Card className="p-4">
          <p className="text-sm font-medium text-muted-foreground">Conversion Rate</p>
          <p className="text-2xl font-bold mt-1">{conversionRate}%</p>
        </Card>
        <Card className="p-4">
          <p className="text-sm font-medium text-muted-foreground">Top Interested Service</p>
          <p className="text-2xl font-bold mt-1 truncate">{topService}</p>
        </Card>
      </div>

      <Card className="p-6">
        <h2 className="text-lg font-semibold mb-6">Lead Interest Summary</h2>
        <div className="flex flex-col relative">
          {sortedServices.length === 0 ? (
            <p className="text-sm text-muted-foreground">No service interest has been recorded yet.</p>
          ) : (
            <div className="flex flex-col">
              {displayedServices.map(([name, count], index) => {
                const rankIndicator = <span className="text-muted-foreground font-mono text-xs w-6">#{index + 1}</span>;

                return (
                  <div key={name} className={`flex items-center justify-between py-3 ${index !== displayedServices.length - 1 ? 'border-b border-gray-100' : ''} animate-in fade-in slide-in-from-top-1 duration-300`}>
                    <div className="flex items-center gap-3">
                      <div className="flex items-center justify-center font-medium">
                        {rankIndicator}
                      </div>
                      <span className="font-medium text-sm text-foreground">{name}</span>
                    </div>
                    <div className="text-sm text-gray-500">
                      {count} {count === 1 ? 'lead' : 'leads'}
                    </div>
                  </div>
                );
              })}
            </div>
          )}
          {sortedServices.length > 5 && (
            <div className="mt-4 flex justify-center">
              <Button 
                variant="ghost" 
                size="sm" 
                className="text-xs text-muted-foreground hover:text-foreground transition-colors"
                onClick={() => setShowAllServices(!showAllServices)}
              >
                {showAllServices ? "Show Less ↑" : "Show More ↓"}
              </Button>
            </div>
          )}
        </div>
      </Card>
      <Card className="p-4">
        <div className="mb-4">
          <Input
            placeholder="Search leads…"
            value={q}
            onChange={(e) => setQ(e.target.value)}
            className="max-w-sm"
          />
        </div>
        {filtered.length === 0 ? (
          <div className="text-sm text-muted-foreground py-12 text-center">
            No leads yet. Use "Create New" to add one.
          </div>
        ) : (
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Name</TableHead>
                <TableHead>Company</TableHead>
                <TableHead>Status</TableHead>
                <TableHead>Source</TableHead>
                <TableHead>Interested Services</TableHead>
                <TableHead>Value</TableHead>
                <TableHead className="text-right">Actions</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {filtered.map((l: any) => (
                <TableRow key={l.id}>
                  <TableCell className="font-medium">{l.name}</TableCell>
                  <TableCell className="text-muted-foreground">{l.company ?? "—"}</TableCell>
                  <TableCell>
                    <Badge variant="secondary" className={STAGE_STYLES[l.stage] ?? ""}>
                      {l.stage.replace("_", " ")}
                    </Badge>
                  </TableCell>
                  <TableCell className="text-muted-foreground">
                    {l.source ? SOURCE_LABELS[l.source] : "—"}
                  </TableCell>
                  <TableCell>
                    {l.lead_services && l.lead_services.length > 0 ? (
                      <div className="flex flex-wrap gap-1">
                        {l.lead_services.map((ls: any) => (
                          <Badge key={ls.id} variant="outline" className="font-normal text-xs">
                            {ls.services?.name}
                          </Badge>
                        ))}
                      </div>
                    ) : (
                      <span className="text-muted-foreground">—</span>
                    )}
                  </TableCell>
                  <TableCell className="text-muted-foreground">
                    ${Number(l.value || 0).toLocaleString()}
                  </TableCell>
                  <TableCell>
                    <div className="flex items-center justify-end gap-1">
                      <Button variant="ghost" size="icon" onClick={() => setEditingLead(l)}>
                        <Pencil className="h-4 w-4" />
                      </Button>
                      <Button variant="ghost" size="icon" asChild>
                        <Link to={`/leads/${l.id}`}>
                          <ArrowRight className="h-4 w-4" />
                        </Link>
                      </Button>
                      <ConfirmDeleteButton
                        itemLabel={l.name}
                        pending={deleteMut.isPending}
                        onConfirm={() => deleteMut.mutate(l.id)}
                      />
                    </div>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        )}
      </Card>

      {editingLead && (
        <EditLeadDialog 
          lead={editingLead}
          services={availableServices}
          onClose={() => setEditingLead(null)}
          onSave={updateMut.mutate}
          isPending={updateMut.isPending}
        />
      )}
    </div>
  );
}

function EditLeadDialog({ lead, services, onClose, onSave, isPending }: any) {
  const [name, setName] = useState(lead.name);
  const [company, setCompany] = useState(lead.company || "");
  const [email, setEmail] = useState(lead.email || "");
  const [phone, setPhone] = useState(lead.phone || "");
  const [value, setValue] = useState(lead.value?.toString() || "0");
  const [source, setSource] = useState(lead.source || "");
  const [stage, setStage] = useState(lead.stage || "lead_created");
  const [notes, setNotes] = useState(lead.notes || "");
  const [serviceIds, setServiceIds] = useState<string[]>(
    lead.lead_services ? lead.lead_services.map((ls: any) => ls.service_id) : []
  );

  return (
    <Dialog open onOpenChange={onClose}>
      <DialogContent className="sm:max-w-[500px]">
        <DialogHeader>
          <DialogTitle>Edit Lead</DialogTitle>
        </DialogHeader>
        <div className="space-y-4 max-h-[70vh] overflow-y-auto pr-4">
          <div className="space-y-1">
            <Label>Name</Label>
            <Input value={name} onChange={(e) => setName(e.target.value)} />
          </div>
          <div className="space-y-1">
            <Label>Company Name</Label>
            <Input value={company} onChange={(e) => setCompany(e.target.value)} />
          </div>
          <div className="space-y-1">
            <Label>Interested Services</Label>
            <select
              multiple
              value={serviceIds}
              onChange={(e) => {
                const options = Array.from(e.target.selectedOptions);
                setServiceIds(options.map(o => o.value));
              }}
              className="w-full rounded-md border bg-background p-2 text-sm min-h-[80px]"
            >
              {services.map((s: any) => (
                <option key={s.id} value={s.id}>
                  {s.name}
                </option>
              ))}
            </select>
            <p className="text-[10px] text-muted-foreground mt-1">Hold Ctrl/Cmd to select multiple</p>
          </div>
          <div className="grid grid-cols-2 gap-3">
            <div className="space-y-1">
              <Label>Email</Label>
              <Input type="email" value={email} onChange={(e) => setEmail(e.target.value)} />
            </div>
            <div className="space-y-1">
              <Label>Phone</Label>
              <Input type="tel" value={phone} onChange={(e) => setPhone(e.target.value)} />
            </div>
          </div>
          <div className="grid grid-cols-2 gap-3">
            <div className="space-y-1">
              <Label>Estimated Value</Label>
              <Input type="number" value={value} onChange={(e) => setValue(e.target.value)} />
            </div>
            <div className="space-y-1">
              <Label>Status</Label>
              <select
                value={stage}
                onChange={(e) => setStage(e.target.value)}
                className="w-full h-9 rounded-md border bg-background px-3 text-sm"
              >
                <option value="lead_created">Lead Created</option>
                <option value="cold">Cold</option>
                <option value="warm">Warm</option>
                <option value="hot">Hot</option>
                <option value="proposal">Proposal</option>
                <option value="negotiation">Negotiation</option>
                <option value="converted">Converted</option>
                <option value="lost">Lost</option>
              </select>
            </div>
          </div>
          <div className="space-y-1">
            <Label>Where did this lead come from?</Label>
            <select
              value={source}
              onChange={(e) => setSource(e.target.value)}
              className="w-full h-9 rounded-md border bg-background px-3 text-sm"
            >
              <option value="" disabled>Select a source…</option>
              <option value="email">Email</option>
              <option value="ads">Ads</option>
              <option value="referral">Referral</option>
            </select>
          </div>
          <div className="space-y-1">
            <Label>Notes</Label>
            <Textarea value={notes} onChange={(e) => setNotes(e.target.value)} />
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" onClick={onClose}>
            Cancel
          </Button>
          <Button 
            disabled={!name || isPending}
            onClick={() => {
              onSave({
                id: lead.id,
                name,
                company: company || null,
                email: email || null,
                phone: phone || null,
                value: Number(value) || 0,
                stage,
                source,
                notes: notes || null,
                service_ids: serviceIds,
              });
            }}
          >
            {isPending ? "Saving..." : "Save Changes"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
