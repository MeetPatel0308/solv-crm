import { createFileRoute, Link } from "@tanstack/react-router";
import { useSuspenseQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { listProjects, deleteProject } from "@/lib/erp.functions";
import { Card } from "@/components/ui/card";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { Badge } from "@/components/ui/badge";
import { Progress } from "@/components/ui/progress";
import { ConfirmDeleteButton } from "@/components/confirm-delete-button";
import { PieChart, Pie, Cell, ResponsiveContainer, Tooltip } from "recharts";
import { toast } from "sonner";

export const Route = createFileRoute("/_authenticated/projects/")({
  head: () => ({ meta: [{ title: "Projects — solv." }] }),
  component: ProjectsList,
});

const COLORS = ["#22C55E", "#3B82F6", "#F59E0B", "#8B5CF6", "#EF4444", "#94A3B8"];

function ProjectsList() {
  const qc = useQueryClient();
  const fn = useServerFn(listProjects);
  const { data } = useSuspenseQuery({ queryKey: ["projects"], queryFn: () => fn() });
  const deleteFn = useServerFn(deleteProject);
  const deleteMut = useMutation({
    mutationFn: (id: string) => deleteFn({ data: { id } }),
    onSuccess: () => {
      toast.success("Project deleted");
      qc.invalidateQueries();
    },
    onError: (e: Error) => toast.error(e.message),
  });
  const kpis = {
    total: data.length,
    inProgress: data.filter((p: any) => p.status === "in_progress").length,
    completed: data.filter((p: any) => p.status === "completed").length,
    overdue: data.filter((p: any) => p.status === "overdue").length,
  };
  const donut = ["planning", "in_progress", "testing", "completed", "deployed", "on_hold", "overdue"].map(
    (s) => ({
      name: s,
      value: data.filter((p: any) => p.status === s).length,
    }),
  );

  return (
    <div className="p-6 md:p-8 space-y-6">
      <div>
        <h1 className="text-2xl font-semibold">Projects</h1>
        <p className="text-sm text-muted-foreground mt-1">
          Track project progress across the business.
        </p>
      </div>

      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <Kpi label="Total" value={kpis.total} />
        <Kpi label="In Progress" value={kpis.inProgress} />
        <Kpi label="Completed" value={kpis.completed} />
        <Kpi label="Overdue" value={kpis.overdue} />
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-4">
        <Card className="p-6 lg:col-span-2">
          <h2 className="font-medium mb-4">All projects</h2>
          {data.length === 0 ? (
            <div className="text-sm text-muted-foreground py-8 text-center">No projects yet</div>
          ) : (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Project</TableHead>
                  <TableHead>Customer</TableHead>
                  <TableHead>Status</TableHead>
                  <TableHead>Progress</TableHead>
                  <TableHead>Deadline</TableHead>
                  <TableHead className="text-right">Actions</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {data.map((p: any) => (
                  <TableRow key={p.id}>
                    <TableCell>
                      <Link
                        to="/projects/$projectId"
                        params={{ projectId: p.id }}
                        className="font-medium hover:underline"
                      >
                        {p.name}
                      </Link>
                    </TableCell>
                    <TableCell className="text-muted-foreground">
                      {p.customers?.name ?? "—"}
                    </TableCell>
                    <TableCell>
                      <Badge variant="secondary">{p.status.replace("_", " ")}</Badge>
                    </TableCell>
                    <TableCell>
                      <Progress value={p.progress} className="w-24" />
                    </TableCell>
                    <TableCell className="text-muted-foreground">{p.deadline ?? "—"}</TableCell>
                    <TableCell className="text-right">
                      <ConfirmDeleteButton
                        itemLabel={p.name}
                        pending={deleteMut.isPending}
                        onConfirm={() => deleteMut.mutate(p.id)}
                      />
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          )}
        </Card>

        <Card className="p-6">
          <h2 className="font-medium mb-4">By status</h2>
          <div className="h-56">
            <ResponsiveContainer>
              <PieChart>
                <Pie data={donut} dataKey="value" nameKey="name" innerRadius={40} outerRadius={70}>
                  {donut.map((_, i) => (
                    <Cell key={i} fill={COLORS[i % COLORS.length]} />
                  ))}
                </Pie>
                <Tooltip />
              </PieChart>
            </ResponsiveContainer>
          </div>
          <ul className="text-xs space-y-1 mt-2">
            {donut.map((d, i) => (
              <li key={d.name} className="flex items-center justify-between">
                <span className="flex items-center gap-2">
                  <span
                    className="w-2 h-2 rounded-full"
                    style={{ background: COLORS[i % COLORS.length] }}
                  />
                  {d.name.replace("_", " ")}
                </span>
                <span>{d.value}</span>
              </li>
            ))}
          </ul>
        </Card>
      </div>
    </div>
  );
}

function Kpi({ label, value }: { label: string; value: number }) {
  return (
    <Card className="p-5">
      <div className="text-xs uppercase text-muted-foreground">{label}</div>
      <div className="text-3xl font-semibold mt-1">{value}</div>
    </Card>
  );
}
