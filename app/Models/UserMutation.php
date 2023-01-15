<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class UserMutation extends Model
{
    use HasFactory;

    protected $table = 'users_mutation';

    protected $fillable = [
        'user_id',
        'branch_id',
        'department_id',
        'job_id'
    ];
}
