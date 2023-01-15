<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class SalesTrip extends Model
{
    use HasFactory;
    protected $table = 'sales_trip';

    protected $fillable = [
        'id',
        'time_start',
        'time_end',
        'dated',
        'notes',
        'photo',
        'active'
    ];
}
