<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class StockLotNumberTemp extends Model
{
    use HasFactory;

    protected $table = 'temp_stock_lotnumber';

    
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
        'category_name',
        'product_name',
        'type_name',
    ];
}
