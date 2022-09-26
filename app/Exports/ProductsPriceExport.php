<?php

namespace App\Exports;

use App\Models\Product;
use Maatwebsite\Excel\Concerns\FromCollection;
use PhpOffice\PhpSpreadsheet\Shared\Date;
use PhpOffice\PhpSpreadsheet\Style\NumberFormat;
use Maatwebsite\Excel\Concerns\WithColumnFormatting;
use Maatwebsite\Excel\Concerns\WithHeadings;

class ProductsPriceExport implements FromCollection,WithColumnFormatting, WithHeadings
{
    /**
    * @return \Illuminate\Support\Collection
    */

    private $keyword;
    private $branch;
    public function __construct($arg1){
        $arr = explode('#',base64_decode($arg1));
        $this->keyword      = $arr[0];
        $this->branch       = $arr[1];
    } 

    public function headings(): array
    {
        return [
            'Product Name',
            'Branch Name',
            'Product Price',
        ];
    }
    public function collection()
    {
        $whereclause = " upper(product_sku.remark) like '%".strtoupper($this->keyword)."%'";
        return 
        Product::orderBy('product_sku.remark', 'ASC')
                        ->join('product_type as pt','pt.id','=','product_sku.type_id')
                        ->join('product_category as pc','pc.id','=','product_sku.category_id')
                        ->join('product_brand as pb','pb.id','=','product_sku.brand_id')
                        ->join('product_price as pr','pr.product_id','=','product_sku.id')
                        ->join('branch as bc','bc.id','=','pr.branch_id')
                        ->whereRaw($whereclause)
                        ->where('bc.id','like','%'.$this->branch.'%')  
                        ->get(['product_sku.remark as product_name','bc.remark as branch_name','pr.price as product_price']);            
        
    }

    public function columnFormats(): array
    {
        return [
            'F' => 'yyyy-mm-dd',
        ];
    }
}
