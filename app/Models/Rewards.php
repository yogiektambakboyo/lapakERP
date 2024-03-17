<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Rewards extends Model
{
    use HasFactory;

    protected $table = 'rewards';
    public $incrementing = false;

    protected $fillable = [
        'product_id',
        'branch_id',
        'point',
        'remark',
        'dated_start',
        'dated_end',
        'created_by',
        'created_at',
        'quota',
        'quota_available',
        'updated_at'
    ];

    
}
