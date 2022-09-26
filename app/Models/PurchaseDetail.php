<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PurchaseDetail extends Model
{
    use HasFactory;

    public $incrementing = false;

    protected $table = 'purchase_detail';

    
    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'purchase_no',
        'product_id',
        'qty',
        'price',
        'subtotal',
        'subtotal_vat',
        'vat_total',
        'uom',
        'vat',
        'product_remark',
        'discount',
        'seq'
    ];
}
