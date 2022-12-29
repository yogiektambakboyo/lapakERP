<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class BranchShift extends Model
{
    use HasFactory;

    protected $table = 'branch_shift';

    protected $fillable = [
        'id',
        'branch_id',
        'shift_id',
        'updated_by',
        'updated_at',
        'created_at',
        'created_by'
    ];
}
