<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PackingDetail extends Model
{
    use HasFactory;

    protected $table = 'packing_detail';

    
    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'doc_no',
        'product_id',
        'qty',
        'qty_pack',
        'ref_no',
        'ref_no_po',
        'created_by',
        'updated_by',
        'updated_at'
    ];
}
