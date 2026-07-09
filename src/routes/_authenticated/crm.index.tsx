import { createFileRoute, Link } from "@tanstack/react-router";
import { useSuspenseQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { useState } from "react";
import { listCustomers, deleteCustomer } from "@/lib/erp.functions";
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
import { Badge } from "@/components/ui/badge";
import { ConfirmDeleteButton } from "@/components/confirm-delete-button";
import { toast } from "sonner";
import { Users, UserCheck, DollarSign, TrendingUp } from "lucide-react";

export const Route = createFileRoute("/_authenticated/crm/")({
  head: () => ({ meta: [{ title: "CRM — solv." }] }),
  component: CrmList,
});

function CrmList() {
  const qc = useQueryClient();
  const fn = useServerFn(listCustomers);
  const { data } = useSuspenseQuery({ queryKey: ["customers"], queryFn: () => fn() });
  const [q, setQ] = useState("");
  const filtered = data.filter((c: any) => c.name.toLowerCase().includes(q.toLowerCase()));

  const deleteFn = useServerFn(deleteCustomer);
  const deleteMut = useMutation({
    mutationFn: (id: string) => deleteFn({ data: { id } }),
    onSuccess: () => {
      toast.success("Customer deleted");
      qc.invalidateQueries();
    },
    onError: (e: Error) => toast.error(e.message),
  });

  const totalCustomers = data.length;
  const activeCustomers = data.filter((c: any) => c.status === "active").length;
  const totalValue = data.reduce((sum: number, c: any) => sum + Number(c.estimated_value || 0), 0);
  const avgValue = totalCustomers ? Math.round(totalValue / totalCustomers) : 0;

  return (
    <div className="p-6 md:p-8 space-y-8">
      <div>
        <h1 className="text-2xl font-semibold">Customers</h1>
        <p className="text-sm text-muted-foreground mt-1">All customers and their status.</p>
      </div>

      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
        <KpiCard label="Total Customers" value={totalCustomers} icon={Users} />
        <KpiCard label="Active Customers" value={activeCustomers} icon={UserCheck} />
        <KpiCard
          label="Total Pipeline Value"
          value={`$${totalValue.toLocaleString()}`}
          icon={DollarSign}
        />
        <KpiCard label="Average Value" value={`$${avgValue.toLocaleString()}`} icon={TrendingUp} />
      </div>

      <Card className="p-4">
        <div className="mb-4">
          <Input
            placeholder="Search customers…"
            value={q}
            onChange={(e) => setQ(e.target.value)}
            className="max-w-sm"
          />
        </div>
        {filtered.length === 0 ? (
          <div className="text-sm text-muted-foreground py-12 text-center">
            No customers yet. Use "Create New" to add one.
          </div>
        ) : (
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Name</TableHead>
                <TableHead>Industry</TableHead>
                <TableHead>Status</TableHead>
                <TableHead>Account Manager</TableHead>
                <TableHead>Value</TableHead>
                <TableHead className="text-right">Actions</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {filtered.map((c: any) => (
                <TableRow key={c.id}>
                  <TableCell>
                    <Link
                      to="/crm/$customerId"
                      params={{ customerId: c.id }}
                      className="font-medium hover:underline"
                    >
                      {c.name}
                    </Link>
                  </TableCell>
                  <TableCell className="text-muted-foreground">{c.industry ?? "—"}</TableCell>
                  <TableCell>
                    <StatusBadge s={c.status} />
                  </TableCell>
                  <TableCell className="text-muted-foreground">
                    {c.account_manager?.full_name ?? "—"}
                  </TableCell>
                  <TableCell className="text-muted-foreground">
                    ${Number(c.estimated_value || 0).toLocaleString()}
                  </TableCell>
                  <TableCell className="text-right">
                    <ConfirmDeleteButton
                      itemLabel={c.name}
                      pending={deleteMut.isPending}
                      onConfirm={() => deleteMut.mutate(c.id)}
                    />
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        )}
      </Card>
    </div>
  );
}

function KpiCard({
  label,
  value,
  icon: Icon,
}: {
  label: string;
  value: number | string;
  icon: React.ComponentType<{ className?: string }>;
}) {
  return (
    <Card className="p-5">
      <div className="flex items-center justify-between">
        <span className="text-xs uppercase tracking-wide text-muted-foreground">{label}</span>
        <Icon className="h-4 w-4 text-muted-foreground" />
      </div>
      <div className="text-3xl font-semibold mt-2">{value}</div>
    </Card>
  );
}

function StatusBadge({ s }: { s: string }) {
  const map: Record<string, string> = {
    cold: "bg-slate-100 text-slate-700",
    warm: "bg-amber-100 text-amber-700",
    hot: "bg-orange-100 text-orange-700",
    converted: "bg-brand/10 text-brand",
    lost: "bg-muted text-muted-foreground",
    active: "bg-emerald-100 text-emerald-700",
  };
  return (
    <Badge variant="secondary" className={map[s] ?? ""}>
      {s}
    </Badge>
  );
}

