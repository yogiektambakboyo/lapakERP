<?php

namespace App\Exports;

use App\Models\User;
use Maatwebsite\Excel\Concerns\FromCollection;
use PhpOffice\PhpSpreadsheet\Shared\Date;
use PhpOffice\PhpSpreadsheet\Style\NumberFormat;
use Maatwebsite\Excel\Concerns\WithColumnFormatting;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Illuminate\Support\Facades\DB;
use App\Models\BranchShift;
use Carbon\Carbon;



class BranchShiftExport implements FromCollection,WithColumnFormatting, WithHeadings
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
            'Branch Name',
            'Shift Name',
            'Time Start',
            'Time End'
        ];
    }
    public function collection()
    {
        return $BranchShift = BranchShift::join('branch as b','b.id','branch_shift.branch_id')
            ->join('shift as ub', function($join){
                $join->on('ub.id', '=', 'branch_shift.shift_id');
            })->where('b.remark','ilike','%'.$this->keyword.'%')->get(['b.remark as branch_name','ub.remark as shift_name','ub.time_start','ub.time_end']);
        
    }


    public function columnFormats(): array
    {
        return [
        ];
    }
}
