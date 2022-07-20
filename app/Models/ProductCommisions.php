<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ProductCommisions extends Model
{
    use HasFactory;

    protected $table = 'product_commisions';

    protected $fillable = [
        'product_id',
        'branch_id',
        'created_by_fee',
        'assigned_to_fee',
        'referral_fee',
        'remark'
    ];
}
