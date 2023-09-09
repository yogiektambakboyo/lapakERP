<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ShipmentDetail extends Model
{
    use HasFactory;

    protected $table = 'shipment_detail';

    
    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'doc_no',
        'updated_by',
        'updated_at',
        'created_by',
        'created_at',
        'product_id',
        'qty',
        'ref_no',
        'ref_no_po' ,
        'remark',
        'product_name'
    ];
}
