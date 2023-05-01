<?php

namespace App\Exports;

use App\Models\Product;
use Maatwebsite\Excel\Concerns\FromCollection;
use PhpOffice\PhpSpreadsheet\Shared\Date;
use PhpOffice\PhpSpreadsheet\Style\NumberFormat;
use Maatwebsite\Excel\Concerns\WithColumnFormatting;
use Maatwebsite\Excel\Concerns\WithHeadings;

class VoucherExport implements FromCollection,WithColumnFormatting, WithHeadings
{
    /**
    * @return \Illuminate\Support\Collection
    */

    private $keyword;
    private $begindate;
    private $enddate;
    private $branch;
    public function __construct($arg1){
        $arr = explode('#',base64_decode($arg1));
        $this->keyword      = $arr[0];
        $this->begindate    = $arr[1];
        $this->enddate      = $arr[2];
        $this->branch       = $arr[3];
    } 

    public function headings(): array
    {
        return [
            'Voucher Name',
            'Voucher Code',
            'Service Name',
            'Branch Name',
            'Value',
            'Date Start',
            'Date End',
            'Price',
            'Already Used?',
            'Invoice No'
        ];
    }
    public function collection()
    {
        $whereclause = " upper(pr.voucher_code) like '%".strtoupper($this->keyword)."%' and '".$this->begindate."' between pr.dated_start and pr.dated_end ";
        return 
        Product::orderBy('product_sku.remark', 'ASC')
                        ->join('product_type as pt','pt.id','=','product_sku.type_id')
                        ->join('product_category as pc','pc.id','=','product_sku.category_id')
                        ->join('product_brand as pb','pb.id','=','product_sku.brand_id')
                        ->join('voucher as pr','pr.product_id','=','product_sku.id')
                        ->join('branch as bc','bc.id','=','pr.branch_id')
                        ->whereRaw($whereclause)
                        ->where('bc.id','like','%'.$this->branch.'%')  
                        ->get(['pr.remark as voucher_remark','pr.voucher_code','product_sku.remark as product_name','bc.remark as branch_name','pr.value as value','pr.dated_start','pr.dated_end','pr.price','pr.is_used','pr.invoice_no']);           
        
    }

    public function columnFormats(): array
    {
        return [];
    }
}
