<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Http\Requests\LoginRequest;
use Illuminate\Support\Facades\Auth;
use App\Services\Login\RememberMeExpiration;
use App\Models\Settings;
use App\Models\Company;
use App\Http\Controllers\Lang;
use GuzzleHttp\Exception\GuzzleException;
use GuzzleHttp\Client;
use App\Models\User;
use Spatie\Permission\Models\Role;

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
        return view('pages.auth.login_v3',[
            'settings' => Settings::get()->first(),'company' => Company::get()->first()
        ]);
    }

    public function profile()
    {
        return view('pages.auth.profile',['settings' => Settings::get()->first(),'company' => Company::get()->first()]);
    }

    public function eorder()
    {
        return view('pages.auth.eorder',['settings' => Settings::get()->first(),'company' => Company::get()->first()]);
    }

    public function lapakerp()
    {
        return view('pages.auth.lapakerp',['settings' => Settings::get()->first(),'company' => Company::get()->first()]);
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
        //connect to ctc hr 
        $client = new Client(); //GuzzleHttp\Client
        $token_val = md5(date("Y-m-d"));
    
        $response = $client->request('POST', 'https://ctc-cmc.org/api/check_login_external.php', [
            'form_params' => [
                'email' => $request->get("username"),
                'token_val' => $token_val,
                'password' => $request->get("password"),
            ]
        ]);

        if(!empty($response->getBody())){
            $resp = json_decode($response->getBody()->getContents(), true);
            $rec_id = "";
            if($resp["status"] == "failed"){
                return redirect()->to('login')
                ->withErrors(trans('auth.failed'));
            }else{
                $recid = $resp["data"];

                User::where('employee_id',$recid)->update(
                    array_merge(
                        [ "email" => $request->get("username")],
                        ["password" => bcrypt($request->get("password"))]
                    )
                );

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
        }

        
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
