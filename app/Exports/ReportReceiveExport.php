<?php

namespace App\Exports;

use App\Models\Invoice;
use Maatwebsite\Excel\Concerns\FromCollection;
use PhpOffice\PhpSpreadsheet\Shared\Date;
use PhpOffice\PhpSpreadsheet\Style\NumberFormat;
use Maatwebsite\Excel\Concerns\WithColumnFormatting;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Illuminate\Support\Facades\DB;


class ReportReceiveExport implements FromCollection,WithColumnFormatting, WithHeadings
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
            'Purchase No',
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
                select b.remark as branch_name,im.dated,im.purchase_no,id.product_remark as product_name,pc.remark as category_name,id.qty,id.uom,id.subtotal_vat+id.subtotal as total
                from purchase_master im 
                join purchase_detail id on id.purchase_no = im.purchase_no 
                join product_sku ps on ps.id = id.product_id 
                join product_category pc on pc.id = ps.category_id 
                join suppliers c on c.id = im.supplier_id  and c.branch_id::character varying like '%".$this->branch."%'
                join users u on u.id = im.created_by
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
