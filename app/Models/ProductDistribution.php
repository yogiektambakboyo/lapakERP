<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ProductDistribution extends Model
{
    use HasFactory;

    protected $table = 'product_distribution';

    protected $fillable = [
        'product_id',
        'branch_id',
        'active'
    ];
}
