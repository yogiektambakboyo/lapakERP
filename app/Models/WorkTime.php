<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class WorkTime extends Model
{
    use HasFactory;

    protected $table = 'work_time';

    
    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'id',
        'user_id',
        'branch_id',
        'time_in',
        'time_out',
        'photo_in',
        'longitude_in',
        'latitude_in',
        'georeverse_in',
        'photo_out',
        'longitude_out',
        'latitude_out',
        'georeverse_out',
        'dated',
        'reason',
    ];
}
