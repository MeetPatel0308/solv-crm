import { createFileRoute, Link, useNavigate } from "@tanstack/react-router";
import { useSuspenseQuery, useMutation, useQueryClient, useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { useState, useEffect } from "react";
import {
  getProject,
  deleteProject,
  upsertProjectTimelineEvent,
  updateProjectManager,
  updateProjectDeadline,
  listTeam,
} from "@/lib/erp.functions";
import { Card } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Progress } from "@/components/ui/progress";
import { ArrowLeft, CalendarDays } from "lucide-react";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { ConfirmDeleteButton } from "@/components/confirm-delete-button";
import { toast } from "sonner";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogFooter,
} from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";

export const Route = createFileRoute("/_authenticated/projects/$projectId")({
  head: () => ({ meta: [{ title: "Project — solv." }] }),
  component: ProjectDetail,
});

const STAGES = [
  "Scope Approved",
  "Development Started",
  "Review",
  "Testing",
  "Completed",
  "Deployed",
];

function ProjectDetail() {
  const { projectId } = Route.useParams();
  const qc = useQueryClient();
  const navigate = useNavigate();
  const fn = useServerFn(getProject);
  const { data } = useSuspenseQuery({
    queryKey: ["project", projectId],
    queryFn: () => fn({ data: { id: projectId } }),
  });
  const { project, tickets, timeline, members } = data;
  const [selectedStage, setSelectedStage] = useState<string | null>(null);

  const getStageEvent = (stageName: string) => {
    return timeline.find((t: any) => t.stage === stageName);
  };

  const getTeam = useServerFn(listTeam);
  const { data: team = [] } = useQuery({
    queryKey: ["team"],
    queryFn: () => getTeam(),
  });

  const updateManagerFn = useServerFn(updateProjectManager);
  const updateManagerMut = useMutation({
    mutationFn: (newId: string) => updateManagerFn({ data: { id: projectId, project_manager_id: newId } }),
    onSuccess: () => {
      toast.success("Project Owner updated");
      qc.invalidateQueries({ queryKey: ["project", projectId] });
      qc.invalidateQueries({ queryKey: ["projects"] });
    },
    onError: (e: Error) => toast.error(e.message),
  });

  const updateDeadlineFn = useServerFn(updateProjectDeadline);
  const updateDeadlineMut = useMutation({
    mutationFn: (newDeadline: string) => updateDeadlineFn({ data: { id: projectId, deadline: newDeadline || null } }),
    onSuccess: () => {
      toast.success("Project Deadline updated");
      qc.invalidateQueries({ queryKey: ["project", projectId] });
      qc.invalidateQueries({ queryKey: ["projects"] });
    },
    onError: (e: Error) => toast.error(e.message),
  });

  const deleteFn = useServerFn(deleteProject);
  const deleteMut = useMutation({
    mutationFn: () => deleteFn({ data: { id: projectId } }),
    onSuccess: () => {
      toast.success("Project deleted");
      qc.invalidateQueries({ queryKey: ["projects"] });
      navigate({ to: "/projects" });
    },
    onError: (e: Error) => toast.error(e.message),
  });

  return (
    <div className="p-6 md:p-8 space-y-6 max-w-6xl">
      <Link
        to="/projects"
        className="text-sm text-muted-foreground hover:text-foreground inline-flex items-center gap-1"
      >
        <ArrowLeft className="h-4 w-4" /> Back to projects
      </Link>

      <div className="flex items-start justify-between gap-4">
        <div>
          <h1 className="text-2xl font-semibold">{project.name}</h1>
          <p className="text-sm text-muted-foreground mt-1 max-w-2xl">
            {project.description ?? "No description"}
          </p>
        </div>
        <div className="flex items-center gap-2">
          <Badge className="bg-brand/10 text-brand hover:bg-brand/20">
            {project.status !== "completed" && project.status !== "deployed" && project.deadline && new Date(project.deadline) < new Date()
              ? "overdue"
              : project.status.replace("_", " ")}
          </Badge>
          <ConfirmDeleteButton
            itemLabel={project.name}
            pending={deleteMut.isPending}
            onConfirm={() => deleteMut.mutate()}
            size="sm"
          />
        </div>
      </div>

      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <Card className="p-5">
          <div className="text-xs uppercase text-muted-foreground">Customer</div>
          <div className="text-sm font-medium mt-1">
            {project.customer_id ? (
              <Link to="/crm/$customerId" params={{ customerId: project.customer_id }} className="hover:underline text-brand">
                {project.customers?.name ?? "Unknown Customer"}
              </Link>
            ) : (
              "Self (Internal)"
            )}
          </div>
        </Card>
        <Card className="p-5">
          <div className="text-xs uppercase text-muted-foreground">Deadline</div>
          <div className="mt-1">
            <input
              type="date"
              value={project.deadline || ""}
              onChange={(e) => updateDeadlineMut.mutate(e.target.value)}
              disabled={updateDeadlineMut.isPending}
              className="w-full h-8 rounded-md border bg-background px-2 text-sm"
            />
          </div>
        </Card>
        <Card className="p-5">
          <div className="text-xs uppercase text-muted-foreground">Project Owner</div>
          <div className="mt-1">
            <select
              value={project.project_manager_id || ""}
              onChange={(e) => updateManagerMut.mutate(e.target.value)}
              disabled={updateManagerMut.isPending}
              className="w-full h-8 rounded-md border bg-background px-2 text-sm"
            >
              <option value="" disabled>-- Select Owner --</option>
              {team.map((t: any) => (
                <option key={t.id} value={t.id}>
                  {t.full_name}
                </option>
              ))}
            </select>
          </div>
        </Card>
        <Card className="p-5">
          <div className="flex justify-between items-center text-xs uppercase text-muted-foreground">
            <span>Progress</span>
            <span className="font-semibold text-foreground">{project.progress}%</span>
          </div>
          <Progress value={project.progress} className="mt-2" />
        </Card>
      </div>

      <Card className="p-6">
        <div className="flex justify-between items-center mb-6">
          <h2 className="font-medium">Project timeline</h2>
        </div>
        <div className="flex items-center gap-4 overflow-x-auto pb-2">
          {STAGES.map((s, i) => {
            const ev = getStageEvent(s);
            const prevCompleted = STAGES.slice(0, i).every((prevStage) => !!getStageEvent(prevStage));
            return (
              <button
                key={s}
                onClick={() => {
                  if (!prevCompleted) {
                    toast.error("Please complete previous stages first");
                    return;
                  }
                  setSelectedStage(s);
                }}
                className={`flex-1 min-w-[120px] flex flex-col items-center p-2.5 rounded-lg transition-all border border-transparent text-center ${prevCompleted ? "hover:bg-secondary/50 hover:border-border cursor-pointer group" : "opacity-50 cursor-not-allowed"}`}
              >
                <div
                  className={`w-8 h-8 rounded-full flex items-center justify-center text-xs font-semibold border-2 transition-all ${ev ? "bg-brand border-brand text-brand-foreground shadow-[0_0_10px_rgba(var(--brand-rgb),0.3)]" : (prevCompleted ? "bg-background border-muted-foreground text-muted-foreground group-hover:border-brand" : "bg-muted border-muted-foreground text-muted-foreground")}`}
                >
                  {i + 1}
                </div>
                <div className={`text-xs mt-2 font-medium transition-colors ${ev || !prevCompleted ? "text-foreground" : "text-foreground group-hover:text-brand"}`}>
                  {s}
                </div>
                <div className="text-[10px] text-muted-foreground mt-1">
                  {ev ? new Date(ev.event_at).toLocaleDateString() : "Set date"}
                </div>
              </button>
            );
          })}
        </div>
      </Card>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <Card className="p-6 md:col-span-2">
          <h2 className="font-medium mb-4">Open tickets</h2>
          {tickets.length === 0 ? (
            <div className="text-sm text-muted-foreground text-center py-4">
              No tickets on this project
            </div>
          ) : (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Ticket</TableHead>
                  <TableHead>Priority</TableHead>
                  <TableHead>Status</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {tickets.map((t: any) => (
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
                    <TableCell>
                      <Badge variant="secondary">{t.priority}</Badge>
                    </TableCell>
                    <TableCell>
                      <Badge variant="secondary">{t.status}</Badge>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          )}
        </Card>

        <Card className="p-6">
          <h2 className="font-medium mb-4">Team</h2>
          {members.length === 0 ? (
            <div className="text-sm text-muted-foreground">No members assigned</div>
          ) : (
            <ul className="space-y-2">
              {members.map((m: any) => (
                <li key={m.id} className="text-sm">
                  {m.user_profile?.full_name}{" "}
                  <span className="text-muted-foreground">— {m.role_label ?? "member"}</span>
                </li>
              ))}
            </ul>
          )}
        </Card>
      </div>
      {selectedStage && (
        <ProjectStageDateDialog
          projectId={projectId}
          stage={selectedStage}
          onClose={() => setSelectedStage(null)}
          currentDate={getStageEvent(selectedStage)?.event_at}
        />
      )}
    </div>
  );
}

function ProjectStageDateDialog({
  projectId,
  stage,
  onClose,
  currentDate,
}: {
  projectId: string;
  stage: string;
  onClose: () => void;
  currentDate?: string;
}) {
  const qc = useQueryClient();
  const [eventAt, setEventAt] = useState(
    currentDate
      ? new Date(currentDate).toISOString().split("T")[0]
      : new Date().toISOString().split("T")[0],
  );
  const fn = useServerFn(upsertProjectTimelineEvent);
  const m = useMutation({
    mutationFn: () => fn({ data: { projectId, stage, eventAt: new Date(eventAt).toISOString() } }),
    onSuccess: () => {
      toast.success(`Updated timeline for ${stage}`);
      qc.invalidateQueries();
      onClose();
    },
    onError: (e: Error) => toast.error(e.message),
  });

  return (
    <Dialog open onOpenChange={onClose}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Set Date for {stage}</DialogTitle>
        </DialogHeader>
        <div className="space-y-3 py-2">
          <div className="space-y-1">
            <Label>Date</Label>
            <Input type="date" value={eventAt} onChange={(e) => setEventAt(e.target.value)} />
          </div>
        </div>
        <DialogFooter>
          <Button variant="ghost" onClick={onClose}>
            Cancel
          </Button>
          <Button disabled={m.isPending} onClick={() => m.mutate()}>
            Save
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
