<?php

namespace App\Exports;

use App\Models\Invoice;
use Maatwebsite\Excel\Concerns\FromCollection;
use PhpOffice\PhpSpreadsheet\Shared\Date;
use PhpOffice\PhpSpreadsheet\Style\NumberFormat;
use Maatwebsite\Excel\Concerns\WithColumnFormatting;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Illuminate\Support\Facades\DB;


class ReportInvoicesExport implements FromCollection,WithColumnFormatting, WithHeadings
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
            'Tgl',
            'Nama Shift ',
            'Nomor Faktur',
            'Nama Tamu',
            'Jenis Kelamin',
            'Total',
            'Total Pembayaran',
            'Tipe Pembayaran',
            'Ref No',
            'Dibuat Oleh',
            'Dibuat Tgl',
            'DiUbah Tgl',
        ];
    }
    public function collection()
    {
        return collect(DB::select("
            select b.remark as branch_name,to_char(im.dated,'dd-MM-YYYY') as dated,s.remark as shift_name,im.invoice_no,im.customers_name,c.gender,im.total,im.total_payment,im.payment_type,coalesce(im.ref_no,'-') ref_no,u.name as created_by_name,im.created_at,im.updated_at
            from invoice_master im 
            join customers c on c.id = im.customers_id and c.branch_id::character varying like '%".$this->branch."%'
            join users u on u.id=im.created_by
            join branch b on b.id = c.branch_id
            join shift s on im.created_at::time  between s.time_start and s.time_end and s.id::character varying like '%".$this->shift_id."%'
            where im.dated between '".$this->begindate."' and '".$this->enddate."'             
        ")); 
    }

    public function columnFormats(): array
    {
        return [
        ];
    }
}
