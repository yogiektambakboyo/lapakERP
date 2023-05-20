<?php

namespace App\Exports;

use App\Models\Invoice;
use Maatwebsite\Excel\Concerns\FromCollection;
use PhpOffice\PhpSpreadsheet\Shared\Date;
use PhpOffice\PhpSpreadsheet\Style\NumberFormat;
use Maatwebsite\Excel\Concerns\WithColumnFormatting;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Illuminate\Support\Facades\DB;


class ReportInvoicesDetailExport implements FromCollection,WithColumnFormatting, WithHeadings
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
            'Cabang',
            'Tanggal',
            'No Faktur Jual',
            'Nama Produk/Perawatan',
            'Nama Kategori',
            'Qty',
            'UOM',
            'Total'
        ];
    }
    public function collection()
    {
        return collect(DB::select("
                select b.remark as branch_name,to_char(im.dated,'dd-MM-YYYY') as dated,im.invoice_no,id.product_name,pc.remark as category_name,id.qty,id.uom,id.total+id.vat_total as total
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
        ];
    }
}
