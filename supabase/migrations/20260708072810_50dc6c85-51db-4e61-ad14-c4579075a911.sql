
CREATE POLICY "ticket_attach_read" ON storage.objects FOR SELECT TO authenticated
USING (bucket_id = 'ticket-attachments' AND (
  public.is_admin(auth.uid()) OR public.has_role(auth.uid(),'support')
  OR public.has_role(auth.uid(),'project_manager') OR public.has_role(auth.uid(),'sales')
));
CREATE POLICY "ticket_attach_write" ON storage.objects FOR INSERT TO authenticated
WITH CHECK (bucket_id = 'ticket-attachments' AND (
  public.is_admin(auth.uid()) OR public.has_role(auth.uid(),'support') OR public.has_role(auth.uid(),'project_manager')
));
CREATE POLICY "ticket_attach_delete" ON storage.objects FOR DELETE TO authenticated
USING (bucket_id = 'ticket-attachments' AND (
  public.is_admin(auth.uid()) OR public.has_role(auth.uid(),'support') OR public.has_role(auth.uid(),'project_manager')
));
