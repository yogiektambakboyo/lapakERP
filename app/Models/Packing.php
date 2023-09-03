<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Packing extends Model
{
    use HasFactory;

    protected $table = 'packing_master';

    
    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'doc_no',
        'dated',
        'ispacked',
        'packed_by',
        'packed_at',
        'created_by',
        'customer_id',
        'remark',
        'updated_by',
        'updated_at'
    ];
}
