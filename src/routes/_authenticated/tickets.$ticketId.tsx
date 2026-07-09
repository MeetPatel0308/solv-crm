import { createFileRoute, Link, useNavigate } from "@tanstack/react-router";
import { useSuspenseQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { useRef, useState } from "react";
import {
  getTicket,
  updateTicketStatus,
  addTicketComment,
  addTicketAttachment,
  deleteTicket,
} from "@/lib/erp.functions";
import { supabase } from "@/integrations/supabase/client";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import { ArrowLeft, Paperclip } from "lucide-react";
import { PriorityBadge, StatusBadge } from "./dashboard";
import { ConfirmDeleteButton } from "@/components/confirm-delete-button";
import { toast } from "sonner";

export const Route = createFileRoute("/_authenticated/tickets/$ticketId")({
  head: () => ({ meta: [{ title: "Ticket — solv." }] }),
  component: TicketDetail,
});

const STATUSES = ["new", "assigned", "in_progress", "waiting", "resolved", "closed"];

function TicketDetail() {
  const { ticketId } = Route.useParams();
  const qc = useQueryClient();
  const navigate = useNavigate();
  const fn = useServerFn(getTicket);
  const updateFn = useServerFn(updateTicketStatus);
  const commentFn = useServerFn(addTicketComment);
  const attachFn = useServerFn(addTicketAttachment);
  const deleteFn = useServerFn(deleteTicket);
  const { data } = useSuspenseQuery({
    queryKey: ["ticket", ticketId],
    queryFn: () => fn({ data: { id: ticketId } }),
  });
  const { ticket, comments, attachments } = data;
  const [body, setBody] = useState("");
  const fileRef = useRef<HTMLInputElement>(null);
  const [uploading, setUploading] = useState(false);

  const deleteMut = useMutation({
    mutationFn: () => deleteFn({ data: { id: ticketId } }),
    onSuccess: () => {
      toast.success("Ticket deleted");
      qc.invalidateQueries({ queryKey: ["tickets"] });
      navigate({ to: "/tickets" });
    },
    onError: (e: Error) => toast.error(e.message),
  });

  const commentMut = useMutation({
    mutationFn: () => commentFn({ data: { ticketId, body } }),
    onSuccess: () => {
      setBody("");
      qc.invalidateQueries({ queryKey: ["ticket", ticketId] });
    },
    onError: (e: Error) => toast.error(e.message),
  });

  const statusMut = useMutation({
    mutationFn: (status: string) => updateFn({ data: { id: ticketId, status } }),
    onSuccess: () => {
      toast.success("Status updated");
      qc.invalidateQueries({ queryKey: ["ticket", ticketId] });
      qc.invalidateQueries({ queryKey: ["tickets"] });
    },
    onError: (e: Error) => toast.error(e.message),
  });

  async function handleFile(e: React.ChangeEvent<HTMLInputElement>) {
    const file = e.target.files?.[0];
    if (!file) return;
    setUploading(true);
    const path = `tickets/${ticketId}/${Date.now()}-${file.name}`;
    const { error } = await supabase.storage.from("ticket-attachments").upload(path, file);
    if (error) {
      setUploading(false);
      return toast.error(error.message);
    }
    await attachFn({
      data: {
        ticketId,
        fileName: file.name,
        storagePath: path,
        contentType: file.type,
        sizeBytes: file.size,
      },
    });
    setUploading(false);
    if (fileRef.current) fileRef.current.value = "";
    qc.invalidateQueries({ queryKey: ["ticket", ticketId] });
    toast.success("Attachment uploaded");
  }

  return (
    <div className="p-6 md:p-8 space-y-6 max-w-5xl">
      <Link
        to="/tickets"
        className="text-sm text-muted-foreground hover:text-foreground inline-flex items-center gap-1"
      >
        <ArrowLeft className="h-4 w-4" /> Back to tickets
      </Link>

      <div className="flex items-start justify-between gap-4">
        <div>
          <div className="text-xs text-muted-foreground">{ticket.ticket_code}</div>
          <h1 className="text-2xl font-semibold mt-1">{ticket.title}</h1>
          <p className="text-sm text-muted-foreground mt-2 max-w-2xl">
            {ticket.description ?? "No description"}
          </p>
        </div>
        <div className="flex flex-col items-end gap-2">
          <div className="flex items-center gap-2">
            <PriorityBadge p={ticket.priority} />
            <StatusBadge s={ticket.status} />
          </div>
          <ConfirmDeleteButton
            itemLabel={ticket.title}
            pending={deleteMut.isPending}
            onConfirm={() => deleteMut.mutate()}
            size="sm"
          />
        </div>
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-4">
        <Card className="p-5">
          <div className="text-xs uppercase text-muted-foreground">Customer</div>
          <div className="text-sm font-medium mt-1">
            {ticket.customers?.name ?? "Self (Internal)"}
          </div>
        </Card>
        <Card className="p-5">
          <div className="text-xs uppercase text-muted-foreground">Project</div>
          <div className="text-sm font-medium mt-1">{ticket.projects?.name ?? "—"}</div>
        </Card>
        <Card className="p-5">
          <div className="text-xs uppercase text-muted-foreground">Dates</div>
          <div className="text-sm font-medium mt-1">
            <div className="text-xs text-muted-foreground">
              Start: {ticket.start_date ? new Date(ticket.start_date).toLocaleDateString() : "—"}
            </div>
            <div className="text-xs text-muted-foreground">
              End: {ticket.end_date ? new Date(ticket.end_date).toLocaleDateString() : "—"}
            </div>
          </div>
        </Card>
        <Card className="p-5">
          <div className="text-xs uppercase text-muted-foreground">Assignee</div>
          <div className="text-sm font-medium mt-1">{ticket.assignee?.full_name ?? "—"}</div>
        </Card>
      </div>

      <Card className="p-5">
        <div className="flex items-center gap-2 flex-wrap">
          <span className="text-xs uppercase text-muted-foreground mr-2">Set status:</span>
          {STATUSES.map((s) => (
            <Button
              key={s}
              variant={ticket.status === s ? "default" : "outline"}
              size="sm"
              onClick={() => statusMut.mutate(s)}
            >
              {s.replace("_", " ")}
            </Button>
          ))}
        </div>
      </Card>

      <Card className="p-6">
        <h2 className="font-medium mb-4">Comments</h2>
        <div className="space-y-3 mb-4">
          {comments.length === 0 && (
            <div className="text-sm text-muted-foreground">No comments yet</div>
          )}
          {comments.map((c: any) => (
            <div key={c.id} className="text-sm border-l-2 border-border pl-3">
              <div className="text-xs text-muted-foreground">
                {c.author?.full_name ?? "User"} · {new Date(c.created_at).toLocaleString()}
              </div>
              <div>{c.body}</div>
            </div>
          ))}
        </div>
        <Textarea
          placeholder="Add a comment…"
          value={body}
          onChange={(e) => setBody(e.target.value)}
        />
        <div className="mt-2 flex justify-end">
          <Button
            size="sm"
            disabled={!body || commentMut.isPending}
            onClick={() => commentMut.mutate()}
          >
            Comment
          </Button>
        </div>
      </Card>

      <Card className="p-6">
        <div className="flex items-center justify-between mb-4">
          <h2 className="font-medium">Attachments</h2>
          <label className="cursor-pointer">
            <input ref={fileRef} type="file" hidden onChange={handleFile} disabled={uploading} />
            <Button size="sm" variant="outline" asChild>
              <span>
                <Paperclip className="h-4 w-4 mr-1" />
                {uploading ? "Uploading…" : "Upload"}
              </span>
            </Button>
          </label>
        </div>
        {attachments.length === 0 ? (
          <div className="text-sm text-muted-foreground">No attachments</div>
        ) : (
          <ul className="space-y-2">
            {attachments.map((a: any) => (
              <li key={a.id} className="text-sm flex items-center justify-between">
                <span>
                  {a.file_name}{" "}
                  <span className="text-muted-foreground text-xs">
                    ({Math.round((a.size_bytes ?? 0) / 1024)} KB)
                  </span>
                </span>
                {a.signed_url && (
                  <a
                    href={a.signed_url}
                    target="_blank"
                    rel="noreferrer"
                    className="text-brand hover:underline text-xs"
                  >
                    Download
                  </a>
                )}
              </li>
            ))}
          </ul>
        )}
      </Card>
    </div>
  );
}
