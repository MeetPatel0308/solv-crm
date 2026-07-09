import { createFileRoute } from "@tanstack/react-router";
import { useSuspenseQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { useState } from "react";
import { listLeads, updateLead, deleteLead } from "@/lib/erp.functions";
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
import { Pencil } from "lucide-react";
import { toast } from "sonner";

export const Route = createFileRoute("/_authenticated/leads/")({
  head: () => ({ meta: [{ title: "Leads — solv." }] }),
  component: LeadsList,
});

const STAGE_STYLES: Record<string, string> = {
  cold: "bg-slate-100 text-slate-700",
  warm: "bg-amber-100 text-amber-700",
  hot: "bg-orange-100 text-orange-700",
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
  const [editing, setEditing] = useState<any>(null);

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

  const filtered = data.filter(
    (l: any) =>
      l.name.toLowerCase().includes(q.toLowerCase()) ||
      (l.company ?? "").toLowerCase().includes(q.toLowerCase()),
  );

  return (
    <div className="p-6 md:p-8 space-y-6">
      <div>
        <h1 className="text-2xl font-semibold">Leads</h1>
        <p className="text-sm text-muted-foreground mt-1">
          Prospective customers and where they came from.
        </p>
      </div>
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
                      {l.stage}
                    </Badge>
                  </TableCell>
                  <TableCell className="text-muted-foreground">
                    {l.source ? SOURCE_LABELS[l.source] : "—"}
                  </TableCell>
                  <TableCell className="text-muted-foreground">
                    ${Number(l.value || 0).toLocaleString()}
                  </TableCell>
                  <TableCell>
                    <div className="flex items-center justify-end gap-1">
                      <Button variant="ghost" size="icon" onClick={() => setEditing(l)}>
                        <Pencil className="h-4 w-4" />
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

      {editing && <EditLeadDialog lead={editing} onClose={() => setEditing(null)} />}
    </div>
  );
}

function EditLeadDialog({ lead, onClose }: { lead: any; onClose: () => void }) {
  const qc = useQueryClient();
  const [name, setName] = useState(lead.name ?? "");
  const [company, setCompany] = useState(lead.company ?? "");
  const [email, setEmail] = useState(lead.email ?? "");
  const [phone, setPhone] = useState(lead.phone ?? "");
  const [value, setValue] = useState(String(lead.value ?? 0));
  const [stage, setStage] = useState(lead.stage ?? "cold");
  const [source, setSource] = useState(lead.source ?? "");
  const [notes, setNotes] = useState(lead.notes ?? "");

  const fn = useServerFn(updateLead);
  const m = useMutation({
    mutationFn: () =>
      fn({
        data: {
          id: lead.id,
          name,
          company: company || null,
          email: email || null,
          phone: phone || null,
          value: Number(value) || 0,
          stage,
          source,
          notes: notes || null,
        },
      }),
    onSuccess: () => {
      toast.success("Lead updated");
      qc.invalidateQueries({ queryKey: ["leads"] });
      qc.invalidateQueries({ queryKey: ["dashboard-stats"] });
      qc.invalidateQueries({ queryKey: ["leads-series"] });
      onClose();
    },
    onError: (e: Error) => toast.error(e.message),
  });

  return (
    <Dialog open onOpenChange={onClose}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Edit Lead</DialogTitle>
        </DialogHeader>
        <div className="space-y-3">
          <div className="space-y-1">
            <Label>Name</Label>
            <Input value={name} onChange={(e) => setName(e.target.value)} />
          </div>
          <div className="space-y-1">
            <Label>Company</Label>
            <Input value={company} onChange={(e) => setCompany(e.target.value)} />
          </div>
          <div className="grid grid-cols-2 gap-3">
            <div className="space-y-1">
              <Label>Email</Label>
              <Input type="email" value={email} onChange={(e) => setEmail(e.target.value)} />
            </div>
            <div className="space-y-1">
              <Label>Phone</Label>
              <Input value={phone} onChange={(e) => setPhone(e.target.value)} />
            </div>
          </div>
          <div className="space-y-1">
            <Label>Estimated Value</Label>
            <Input type="number" value={value} onChange={(e) => setValue(e.target.value)} />
          </div>
          <div className="grid grid-cols-2 gap-3">
            <div className="space-y-1">
              <Label>Status</Label>
              <select
                value={stage}
                onChange={(e) => setStage(e.target.value)}
                className="w-full h-9 rounded-md border bg-background px-3 text-sm"
              >
                <option value="cold">Cold</option>
                <option value="warm">Warm</option>
                <option value="hot">Hot</option>
                <option value="converted">Converted</option>
                <option value="lost">Lost</option>
              </select>
            </div>
            <div className="space-y-1">
              <Label>Source</Label>
              <select
                value={source}
                onChange={(e) => setSource(e.target.value)}
                className="w-full h-9 rounded-md border bg-background px-3 text-sm"
              >
                <option value="" disabled>
                  Select a source…
                </option>
                <option value="email">Email</option>
                <option value="ads">Ads</option>
                <option value="referral">Referral</option>
              </select>
            </div>
          </div>
          <div className="space-y-1">
            <Label>Notes</Label>
            <Textarea value={notes} onChange={(e) => setNotes(e.target.value)} />
          </div>
        </div>
        <DialogFooter>
          <Button variant="ghost" onClick={onClose}>
            Cancel
          </Button>
          <Button disabled={!name || !source || m.isPending} onClick={() => m.mutate()}>
            Save changes
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
