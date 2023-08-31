<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PickingDetail extends Model
{
    use HasFactory;

    protected $table = 'picking_detail';

    
    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'doc_no',
        'ispicked',
        'product_id',
        'qty',
        'created_by',
        'updated_by',
        'updated_at'
    ];
}
