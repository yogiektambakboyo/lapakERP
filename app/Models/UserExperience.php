<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class UserExperience extends Model
{
    use HasFactory;
    protected $primaryKey = null;
    public $incrementing = false;
    protected $table = 'users_experience';

    protected $fillable = [
        'users_id',
        'company',
        'job_position',
        'years',
        'updated_at',
        'created_at',
        'created_by'
    ];
}
