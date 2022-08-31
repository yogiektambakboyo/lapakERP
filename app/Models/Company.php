<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Company extends Model
{
    use HasFactory;
    protected $table = 'company';

    protected $fillable = [
        'remark',
        'address',
        'city',
        'email',
        'phone_no',
        'icon_file',
    ];
}
