<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ProductIngredients extends Model
{

    protected $table = 'product_ingredients';
    public $incrementing = false;


    
    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'product_id',
        'product_id_material',
        'uom_id',
        'qty',
        'updated_at',
        'created_by',
        'created_at',
    ];
}
