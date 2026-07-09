import { createFileRoute, Link, useNavigate } from "@tanstack/react-router";
import { useSuspenseQuery, useMutation, useQueryClient, useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { useState } from "react";
import {
  getCustomer,
  deleteCustomer,
  updateCustomerServices,
  listServices,
  createSale,
  getMyRoles,
  createCustomService,
} from "@/lib/erp.functions";
import { Card } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { ArrowLeft, Plus } from "lucide-react";
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
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";

export const Route = createFileRoute("/_authenticated/crm/$customerId")({
  head: () => ({ meta: [{ title: "Customer — solv." }] }),
  component: CustomerDetail,
});

function CustomerDetail() {
  const { customerId } = Route.useParams();
  const qc = useQueryClient();
  const navigate = useNavigate();
  const fn = useServerFn(getCustomer);
  const { data } = useSuspenseQuery({
    queryKey: ["customer", customerId],
    queryFn: () => fn({ data: { id: customerId } }),
  });
  const { customer, timeline, services, openTickets, sales = [] } = data;

  const rolesFn = useServerFn(getMyRoles);
  const { data: rolesData } = useQuery({
    queryKey: ["my-roles"],
    queryFn: () => rolesFn(),
  });
  const isAdmin = rolesData?.roles?.includes("admin") ?? false;

  const [assigningServices, setAssigningServices] = useState(false);
  const [addingSale, setAddingSale] = useState(false);

  const monthlyRetainer = sales
    .filter((s: any) => s.billing_type === "retainer" && s.status === "active")
    .reduce((sum: number, s: any) => sum + Number(s.value), 0);

  const oneOffRevenue = sales
    .filter((s: any) => s.billing_type === "one-off")
    .reduce((sum: number, s: any) => sum + Number(s.value), 0);

  const deleteFn = useServerFn(deleteCustomer);
  const deleteMut = useMutation({
    mutationFn: () => deleteFn({ data: { id: customerId } }),
    onSuccess: () => {
      toast.success("Customer deleted");
      qc.invalidateQueries({ queryKey: ["customers"] });
      navigate({ to: "/crm" });
    },
    onError: (e: Error) => toast.error(e.message),
  });

  return (
    <div className="p-6 md:p-8 space-y-6 max-w-6xl">
      <Link
        to="/crm"
        className="text-sm text-muted-foreground hover:text-foreground inline-flex items-center gap-1"
      >
        <ArrowLeft className="h-4 w-4" /> Back to customers
      </Link>

      <div className="flex items-start justify-between gap-4">
        <div>
          <h1 className="text-2xl font-semibold">{customer.name}</h1>
          <p className="text-sm text-muted-foreground mt-1">
            {customer.industry ?? "—"} · Manager: {customer.account_manager?.full_name ?? "—"}
          </p>
        </div>
        <div className="flex items-center gap-2">
          <Button size="sm" variant="outline" onClick={() => setAddingSale(true)}>
            <Plus className="h-4 w-4 mr-1" /> Add Sale
          </Button>
          <Badge className="bg-brand/10 text-brand hover:bg-brand/20">{customer.status}</Badge>
          <ConfirmDeleteButton
            itemLabel={customer.name}
            pending={deleteMut.isPending}
            onConfirm={() => deleteMut.mutate()}
            size="sm"
          />
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <Card className="p-5">
          <div className="text-xs uppercase text-muted-foreground">Monthly Retainer</div>
          <div className="text-2xl font-semibold mt-1">${monthlyRetainer.toLocaleString()}</div>
        </Card>
        <Card className="p-5">
          <div className="text-xs uppercase text-muted-foreground">One-Off Revenue</div>
          <div className="text-2xl font-semibold mt-1">${oneOffRevenue.toLocaleString()}</div>
        </Card>
        <Card className="p-5">
          <div className="text-xs uppercase text-muted-foreground">Products & Services</div>
          <div className="text-2xl font-semibold mt-1">{services.length}</div>
        </Card>
        <Card className="p-5">
          <div className="text-xs uppercase text-muted-foreground">Open Tickets</div>
          <div className="text-2xl font-semibold mt-1">{openTickets.length}</div>
        </Card>
      </div>

      <Card className="p-6">
        <div className="flex justify-between items-center mb-6">
          <h2 className="font-medium">Customer timeline</h2>
        </div>
        <div className="mt-6 space-y-3">
          {timeline.length === 0 ? (
            <div className="text-sm text-muted-foreground text-center py-4">
              No timeline events yet
            </div>
          ) : (
            timeline.map((e: any) => (
              <div key={e.id} className="flex justify-between text-sm border-b pb-2">
                <div>
                  <div className="font-medium">{e.stage}</div>
                  <div className="text-muted-foreground">{e.description}</div>
                  {e.value != null && (
                    <div className="text-sm font-semibold text-emerald-600 mt-1">
                      ${Number(e.value).toLocaleString()}
                    </div>
                  )}
                </div>
                <div className="text-xs text-muted-foreground text-right">
                  {new Date(e.event_at).toLocaleDateString()}
                  <br />
                  {e.assignee?.full_name}
                </div>
              </div>
            ))
          )}
        </div>
      </Card>

      {/* Main Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        <Card className="p-6">
          <div className="flex justify-between items-center mb-4">
            <h2 className="font-medium">Products & Services</h2>
            <Button variant="outline" size="sm" onClick={() => setAssigningServices(true)}>
              <Plus className="h-4 w-4 mr-1" /> Assign
            </Button>
          </div>
          {services.length === 0 ? (
            <div className="text-sm text-muted-foreground">No products or services assigned</div>
          ) : (
            <ul className="space-y-2">
              {services.map((s: any) => (
                <li
                  key={s.id}
                  className="flex justify-between items-center text-sm border-b pb-2 last:border-0 last:pb-0"
                >
                  <span className="font-medium">{s.services?.name}</span>
                  <Badge variant="secondary" className="capitalize">
                    {s.status}
                  </Badge>
                </li>
              ))}
            </ul>
          )}
        </Card>

        <Card className="p-6">
          <h2 className="font-medium mb-4">Open tickets</h2>
          {openTickets.length === 0 ? (
            <div className="text-sm text-muted-foreground">None open</div>
          ) : (
            <ul className="space-y-2">
              {openTickets.map((t: any) => (
                <li key={t.id} className="text-sm">
                  <Link
                    to="/tickets/$ticketId"
                    params={{ ticketId: t.id }}
                    className="hover:underline"
                  >
                    <span className="text-muted-foreground mr-2">{t.ticket_code}</span>
                    {t.title}
                  </Link>
                </li>
              ))}
            </ul>
          )}
        </Card>
      </div>

      {assigningServices && (
        <AssignServicesDialog
          customerId={customerId}
          currentServiceIds={services.map((s: any) => s.service_id)}
          onClose={() => setAssigningServices(false)}
        />
      )}

      {addingSale && (
        <AddSaleDialog
          customerId={customerId}
          currentServiceIds={services.map((s: any) => s.service_id)}
          onClose={() => setAddingSale(false)}
        />
      )}
    </div>
  );
}

function AddSaleDialog({
  customerId,
  currentServiceIds,
  onClose,
}: {
  customerId: string;
  currentServiceIds: string[];
  onClose: () => void;
}) {
  const qc = useQueryClient();
  const getSrvs = useServerFn(listServices);
  const { data: availableServices = [] } = useQuery({
    queryKey: ["services"],
    queryFn: () => getSrvs(),
  });
  
  const customSrvFn = useServerFn(createCustomService);
  const updateServicesFn = useServerFn(updateCustomerServices);
  const fn = useServerFn(createSale);

  const [selectedServices, setSelectedServices] = useState<string[]>([]);
  const [showCustom, setShowCustom] = useState(false);
  const [customService, setCustomService] = useState("");
  
  const [billingType, setBillingType] = useState<"retainer" | "one-off">("retainer");
  const [value, setValue] = useState("");
  const [status, setStatus] = useState<"active" | "completed" | "cancelled">("active");
  const [startDate, setStartDate] = useState(new Date().toISOString().split("T")[0]);

  const m = useMutation({
    mutationFn: async () => {
      const finalServiceIds = [...selectedServices];
      let customName = "";
      if (showCustom && customService.trim()) {
        customName = customService.trim();
        const newId = await customSrvFn({ data: { name: customName } });
        finalServiceIds.push(newId);
      }

      if (finalServiceIds.length === 0 && !customName) {
        throw new Error("Please select at least one service.");
      }

      const combinedServiceIds = Array.from(new Set([...currentServiceIds, ...finalServiceIds]));
      await updateServicesFn({ data: { customerId, serviceIds: combinedServiceIds } });

      const names = finalServiceIds.map(id => availableServices.find((s: any) => s.id === id)?.name).filter(Boolean);
      if (customName) names.push(customName);
      
      const description = Array.from(new Set(names)).join(", ");

      return fn({
        data: {
          customer_id: customerId,
          description: description,
          billing_type: billingType,
          value: Number(value),
          status,
          start_date: startDate,
        },
      });
    },
    onSuccess: () => {
      toast.success("Sale added successfully");
      qc.invalidateQueries();
      onClose();
    },
    onError: (e: Error) => toast.error(e.message),
  });

  return (
    <Dialog open onOpenChange={onClose}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Add Sale</DialogTitle>
        </DialogHeader>
        <div className="space-y-4 py-2">
          <div className="space-y-2">
            <Label>Product/Service</Label>
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
          <div className="grid grid-cols-2 gap-4">
            <div className="space-y-1">
              <Label>Billing Type</Label>
              <Select value={billingType} onValueChange={(val: any) => setBillingType(val)}>
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="retainer">Retainer</SelectItem>
                  <SelectItem value="one-off">One-Off</SelectItem>
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-1">
              <Label>Status</Label>
              <Select value={status} onValueChange={(val: any) => setStatus(val)}>
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="active">Active</SelectItem>
                  <SelectItem value="completed">Completed</SelectItem>
                  <SelectItem value="cancelled">Cancelled</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>
          <div className="grid grid-cols-2 gap-4">
            <div className="space-y-1">
              <Label>Value ($)</Label>
              <Input
                type="number"
                min="0"
                step="0.01"
                value={value}
                onChange={(e) => setValue(e.target.value)}
                placeholder="0.00"
              />
            </div>
            <div className="space-y-1">
              <Label>Start Date</Label>
              <Input
                type="date"
                value={startDate}
                onChange={(e) => setStartDate(e.target.value)}
              />
            </div>
          </div>
        </div>
        <DialogFooter>
          <Button variant="ghost" onClick={onClose}>
            Cancel
          </Button>
          <Button
            disabled={m.isPending || (selectedServices.length === 0 && (!showCustom || !customService.trim())) || !value}
            onClick={() => m.mutate()}
          >
            Save Sale
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

function AssignServicesDialog({
  customerId,
  currentServiceIds,
  onClose,
}: {
  customerId: string;
  currentServiceIds: string[];
  onClose: () => void;
}) {
  const qc = useQueryClient();
  const [selectedIds, setSelectedIds] = useState<string[]>(currentServiceIds);
  const listFn = useServerFn(listServices);
  const updateFn = useServerFn(updateCustomerServices);

  const { data: allServices = [], isLoading } = useQuery({
    queryKey: ["all-services"],
    queryFn: () => listFn(),
  });

  const m = useMutation({
    mutationFn: () => updateFn({ data: { customerId, serviceIds: selectedIds } }),
    onSuccess: () => {
      toast.success("Services updated successfully");
      qc.invalidateQueries();
      onClose();
    },
    onError: (e: Error) => toast.error(e.message),
  });

  const toggleService = (id: string) => {
    setSelectedIds((prev) => (prev.includes(id) ? prev.filter((x) => x !== id) : [...prev, id]));
  };

  const parents = allServices.filter((s: any) => !s.parent_id);

  return (
    <Dialog open onOpenChange={onClose}>
      <DialogContent className="max-w-md max-h-[80vh] overflow-y-auto">
        <DialogHeader>
          <DialogTitle>Assign Services & Subservices</DialogTitle>
        </DialogHeader>
        {isLoading ? (
          <div className="py-8 text-center text-sm text-muted-foreground">Loading services...</div>
        ) : (
          <div className="space-y-4 py-2">
            {parents.map((parent: any) => {
              const subs = allServices.filter((s: any) => s.parent_id === parent.id);
              const parentChecked = selectedIds.includes(parent.id);
              return (
                <div key={parent.id} className="space-y-2 border-b pb-3 last:border-0 last:pb-0">
                  <div className="flex items-center space-x-2">
                    <input
                      type="checkbox"
                      id={parent.id}
                      checked={parentChecked}
                      onChange={() => toggleService(parent.id)}
                      className="rounded border-gray-300 text-brand focus:ring-brand h-4 w-4"
                    />
                    <Label htmlFor={parent.id} className="font-medium cursor-pointer text-base">
                      {parent.name}
                    </Label>
                  </div>
                  {subs.length > 0 && (
                    <div className="pl-6 space-y-2">
                      {subs.map((sub: any) => {
                        const subChecked = selectedIds.includes(sub.id);
                        return (
                          <div key={sub.id} className="flex items-center space-x-2">
                            <input
                              type="checkbox"
                              id={sub.id}
                              checked={subChecked}
                              onChange={() => toggleService(sub.id)}
                              className="rounded border-gray-300 text-brand focus:ring-brand h-4 w-4"
                            />
                            <Label
                              htmlFor={sub.id}
                              className="text-sm cursor-pointer text-muted-foreground"
                            >
                              {sub.name}
                            </Label>
                          </div>
                        );
                      })}
                    </div>
                  )}
                </div>
              );
            })}
          </div>
        )}
        <DialogFooter className="mt-4">
          <Button variant="ghost" onClick={onClose}>
            Cancel
          </Button>
          <Button disabled={m.isPending} onClick={() => m.mutate()}>
            Save Changes
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
