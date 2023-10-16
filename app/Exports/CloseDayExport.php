<?php

namespace App\Exports;

use App\Models\Purchase;
use Maatwebsite\Excel\Concerns\FromCollection;
use PhpOffice\PhpSpreadsheet\Shared\Date;
use PhpOffice\PhpSpreadsheet\Style\NumberFormat;
use Maatwebsite\Excel\Concerns\WithColumnFormatting;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Illuminate\Support\Facades\DB;


class CloseDayExport implements FromCollection,WithColumnFormatting, WithHeadings
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
            'Cabang',
            'Tanggal',
            'Total All',
            'Total Service',
            'Total Salon',
            'Total Product',
            'Total Drink',
            'Total Extra',
            'Total Cas Lebaran',
            'Cash',
            'BANK 1 - Debit',
            'BANK 1 - Kredit',
            'BANK 2 - Debit',
            'BANK 2 - Kredit',
            'BANK 1 - Transfer',
            'BANK 2 - Transfer',
            'BANK 1 - QRIS',
            'BANK 2 - QRIS',
            'Qty Transaction',
            'Qty Customer',
            'Cases'
        ];
    }
    public function collection()
    {
        return collect(DB::select("
            select b.remark as branch_name,im.dated,sum(id.total+id.vat_total) as total_all,
            sum(case when ps.type_id = 2 and ps.category_id !=53 then id.total+id.vat_total else 0 end) as total_service,
            sum(case when ps.type_id = 2 and ps.category_id = 53 then id.total+id.vat_total else 0 end) as total_salon,
            sum(case when ps.type_id = 1 and ps.category_id !=26 then id.total+id.vat_total else 0 end) as total_product,
            sum(case when ps.type_id = 1 and ps.category_id =26 then id.total+id.vat_total else 0 end) as total_drink,
            sum(case when ps.type_id = 8 and ps.remark not like '%CHARGE LEBARAN%'  then id.total+id.vat_total else 0 end) as total_extra,
            sum(case when ps.type_id = 8 and ps.remark like '%CHARGE LEBARAN%'  then id.total+id.vat_total else 0 end) as total_lebaran,
            sum(case when im.payment_type = 'Cash' then id.total+id.vat_total else 0 end) as total_cash,
            sum(case when im.payment_type = 'BCA - Debit' or im.payment_type = 'BANK 1 - Debit' then id.total+id.vat_total else 0 end) as total_b1d,
            sum(case when im.payment_type = 'BCA - Kredit' or im.payment_type = 'BANK 1 - Kredit' then id.total+id.vat_total else 0 end) as total_b1c,
            sum(case when im.payment_type = 'Mandiri - Debit' or im.payment_type = 'BANK 2 - Debit' then id.total+id.vat_total else 0 end) as total_b2d,
            sum(case when im.payment_type = 'Mandiri - Kredit' or im.payment_type = 'BANK 2 - Kredit' then id.total+id.vat_total else 0 end) as total_b2c,
            sum(case when im.payment_type = 'Transfer' or im.payment_type = 'BANK 1 - Transfer' then id.total+id.vat_total else 0 end) as total_b1t,
            sum(case when im.payment_type = 'BANK 2 - Transfer' then id.total+id.vat_total else 0 end) as total_b2t,
            sum(case when im.payment_type = 'QRIS' or im.payment_type = 'BANK 1 - QRIS' then id.total+id.vat_total else 0 end) as total_b1q,
            sum(case when im.payment_type = 'BANK 2 - QRIS' then id.total+id.vat_total else 0 end) as total_b2q,
            count(distinct im.invoice_no) qty_transaction,count(distinct im.invoice_no) qty_customers,
            sum(case when ps.type_id = 2 then id.qty else 0 end) as qty_service
            from invoice_master im 
            join invoice_detail id on id.invoice_no  = im.invoice_no 
            join product_sku ps on ps.id = id.product_id 
            join customers c on c.id = im.customers_id and c.branch_id::character varying like '%".$this->branch."%'
            join branch b on b.id = c.branch_id
            where im.dated between '".$this->begindate."' and '".$this->enddate."'
            group by b.remark,im.dated,b.id        
        ")); 
    }

    public function columnFormats(): array
    {
        return [
        ];
    }
}
