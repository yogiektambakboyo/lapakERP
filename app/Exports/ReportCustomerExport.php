<?php

namespace App\Exports;

use App\Models\Invoice;
use Maatwebsite\Excel\Concerns\FromCollection;
use PhpOffice\PhpSpreadsheet\Shared\Date;
use PhpOffice\PhpSpreadsheet\Style\NumberFormat;
use Maatwebsite\Excel\Concerns\WithColumnFormatting;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Illuminate\Support\Facades\DB;


class ReportCustomerExport implements FromCollection,WithColumnFormatting, WithHeadings
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
            'Customer Name',
            'Address',
            'Phone No',
        ];
    }
    public function collection()
    {
        return collect(DB::select("
            select b.remark as branch_name,c.name as customers_name,c.address,c.phone_no  from customers c
            join branch b on b.id = c.branch_id 
            join users_branch ub on ub.branch_id = b.id and ub.user_id = ".$this->userid." and ub.branch_id::character varying like '%".$this->branch."%'                       
        ")); 
    }

    public function columnFormats(): array
    {
        return [
        ];
    }
}
