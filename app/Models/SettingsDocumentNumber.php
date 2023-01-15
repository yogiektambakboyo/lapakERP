<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class SettingsDocumentNumber extends Model
{
    use HasFactory;
    protected $table = 'setting_document_counter';

    protected $fillable = [
        'doc_type',
        'abbr',
        'period',
        'current_value',
        'updated_at',
    ];
}
