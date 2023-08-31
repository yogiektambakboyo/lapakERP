<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Picking extends Model
{
    use HasFactory;

    protected $table = 'picking_master';

    
    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'doc_no',
        'dated',
        'ispicked',
        'picked_by',
        'picked_at',
        'created_by',
        'updated_by',
        'updated_at'
    ];
}
