import { createFileRoute } from "@tanstack/react-router";
import { useSuspenseQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { getReports } from "@/lib/erp.functions";
import { Card } from "@/components/ui/card";
import { BarChart, Bar, ResponsiveContainer, XAxis, YAxis, Tooltip, CartesianGrid } from "recharts";

export const Route = createFileRoute("/_authenticated/reports")({
  head: () => ({ meta: [{ title: "Reports — solv." }] }),
  component: ReportsPage,
});

function ReportsPage() {
  const fn = useServerFn(getReports);
  const { data } = useSuspenseQuery({ queryKey: ["reports"], queryFn: () => fn() });

  return (
    <div className="p-6 md:p-8 space-y-6 max-w-6xl">
      <div>
        <h1 className="text-2xl font-semibold">Reports</h1>
        <p className="text-sm text-muted-foreground mt-1">Business analytics.</p>
      </div>

      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <Kpi label="Total Leads" value={data.totalLeads} />
        <Kpi label="Converted" value={data.converted} />
        <Kpi label="Conversion %" value={`${data.conversion}%`} />
        <Kpi label="Avg days to convert" value={data.avgDaysToConvert} />
      </div>

      <div className="grid grid-cols-2 md:grid-cols-2 gap-4">
        <Kpi label="Total Tickets" value={data.ticketCount} />
        <Kpi label="Open Tickets" value={data.openTickets} />
      </div>

      <Card className="p-6">
        <h2 className="font-medium mb-4">Projects by status</h2>
        <div className="h-72">
          <ResponsiveContainer>
            <BarChart data={data.projectStatus}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="name" fontSize={11} />
              <YAxis fontSize={11} />
              <Tooltip />
              <Bar dataKey="value" fill="var(--color-brand)" radius={[6, 6, 0, 0]} />
            </BarChart>
          </ResponsiveContainer>
        </div>
      </Card>
    </div>
  );
}

function Kpi({ label, value }: { label: string; value: number | string }) {
  return (
    <Card className="p-5">
      <div className="text-xs uppercase text-muted-foreground">{label}</div>
      <div className="text-3xl font-semibold mt-1">{value}</div>
    </Card>
  );
}
