<?php

namespace App\Exports;

use App\Models\Product;
use Maatwebsite\Excel\Concerns\FromCollection;
use PhpOffice\PhpSpreadsheet\Shared\Date;
use PhpOffice\PhpSpreadsheet\Style\NumberFormat;
use Maatwebsite\Excel\Concerns\WithColumnFormatting;
use Maatwebsite\Excel\Concerns\WithHeadings;

class ProductsPriceAdjExport implements FromCollection,WithColumnFormatting, WithHeadings
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
            'Branch Name',
            'Product Name',
            'Value',
            'Date Start',
            'Date End',
        ];
    }
    public function collection()
    {
        $whereclause = " upper(product_sku.remark) like '%".strtoupper($this->keyword)."%' and now()::date between '".$this->begindate."' and '".$this->enddate."' ";
        return 
        Product::orderBy('product_sku.remark', 'ASC')
                        ->join('product_type as pt','pt.id','=','product_sku.type_id')
                        ->join('product_category as pc','pc.id','=','product_sku.category_id')
                        ->join('product_brand as pb','pb.id','=','product_sku.brand_id')
                        ->join('price_adjustment as pr','pr.product_id','=','product_sku.id')
                        ->join('branch as bc','bc.id','=','pr.branch_id')
                        ->whereRaw($whereclause)
                        ->where('bc.id','like','%'.$this->branch.'%')  
                        ->paginate(10,['bc.remark as branch_name','product_sku.remark as product_name','pr.value as value','pr.dated_start','pr.dated_end']);           
        
    }

    public function columnFormats(): array
    {
        return [
            'F' => 'yyyy-mm-dd',
        ];
    }
}
