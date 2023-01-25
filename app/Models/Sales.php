<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Sales extends Model
{
    use HasFactory;
    protected $table = 'sales';

    protected $fillable = [
        'name',
        'username',
        'password',
        'address',
        'branch_id',
        'external_code',
        'active'
    ];
}
