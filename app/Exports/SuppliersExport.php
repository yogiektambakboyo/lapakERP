<?php

namespace App\Exports;

use App\Models\User;
use Maatwebsite\Excel\Concerns\FromCollection;
use PhpOffice\PhpSpreadsheet\Shared\Date;
use PhpOffice\PhpSpreadsheet\Style\NumberFormat;
use Maatwebsite\Excel\Concerns\WithColumnFormatting;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Illuminate\Support\Facades\DB;
use App\Models\Supplier;


class SuppliersExport implements FromCollection,WithColumnFormatting, WithHeadings
{
    /**
    * @return \Illuminate\Support\Collection
    */

    private $keyword;
    private $branch;
    private $user_id;
    public function __construct($arg1){
        $arr = explode('#',base64_decode($arg1));
        $this->keyword      = $arr[0];
        $this->branch    = $arr[1];
        $this->user_id    = $arr[2];
    } 

    public function headings(): array
    {
        //b.remark as branch_name','customers.name','customers.address','customers.phone_no
        return [
            'Branch Name',
            'Name',
            'Address',
            'Handphone',
            'Email',
        ];
    }
    public function collection()
    {
        return Supplier::join('branch as b','b.id','suppliers.branch_id')
        ->join('users_branch as ub', function($join){
            $join->on('ub.branch_id', '=', 'b.id');
        })->where('ub.user_id', $this->user_id)->where('suppliers.branch_id','like','%'.$this->branch.'%')->where('suppliers.name','ILIKE','%'.$this->keyword.'%')->get(['b.remark as branch_name','suppliers.name','suppliers.address','suppliers.handphone','suppliers.email']);;

    }


    public function columnFormats(): array
    {
        return [
            
        ];
    }
}
