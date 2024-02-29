<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PromoDetail extends Model
{
    use HasFactory;

    protected $table = 'promo_detail';
    public $incrementing = false;

    protected $fillable = [
        'product_id',
        'promo_id',
        'id',
    ];
}
