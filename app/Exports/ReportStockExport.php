<?php

namespace App\Exports;

use Maatwebsite\Excel\Concerns\FromCollection;
use PhpOffice\PhpSpreadsheet\Shared\Date;
use PhpOffice\PhpSpreadsheet\Style\NumberFormat;
use Maatwebsite\Excel\Concerns\WithColumnFormatting;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Illuminate\Support\Facades\DB;


class ReportStockExport implements FromCollection,WithColumnFormatting, WithHeadings
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
            'Cabang',
            'Nama Produk/Perawatan',
            'Jml',
            'Jml Buffer',
            'Selisih',
        ];
    }
    public function collection()
    {
        return collect(DB::select("
            select b.remark as branch_name,ps.remark as product_name,psd.qty,coalesce(sb.qty,0) as qty_buffer,psd.qty-coalesce(sb.qty,0) as qty_dif  from users u 
            join users_branch ub on ub.user_id = u.id 
            join product_stock psd on psd.branch_id = ub.branch_id and psd.branch_id::character varying like '%".$this->branch."%'
            join product_sku ps on ps.id = psd.product_id and ps.type_id = 1
            join branch b on b.id = ub.branch_id 
            join product_distribution pd on pd.product_id = ps.id and pd.branch_id = ub.branch_id 
            left join product_stock_buffer sb on sb.branch_id = b.id and sb.product_id = ps.id
            where u.id = ".$this->userid." order by 1,2             
        ")); 
    }

    public function columnFormats(): array
    {
        return [
            'B' => 'yyyy-mm-dd',
        ];
    }
}
