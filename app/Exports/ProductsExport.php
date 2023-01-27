<?php

namespace App\Exports;

use App\Models\Product;
use Maatwebsite\Excel\Concerns\FromCollection;
use PhpOffice\PhpSpreadsheet\Shared\Date;
use PhpOffice\PhpSpreadsheet\Style\NumberFormat;
use Maatwebsite\Excel\Concerns\WithColumnFormatting;
use Maatwebsite\Excel\Concerns\WithHeadings;

class ProductsExport implements FromCollection,WithColumnFormatting, WithHeadings
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
            'External Code',
            'Name',
            'Name Abbreviation',
            'Product Type',
            'Product Category',
            'Product Brand',
        ];
    }
    public function collection()
    {
        $whereclause =  " upper(product_sku.remark) ilike '%".strtoupper($this->keyword)."%' or pt.remark ilike '%".strtoupper($this->keyword)."%' ";
        return 
        Product::orderBy('product_sku.remark', 'ASC')
                    ->join('product_type as pt','pt.id','=','product_sku.type_id')
                    ->join('product_category as pc','pc.id','=','product_sku.category_id')
                    ->join('product_brand as pb','pb.id','=','product_sku.brand_id')
                    ->whereRaw($whereclause)
                    ->get(['product_sku.external_code','product_sku.remark as product_name','product_sku.abbr','pt.remark as product_type','pc.remark as product_category','pb.remark as product_brand']);            
        
    }

    public function columnFormats(): array
    {
        return [
            'F' => 'yyyy-mm-dd',
        ];
    }
}
