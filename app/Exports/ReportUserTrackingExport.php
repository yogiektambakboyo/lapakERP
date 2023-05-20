<?php

namespace App\Exports;

use Maatwebsite\Excel\Concerns\FromCollection;
use PhpOffice\PhpSpreadsheet\Shared\Date;
use PhpOffice\PhpSpreadsheet\Style\NumberFormat;
use Maatwebsite\Excel\Concerns\WithColumnFormatting;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Illuminate\Support\Facades\DB;


class ReportUserTrackingExport implements FromCollection,WithColumnFormatting, WithHeadings
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
            'Nama',
            'Cabang',
            'Posisi',
            'Dibuat',
        ];
    }
    public function collection()
    {
        return collect(DB::select("
        select u.name,b.remark as branch_name,jt.remark  as job_title ,um.created_at  from users_mutation um 
        join users u on u.id = um.user_id 
        join users_branch ub on ub.user_id = u.id and ub.branch_id::character varying like '%".$this->branch."%' 
        join branch b on b.id = um.branch_id 
        join job_title jt on jt.id = um.job_id 
        where um.created_at between '".$this->begindate."' and '".$this->enddate."' 
        order by um.created_at             
        ")); 
    }

    public function columnFormats(): array
    {
        return [
            
        ];
    }
}
