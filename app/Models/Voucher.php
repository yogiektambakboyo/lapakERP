<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Voucher extends Model
{
    use HasFactory;

    protected $table = 'voucher';
    public $incrementing = false;

    protected $fillable = [
        'product_id',
        'branch_id',
        'voucher_code',
        'remark',
        'value',
        'price',
        'dated_start',
        'dated_end',
        'created_by',
        'created_at',
        'updated_at'
    ];
}
