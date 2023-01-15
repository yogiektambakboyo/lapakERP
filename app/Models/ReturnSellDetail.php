<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ReturnSellDetail extends Model
{
    use HasFactory;

    public $incrementing = false;

    protected $table = 'return_sell_detail';

    
    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'return_sell_no',
        'product_id',
        'qty',
        'price',
        'total',
        'discount',
        'seq',
        'assigned_to',
        'referral_by',
        'assigned_to_name',
        'referral_by_name',
        'vat',
        'vat_total',
        'product_name',
        'uom'
    ];
}
