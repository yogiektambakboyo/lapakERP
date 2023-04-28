<?php

namespace App\Exports;

use Maatwebsite\Excel\Concerns\FromCollection;
use PhpOffice\PhpSpreadsheet\Shared\Date;
use PhpOffice\PhpSpreadsheet\Style\NumberFormat;
use Maatwebsite\Excel\Concerns\WithColumnFormatting;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Illuminate\Support\Facades\DB;


class ReportTripMapExport implements FromCollection,WithColumnFormatting, WithHeadings
{
    /**
    * @return \Illuminate\Support\Collection
    */

    private $begindate;
    private $seller;
    private $branch;
    private $userid;
    public function __construct($arg1){
        //base64_encode($keyword.'#'.$begindate.'#'.$enddate.'#'.$branchx);
        $arr = explode('#',base64_decode($arg1));
        $this->begindate    = $arr[0];
        $this->branch       = $arr[1];
        $this->userid       = $arr[2];
        $this->seller       = $arr[3];
    } 

    public function headings(): array
    {
        return [
            'Branch',
            'Name',
            'Geolocation',
            'Georeverse',
            'Created_at',
        ];
    }
    public function collection()
    {
        return collect(DB::select("
                select b.remark,s.name,std.latitude||','||std.longitude,std.georeverse,to_char(std.created_at,'YYYY-MM-DD HH24:MI:ss') as created_at  from sales_trip st 
                join sales_trip_detail std on std.trip_id = st.id 
                join sales s on s.id = st.sales_id  and s.id::character varying like '%".$this->seller."%'
                join branch b on b.id = s.branch_id  and b.id::character varying like '%".$this->branch."%'
                join users_branch ub on ub.branch_id = b.id 
                join users u on u.id = ".$this->userid." and u.id = ub.user_id 
                where st.dated = '".$this->begindate."' order by name asc,std.created_at asc            
        ")); 
    }

    public function columnFormats(): array
    {
        return [];
    }
}
