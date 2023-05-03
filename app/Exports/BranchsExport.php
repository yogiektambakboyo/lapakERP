<?php

namespace App\Exports;

use App\Models\Branch;
use Maatwebsite\Excel\Concerns\FromCollection;
use PhpOffice\PhpSpreadsheet\Shared\Date;
use PhpOffice\PhpSpreadsheet\Style\NumberFormat;
use Maatwebsite\Excel\Concerns\WithColumnFormatting;
use Maatwebsite\Excel\Concerns\WithHeadings;

class BranchsExport implements FromCollection,WithColumnFormatting, WithHeadings
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
            'Name',
            'Address',
            'City',
            'Abbreviation',
            'Active',
            'Create Date'
        ];
    }
    public function collection()
    {
        return Branch::orderBy('id', 'ASC')->where('branch.remark','LIKE','%'.$this->keyword.'%')->get();
    }

    public function columnFormats(): array
    {
        return [
        ];
    }
}
