<?php

namespace App\Exports;

use Maatwebsite\Excel\Concerns\FromCollection;
use PhpOffice\PhpSpreadsheet\Shared\Date;
use PhpOffice\PhpSpreadsheet\Style\NumberFormat;
use Maatwebsite\Excel\Concerns\WithColumnFormatting;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Illuminate\Support\Facades\DB;


class ReportSalesTripExport implements FromCollection,WithColumnFormatting, WithHeadings
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
            'Trip ID',
            'Time_tart',
            'Time End',
            'Active',
            'Photo',
            'Notes',
            'Created At',
        ];
    }
    public function collection()
    {
        return collect(DB::select("

            select b.remark as  branch_name,dated,s.name as sellername,st.id as trip_id,st.time_start,st.time_end,st.active as active_trip,st.photo, st.notes,st.created_at 
            from sales_trip st 
            join sales s on s.id = st.sales_id 
            join branch b on b.id = s.branch_id and b.id::character varying like '%".$this->branch."%'
            where st.dated between '".$this->begindate."' and '".$this->enddate."'
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
