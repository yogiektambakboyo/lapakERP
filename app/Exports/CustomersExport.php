<?php

namespace App\Exports;

use App\Models\User;
use Maatwebsite\Excel\Concerns\FromCollection;
use PhpOffice\PhpSpreadsheet\Shared\Date;
use PhpOffice\PhpSpreadsheet\Style\NumberFormat;
use Maatwebsite\Excel\Concerns\WithColumnFormatting;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Illuminate\Support\Facades\DB;
use App\Models\Customer;


class CustomersExport implements FromCollection,WithColumnFormatting, WithHeadings
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
            'External Code',
            'Name',
            'Address',
            'Phone No',
            'Segment',
        ];
    }
    public function collection()
    {
        return Customer::join('branch as b','b.id','customers.branch_id')
        ->join('customers_segment as cs','cs.id','=','customers.segment_id')
        ->join('users_branch as ub', function($join){
            $join->on('ub.branch_id', '=', 'b.id');
        })->where('ub.user_id', $this->user_id)->where('customers.branch_id','like','%'.$this->branch.'%')->where('customers.name','ILIKE','%'.$this->keyword.'%')->get(['b.remark as branch_name','customers.external_code','customers.name','customers.address','customers.phone_no','cs.remark as segment_name']);;

    }


    public function columnFormats(): array
    {
        return [
            
        ];
    }
}
