<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class TripDetail extends Model
{
    use HasFactory;

    protected $table = 'trip_detail';

    
    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'id',
        'remark',
        'updated_at',
        'created_at',
        'created_by',
        'updated_by',
        'doc_no',
        'qty',
        'product_id',
        'price',
        'uom',
        'seq',
        'total'
    ];
}
