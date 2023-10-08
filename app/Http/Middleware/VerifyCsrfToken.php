<?php

namespace App\Http\Middleware;

use Illuminate\Foundation\Http\Middleware\VerifyCsrfToken as Middleware;

class VerifyCsrfToken extends Middleware
{
    /**
     * The URIs that should be excluded from CSRF verification.
     *
     * @var array
     */
    protected $except = [
        '/api_login',
        '/api_profile',
        '/api_profile_emp',
        '/api_branch',
        '/api_invoice',
        '/api_post_review',
        '/api_photo_slide',
        '/api_photo_slide_detail',
        '/api_post_invoice_terapist',
        //
    ];
}
