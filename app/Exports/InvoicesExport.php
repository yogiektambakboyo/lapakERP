<?php

namespace App\Exports;

use App\Models\Invoice;
use Maatwebsite\Excel\Concerns\FromCollection;
use PhpOffice\PhpSpreadsheet\Shared\Date;
use PhpOffice\PhpSpreadsheet\Style\NumberFormat;
use Maatwebsite\Excel\Concerns\WithColumnFormatting;
use Maatwebsite\Excel\Concerns\WithHeadings;

class InvoicesExport implements FromCollection,WithColumnFormatting, WithHeadings
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
        return [
            'Cabang',
            'No Faktur Jual',
            'Tanggal',
            'Customer',
            'Total',
            'Total Discount',
            'Total Payment',
            'Updated_at',
            'Created_at'
        ];
    }
    public function collection()
    {
        $fil = [ $this->begindate , $this->enddate ];
        return $invoices = Invoice::orderBy('invoice_master.id', 'ASC')
                ->join('customers as jt','jt.id','=','invoice_master.customers_id')
                ->join('branch as b','b.id','=','jt.branch_id')
                ->join('users_branch as ub', function($join){
                    $join->on('ub.branch_id', '=', 'b.id')
                    ->whereColumn('ub.branch_id', 'jt.branch_id');
                })->where('ub.user_id', $this->user_id)  
                ->where('invoice_master.invoice_no','ilike','%'.$this->keyword.'%') 
                ->where('b.id','like','%'.$this->branch.'%') 
                ->where('invoice_master.invoice_no','ilike','INV-%')
                ->whereBetween('invoice_master.dated',$fil) 
              ->get(['b.remark as branch_name','invoice_master.invoice_no','invoice_master.dated','jt.name as customer','invoice_master.total','invoice_master.total_discount','invoice_master.total_payment','invoice_master.updated_at','invoice_master.created_at' ]);
    }

    public function columnFormats(): array
    {
        return [
        ];
    }
}
