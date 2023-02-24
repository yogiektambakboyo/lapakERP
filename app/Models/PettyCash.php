<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PettyCash extends Model
{
    use HasFactory;

    protected $table = 'petty_cash';

    protected $fillable = [
        'branch_id',
        'dated',
        'price',
        'remark',
        'qty',
        'total',
        'type',
        'created_by'
    ];
}
