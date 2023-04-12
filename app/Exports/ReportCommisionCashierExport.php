<?php

namespace App\Exports;

use Maatwebsite\Excel\Concerns\FromCollection;
use PhpOffice\PhpSpreadsheet\Shared\Date;
use PhpOffice\PhpSpreadsheet\Style\NumberFormat;
use Maatwebsite\Excel\Concerns\WithColumnFormatting;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Illuminate\Support\Facades\DB;


class ReportCommisionCashierExport implements FromCollection,WithColumnFormatting, WithHeadings
{
    /**
    * @return \Illuminate\Support\Collection
    */

    private $begindate;
    private $enddate;
    private $branch;
    private $userid;
    public function __construct($arg1){
        //base64_encode($keyword.'#'.$begindate.'#'.$enddate.'#'.$branchx);
        $arr = explode('#',base64_decode($arg1));
        $this->begindate    = $arr[0];
        $this->enddate      = $arr[1];
        $this->branch       = $arr[2];
        $this->userid       = $arr[3];
    } 

    public function headings(): array
    {
        //b.remark as branch_name,'work_commission' as com_type,to_char(im.dated,'dd-MM-YYYY') as dated,im.invoice_no,ps.remark,u.name,id.price,id.qty,id.total,pc.values base_commision,pc.values  * id.qty as commisions  
        return [
            'Branch',
            'Dated',
            'Nama Terapist',
            'Invoice No',
            'Name',
            'Price',
            'Qty',
            'Total',
            'Type Commision',
            'Base Commision',
            'Total Commision',
        ];
    }
    public function collection()
    {
        return collect(DB::select("
            select  b.remark as branch_name,to_char(im.dated,'dd-MM-YYYY') as dated,im.invoice_no,ps.remark,im.created_by,u.name,id.price,id.qty,id.total,'work_commission' as com_type,pc.created_by_fee base_commision,pc.created_by_fee * id.qty as commisions  
            from invoice_master im 
            join invoice_detail id on id.invoice_no = im.invoice_no 
            join product_sku ps on ps.id = id.product_id 
            join customers c on c.id = im.customers_id  and c.branch_id::character varying like '%".$this->branch."%' 
            join branch b on b.id = c.branch_id
            join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
            join users u on u.id = im.created_by and u.job_id = 1  and u.id = im.created_by and coalesce(id.assigned_to,0) > 0
            where pc.created_by_fee > 0 and im.dated between '".$this->begindate."' and '".$this->enddate."' 
            union 
            select  b.remark as branch_name,to_char(im.dated,'dd-MM-YYYY') as dated,im.invoice_no,ps.remark,im.created_by,u.name,id.price,id.qty,id.total,'referral' as com_type,pc.referral_fee base_commision,pc.referral_fee  * id.qty as commisions  
            from invoice_master im 
            join invoice_detail id on id.invoice_no = im.invoice_no
            join product_sku ps on ps.id = id.product_id 
            join customers c on c.id = im.customers_id  and c.branch_id::character varying like '%".$this->branch."%' 
            join branch b on b.id = c.branch_id
            join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
            join users u on u.id = im.created_by and u.job_id = 1 and u.id = id.referral_by 
            where pc.created_by_fee <= 0 and pc.referral_fee > 0 and im.dated between '".$this->begindate."' and '".$this->enddate."'             
        ")); 
    }

    public function columnFormats(): array
    {
        return [
            
        ];
    }
}
