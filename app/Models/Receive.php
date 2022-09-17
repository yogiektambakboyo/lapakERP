<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Receive extends Model
{
    use HasFactory;

    protected $table = 'receive_master';

    
    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'receive_no',
        'dated',
        'supplier_id',
        'supplier_name',
        'total',
        'tax',
        'total_payment',
        'total_vat',
        'total_discount',
        'remark',
        'payment_type',
        'payment_nominal',
        'voucher_code',
        'created_by',
        'updated_by',
        'scheduled_at',
        'branch_id',
        'branch_name',
        'ref_no',
        'is_receive',
        'ship_to',
    ];
}
