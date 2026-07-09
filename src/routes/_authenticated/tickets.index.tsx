import { createFileRoute, Link } from "@tanstack/react-router";
import { useSuspenseQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { useState } from "react";
import { listTickets, deleteTicket } from "@/lib/erp.functions";
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
import { PriorityBadge, StatusBadge } from "./dashboard";
import { ConfirmDeleteButton } from "@/components/confirm-delete-button";
import { toast } from "sonner";

export const Route = createFileRoute("/_authenticated/tickets/")({
  head: () => ({ meta: [{ title: "Tickets — solv." }] }),
  component: TicketList,
});

function TicketList() {
  const qc = useQueryClient();
  const fn = useServerFn(listTickets);
  const { data } = useSuspenseQuery({ queryKey: ["tickets"], queryFn: () => fn() });
  const [q, setQ] = useState("");
  const deleteFn = useServerFn(deleteTicket);
  const deleteMut = useMutation({
    mutationFn: (id: string) => deleteFn({ data: { id } }),
    onSuccess: () => {
      toast.success("Ticket deleted");
      qc.invalidateQueries();
    },
    onError: (e: Error) => toast.error(e.message),
  });
  const filtered = data.filter(
    (t: any) =>
      t.title.toLowerCase().includes(q.toLowerCase()) ||
      (t.ticket_code ?? "").toLowerCase().includes(q.toLowerCase()),
  );

  const cards = {
    open: data.filter((t: any) => t.status === "new").length,
    assigned: data.filter((t: any) => t.status === "assigned").length,
    inProgress: data.filter((t: any) => t.status === "in_progress").length,
    waiting: data.filter((t: any) => t.status === "waiting").length,
    resolved: data.filter((t: any) => t.status === "resolved").length,
  };

  return (
    <div className="p-6 md:p-8 space-y-6">
      <div>
        <h1 className="text-2xl font-semibold">Tickets</h1>
        <p className="text-sm text-muted-foreground mt-1">Support and internal issues.</p>
      </div>

      <div className="grid grid-cols-2 md:grid-cols-5 gap-3">
        <Kpi label="Open" value={cards.open} />
        <Kpi label="Assigned" value={cards.assigned} />
        <Kpi label="In Progress" value={cards.inProgress} />
        <Kpi label="Waiting" value={cards.waiting} />
        <Kpi label="Resolved" value={cards.resolved} />
      </div>

      <Card className="p-4">
        <Input
          placeholder="Search tickets…"
          value={q}
          onChange={(e) => setQ(e.target.value)}
          className="max-w-sm mb-4"
        />
        {filtered.length === 0 ? (
          <div className="text-sm text-muted-foreground py-12 text-center">No tickets</div>
        ) : (
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Ticket</TableHead>
                <TableHead>Customer</TableHead>
                <TableHead>Project</TableHead>
                <TableHead>Priority</TableHead>
                <TableHead>Assigned</TableHead>
                <TableHead>Status</TableHead>
                <TableHead className="text-right">Actions</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {filtered.map((t: any) => (
                <TableRow key={t.id}>
                  <TableCell>
                    <Link
                      to="/tickets/$ticketId"
                      params={{ ticketId: t.id }}
                      className="hover:underline"
                    >
                      <span className="text-muted-foreground mr-2">{t.ticket_code}</span>
                      {t.title}
                    </Link>
                  </TableCell>
                  <TableCell className="text-muted-foreground">
                    {t.customers?.name ?? "Self (Internal)"}
                  </TableCell>
                  <TableCell className="text-muted-foreground">{t.projects?.name ?? "—"}</TableCell>
                  <TableCell>
                    <PriorityBadge p={t.priority} />
                  </TableCell>
                  <TableCell className="text-muted-foreground">
                    {t.assignee?.full_name ?? "—"}
                  </TableCell>
                  <TableCell>
                    <StatusBadge s={t.status} />
                  </TableCell>
                  <TableCell className="text-right">
                    <ConfirmDeleteButton
                      itemLabel={t.title}
                      pending={deleteMut.isPending}
                      onConfirm={() => deleteMut.mutate(t.id)}
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

function Kpi({ label, value }: { label: string; value: number }) {
  return (
    <Card className="p-4">
      <div className="text-xs uppercase text-muted-foreground">{label}</div>
      <div className="text-2xl font-semibold mt-1">{value}</div>
    </Card>
  );
}
