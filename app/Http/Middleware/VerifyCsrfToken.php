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
        '/api_product_list',
        '/api_product_list_stock',
        '/api_product_update',
        '/api_order_list',
        '/api_order_detail',
        '/api_customer_list',
        '/api_ml_list',
        '/api_customer_create',
        '/api_order_create',
        '/api_order_update',
        '/api_db_version',
    ];
}
