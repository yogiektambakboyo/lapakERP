<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PettyCashDetail extends Model
{
    use HasFactory;

    protected $table = 'petty_cash_detail';

    protected $fillable = [
        'id',
        'dated',
        'remark',
        'product_id',
        'qty',
        'price',
        'line_total',
        'updated_at',
        'updated_by',
        'created_by',
        'created_at',
        'doc_no',
    ];
}
