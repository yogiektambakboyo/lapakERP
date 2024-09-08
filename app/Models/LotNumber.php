<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class LotNumber extends Model
{
    use HasFactory;

    protected $table = 'lot_number';

    
    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'doc_no',
        'qty_available',
        'qty_onhand',
        'qty_allocated',
        'product_id',
        'created_by',
        'created_at',
        'price',
        'currency',
        'kurs',
        'updated_at',
    ];
}
