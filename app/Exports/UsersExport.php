<?php

namespace App\Exports;

use App\Models\User;
use Maatwebsite\Excel\Concerns\FromCollection;
use PhpOffice\PhpSpreadsheet\Shared\Date;
use PhpOffice\PhpSpreadsheet\Style\NumberFormat;
use Maatwebsite\Excel\Concerns\WithColumnFormatting;
use Maatwebsite\Excel\Concerns\WithHeadings;

class UsersExport implements FromCollection,WithColumnFormatting, WithHeadings
{
    /**
    * @return \Illuminate\Support\Collection
    */

    private $keyword;
    public function __construct($arg1){
        $this->keyword = $arg1;
    } 

    public function headings(): array
    {
        return [
            '#',
            'Employee ID',
            'Name',
            'Job Title',
            'Join Date',
        ];
    }
    public function collection()
    {
        return User::orderBy('id', 'ASC')->join('job_title as jt','jt.id','=','users.job_id')
        ->where('users.name','!=','Admin')->where('users.name','like','%'.$this->keyword.'%')->get(['users.id','users.employee_id','users.name','jt.remark as job_title','users.join_date' ]);
    }

    public function columnFormats(): array
    {
        return [
            'F' => 'yyyy-mm-dd',
        ];
    }
}
