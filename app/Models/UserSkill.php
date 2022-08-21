<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class UserSkill extends Model
{
    use HasFactory;
    protected $primaryKey = null;
    public $incrementing = false;
    protected $table = 'users_skills';

    protected $fillable = [
        'branch_id',
        'user_id',
        'modul',
        'trainer',
        'status',
        'dated',
        'updated_at',
        'created_at',
        'created_by'
    ];
}
