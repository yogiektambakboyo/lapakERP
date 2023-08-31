<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PickingRef extends Model
{
    use HasFactory;

    protected $table = 'picking_ref';

    
    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'doc_no',
        'ref_no',
        'created_by',
        'updated_by',
        'updated_at'
    ];
}
