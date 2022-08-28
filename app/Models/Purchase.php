<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Purchase extends Model
{
    use HasFactory;

    protected $table = 'purchase_master';

    
    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'purchase_no',
        'dated',
        'supplier_id',
        'total',
        'total_vat',
        'total_payment',
        'total_discount',
        'remark',
        'payment_type',
        'payment_nominal',
        'voucher_code',
        'created_by',
        'updated_by',
        'scheduled_at',
        'branch_id',
        'total_discount',
        'ref_no',
        'is_receive',
        'ship_to',
    ];
}
