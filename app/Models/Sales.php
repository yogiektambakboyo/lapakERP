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
        'ident_id',
        'branch_id',
        'active'
    ];
}
