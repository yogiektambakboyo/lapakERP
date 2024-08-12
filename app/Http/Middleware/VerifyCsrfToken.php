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
        '/api_branch_list',
        '/api_branch_list_link',
        '/api_invoice',
        '/api_insert_leave',
        '/api_get_reason',
        '/api_get_leave',
        '/api_post_review',
        '/api_post_review_new',
        '/api_user_info',
        '/api_photo_slide',
        '/api_insert_work',
        '/api_get_work_today',
        '/api_get_work',
        '/api_check_hp',
        '/api_register',
        '/api_register_otp',
        '/api_photo_slide_detail',
        '/api_post_invoice_terapist',
        '/get_checkmembership',
        '/send-msg-wa',
        '/send-wa-media',
        '/api_voucher_list',
        '/api_voucher_one',
        '/api_voucher_one_update',
        '/api_post_review_ios_master',
        '/api_post_review_ios_detail',
        //
    ];
}
