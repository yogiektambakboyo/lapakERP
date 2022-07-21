<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ProductPrice extends Model
{
    use HasFactory;

    protected $table = 'product_price';
    public $incrementing = false;

    protected $fillable = [
        'product_id',
        'branch_id',
        'price',
        'created_by'
    ];
}
