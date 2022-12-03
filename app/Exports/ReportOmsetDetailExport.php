<?php

namespace App\Exports;

use App\Models\Invoice;
use Maatwebsite\Excel\Concerns\FromCollection;
use PhpOffice\PhpSpreadsheet\Shared\Date;
use PhpOffice\PhpSpreadsheet\Style\NumberFormat;
use Maatwebsite\Excel\Concerns\WithColumnFormatting;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Illuminate\Support\Facades\DB;


class ReportOmsetDetailExport implements FromCollection,WithColumnFormatting, WithHeadings
{
    /**
    * @return \Illuminate\Support\Collection
    */

    private $begindate;
    private $enddate;
    private $branch;
    public function __construct($arg1){
        //base64_encode($keyword.'#'.$begindate.'#'.$enddate.'#'.$branchx);
        $arr = explode('#',base64_decode($arg1));
        $this->begindate    = $arr[0];
        $this->enddate      = $arr[1];
        $this->branch       = $arr[2];
    } 

    public function headings(): array
    {
        return [
            'Branch',
            'Dated',
            'Invoice No',
            'Product Name',
            'Category Name',
            'Qty',
            'UOM',
            'Total',
            'Price Purchase',
            'Margin'
        ];
    }
    public function collection()
    {
        return collect(DB::select("
                select b.remark as branch_name,im.dated,im.invoice_no,id.product_name,pc.remark as category_name,id.qty,id.uom,id.total as total,id.price_purchase,case when coalesce(id.price_purchase)<=0 then 0 else id.total-id.price_purchase  end as margin
                from invoice_master im 
                join invoice_detail id on id.invoice_no = im.invoice_no 
                join product_sku ps on ps.id = id.product_id 
                join product_category pc on pc.id = ps.category_id 
                join customers c on c.id = im.customers_id  and c.branch_id::character varying like '%".$this->branch."%'
                join users u on u.id=im.created_by
                join branch b on b.id = c.branch_id
                where im.dated between '".$this->begindate."' and '".$this->enddate."'             
        ")); 
    }

    public function columnFormats(): array
    {
        return [
            'B' => 'yyyy-mm-dd',
        ];
    }
}
