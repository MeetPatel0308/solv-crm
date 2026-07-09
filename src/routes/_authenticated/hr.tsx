import { createFileRoute } from "@tanstack/react-router";
import { useSuspenseQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { listTeam, setUserRole } from "@/lib/erp.functions";
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
import { Switch } from "@/components/ui/switch";
import { toast } from "sonner";

export const Route = createFileRoute("/_authenticated/hr")({
  head: () => ({ meta: [{ title: "HR / Team — solv." }] }),
  component: HrPage,
});

const ROLES = ["admin", "sales", "project_manager", "support", "hr"] as const;

function HrPage() {
  const qc = useQueryClient();
  const fn = useServerFn(listTeam);
  const roleFn = useServerFn(setUserRole);
  const { data } = useSuspenseQuery({ queryKey: ["team"], queryFn: () => fn() });
  const m = useMutation({
    mutationFn: (v: { userId: string; role: string; enabled: boolean }) => roleFn({ data: v }),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["team"] });
      toast.success("Role updated");
    },
    onError: (e: Error) => toast.error(e.message),
  });

  return (
    <div className="p-6 md:p-8 space-y-6">
      <div>
        <h1 className="text-2xl font-semibold">Team</h1>
        <p className="text-sm text-muted-foreground mt-1">Manage employees, roles, and workload.</p>
      </div>
      <Card className="p-4">
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Name</TableHead>
              <TableHead>Email</TableHead>
              <TableHead>Roles</TableHead>
              <TableHead>Active Projects</TableHead>
              <TableHead>Open Tickets</TableHead>
              <TableHead>Leave</TableHead>
              <TableHead>Assign roles</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {data.map((p: any) => (
              <TableRow key={p.id}>
                <TableCell className="font-medium">{p.full_name ?? "—"}</TableCell>
                <TableCell className="text-muted-foreground">{p.email}</TableCell>
                <TableCell>
                  {p.roles.map((r: string) => (
                    <Badge key={r} variant="secondary" className="mr-1">
                      {r.replace("_", " ")}
                    </Badge>
                  ))}
                </TableCell>
                <TableCell>{p.activeProjects}</TableCell>
                <TableCell>{p.openTickets}</TableCell>
                <TableCell className="text-muted-foreground">{p.leave_status ?? "—"}</TableCell>
                <TableCell>
                  <div className="flex flex-wrap gap-2">
                    {ROLES.map((r) => (
                      <label key={r} className="flex items-center gap-1 text-xs">
                        <Switch
                          checked={p.roles.includes(r)}
                          onCheckedChange={(checked) =>
                            m.mutate({ userId: p.id, role: r, enabled: checked })
                          }
                        />
                        {r.replace("_", " ")}
                      </label>
                    ))}
                  </div>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </Card>
    </div>
  );
}
