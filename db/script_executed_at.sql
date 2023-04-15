select string_agg(distinct u.name,',') as created_by
                from invoice_master im 
                join customers c on c.id= im.customers_id 
                join users u on u.id= im.created_by
                where im.dated = '2023-04-12'  and c.branch_id = 14
                
                
select coalesce(string_agg(distinct u.name,', '),'-') as created_by
from invoice_master im 
join customers c on c.id= im.customers_id 
join users u on u.id= im.created_by
join branch_shift bs on bs.branch_id = c.branch_id
join shift s on s.id = 11  and s.id = bs.shift_id
where im.dated = '2023-04-10'  and c.branch_id = 14  and im.created_at::time  between s.time_start and s.time_end