<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Http\Requests\LoginRequest;
use Illuminate\Support\Facades\Auth;
use App\Services\Login\RememberMeExpiration;
use App\Models\Settings;
use App\Models\Company;
use App\Http\Controllers\Lang;

class LoginController extends Controller
{
    use RememberMeExpiration;

    /**
     * Display login page.
     * 
     * @return Renderable
     */
    public function show()
    {
        return view('pages.auth.login',[
            'settings' => Settings::get()->first(),'company' => Company::get()->first()
        ]);
    }

    /**
     * Handle account login request
     * 
     * @param LoginRequest $request
     * 
     * @return \Illuminate\Http\Response
     */
    public function login(LoginRequest $request)
    {
        $credentials = $request->getCredentials();

        if(!Auth::validate($credentials)):
            return redirect()->to('login')
                ->withErrors(trans('auth.failed'));
        endif;

        $user = Auth::getProvider()->retrieveByCredentials($credentials);

        Auth::login($user, $request->get('remember'));

        if($request->get('remember')):
            $this->setRememberMeExpiration($user);
        endif;

        return $this->authenticated($request, $user);
    }

    /**
     * Handle response after user authenticated
     * 
     * @param Request $request
     * @param Auth $user
     * 
     * @return \Illuminate\Http\Response
     */
    protected function authenticated(Request $request, $user) 
    {
        return redirect()->intended();
    }
}
