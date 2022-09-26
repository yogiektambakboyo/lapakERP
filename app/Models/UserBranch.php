<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class UserBranch extends Model
{
    use HasFactory;
    protected $primaryKey = null;
    public $incrementing = false;
    protected $table = 'users_branch';

    protected $fillable = [
        'branch_id',
        'user_id'
    ];
}
