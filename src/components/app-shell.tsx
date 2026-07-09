import { Link, useRouterState, useNavigate } from "@tanstack/react-router";
import type { ReactNode } from "react";
import {
  LayoutDashboard,
  Users,
  Sparkles,
  FolderKanban,
  TicketCheck,
  BarChart3,
  UsersRound,
  Settings,
  Search,
  Bell,
  Plus,
  LogOut,
} from "lucide-react";
import { useQuery, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { supabase } from "@/integrations/supabase/client";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { Badge } from "@/components/ui/badge";
import { CreateNewMenu } from "./create-new-menu";
import { getMyRoles } from "@/lib/erp.functions";
import { toast } from "sonner";
import { cn } from "@/lib/utils";

type Role = "admin" | "sales" | "project_manager" | "support" | "hr";

const NAV: { to: string; label: string; icon: typeof LayoutDashboard; roles: Role[] }[] = [
  {
    to: "/dashboard",
    label: "Dashboard",
    icon: LayoutDashboard,
    roles: ["admin", "sales", "project_manager", "support", "hr"],
  },
  {
    to: "/crm",
    label: "CRM",
    icon: Users,
    roles: ["admin", "sales", "project_manager", "support"],
  },
  { to: "/leads", label: "Leads", icon: Sparkles, roles: ["admin", "sales"] },
  {
    to: "/projects",
    label: "Projects",
    icon: FolderKanban,
    roles: ["admin", "project_manager", "support"],
  },
  {
    to: "/tickets",
    label: "Tickets",
    icon: TicketCheck,
    roles: ["admin", "sales", "project_manager", "support"],
  },
  {
    to: "/reports",
    label: "Reports",
    icon: BarChart3,
    roles: ["admin", "sales", "project_manager", "support", "hr"],
  },
  { to: "/hr", label: "HR / Team", icon: UsersRound, roles: ["admin", "hr"] },
  { to: "/settings", label: "Settings", icon: Settings, roles: ["admin"] },
];

export function AppShell({ children }: { children: ReactNode }) {
  const pathname = useRouterState({ select: (s) => s.location.pathname });
  const navigate = useNavigate();
  const queryClient = useQueryClient();
  const rolesFn = useServerFn(getMyRoles);
  const { data: rolesData } = useQuery({
    queryKey: ["my-roles"],
    queryFn: () => rolesFn(),
  });
  const roles: Role[] = (rolesData?.roles ?? []) as Role[];
  const email = rolesData?.email ?? "";
  const fullName = rolesData?.fullName ?? email;

  const visibleNav = NAV.filter((n) => roles.some((r) => n.roles.includes(r)));

  async function signOut() {
    await queryClient.cancelQueries();
    queryClient.clear();
    await supabase.auth.signOut();
    navigate({ to: "/auth", replace: true });
  }

  return (
    <div className="min-h-screen flex bg-muted/20">
      {/* Sidebar */}
      <aside className="hidden md:flex w-60 shrink-0 flex-col bg-sidebar text-sidebar-foreground border-r border-sidebar-border">
        <div className="h-16 flex items-center px-6 border-b border-sidebar-border">
          <span className="text-2xl font-semibold tracking-tight text-brand">solv.</span>
        </div>
        <nav className="flex-1 px-3 py-4 space-y-1">
          {visibleNav.map((item) => {
            const active = pathname === item.to || pathname.startsWith(item.to + "/");
            const Icon = item.icon;
            return (
              <Link
                key={item.to}
                to={item.to}
                className={cn(
                  "flex items-center gap-3 rounded-md px-3 py-2 text-sm transition-colors",
                  active
                    ? "bg-sidebar-accent text-white"
                    : "text-sidebar-foreground/70 hover:bg-sidebar-accent hover:text-white",
                )}
              >
                <Icon className="h-4 w-4" />
                {item.label}
              </Link>
            );
          })}
        </nav>
        <div className="p-3 border-t border-sidebar-border text-xs text-sidebar-foreground/50">
          {roles.map((r) => (
            <Badge
              key={r}
              variant="secondary"
              className="mr-1 mb-1 bg-sidebar-accent text-white/80 border-0"
            >
              {r.replace("_", " ")}
            </Badge>
          ))}
        </div>
      </aside>

      {/* Main */}
      <div className="flex-1 flex flex-col min-w-0">
        <header className="h-16 shrink-0 border-b bg-background flex items-center gap-3 px-4 md:px-6">
          <div className="md:hidden text-lg font-semibold text-brand">solv.</div>
          <div className="flex-1 max-w-md">
            <div className="relative">
              <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
              <Input
                placeholder="Search customers, projects, tickets…"
                className="pl-9 bg-muted/40 border-0"
              />
            </div>
          </div>
          <div className="flex items-center gap-2 ml-auto">
            <CreateNewMenu roles={roles}>
              <Button size="sm" className="gap-1.5">
                <Plus className="h-4 w-4" /> Create New
              </Button>
            </CreateNewMenu>
            <Button variant="ghost" size="icon" onClick={() => toast.info("No new notifications")}>
              <Bell className="h-4 w-4" />
            </Button>
            <DropdownMenu>
              <DropdownMenuTrigger asChild>
                <Button variant="ghost" size="icon" className="rounded-full">
                  <Avatar className="h-8 w-8">
                    <AvatarFallback className="bg-brand/10 text-brand text-xs font-medium">
                      {(fullName || email).slice(0, 2).toUpperCase()}
                    </AvatarFallback>
                  </Avatar>
                </Button>
              </DropdownMenuTrigger>
              <DropdownMenuContent align="end" className="w-56">
                <DropdownMenuLabel>
                  <div className="text-sm font-medium">{fullName}</div>
                  <div className="text-xs text-muted-foreground font-normal">{email}</div>
                </DropdownMenuLabel>
                <DropdownMenuSeparator />
                <DropdownMenuItem onClick={signOut}>
                  <LogOut className="h-4 w-4 mr-2" /> Sign out
                </DropdownMenuItem>
              </DropdownMenuContent>
            </DropdownMenu>
          </div>
        </header>
        <main className="flex-1 overflow-auto">{children}</main>
      </div>
    </div>
  );
}
