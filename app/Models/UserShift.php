<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class UserShift extends Model
{
    use HasFactory;

    protected $table = 'users_shift';

    protected $fillable = [
        'users_id',
        'branch_id',
        'dated',
        'shift_id',
        'shift_remark',
        'shift_time_start',
        'shift_time_end',
        'remark',
        'updated_at',
        'created_at',
    ];
}
