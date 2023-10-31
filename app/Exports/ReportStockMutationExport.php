<?php

namespace App\Exports;

use Maatwebsite\Excel\Concerns\FromCollection;
use PhpOffice\PhpSpreadsheet\Shared\Date;
use PhpOffice\PhpSpreadsheet\Style\NumberFormat;
use Maatwebsite\Excel\Concerns\WithColumnFormatting;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Illuminate\Support\Facades\DB;


class ReportStockMutationExport implements FromCollection,WithColumnFormatting, WithHeadings
{
    /**
    * @return \Illuminate\Support\Collection
    */

    private $begindate;
    private $enddate;
    private $branch;
    private $userid;
    private $period;
    public function __construct($arg1){
        //base64_encode($keyword.'#'.$begindate.'#'.$enddate.'#'.$branchx);
        $arr = explode('#',base64_decode($arg1));
        $this->begindate    = $arr[0];
        $this->enddate      = $arr[1];
        $this->branch       = $arr[2];
        $this->userid       = $arr[3];
        $this->period       = $arr[4];
    } 

    public function headings(): array
    {
        return [
            'Cabang',
            'Periode',
            'Nama Produk',
            'Stok Awal',
            'Stok Akhir',
            'Jumlah Masuk',
            'Jumlah Akhir',
            'Diedit pada',
        ];
    }
    public function collection()
    {
        return collect(DB::select("
        select b.remark as branch_name,psd.periode,ps.remark as product_name,psd.balance_begin,psd.balance_end,psd.qty_in,psd.qty_out,psd.updated_at  from users u 
        join users_branch ub on ub.user_id = u.id 
        join period_stock psd on psd.branch_id = ub.branch_id  and psd.branch_id::character varying like '%".$this->branch."%'  and psd.periode = ".$this->period."::int
        join product_sku ps on ps.id = psd.product_id and ps.type_id = 1
        join branch b on b.id = ub.branch_id 
        where u.id = ".$this->userid." order by 1,2             
        ")); 
    }

    public function columnFormats(): array
    {
        return [
        ];
    }
}
