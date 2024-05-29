<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Calendar extends Model
{
    use HasFactory;

    protected $table = 'calendar';
    public $incrementing = false;

    protected $fillable = [
        'id',
        'dated',
        'week',
        'period',
        'updated_at',
        'updated_by',
        'created_by',
        'created_at',
        'is_holiday',
    ];
}
