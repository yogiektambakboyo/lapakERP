<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PointConvertion extends Model
{
    use HasFactory;

    protected $table = 'point_convertion_branch';
    public $incrementing = false;


    protected $fillable = [
        'point_value',
        'branch_id',
        'point',
    ];
}
