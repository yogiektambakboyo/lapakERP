<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ProductStock extends Model
{
    use HasFactory;

    protected $table = 'product_stock';
    public $incrementing = false;

    protected $fillable = [
        'product_id',
        'branch_id',
        'qty',
        'created_by'
    ];
}
