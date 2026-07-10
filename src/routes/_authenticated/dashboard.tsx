import { createFileRoute, Link } from "@tanstack/react-router";
import { useSuspenseQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { getDashboardStats, getLeadsSeries } from "@/lib/erp.functions";
import { Card } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { Users, FolderKanban, TicketCheck, Sparkles } from "lucide-react";
import { Progress } from "@/components/ui/progress";

export const Route = createFileRoute("/_authenticated/dashboard")({
  head: () => ({ meta: [{ title: "Dashboard — solv." }] }),
  component: DashboardPage,
});

function DashboardPage() {
  const statsFn = useServerFn(getDashboardStats);
  const { data: stats } = useSuspenseQuery({
    queryKey: ["dashboard-stats"],
    queryFn: () => statsFn(),
  });

  return (
    <div className="p-6 md:p-8 space-y-8 max-w-[1400px]">
      <div>
        <h1 className="text-2xl font-semibold tracking-tight">Dashboard</h1>
        <p className="text-sm text-muted-foreground mt-1">Overview of your business today.</p>
      </div>

      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
        <KpiCard label="Active Customers" value={stats.customersCount} icon={Users} />
        <KpiCard label="Active Projects" value={stats.projectsCount} icon={FolderKanban} />
        <KpiCard label="Open Tickets" value={stats.ticketsCount} icon={TicketCheck} />
        <KpiCard label="Leads This Month" value={stats.leadsCount} icon={Sparkles} />
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-4">
        <Card className="p-6 lg:col-span-2">
          <h2 className="font-medium mb-6">Lead Performance</h2>
          <div className="grid grid-cols-2 gap-8">
            <div className="space-y-2">
              <div className="text-sm text-muted-foreground">Conversion Rate</div>
              <div className="text-2xl font-semibold">{stats.leadPerformance?.conversionRate ?? 0}%</div>
              <Progress value={stats.leadPerformance?.conversionRate ?? 0} className="h-1.5 [&>div]:bg-emerald-500" />
            </div>
            <div className="space-y-2">
              <div className="text-sm text-muted-foreground">Average Time to Convert</div>
              <div className="text-2xl font-semibold">{stats.leadPerformance?.avgTimeToConvert ?? 0} Days</div>
            </div>
            <div className="space-y-2">
              <div className="text-sm text-muted-foreground">Lost Rate</div>
              <div className="text-2xl font-semibold">{stats.leadPerformance?.lostRate ?? 0}%</div>
              <Progress value={stats.leadPerformance?.lostRate ?? 0} className="h-1.5 [&>div]:bg-red-500" />
            </div>
            <div className="space-y-2">
              <div className="text-sm text-muted-foreground">New Leads This Month</div>
              <div className="text-2xl font-semibold">{stats.leadPerformance?.newLeadsThisMonth ?? 0}</div>
            </div>
          </div>
        </Card>

        <Card className="p-6">
          <h2 className="font-medium mb-4">Sales pipeline</h2>
          <div className="space-y-3">
            {stats.pipelineCounts.map((s) => (
              <div key={s.stage} className="flex items-center justify-between text-sm">
                <span className="capitalize text-muted-foreground">{s.stage}</span>
                <span className="font-medium">{s.count}</span>
              </div>
            ))}
          </div>
        </Card>
      </div>

      <Card className="p-6">
        <div className="flex items-center justify-between mb-4">
          <h2 className="font-medium">Open tickets</h2>
          <Link to="/tickets" className="text-xs text-muted-foreground hover:text-foreground">
            View all
          </Link>
        </div>
        {stats.openTickets.length === 0 ? (
          <div className="text-sm text-muted-foreground py-8 text-center">No open tickets</div>
        ) : (
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Ticket</TableHead>
                <TableHead>Customer</TableHead>
                <TableHead>Project</TableHead>
                <TableHead>Priority</TableHead>
                <TableHead>Status</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {stats.openTickets.map((t: any) => (
                <TableRow key={t.id} className="cursor-pointer">
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
                    {t.customers?.name ?? "—"}
                  </TableCell>
                  <TableCell className="text-muted-foreground">{t.projects?.name ?? "—"}</TableCell>
                  <TableCell>
                    <PriorityBadge p={t.priority} />
                  </TableCell>
                  <TableCell>
                    <StatusBadge s={t.status} />
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

function KpiCard({ label, value, icon: Icon }: { label: string; value: number; icon: any }) {
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

export function PriorityBadge({ p }: { p: string }) {
  const map: Record<string, string> = {
    low: "bg-muted text-muted-foreground",
    medium: "bg-blue-100 text-blue-700",
    high: "bg-orange-100 text-orange-700",
    urgent: "bg-red-100 text-red-700",
  };
  return (
    <Badge variant="secondary" className={map[p] ?? ""}>
      {p}
    </Badge>
  );
}

export function StatusBadge({ s }: { s: string }) {
  const map: Record<string, string> = {
    new: "bg-slate-100 text-slate-700",
    assigned: "bg-blue-100 text-blue-700",
    in_progress: "bg-brand/10 text-brand",
    waiting: "bg-amber-100 text-amber-700",
    resolved: "bg-emerald-100 text-emerald-700",
    closed: "bg-muted text-muted-foreground",
  };
  return (
    <Badge variant="secondary" className={map[s] ?? ""}>
      {s.replace("_", " ")}
    </Badge>
  );
}
