<?php

namespace App\Exports;

use Maatwebsite\Excel\Concerns\FromCollection;
use PhpOffice\PhpSpreadsheet\Shared\Date;
use PhpOffice\PhpSpreadsheet\Style\NumberFormat;
use Maatwebsite\Excel\Concerns\WithColumnFormatting;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Illuminate\Support\Facades\DB;


class ReportCustomerRegExport implements FromCollection,WithColumnFormatting, WithHeadings
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
            'Cabang',
            'Seller Name',
            '#ID',
            'Name',
            'Address',
            'Phone No',
            'Handphone',
            'City',
            'Credit Limit',
            'Longitude',
            'Latitude',
            'Email',
            'Citizen Id',
            'Tax ID',
            'Contact Person',
            'Contact Person Job Position',
            'contact Person Level',
            'Type',
            'Clasification',
            'Photo',
            'Notes',
            'Created At',
        ];
    }
    public function collection()
    {
        return collect(DB::select("
                select b.remark as  branch_name,s.name as sellername,cr.id,cr.name,cr.address,cr.phone_no,cr.handphone,cr.city,cr.credit_limit,cr.longitude,cr.latitude,cr.email,cr.citizen_id,cr.tax_id,
                cr.contact_person,cr.contact_person_job_position,cr.contact_person_level,cr.type,cr.clasification,'https://kakikupos.com/images/smd-image/'||cr.photo as photo,regexp_replace(cr.notes, E'[\\n\\r]+', ' ', 'g' ) as notes  
                from customers_registration cr 
                join sales s on s.id = cr.sales_id 
                join branch b on b.id = s.branch_id and b.id::character varying like '%".$this->branch."%'
                where cr.created_at::date between '".$this->begindate."' and '".$this->enddate."'
                order by  b.remark
        ")); 
    }

    public function columnFormats(): array
    {
        return [];
    }
}
