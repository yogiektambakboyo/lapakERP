<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Shift extends Model
{
    use HasFactory;

    protected $table = 'shift';

    protected $fillable = [
        'id',
        'remark',
        'time_start',
        'time_end',
        'updated_at',
        'created_at',
        'created_by'
    ];
}
