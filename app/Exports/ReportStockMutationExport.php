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
            'Jumlah Masuk',
            'Jumlah Keluar',
            'Stok Akhir',
        ];
    }
    public function collection()
    {
        $period_now = DB::select("select period_no,remark,start_cal,start_cal+1 as start_cal_p,end_cal from period where period_no='".$this->period."'::int and period_no>=202301  order by period_no desc");

        return collect(DB::select("
        
            select to_char('".$period_now[0]->end_cal."'::date,'YYYYMM') as periode,branch_name,product_name,sum(qty_begin) as balance_begin,sum(a.qty_in) as qty_in,sum(a.qty_out) as qty_out,sum(qty_begin)+sum(a.qty_in)-sum(a.qty_out) as balance_end from ( 
                select branch_name,product_name,0 as qty_begin,sum(a.qty_in) as qty_in,sum(a.qty_out) as qty_out 
                from ( 
                    select b.id as branch_id,b.remark as branch_name,im.dated,id.product_id,ps.remark as product_name,sum(id.qty) as qty_out,0 as qty_in 
                    from invoice_master im 
                    join invoice_detail id on id.invoice_no = im.invoice_no 
                    join customers c ON c.id = im.customers_id join product_sku ps on ps.id = id.product_id and ps.type_id = 1 
                    join product_distribution pdd on pdd.product_id = id.product_id and pdd.branch_id = c.branch_id and pdd.active='1' 
                    join branch b on b.id = c.branch_id and b.id::character varying like '".$this->branch."' 
                    where im.dated between '".$period_now[0]->start_cal_p."' and '".$period_now[0]->end_cal."'
                    group by b.id,b.remark,im.dated,id.product_id,ps.remark 
                    union all 
                    select b.id as branch_id,b.remark as branch_name,im.dated,ps2.id as product_id,ps2.remark as product_name,sum(id.qty*pi2.qty) as qty_out,0 as qty_in 
                    from invoice_master im 
                    join invoice_detail id on id.invoice_no = im.invoice_no 
                    join customers c ON c.id = im.customers_id 
                    join product_sku ps on ps.id = id.product_id 
                    join product_ingredients pi2 on pi2.product_id = ps.id 
                    join product_distribution pdd on pdd.product_id = pi2.product_id_material and pdd.branch_id = c.branch_id and pdd.active='1' 
                    join product_sku ps2 on ps2.id = pi2.product_id_material 
                    join branch b on b.id = c.branch_id and b.id::character varying like '".$this->branch."' 
                    where im.dated between '".$period_now[0]->start_cal_p."' and '".$period_now[0]->end_cal."'
                    group by b.id,b.remark,im.dated,ps2.id,ps2.remark 
                    union all 
                    select b.id as branch_id,b.remark as branch_name,im.dated,id.product_id,ps.remark as product_name,sum(id.qty) as qty_out,0 as qty_in 
                    from petty_cash im 
                    join petty_cash_detail id on id.doc_no = im.doc_no 
                    join product_sku ps on ps.id = id.product_id and ps.type_id = 1 
                    join branch b on b.id = im.branch_id and b.id::character varying like '".$this->branch."' 
                    join product_distribution pdd on pdd.product_id = id.product_id and pdd.branch_id = b.id and pdd.active='1' 
                    where im.dated between '".$period_now[0]->start_cal_p."' and '".$period_now[0]->end_cal."' and im.type='Produk - Keluar' 
                    group by b.id,b.remark,im.dated,id.product_id,ps.remark 
                    union all 
                    select b.id as branch_id,b.remark as branch_name,im.dated,id.product_id,ps.remark as product_name,0 as qty_out,sum(id.qty) as qty_in 
                    from petty_cash im 
                    join petty_cash_detail id on id.doc_no = im.doc_no 
                    join product_sku ps on ps.id = id.product_id and ps.type_id = 1 
                    join branch b on b.id = im.branch_id and b.id::character varying like '".$this->branch."' 
                    join product_distribution pdd on pdd.product_id = id.product_id and pdd.branch_id = b.id and pdd.active='1' 
                    where im.dated between '".$period_now[0]->start_cal_p."' and '".$period_now[0]->end_cal."' and im.type='Produk - Masuk' 
                    group by b.id,b.remark,im.dated,id.product_id,ps.remark 
                    union all 
                    select b.id as branch_id,b.remark as branch_name,im.dated,id.product_id,ps.remark as product_name,0 as qty_out,sum(id.qty) as qty_in 
                    from receive_master im 
                    join receive_detail id on id.receive_no = im.receive_no 
                    join product_sku ps on ps.id = id.product_id and ps.type_id = 1 
                    join branch b on b.id = im.branch_id and b.id::character varying like '".$this->branch."'
                    join product_distribution pdd on pdd.product_id = id.product_id and pdd.branch_id = b.id and pdd.active='1' 
                    where im.dated between '".$period_now[0]->start_cal_p."' and '".$period_now[0]->end_cal."'
                    group by b.id,b.remark,im.dated,id.product_id,ps.remark ) a 
                join users_branch ub on ub.branch_id = a.branch_id 
                where ub.user_id = ".$this->userid."
                group by a.branch_id,a.branch_name,product_name 
                union all 
                select b.remark as branch_name,ps.remark as product_name,qty_stock as qty_begin,0 as qty_in,0 as qty_out 
                from period_stock_daily psd 
                join branch b on b.id = psd.branch_id and b.id::character varying like '".$this->branch."'
                join users_branch uu on uu.branch_id = psd.branch_id and uu.user_id = ".$this->userid."
                join product_sku ps on ps.id = psd.product_id and ps.type_id = 1 
                join product_distribution pdd on pdd.product_id = psd.product_id and pdd.branch_id = b.id and pdd.active='1' 
                where psd.dated='".$period_now[0]->start_cal."'
            ) a group by branch_name,product_name order by 1,2
        ")); 
    }

    public function columnFormats(): array
    {
        return [
        ];
    }
}
