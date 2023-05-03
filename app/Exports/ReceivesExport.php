<?php

namespace App\Exports;

use App\Models\Receive;
use Maatwebsite\Excel\Concerns\FromCollection;
use PhpOffice\PhpSpreadsheet\Shared\Date;
use PhpOffice\PhpSpreadsheet\Style\NumberFormat;
use Maatwebsite\Excel\Concerns\WithColumnFormatting;
use Maatwebsite\Excel\Concerns\WithHeadings;

class ReceivesExport implements FromCollection,WithColumnFormatting, WithHeadings
{
    /**
    * @return \Illuminate\Support\Collection
    */

    private $keyword;
    private $begindate;
    private $enddate;
    private $branch;
    public function __construct($arg1){
        //base64_encode($keyword.'#'.$begindate.'#'.$enddate.'#'.$branchx);
        $arr = explode('#',base64_decode($arg1));
        $this->keyword      = $arr[0];
        $this->begindate    = $arr[1];
        $this->enddate      = $arr[2];
        $this->branch       = $arr[3];
    } 

    public function headings(): array
    {
        return [
            'Branch',
            'Receive No',
            'Dated',
            'Supplier',
            'Total',
        ];
    }
    public function collection()
    {
        $fil = [ $this->begindate , $this->enddate ];
        return Receive::orderBy('receive_master.id', 'ASC')
        ->join('suppliers as jt','jt.id','=','receive_master.supplier_id')
        ->join('branch as b','b.id','=','jt.branch_id')
        ->where('b.id','like','%'.$this->branch.'%')  
        ->where('receive_master.receive_no','like','%'.$this->keyword.'%')
        ->whereBetween('receive_master.dated',$fil)  
      ->get(['b.remark as branch_name','receive_master.receive_no','receive_master.dated','jt.name as supplier','receive_master.total' ]);
    }

    public function columnFormats(): array
    {
        return [
        ];
    }
}
