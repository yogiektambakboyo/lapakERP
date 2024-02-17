<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Promo extends Model
{
    use HasFactory;

    protected $table = 'promo';
    public $incrementing = false;

    protected $fillable = [
        'branch_id',
        'promo_id',
        'remarks',
        'value',
        'value_idx',
        'date_start',
        'date_end',
        'created_by',
        'created_at',
        'moq',
        'active_day',
        'active_time',
        'type_customer',
        'updated_at'
    ];
}
