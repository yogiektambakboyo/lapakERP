<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class OrderDetail extends Model
{
    use HasFactory;

    public $incrementing = false;

    protected $table = 'order_detail';

    
    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'order_no',
        'product_id',
        'product_name',
        'qty',
        'price',
        'total',
        'discount',
        'seq',
        'uom',
        'vat',
        'vat_total',
        'assigned_to',
        'assigned_to_name',
        'referral_by',
        'referral_by_name',
    ];
}
