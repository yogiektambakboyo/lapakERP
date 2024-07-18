<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Http\Requests\LoginRequest;
use Illuminate\Support\Facades\Auth;
use App\Services\Login\RememberMeExpiration;
use App\Models\Settings;
use App\Models\Company;
use App\Models\Branch;
use App\Models\User;
use Spatie\Permission\Models\Role;
use App\Models\UserBranch;
use App\Models\UserMutation;
use App\Http\Controllers\Lang;
use App\Mail\NotifEmail;
use Illuminate\Support\Facades\Mail;

class RegisterController extends Controller
{
    use RememberMeExpiration;

    /**
     * Display login page.
     * 
     * @return Renderable
     */
    public function show()
    {
        return view('auth.register',[
            'settings' => Settings::get()->first(),'company' => Company::get()->first()
        ]);
    }

    public function profile()
    {
        return view('pages.auth.profile',['settings' => Settings::get()->first(),'company' => Company::get()->first()]);
    }

    /**
     * Store a newly created user
     * @param Request $request
     * 
     * @return \Illuminate\Http\Response
     */
    public function store_regis(Request $request) 
    {
        //For demo purposes only. When creating user or inviting a user
        // you should create a generated random password and email it to the user

        $company = $request->get('company');

        Branch::create(array_merge(
            ['remark' => $company],
            ['address' => $company],
            ['city' => $company],
            ['abbr' => $company],
            ['active' => "1"]
        ));

        $my_branch_id = Branch::orderBy('id', 'desc')->first()->id;
        

        User::create(
            array_merge(
                ['password' => $request->get('password') ],
                ['email' => $request->get('email') ],
                ['name' => $company ],
                ['username' => $request->get('email') ],
                ['branch_id' => $my_branch_id ],
                ['active' => '1' ],
                ['job_id' => 13 ],
                ['department_id' => 1 ]
            )
        );

        $my_id = User::orderBy('id', 'desc')->first()->id;

        UserBranch::create(
            array_merge(
                ['user_id' => $my_id],
                ['branch_id' => $my_branch_id],
            )
        );

        UserMutation::create(array_merge(
            ['user_id' => $my_id],
            ['job_id' => 13 ],
            ['department_id' => 1 ],
            ['branch_id' => $my_branch_id]
        ));

        $rolex = Role::where('id', 13)->first();
        $user_x = User::where(['id' => $my_id])->first();
        $user_x->assignRole($rolex);

        $name = $company;
        $content = "https://lapakkreatif.com/activated_acc/".md5($my_id);

		Mail::to($request->get('email'))->send(new NotifEmail($name,$content));

        return redirect()->route('register.show')
            ->withSuccess(__('Proses registrasi berhasil, silahkan login menggunakan email dan password yang telah didaftarkan'));
    }

    public function activated_acc(Request $request) 
    {
       $mid = $request->get("");
        return redirect()->route('register.show')
            ->withSuccess(__('Proses registrasi berhasil, silahkan login menggunakan email dan password yang telah didaftarkan'));
    }

}
