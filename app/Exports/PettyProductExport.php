<?php

namespace App\Exports;

use App\Models\PettyCash;
use Maatwebsite\Excel\Concerns\FromCollection;
use PhpOffice\PhpSpreadsheet\Shared\Date;
use PhpOffice\PhpSpreadsheet\Style\NumberFormat;
use Maatwebsite\Excel\Concerns\WithColumnFormatting;
use Maatwebsite\Excel\Concerns\WithHeadings;

class PettyProductExport implements FromCollection,WithColumnFormatting, WithHeadings
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
            'Document No',
            'Tanggal',
            'Type',
            'Remark',
        ];
    }
    public function collection()
    {
        $fil = [ $this->begindate , $this->enddate ];
        return PettyCash::orderBy('petty_cash.dated', 'ASC')
                ->join('branch as b','b.id','=','petty_cash.branch_id')
                ->join('users_branch as ub', function($join){
                    $join->on('ub.branch_id', '=', 'b.id')
                    ->whereColumn('ub.branch_id', 'petty_cash.branch_id');
                })->where('ub.user_id', $this->user_id)  
                ->where('petty_cash.doc_no','ilike','%'.$this->keyword.'%') 
                ->where('b.id','like','%'.$this->branch.'%') 
                ->where('petty_cash.type','!=','Kas - Keluar')
                ->whereBetween('petty_cash.dated',$fil) 
                ->get(['b.remark as branch_name','petty_cash.doc_no','petty_cash.dated','petty_cash.type','petty_cash.remark' ]);
    }

    public function columnFormats(): array
    {
        return [
        ];
    }
}
