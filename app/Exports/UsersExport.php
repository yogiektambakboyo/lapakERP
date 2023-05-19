<?php

namespace App\Exports;

use App\Models\User;
use Maatwebsite\Excel\Concerns\FromCollection;
use PhpOffice\PhpSpreadsheet\Shared\Date;
use PhpOffice\PhpSpreadsheet\Style\NumberFormat;
use Maatwebsite\Excel\Concerns\WithColumnFormatting;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Illuminate\Support\Facades\DB;


class UsersExport implements FromCollection,WithColumnFormatting, WithHeadings
{
    /**
    * @return \Illuminate\Support\Collection
    */

    private $keyword;
    private $jobtitle;
    private $enddate;
    private $branch;
    public function __construct($arg1){
        //base64_encode($keyword.'#'.$begindate.'#'.$enddate.'#'.$branchx);
        $arr = explode('#',base64_decode($arg1));
        $this->keyword      = $arr[0];
        $this->jobtitle    = $arr[1];
        $this->enddate      = $arr[2];
        $this->branch       = $arr[3];
    } 

    public function headings(): array
    {
        //u.id,u.name,u.email,u.employee_id,u.employee_status,d.remark as department,u.username,u.birth_place,u.birth_date ,u.phone_no,u.address,u.city,u.join_date,u.join_years,
        //u.gender,u.netizen_id,jt.remark as job_title ,string_agg(b.remark,',') as branch_name
        return [
            '#',
            'Name',
            'Branch Name',
            'Email',
            'Employee ID',
            'Employee Status',
            'Department',
            'Username',
            'Birth Place',
            'Birth Date',
            'Phone No',
            'Address',
            'City',
            'Join Date',
            'Join Years',
            'Gender',
            'Netizen ID',
            'Job Title',
            'Active'
        ];
    }
    public function collection()
    {
        return collect(DB::select("select u.id,u.name,string_agg(b.remark,',') as branch_name,u.email,u.employee_id,u.employee_status,d.remark as department,u.username,u.birth_place,u.birth_date ,u.phone_no,u.address,u.city,u.join_date,u.join_years,u.gender,u.netizen_id,jt.remark as job_title,u.active 
        from users u
        join users_branch ub on ub.user_id = u.id
        join branch b on b.id = ub.branch_id 
        join job_title jt on jt.id = u.job_id 
        join departments d on d.id = u.department_id 
        where u.name != 'Admin' and u.name ilike '%".$this->keyword."%' and jt.id::character varying like '%".$this->jobtitle."%' and b.id::character varying like '%".$this->branch."%' and u.join_date <= '".$this->enddate."'
        group by u.id,u.name,u.email,u.username,u.phone_no,d.remark,u.address,u.join_date,u.join_years,u.gender,u.netizen_id,u.city,u.netizen_id,jt.remark,u.employee_id,u.employee_status,u.birth_place,u.birth_date  
        "));

    }


    public function columnFormats(): array
    {
        return [
        ];
    }
}
