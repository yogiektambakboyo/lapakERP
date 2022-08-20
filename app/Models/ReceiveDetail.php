<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ReceiveDetail extends Model
{
    use HasFactory;

    public $incrementing = false;

    protected $table = 'receive_detail';

    
    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'receive_no',
        'product_id',
        'qty',
        'price',
        'total',
        'discount',
        'expired_at',
        'batch_no',
        'seq'
    ];
}
