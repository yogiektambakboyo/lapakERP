<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Order extends Model
{
    use HasFactory;

    protected $table = 'order_master';

    
    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'order_no',
        'dated',
        'customers_id',
        'total',
        'tax',
        'total_payment',
        'total_discount',
        'remark',
        'payment_type',
        'payment_nominal',
        'voucher_code',
        'created_by',
    ];
}
