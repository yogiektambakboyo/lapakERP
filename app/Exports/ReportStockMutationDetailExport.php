<?php

namespace App\Exports;

use Maatwebsite\Excel\Concerns\FromCollection;
use PhpOffice\PhpSpreadsheet\Shared\Date;
use PhpOffice\PhpSpreadsheet\Style\NumberFormat;
use Maatwebsite\Excel\Concerns\WithColumnFormatting;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Illuminate\Support\Facades\DB;


class ReportStockMutationDetailExport implements FromCollection,WithColumnFormatting, WithHeadings
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
        return [
            'Branch',
            'Dated',
            'Product Name',
            'Qty In',
            'Qty Out',
            'Stock',
        ];
    }
    public function collection()
    {
        return collect(DB::select("

        select branch_name,to_char(a.dated,'dd-mm-YYYY') as dated_display,product_name,sum(a.qty_in) as qty_in,sum(a.qty_out) as qty_out,coalesce(psd.qty_stock,0) as qty_stock from (
            select b.id as branch_id,b.remark as branch_name,im.dated,id.product_id,ps.remark as product_name,sum(id.qty) as qty_out,0  as qty_in  from invoice_master im 
            join invoice_detail id on id.invoice_no = im.invoice_no 
            join customers c ON c.id = im.customers_id
            join product_sku ps on ps.id = id.product_id and ps.type_id = 1 
            join branch b on b.id = c.branch_id and b.id::character varying like '".$this->branch."'
            where im.dated between '".$this->begindate."' and '".$this->enddate."'
            group by b.id,b.remark,im.dated,id.product_id,ps.remark
            union 
            select b.id as branch_id,b.remark as branch_name,im.dated,ps2.id as product_id,ps2.remark as product_name,sum(id.qty*pi2.qty) as qty_out,0  as qty_in  from invoice_master im 
            join invoice_detail id on id.invoice_no = im.invoice_no 
            join customers c ON c.id = im.customers_id
            join product_sku ps on ps.id = id.product_id
            join product_ingredients pi2 on pi2.product_id = ps.id 
            join product_sku ps2 on ps2.id = pi2.product_id_material
            join branch b on b.id = c.branch_id and b.id::character varying like '".$this->branch."'
            where im.dated between '".$this->begindate."' and '".$this->enddate."'
            group by b.id,b.remark,im.dated,ps2.id,ps2.remark
            union
            select b.id as branch_id,b.remark as branch_name,im.dated,id.product_id,ps.remark as product_name,sum(id.qty) as qty_out,0  as qty_in  from petty_cash im 
            join petty_cash_detail id on id.doc_no  = im.doc_no
            join product_sku ps on ps.id = id.product_id and ps.type_id = 1
            join branch b on b.id = im.branch_id and b.id::character varying like '".$this->branch."'
            where im.dated between '".$this->begindate."' and '".$this->enddate."' and im.type='Produk - Keluar'
            group by b.id,b.remark,im.dated,id.product_id,ps.remark
            union
            select b.id as branch_id,b.remark as branch_name,im.dated,id.product_id,ps.remark as product_name,0 as qty_out,sum(id.qty)  as qty_in  from petty_cash im 
            join petty_cash_detail id on id.doc_no  = im.doc_no
            join product_sku ps on ps.id = id.product_id and ps.type_id = 1 
            join branch b on b.id = im.branch_id and b.id::character varying like '".$this->branch."'
            where im.dated between '".$this->begindate."' and '".$this->enddate."' and im.type='Produk - Masuk'
            group by b.id,b.remark,im.dated,id.product_id,ps.remark
            union
            select b.id as branch_id,b.remark as branch_name,im.dated,id.product_id,ps.remark as product_name,0 as qty_out,sum(id.qty) as qty_in  from receive_master im 
            join receive_detail id on id.receive_no = im.receive_no 
            join product_sku ps on ps.id = id.product_id and ps.type_id = 1 
            join branch b on b.id = im.branch_id and b.id::character varying like '".$this->branch."'
            where im.dated between '".$this->begindate."' and '".$this->enddate."'
            group by b.id,b.remark,im.dated,id.product_id,ps.remark
        ) a join users_branch ub on ub.branch_id = a.branch_id 
        left join period_stock_daily psd on psd.dated = a.dated and psd.product_id = a.product_id and psd.branch_id  = a.branch_id             
        where ub.user_id = ".$this->userid."
        group by a.branch_id,a.branch_name,a.dated,product_name,coalesce(psd.qty_stock,0),to_char(a.dated,'dd-mm-YYYY')
     
        ")); 
    }

    public function columnFormats(): array
    {
        return [
        ];
    }
}
