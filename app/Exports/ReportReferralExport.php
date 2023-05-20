<?php

namespace App\Exports;

use Maatwebsite\Excel\Concerns\FromCollection;
use PhpOffice\PhpSpreadsheet\Shared\Date;
use PhpOffice\PhpSpreadsheet\Style\NumberFormat;
use Maatwebsite\Excel\Concerns\WithColumnFormatting;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Illuminate\Support\Facades\DB;


class ReportReferralExport implements FromCollection,WithColumnFormatting, WithHeadings
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
        //b.remark as branch_name,u.employee_id,u.name,u.join_date,u.join_years,uf.name 
        return [
            'Cabang',
            'Employee ID',
            'Name',
            'Join Date',
            'Join Year',
            'Referral Name',
        ];
    }
    public function collection()
    {
        return collect(DB::select("
            select b.remark as branch_name,u.employee_id,u.name,u.join_date,u.join_years,uf.name as referral_name
            from users u
            join users uf on uf.id = u.referral_id  
            join users_branch ub on ub.user_id = u.id and ub.branch_id in (select branch_id from users_branch where user_id=".$this->userid." )
            join branch b on b.id = ub.branch_id and b.id::character varying like '%".$this->branch."%' 
            where u.active = '1'            
        ")); 
    }

    public function columnFormats(): array
    {
        return [
            
        ];
    }
}
