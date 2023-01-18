<?php

namespace App\Exports;

use Maatwebsite\Excel\Concerns\FromCollection;
use PhpOffice\PhpSpreadsheet\Shared\Date;
use PhpOffice\PhpSpreadsheet\Style\NumberFormat;
use Maatwebsite\Excel\Concerns\WithColumnFormatting;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Illuminate\Support\Facades\DB;


class ReportSalesVisitExport implements FromCollection,WithColumnFormatting, WithHeadings
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
            'Branch',
            'Dated',
            'Seller Name',
            'Customer Name',
            'Geolocation',
            'Georeverse',
            'Is Checkout',
            'Time Start',
            'Time End',
            'Photo',
            'Created At',
        ];
    }
    public function collection()
    {
        return collect(DB::select("


                    select b.remark as  branch_name,dated,s.name as sellername,c.name as customer_name,st.latitude||','||st.longitude,st.georeverse,st.is_checkout,to_char(st.time_start,'yyyy-MM-dd HH24:MI') time_start,to_char(st.time_end,'yyyy-MM-dd HH24:MI') time_end,st.photo,to_char(st.created_at,'yyyy-MM-dd HH24:MI:ss') created_at 
                    from sales_visit st 
                    join sales s on s.id = st.sales_id 
                    join customers c on c.id = st.customer_id 
                    join branch b on b.id = s.branch_id  and b.id::character varying like '%".$this->branch."%' 
                    where st.dated  between '".$this->begindate."' and '".$this->enddate."'
                    order by b.remark,s.name,st.time_start  

        
        ")); 
    }

    public function columnFormats(): array
    {
        return [
            'B' => 'yyyy-mm-dd',
        ];
    }
}
