<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class RewardsTrans extends Model
{
    use HasFactory;

    protected $table = 'rewards_transaction';
    public $incrementing = false;

    protected $fillable = [
        'point',
        'remark',
        'sales_id',
        'rewards_id',
        'status',
        'created_by',
        'created_at',
        'updated_at'
    ];

    
}
