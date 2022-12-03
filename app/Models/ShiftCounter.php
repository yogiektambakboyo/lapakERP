<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ShiftCounter extends Model
{
    use HasFactory;
    protected $primaryKey = null;
    public $incrementing = false;
    protected $table = 'shift_counter';

    protected $fillable = [
        'branch_id',
        'users_id',
        'queue_no',
        'updated_at',
        'created_at',
        'created_by'
    ];
}
