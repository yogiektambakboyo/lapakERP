<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class SalesTripDetail extends Model
{
    use HasFactory;
    protected $table = 'sales_trip_detail';

    //branch_name,dated,s.name as sellername,st.id as trip_id,std.longitude,std.latitude,std.georeverse,std.created_at 
    protected $fillable = [
        'id',
        'longitude',
        'latitude',
        'georeverse',
        'created_at'
    ];
}
