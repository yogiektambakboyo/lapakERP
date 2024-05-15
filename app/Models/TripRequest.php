<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class TripRequest extends Model
{
    use HasFactory;

    protected $table = 'trip_request';

    
    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'id',
        'user_id',
        'dated_start',
        'dated_end',
        'remark',
        'updated_at',
        'created_at',
        'created_by',
        'updated_by',
        'is_approve',
        'approved_by',
        'approved_at',
        'location_source',
        'location_destination',
        'doc_no',
        'total'
    ];
}
