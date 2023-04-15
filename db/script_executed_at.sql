UPDATE 
    invoice_detail p
SET 
    executed_at = s.scheduled_at 
FROM 
    invoice_master s
WHERE 
    p.invoice_no = s.invoice_no;