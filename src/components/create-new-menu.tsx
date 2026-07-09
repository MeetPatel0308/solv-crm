import { useState, type ReactNode } from "react";
import { useNavigate } from "@tanstack/react-router";
import { useMutation, useQueryClient, useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogFooter,
} from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import { Users, FolderKanban, TicketCheck, Sparkles } from "lucide-react";
import { toast } from "sonner";
import {
  createCustomer,
  createLead,
  createCustomService,
  createProject,
  createTicket,
  listCustomers,
  listProjects,
  listServices,
  listTeam,
} from "@/lib/erp.functions";

type Role = "admin" | "sales" | "project_manager" | "support" | "hr";
type Kind = "customer" | "lead" | "project" | "ticket" | null;

export function CreateNewMenu({ children, roles }: { children: ReactNode; roles: Role[] }) {
  const [open, setOpen] = useState<Kind>(null);
  const canCRM = roles.includes("admin") || roles.includes("sales");
  const canPM = roles.includes("admin") || roles.includes("project_manager");
  const canTicket = canPM || roles.includes("support");

  return (
    <>
      <DropdownMenu>
        <DropdownMenuTrigger asChild>{children}</DropdownMenuTrigger>
        <DropdownMenuContent align="end" className="w-56">
          {canCRM && (
            <DropdownMenuItem onSelect={() => setOpen("customer")}>
              <Users className="h-4 w-4 mr-2" /> New Customer
            </DropdownMenuItem>
          )}
          {canCRM && (
            <DropdownMenuItem onSelect={() => setOpen("lead")}>
              <Sparkles className="h-4 w-4 mr-2" /> New Lead
            </DropdownMenuItem>
          )}
          {canPM && (
            <DropdownMenuItem onSelect={() => setOpen("project")}>
              <FolderKanban className="h-4 w-4 mr-2" /> New Project
            </DropdownMenuItem>
          )}
          {canTicket && (
            <DropdownMenuItem onSelect={() => setOpen("ticket")}>
              <TicketCheck className="h-4 w-4 mr-2" /> New Ticket
            </DropdownMenuItem>
          )}
        </DropdownMenuContent>
      </DropdownMenu>

      {open === "customer" && <CustomerDialog onClose={() => setOpen(null)} />}
      {open === "lead" && <LeadDialog onClose={() => setOpen(null)} />}
      {open === "project" && <ProjectDialog onClose={() => setOpen(null)} />}
      {open === "ticket" && <TicketDialog onClose={() => setOpen(null)} />}
    </>
  );
}

