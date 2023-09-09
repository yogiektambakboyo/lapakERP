<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Shipment extends Model
{
    use HasFactory;

    protected $table = 'shipment_master';

    
    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'dated',
        'doc_no',
        'updated_by',
        'updated_at',
        'created_by',
        'created_at',
        'isshipped',
        'shipped_at',
        'shipped_by',
        'remark',
        'customer_id',
        'address',
        'shipping_method',
        'shipper_name',
        'etd',
        'eta',
        'awb',
        'weight',
        'volume',
        'status',
        'shipment_cost',
    ];
}
