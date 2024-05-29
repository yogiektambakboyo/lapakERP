<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Reason extends Model
{
    use HasFactory;

    protected $table = 'reason';
    public $incrementing = false;

    protected $fillable = [
        'reason_type',
        'remark',
        'id',
    ];
}
