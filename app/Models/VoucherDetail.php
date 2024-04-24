<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class VoucherDetail extends Model
{
    use HasFactory;

    protected $table = 'voucher_detail';
    public $incrementing = false;

    protected $fillable = [
        'product_id',
        'voucher_code',
        'created_by',
        'created_at',
        'branch_id',
        'updated_at'
    ];
}
