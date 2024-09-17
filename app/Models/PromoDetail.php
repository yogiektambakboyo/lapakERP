<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PromoDetail extends Model
{
    use HasFactory;

    protected $table = 'promo_detail';

    
    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'doc_no',
        'remark',
        'qty',
        'value_nominal',
        'product_id',
        'created_by',
        'created_at',
        'updated_by',
        'updated_at',
    ];

}
