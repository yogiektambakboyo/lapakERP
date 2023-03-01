<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PettyCash extends Model
{
    use HasFactory;

    protected $table = 'petty_cash';

    protected $fillable = [
        'id',
        'dated',
        'remark',
        'total',
        'updated_at',
        'updated_by',
        'created_by',
        'created_at',
        'type',
        'branch_id',
        'doc_no',
    ];
}