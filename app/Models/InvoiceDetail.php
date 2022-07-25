<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class InvoiceDetail extends Model
{
    use HasFactory;

    public $incrementing = false;

    protected $table = 'invoice_detail';

    
    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'invoice_no',
        'product_id',
        'qty',
        'price',
        'total',
        'discount',
        'seq',
        'assigned_to',
        'referral_by',
    ];
}
