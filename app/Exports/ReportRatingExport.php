<?php

namespace App\Exports;

use App\Models\Invoice;
use Maatwebsite\Excel\Concerns\FromCollection;
use PhpOffice\PhpSpreadsheet\Shared\Date;
use PhpOffice\PhpSpreadsheet\Style\NumberFormat;
use Maatwebsite\Excel\Concerns\WithColumnFormatting;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Illuminate\Support\Facades\DB;


class ReportRatingExport implements FromCollection,WithColumnFormatting, WithHeadings
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
            'No Faktur',
            'Tanggal Faktur',
            'Nama Tamu',
            'Nama Terapis',
            'Penilaian',
            'Notes',
            'Tgl Penilaian'
        ];
    }
    public function collection()
    {
        return collect(DB::select("
                select b.remark as branch_name,im.invoice_no,im.dated as invoice_date,im.customers_name,u.name,ir.value_review,ir.remarks,ir.created_at from invoice_master im 
                join invoice_review_detail ir on ir.invoice_no = im.invoice_no
                join customers c on c.id=im.customers_id
                join branch b on b.id=c.branch_id and b.id::character varying like '%".$this->branch."%'
                join users u on u.id=ir.user_id
                where im.dated between '".$this->begindate."' and '".$this->enddate."'      order by b.remark,im.dated,im.invoice_no   
        ")); 
    }

    public function columnFormats(): array
    {
        return [
        ];
    }
}
