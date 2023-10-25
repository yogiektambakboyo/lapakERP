<?php

namespace App\Exports;

use Maatwebsite\Excel\Concerns\FromCollection;
use PhpOffice\PhpSpreadsheet\Shared\Date;
use PhpOffice\PhpSpreadsheet\Style\NumberFormat;
use Maatwebsite\Excel\Concerns\WithColumnFormatting;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Illuminate\Support\Facades\DB;


class ReportStockMutationDetailExport implements FromCollection,WithColumnFormatting, WithHeadings
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
            'Tgl',
            'Nama Produk',
            'Jumlah Masuk',
            'Jumlah Keluar',
            'Sisa Stok',
        ];
    }
    public function collection()
    {
        $data = DB::select("
        select * from (
        select branch_name,to_char(a.dated,'dd-mm-YYYY') as dated_display,product_name,sum(a.qty_in) as qty_in,sum(a.qty_out) as qty_out,coalesce(psd.qty_stock,0) as qty_stock,coalesce(ds.qty_stock,0) as qty_begin from (
            select b.id as branch_id,b.remark as branch_name,im.dated,id.product_id,ps.remark as product_name,sum(id.qty) as qty_out,0  as qty_in  from invoice_master im 
            join invoice_detail id on id.invoice_no = im.invoice_no 
            join customers c ON c.id = im.customers_id
            join product_sku ps on ps.id = id.product_id and ps.type_id = 1 
            join product_distribution pdd on pdd.product_id = id.product_id and pdd.branch_id = c.branch_id and pdd.active='1'
            join branch b on b.id = c.branch_id and b.id::character varying like '".$this->branch."'
            where im.dated between '".$this->begindate."' and '".$this->enddate."'
            group by b.id,b.remark,im.dated,id.product_id,ps.remark
            union 
            select b.id as branch_id,b.remark as branch_name,im.dated,ps2.id as product_id,ps2.remark as product_name,sum(id.qty*pi2.qty) as qty_out,0  as qty_in  from invoice_master im 
            join invoice_detail id on id.invoice_no = im.invoice_no 
            join customers c ON c.id = im.customers_id
            join product_sku ps on ps.id = id.product_id
            join product_ingredients pi2 on pi2.product_id = ps.id 
            join product_distribution pdd on pdd.product_id = pi2.product_id_material and pdd.branch_id = c.branch_id and pdd.active='1'
            join product_sku ps2 on ps2.id = pi2.product_id_material
            join branch b on b.id = c.branch_id and b.id::character varying like '".$this->branch."'
            where im.dated between '".$this->begindate."' and '".$this->enddate."'
            group by b.id,b.remark,im.dated,ps2.id,ps2.remark
            union
            select b.id as branch_id,b.remark as branch_name,im.dated,id.product_id,ps.remark as product_name,sum(id.qty) as qty_out,0  as qty_in  from petty_cash im 
            join petty_cash_detail id on id.doc_no  = im.doc_no
            join product_sku ps on ps.id = id.product_id and ps.type_id = 1
            join branch b on b.id = im.branch_id and b.id::character varying like '".$this->branch."'
            join product_distribution pdd on pdd.product_id = id.product_id and pdd.branch_id = b.id and pdd.active='1'
            where im.dated between '".$this->begindate."' and '".$this->enddate."' and im.type='Produk - Keluar'
            group by b.id,b.remark,im.dated,id.product_id,ps.remark
            union
            select b.id as branch_id,b.remark as branch_name,im.dated,id.product_id,ps.remark as product_name,0 as qty_out,sum(id.qty)  as qty_in  from petty_cash im 
            join petty_cash_detail id on id.doc_no  = im.doc_no
            join product_sku ps on ps.id = id.product_id and ps.type_id = 1 
            join branch b on b.id = im.branch_id and b.id::character varying like '".$this->branch."'
            join product_distribution pdd on pdd.product_id = id.product_id and pdd.branch_id = b.id and pdd.active='1'
            where im.dated between '".$this->begindate."' and '".$this->enddate."' and im.type='Produk - Masuk'
            group by b.id,b.remark,im.dated,id.product_id,ps.remark
            union
            select b.id as branch_id,b.remark as branch_name,im.dated,id.product_id,ps.remark as product_name,0 as qty_out,sum(id.qty) as qty_in  from receive_master im 
            join receive_detail id on id.receive_no = im.receive_no 
            join product_sku ps on ps.id = id.product_id and ps.type_id = 1 
            join branch b on b.id = im.branch_id and b.id::character varying like '".$this->branch."'
            join product_distribution pdd on pdd.product_id = id.product_id and pdd.branch_id = b.id and pdd.active='1'
            where im.dated between '".$this->begindate."' and '".$this->enddate."'
            group by b.id,b.remark,im.dated,id.product_id,ps.remark
        ) a join users_branch ub on ub.branch_id = a.branch_id 
        left join period_stock_daily psd on psd.dated = a.dated and psd.product_id = a.product_id and psd.branch_id  = a.branch_id       
        left join (select dated,branch_id,product_id,qty_stock,rank()  OVER (partition by branch_id,product_id ORDER BY branch_id,product_id,dated DESC) as ranking  from period_stock_daily where dated<'".$this->begindate."') ds on ds.ranking=1  and ds.product_id = a.product_id and ds.branch_id  = a.branch_id      
        where ub.user_id = ".$this->userid."
        group by ds.qty_stock,a.branch_id,a.branch_name,a.dated,product_name,coalesce(psd.qty_stock,0),to_char(a.dated,'dd-mm-YYYY')
        union all 
            select b.remark as branch_name,'00-00-0000' as dated_display,ps.remark as product_name,0 as qty_in,0 as qty_out,qty_stock,qty_stock as qty_begin 
            from period_stock_daily psd 
            join branch b  on b.id = psd.branch_id and b.id::character varying like '".$this->branch."'
            join product_distribution pdd on pdd.product_id = psd.product_id and pdd.branch_id = b.id and pdd.active='1'
            join users_branch uu on uu.branch_id = psd.branch_id  and uu.user_id = ".$this->userid."
            join product_sku ps on ps.id = psd.product_id and ps.type_id = 1
            where psd.dated=('".$this->begindate."'::date-interval'1 days')::date
            ) a order by 1,3,2  

        ");

        
        $qty_begin = 0;
        $l_product = "";
        $l_branch = "";

        for ($i=0; $i < count($data); $i++) { 
            if($l_branch == ""){
                $qty_begin = 0;
            }  

            if($l_branch <> $data[$i]->branch_name || $l_product <> $data[$i]->product_name){
                $qty_begin = $data[$i]->qty_begin;
                $l_product = $data[$i]->product_name;
                $l_branch = $data[$i]->branch_name;

                if($data[$i]->dated_display=="00-00-0000"){
                    $data[$i]->dated_display = "00 - Saldo Awal - 00";
                    $data[$i]->qty_in = 0;
                    $data[$i]->qty_out = 0;
                }
            }else{
                $qty_begin = ($qty_begin+$data[$i]->qty_in)-$data[$i]->qty_out;
            }

            unset($data[$i]->qty_begin);

            $data[$i]->qty_stock = $qty_begin;
        }

        return collect($data); 
    }

    public function columnFormats(): array
    {
        return [
        ];
    }
}
