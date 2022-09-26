<?php

namespace App\Exports;

use App\Models\Order;
use Maatwebsite\Excel\Concerns\FromCollection;
use PhpOffice\PhpSpreadsheet\Shared\Date;
use PhpOffice\PhpSpreadsheet\Style\NumberFormat;
use Maatwebsite\Excel\Concerns\WithColumnFormatting;
use Maatwebsite\Excel\Concerns\WithHeadings;

class OrdersExport implements FromCollection,WithColumnFormatting, WithHeadings
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
            'Branch',
            'Order No',
            'Dated',
            'Customer',
            'Total',
            'Total Discount',
            'Total Payment',
        ];
    }
    public function collection()
    {
        $fil = [ $this->begindate , $this->enddate ];
        return Order::orderBy('order_master.id', 'ASC')
        ->join('customers as jt','jt.id','=','order_master.customers_id')
        ->join('branch as b','b.id','=','jt.branch_id')
        ->join('users_branch as ub', function($join){
            $join->on('ub.branch_id', '=', 'b.id')
            ->whereColumn('ub.branch_id', 'jt.branch_id');
        })->where('ub.user_id', $this->user_id)
        ->where('order_master.order_no','ilike','%'.$this->keyword.'%')  
        ->where('b.id','like','%'.$this->branch.'%')  
        ->whereBetween('order_master.dated',$fil)  
      ->get(['b.remark as branch_name','order_master.order_no','order_master.dated','jt.name as customer','order_master.total','order_master.total_discount','order_master.total_payment' ]);
    }

    public function columnFormats(): array
    {
        return [
            'F' => 'yyyy-mm-dd',
        ];
    }
}
