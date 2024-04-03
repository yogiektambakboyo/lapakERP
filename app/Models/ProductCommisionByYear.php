<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ProductCommisionByYear extends Model
{
    use HasFactory;

    protected $table = 'product_commision_by_year';
    public $incrementing = false;

    protected $fillable = [
        'product_id',
        'branch_id',
        'jobs_id',
        'years',
        'values',
        'values_extra',
        'created_by'
    ];
}
