<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Promo extends Model
{
    use HasFactory;

    protected $table = 'promo_master';

    
    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'doc_no',
        'remark',
        'value_idx',
        'value_nominal',
        'dated_start',
        'dated_end',
        'is_term',
        'product_id',
        'created_by',
        'created_at',
        'branch_id',
        'updated_by',
        'updated_at',
    ];

}
