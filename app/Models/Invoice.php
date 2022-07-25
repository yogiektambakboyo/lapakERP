<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Invoice extends Model
{
    use HasFactory;

    protected $table = 'invoice_master';

    
    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'invoice_no',
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
        'ref_no'
    ];
}
