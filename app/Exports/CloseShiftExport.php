<?php

namespace App\Exports;

use App\Models\Purchase;
use Maatwebsite\Excel\Concerns\FromCollection;
use PhpOffice\PhpSpreadsheet\Shared\Date;
use PhpOffice\PhpSpreadsheet\Style\NumberFormat;
use Maatwebsite\Excel\Concerns\WithColumnFormatting;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Illuminate\Support\Facades\DB;


class CloseShiftExport implements FromCollection,WithColumnFormatting, WithHeadings
{
    /**
    * @return \Illuminate\Support\Collection
    */

    private $shift_id;
    private $begindate;
    private $enddate;
    private $branch;
    public function __construct($arg1){
        //base64_encode($keyword.'#'.$begindate.'#'.$enddate.'#'.$branchx);
        $arr = explode('#',base64_decode($arg1));
        $this->shift_id      = $arr[0];
        $this->begindate    = $arr[1];
        $this->enddate      = $arr[2];
        $this->branch       = $arr[3];
    } 

    public function headings(): array
    {
        return [
            'Branch',
            'Dated',
            'Shift Name',
            'Total All',
            'Total Service',
            'Total Product',
            'Total Drink',
            'Total Extra',
            'Cash',
            'BCA - Debit',
            'BCA - Kredit',
            'Mandiri - Debit',
            'Mandiri - Kredit',
            'Qty Transaction',
            'Qty Customer',
        ];
    }
    public function collection()
    {
        return collect(DB::select("
            select b.remark as branch_name,im.dated ,s.remark as shift_name,sum(id.total+id.vat_total) as total_all,
            sum(case when ps.type_id = 2 then id.total+id.vat_total else 0 end) as total_service,
            sum(case when ps.type_id = 1 and ps.category_id !=12 then id.total+id.vat_total else 0 end) as total_product,
            sum(case when ps.type_id = 1 and ps.category_id =12 then id.total+id.vat_total else 0 end) as total_drink,
            sum(case when ps.type_id = 8 then id.total+id.vat_total else 0 end) as total_extra,
            sum(case when im.payment_type = 'Cash' then id.total+id.vat_total else 0 end) as total_cash,
            sum(case when im.payment_type = 'BCA - Debit' then id.total+id.vat_total else 0 end) as total_b_d,
            sum(case when im.payment_type = 'BCA - Kredit' then id.total+id.vat_total else 0 end) as total_b_k,
            sum(case when im.payment_type = 'Mandiri - Debit' then id.total+id.vat_total else 0 end) as total_m_d,
            sum(case when im.payment_type = 'Mandiri - Kredit' then id.total+id.vat_total else 0 end) as total_m_k,
            count(distinct im.invoice_no) qty_transaction,count(distinct im.customers_id) qty_customers
            from invoice_master im 
            join invoice_detail id on id.invoice_no  = im.invoice_no 
            join product_sku ps on ps.id = id.product_id 
            join customers c on c.id = im.customers_id and c.branch_id::character varying like '%".$this->branch."%'
            join branch b on b.id = c.branch_id
            join shift s on im.created_at::time  between s.time_start and s.time_end and s.id::character varying like '%".$this->shift_id."%'
            where im.dated between '".$this->begindate."' and '".$this->enddate."'
            group by b.remark,im.dated,s.remark,b.id,s.id              
        ")); 
    }

    public function columnFormats(): array
    {
        return [
            'F' => 'yyyy-mm-dd',
        ];
    }
}
