<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class StockLotNumber extends Model
{
    use HasFactory;

    protected $table = 'stock_lotnumber';

    
    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'recid',
        'no_surat',
        'spkid',
        'lot_number',
        'alias_code',
        'location',
        'qty',
        'qty_available',
        'is_used',
    ];
}
