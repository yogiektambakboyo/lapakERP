<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ProductCommisionsEx extends Model
{
    use HasFactory;

    protected $table = 'product_commisions_ex';
    public $incrementing = false;
    

    protected $fillable = [
        'product_id',
        'branch_id',
        'created_by',
        'created_by_fee',
        'users_id',
        'referral_fee',
        'remark'
    ];
}
