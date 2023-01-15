<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PeriodSellPrice extends Model
{

    protected $table = 'period_price_sell';

    
    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'period',
        'product_id',
        'value',
        'branch_id',
        'updated_at',
        'created_by',
        'updated_by',
        'created_at'
    ];
}
