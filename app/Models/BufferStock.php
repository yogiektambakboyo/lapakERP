<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class BufferStock extends Model
{
    use HasFactory;

    protected $table = 'product_stock_buffer';
    public $incrementing = false;

    protected $fillable = [
        'product_id',
        'branch_id',
        'qty',
        'updated_by',
        'created_by',
        'created_at',
        'updated_at'
    ];
}
