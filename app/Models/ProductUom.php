<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ProductUom extends Model
{
    use HasFactory;

    protected $table = 'product_uom';

    public $incrementing = false;
    protected $fillable = [
        'product_id',
        'uom_id'
    ];
}