function CustomerDialog({ onClose }: { onClose: () => void }) {
  const qc = useQueryClient();
  const nav = useNavigate();
  const [name, setName] = useState("");
  const [industry, setIndustry] = useState("");
  const [email, setEmail] = useState("");
  const fn = useServerFn(createCustomer);
  const m = useMutation({
    mutationFn: () =>
      fn({ data: { name, industry: industry || null, contactEmail: email || null } }),
    onSuccess: (row) => {
      toast.success("Customer created");
      qc.invalidateQueries();
      onClose();
      nav({ to: "/crm/$customerId", params: { customerId: row.id } });
    },
    onError: (e: Error) => toast.error(e.message),
  });
  return (
    <Dialog open onOpenChange={onClose}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>New Customer</DialogTitle>
        </DialogHeader>
        <div className="space-y-3">
          <div className="space-y-1">
            <Label>Name</Label>
            <Input value={name} onChange={(e) => setName(e.target.value)} />
          </div>
          <div className="space-y-1">
            <Label>Industry</Label>
            <Input value={industry} onChange={(e) => setIndustry(e.target.value)} />
          </div>
          <div className="space-y-1">
            <Label>Contact Email</Label>
            <Input type="email" value={email} onChange={(e) => setEmail(e.target.value)} />
          </div>
        </div>
        <DialogFooter>
          <Button variant="ghost" onClick={onClose}>
            Cancel
          </Button>
          <Button disabled={!name || m.isPending} onClick={() => m.mutate()}>
            Create
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

function LeadDialog({ onClose }: { onClose: () => void }) {
  const qc = useQueryClient();
  const [name, setName] = useState("");
  const [leadType, setLeadType] = useState<"new" | "existing">("new");
  const [company, setCompany] = useState("");
  const [customerId, setCustomerId] = useState("");
  const [email, setEmail] = useState("");
  const [stage, setStage] = useState("cold");
  const [source, setSource] = useState("");
  const [phone, setPhone] = useState("");
  const [notes, setNotes] = useState("");
  const [assignedTo, setAssignedTo] = useState("");
  
  const [selectedServices, setSelectedServices] = useState<string[]>([]);
  const [showCustom, setShowCustom] = useState(false);
  const [customService, setCustomService] = useState("");
  
  const fn = useServerFn(createLead);
  const customSrvFn = useServerFn(createCustomService);
  
  const getCusts = useServerFn(listCustomers);
  const { data: customers = [] } = useQuery({
    queryKey: ["customers"],
    queryFn: () => getCusts(),
  });

  const getSrvs = useServerFn(listServices);
  const { data: availableServices = [] } = useQuery({
    queryKey: ["services"],
    queryFn: () => getSrvs(),
  });

  const getTeam = useServerFn(listTeam);
  const { data: team = [] } = useQuery({
    queryKey: ["team"],
    queryFn: () => getTeam(),
  });

  const m = useMutation({
    mutationFn: async () => {
      const finalServiceIds = [...selectedServices];
      if (showCustom && customService.trim()) {
        const newId = await customSrvFn({ data: { name: customService.trim() } });
        finalServiceIds.push(newId);
      }
      
      const finalName = leadType === "existing" 
        ? (customers.find((c: any) => c.id === customerId)?.name || "Unknown")
        : name;

      return fn({
        data: {
          name: finalName,
          company: leadType === "existing" ? "" : (company || null),
          email: leadType === "existing" ? null : (email || null),
          phone: leadType === "existing" ? null : (phone || null),
          value: 0,
          stage,
          source,
          customer_id: leadType === "existing" ? (customerId || null) : null,
          service_ids: finalServiceIds,
          assigned_to: assignedTo || null,
          notes: notes || null,
        },
      });
    },
    onSuccess: () => {
      toast.success("Lead created");
      qc.invalidateQueries();
      onClose();
    },
    onError: (e: Error) => toast.error(e.message),
  });
  return (
    <Dialog open onOpenChange={onClose}>
      <DialogContent className="sm:max-w-[500px]">
        <DialogHeader>
          <DialogTitle>New Lead</DialogTitle>
        </DialogHeader>
        <div className="space-y-4 max-h-[70vh] overflow-y-auto pr-4">
          <div className="space-y-2">
            <Label>Lead Type</Label>
            <div className="flex gap-4">
              <label className="flex items-center gap-2 text-sm">
                <input 
                  type="radio" 
                  checked={leadType === "new"} 
                  onChange={() => {
                    setLeadType("new");
                    setCustomerId("");
                  }} 
                />
                New Company
              </label>
              <label className="flex items-center gap-2 text-sm">
                <input 
                  type="radio" 
                  checked={leadType === "existing"} 
                  onChange={() => {
                    setLeadType("existing");
                    setCompany("");
                  }} 
                />
                Existing Customer
              </label>
            </div>
          </div>
          {leadType === "new" && (
            <div className="space-y-1">
              <Label>Contact Name</Label>
              <Input value={name} onChange={(e) => setName(e.target.value)} />
            </div>
          )}

          {leadType === "new" ? (
            <div className="space-y-1">
              <Label>Company Name</Label>
              <Input 
                value={company} 
                onChange={(e) => setCompany(e.target.value)} 
                placeholder="Company Name..."
              />
            </div>
          ) : (
            <div className="space-y-1">
              <Label>Select Customer</Label>
              <select
                value={customerId}
                onChange={(e) => setCustomerId(e.target.value)}
                className="w-full h-9 rounded-md border bg-background px-3 text-sm"
              >
                <option value="" disabled>-- Select Customer --</option>
                {customers.map((c: any) => (
                  <option key={c.id} value={c.id}>
                    {c.name}
                  </option>
                ))}
              </select>
            </div>
          )}
          
          <div className="space-y-2">
            <Label>Interested Services</Label>
            <div className="border rounded-md p-3 space-y-2 max-h-[200px] overflow-y-auto bg-background">
              {availableServices.map((s: any) => {
                const isSelected = selectedServices.includes(s.id);
                return (
                  <label key={s.id} className="flex items-center gap-2 text-sm cursor-pointer hover:bg-slate-50 p-1 rounded">
                    <input 
                      type="checkbox" 
                      checked={isSelected}
                      onChange={() => {
                        if (isSelected) setSelectedServices((prev) => prev.filter((id) => id !== s.id));
                        else setSelectedServices((prev) => [...prev, s.id]);
                      }}
                      className="accent-brand h-4 w-4 rounded border-gray-300"
                    />
                    {s.name}
                  </label>
                );
              })}
              <label className="flex items-center gap-2 text-sm cursor-pointer hover:bg-slate-50 p-1 rounded">
                <input 
                  type="checkbox" 
                  checked={showCustom}
                  onChange={() => setShowCustom(!showCustom)}
                  className="accent-brand h-4 w-4 rounded border-gray-300"
                />
                Other...
              </label>
            </div>
            {showCustom && (
              <div className="mt-2 space-y-1">
                <Label>Custom Service</Label>
                <Input
                  value={customService}
                  onChange={(e) => setCustomService(e.target.value)}
                  placeholder="Enter service name..."
                />
              </div>
            )}
          </div>
          
          {leadType === "new" && (
            <div className="grid grid-cols-2 gap-3">
              <div className="space-y-1">
                <Label>Email</Label>
                <Input type="email" value={email} onChange={(e) => setEmail(e.target.value)} />
              </div>
              <div className="space-y-1">
                <Label>Phone</Label>
                <Input type="tel" value={phone} onChange={(e) => setPhone(e.target.value)} />
              </div>
            </div>
          )}
          
          <div className="grid grid-cols-2 gap-3">
            <div className="space-y-1">
              <Label>Status</Label>
              <select
                value={stage}
                onChange={(e) => setStage(e.target.value)}
                className="w-full h-9 rounded-md border bg-background px-3 text-sm"
              >
                <option value="lead_created">Lead Created</option>
                <option value="cold">Cold</option>
                <option value="warm">Warm</option>
                <option value="hot">Hot</option>
                <option value="proposal">Proposal</option>
                <option value="negotiation">Negotiation</option>
                <option value="converted">Converted</option>
                <option value="lost">Lost</option>
              </select>
            </div>
            <div className="space-y-1">
              <Label>Lead Source</Label>
              <select
                value={source}
                onChange={(e) => setSource(e.target.value)}
                className="w-full h-9 rounded-md border bg-background px-3 text-sm"
              >
                <option value="" disabled>Select a source…</option>
                <option value="email">Email</option>
                <option value="ads">Ads</option>
                <option value="referral">Referral</option>
              </select>
            </div>
            <div className="space-y-1 col-span-2">
              <Label>Assigned Team Member</Label>
              <select
                value={assignedTo}
                onChange={(e) => setAssignedTo(e.target.value)}
                className="w-full h-9 rounded-md border bg-background px-3 text-sm"
              >
                <option value="">-- Unassigned --</option>
                {team.map((t: any) => (
                  <option key={t.id} value={t.id}>
                    {t.full_name || t.email}
                  </option>
                ))}
              </select>
            </div>
          </div>
          <div className="space-y-1">
            <Label>Notes</Label>
            <Input value={notes} onChange={(e) => setNotes(e.target.value)} />
          </div>
        </div>
        <DialogFooter>
          <Button variant="ghost" onClick={onClose}>
            Cancel
          </Button>
          <Button 
            disabled={(leadType === "new" && !name) || (leadType === "existing" && !customerId) || !source || m.isPending} 
            onClick={() => m.mutate()}
          >
            {m.isPending ? "Creating..." : "Create"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

function ProjectDialog({ onClose }: { onClose: () => void }) {
  const qc = useQueryClient();
  const nav = useNavigate();
  const [name, setName] = useState("");
  const [description, setDescription] = useState("");
  const [deadline, setDeadline] = useState("");
  const fn = useServerFn(createProject);
  const m = useMutation({
    mutationFn: () =>
      fn({ data: { name, description: description || null, deadline: deadline || null } }),
    onSuccess: (row) => {
      toast.success("Project created");
      qc.invalidateQueries();
      onClose();
      nav({ to: "/projects/$projectId", params: { projectId: row.id } });
    },
    onError: (e: Error) => toast.error(e.message),
  });
  return (
    <Dialog open onOpenChange={onClose}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>New Project</DialogTitle>
        </DialogHeader>
        <div className="space-y-3">
          <div className="space-y-1">
            <Label>Name</Label>
            <Input value={name} onChange={(e) => setName(e.target.value)} />
          </div>
          <div className="space-y-1">
            <Label>Description</Label>
            <Textarea value={description} onChange={(e) => setDescription(e.target.value)} />
          </div>
          <div className="space-y-1">
            <Label>Deadline</Label>
            <Input type="date" value={deadline} onChange={(e) => setDeadline(e.target.value)} />
          </div>
        </div>
        <DialogFooter>
          <Button variant="ghost" onClick={onClose}>
            Cancel
          </Button>
          <Button disabled={!name || m.isPending} onClick={() => m.mutate()}>
            Create
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

function TicketDialog({ onClose }: { onClose: () => void }) {
  const qc = useQueryClient();
  const nav = useNavigate();
  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");
  const [priority, setPriority] = useState("medium");
  const [customerId, setCustomerId] = useState("self");
  const [projectId, setProjectId] = useState("");
  const [startDate, setStartDate] = useState("");
  const [endDate, setEndDate] = useState("");

  const listCustomersFn = useServerFn(listCustomers);
  const listProjectsFn = useServerFn(listProjects);

  const { data: customers = [] } = useQuery({
    queryKey: ["customers"],
    queryFn: () => listCustomersFn(),
  });

  const { data: projects = [] } = useQuery({
    queryKey: ["projects"],
    queryFn: () => listProjectsFn(),
  });

  const fn = useServerFn(createTicket);
  const m = useMutation({
    mutationFn: () =>
      fn({
        data: {
          title,
          description: description || null,
          priority,
          customerId: customerId === "self" ? null : customerId,
          projectId: projectId || null,
          startDate: startDate || null,
          endDate: endDate || null,
        },
      }),
    onSuccess: (row) => {
      toast.success("Ticket created");
      qc.invalidateQueries();
      onClose();
      nav({ to: "/tickets/$ticketId", params: { ticketId: row.id } });
    },
    onError: (e: Error) => toast.error(e.message),
  });
  return (
    <Dialog open onOpenChange={onClose}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>New Ticket</DialogTitle>
        </DialogHeader>
        <div className="space-y-3">
          <div className="space-y-1">
            <Label>Title</Label>
            <Input value={title} onChange={(e) => setTitle(e.target.value)} />
          </div>
          <div className="space-y-1">
            <Label>Description</Label>
            <Textarea value={description} onChange={(e) => setDescription(e.target.value)} />
          </div>
          <div className="grid grid-cols-2 gap-3">
            <div className="space-y-1">
              <Label>Customer</Label>
              <select
                value={customerId}
                onChange={(e) => setCustomerId(e.target.value)}
                className="w-full h-9 rounded-md border bg-background px-3 text-sm"
              >
                <option value="self">Self (Internal Work)</option>
                {customers.map((c: any) => (
                  <option key={c.id} value={c.id}>
                    {c.name}
                  </option>
                ))}
              </select>
            </div>
            <div className="space-y-1">
              <Label>Project (Optional)</Label>
              <select
                value={projectId}
                onChange={(e) => setProjectId(e.target.value)}
                className="w-full h-9 rounded-md border bg-background px-3 text-sm"
              >
                <option value="">No Project</option>
                {projects.map((p: any) => (
                  <option key={p.id} value={p.id}>
                    {p.name}
                  </option>
                ))}
              </select>
            </div>
          </div>
          <div className="grid grid-cols-2 gap-3">
            <div className="space-y-1">
              <Label>Start Date</Label>
              <Input type="date" value={startDate} onChange={(e) => setStartDate(e.target.value)} />
            </div>
            <div className="space-y-1">
              <Label>End Date</Label>
              <Input type="date" value={endDate} onChange={(e) => setEndDate(e.target.value)} />
            </div>
          </div>
          <div className="space-y-1">
            <Label>Priority</Label>
            <select
              value={priority}
              onChange={(e) => setPriority(e.target.value)}
              className="w-full h-9 rounded-md border bg-background px-3 text-sm"
            >
              <option value="low">Low</option>
              <option value="medium">Medium</option>
              <option value="high">High</option>
              <option value="urgent">Urgent</option>
            </select>
          </div>
        </div>
        <DialogFooter>
          <Button variant="ghost" onClick={onClose}>
            Cancel
          </Button>
          <Button disabled={!title || m.isPending} onClick={() => m.mutate()}>
            Create
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
