<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ProductPriceAdj extends Model
{
    use HasFactory;

    protected $table = 'price_adjustment';
    public $incrementing = false;

    protected $fillable = [
        'product_id',
        'branch_id',
        'value',
        'dated_start',
        'dated_end',
        'created_by',
        'created_at',
        'updated_at'
    ];
}
