import { createFileRoute } from "@tanstack/react-router";
import { useSuspenseQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { useState } from "react";
import { listServices, upsertService, deleteService } from "@/lib/erp.functions";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Switch } from "@/components/ui/switch";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogFooter,
} from "@/components/ui/dialog";
import { Plus, Trash2 } from "lucide-react";
import { toast } from "sonner";

export const Route = createFileRoute("/_authenticated/settings")({
  head: () => ({ meta: [{ title: "Settings — solv." }] }),
  component: SettingsPage,
});

type Svc = { id: string; name: string; parent_id: string | null; active: boolean };

function SettingsPage() {
  const qc = useQueryClient();
  const listFn = useServerFn(listServices);
  const upsertFn = useServerFn(upsertService);
  const delFn = useServerFn(deleteService);
  const { data } = useSuspenseQuery({ queryKey: ["services"], queryFn: () => listFn() });
  const [open, setOpen] = useState<{
    id?: string;
    name: string;
    parent_id: string | null;
    active: boolean;
  } | null>(null);

  const upMut = useMutation({
    mutationFn: (v: any) => upsertFn({ data: v }),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["services"] });
      setOpen(null);
      toast.success("Saved");
    },
    onError: (e: Error) => toast.error(e.message),
  });
  const delMut = useMutation({
    mutationFn: (id: string) => delFn({ data: { id } }),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["services"] });
      toast.success("Deleted");
    },
    onError: (e: Error) => toast.error(e.message),
  });

  const roots = data.filter((s: Svc) => !s.parent_id);
  const childrenOf = (id: string) => data.filter((s: Svc) => s.parent_id === id);

  return (
    <div className="p-6 md:p-8 space-y-6 max-w-4xl">
      <div>
        <h1 className="text-2xl font-semibold">Settings</h1>
        <p className="text-sm text-muted-foreground mt-1">Manage your services catalog.</p>
      </div>

      <Card className="p-6">
        <div className="flex items-center justify-between mb-4">
          <h2 className="font-medium">Services catalog</h2>
          <Button size="sm" onClick={() => setOpen({ name: "", parent_id: null, active: true })}>
            <Plus className="h-4 w-4 mr-1" /> New service
          </Button>
        </div>
        <ul className="space-y-2">
          {roots.map((s: Svc) => (
            <li key={s.id}>
              <Row s={s} onEdit={() => setOpen(s)} onDelete={() => delMut.mutate(s.id)} />
              <ul className="ml-6 mt-2 space-y-1 border-l pl-3">
                {childrenOf(s.id).map((c: Svc) => (
                  <li key={c.id}>
                    <Row s={c} onEdit={() => setOpen(c)} onDelete={() => delMut.mutate(c.id)} />
                  </li>
                ))}
                <li>
                  <button
                    className="text-xs text-muted-foreground hover:text-foreground"
                    onClick={() => setOpen({ name: "", parent_id: s.id, active: true })}
                  >
                    + Add sub-product
                  </button>
                </li>
              </ul>
            </li>
          ))}
        </ul>
      </Card>

      {open && (
        <Dialog open onOpenChange={(o) => !o && setOpen(null)}>
          <DialogContent>
            <DialogHeader>
              <DialogTitle>{open.id ? "Edit service" : "New service"}</DialogTitle>
            </DialogHeader>
            <div className="space-y-3">
              <div className="space-y-1">
                <Label>Name</Label>
                <Input
                  value={open.name}
                  onChange={(e) => setOpen({ ...open, name: e.target.value })}
                />
              </div>
              <div className="flex items-center justify-between">
                <Label>Active</Label>
                <Switch
                  checked={open.active}
                  onCheckedChange={(v) => setOpen({ ...open, active: v })}
                />
              </div>
            </div>
            <DialogFooter>
              <Button variant="ghost" onClick={() => setOpen(null)}>
                Cancel
              </Button>
              <Button disabled={!open.name} onClick={() => upMut.mutate(open)}>
                Save
              </Button>
            </DialogFooter>
          </DialogContent>
        </Dialog>
      )}
    </div>
  );
}

function Row({ s, onEdit, onDelete }: { s: Svc; onEdit: () => void; onDelete: () => void }) {
  return (
    <div className="flex items-center justify-between text-sm py-1">
      <button className="text-left flex-1 hover:underline" onClick={onEdit}>
        {s.name}{" "}
        {!s.active && <span className="text-xs text-muted-foreground ml-2">(inactive)</span>}
      </button>
      <button className="text-muted-foreground hover:text-destructive" onClick={onDelete}>
        <Trash2 className="h-4 w-4" />
      </button>
    </div>
  );
}
