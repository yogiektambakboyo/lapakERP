<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ProductPoint extends Model
{
    use HasFactory;

    protected $table = 'product_point';

    protected $fillable = [
        'product_id',
        'branch_id',
        'point',
    ];
}
