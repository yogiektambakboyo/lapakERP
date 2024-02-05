<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Product extends Model
{

    protected $table = 'product_sku';

    
    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'abbr',
        'remark',
        'type_id',
        'brand_id',
        'category_id',
        'created_by',
        'updated_by',
        'updated_at',
        'photo',
        'barcode',
        'photo_2',
        'photo_3',
        'photo_4',
        'photo_5'
    ];
}
