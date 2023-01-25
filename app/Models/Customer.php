<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Customer extends Model
{
    use HasFactory;

    protected $table = 'customers';

    protected $fillable = [
        'name',
        'address',
        'phone_no',
        'membership_id',
        'abbr',
        'branch_id',
        'sales_id',
        'city',
        'notes',
        'credit_limit',
        'longitude',
        'latitude',
        'email',
        'handphone',
        'whatsapp_no',
        'citizen_id',
        'tax_id',
        'contact_person',
        'type',
        'clasification',
        'contact_person_job_position',
        'contact_person_level',
        'visit_day',
        'visit_week',
        'external_code',
    ];
}
