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
        'customers_name',
        'total_payment',
        'total_discount',
        'remark',
        'currency',
        'kurs',
        'payment_type',
        'payment_nominal',
        'voucher_code',
        'created_by',
        'updated_by',
        'scheduled_at',
        'branch_room_id',
        'voucher_code',
        'printed_at',
        'printed_count',
        'queue_no'
    ];
}
