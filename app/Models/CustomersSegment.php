<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class CustomersSegment extends Model
{
    use HasFactory;

    protected $table = 'customers_segment';

    protected $fillable = [
        'remark',
        'id',
    ];
}
