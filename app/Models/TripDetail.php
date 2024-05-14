<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class TripRequest extends Model
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
        'price',
        'total'
    ];
}
