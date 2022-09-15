<?php

namespace App\Exports;

use App\Models\User;
use Maatwebsite\Excel\Concerns\FromCollection;
use PhpOffice\PhpSpreadsheet\Shared\Date;
use PhpOffice\PhpSpreadsheet\Style\NumberFormat;
use Maatwebsite\Excel\Concerns\WithColumnFormatting;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Illuminate\Support\Facades\DB;
use App\Models\UserShift;
use Carbon\Carbon;



class UserShiftExport implements FromCollection,WithColumnFormatting, WithHeadings
{
    /**
    * @return \Illuminate\Support\Collection
    */

    private $keyword;
    private $begindate;
    private $enddate;
    private $branch;
    private $user_id;
    public function __construct($arg1){
        //base64_encode($keyword.'#'.$begindate.'#'.$enddate.'#'.$branchx);
        $arr = explode('#',base64_decode($arg1));
        $this->keyword      = $arr[0];
        $this->begindate    = $arr[1];
        $this->enddate      = $arr[2];
        $this->branch       = $arr[3];
        $this->user_id       = $arr[4];
    } 

    public function headings(): array
    {
        //u.id,u.name,u.email,u.employee_id,u.employee_status,d.remark as department,u.username,u.birth_place,u.birth_date ,u.phone_no,u.address,u.city,u.join_date,u.join_years,
        //u.gender,u.netizen_id,jt.remark as job_title ,string_agg(b.remark,',') as branch_name
        return [
            'Dated',
            'Name',
            'Branch Name',
            'Shift Name',
            'Time Start',
            'Time End',
            'Remark'
        ];
    }
    public function collection()
    {
        return UserShift::join('branch as b','b.id','users_shift.branch_id')
        ->join('users as u','u.id','=','users_shift.users_id')
        ->join('users_branch as ub', function($join){
            $join->on('ub.branch_id', '=', 'b.id');
        })->where('ub.user_id', $this->user_id)->where('u.name','ilike','%'.$this->keyword.'%')->where('users_shift.dated','>=',Carbon::now()->startOfMonth())->get(['users_shift.dated','u.name','b.remark as branch_name','users_shift.shift_remark','users_shift.shift_time_start','users_shift.shift_time_end','users_shift.remark']);

    }


    public function columnFormats(): array
    {
        return [
            'A' => 'yyyy-mm-dd',
        ];
    }
}
