<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ReturnSell extends Model
{
    use HasFactory;

    protected $table = 'return_sell_master';

    
    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'return_sell_no',
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
        'updated_by',
        'scheduled_at',
        'branch_room_id',
        'ref_no',
        'customers_name',
        'printed_count'
    ];
}
