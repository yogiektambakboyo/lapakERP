<?php

namespace App\Http\Controllers;

use Carbon\Carbon;
use App\Models\User;
use Illuminate\Http\Request;
use Spatie\Permission\Models\Role;
use App\Models\Branch;
use App\Models\JobTitle;
use App\Models\Department;
use App\Models\UserBranch;
use App\Models\UserMutation;
use App\Http\Requests\StoreUserRequest;
use App\Http\Requests\UpdateUserRequest;
use Spatie\Permission\Models\Permission;
use Maatwebsite\Excel\Facades\Excel;
use App\Exports\UsersExport;
use App\Http\Controllers\Controller;
use Yajra\Datatables\Datatables;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use File;

class UsersController extends Controller
{
    /**
     * Display all users
     * 
     * @return \Illuminate\Http\Response
     */

    private $data,$act_permission,$module="users";

    public function __construct()
    {
        $this->act_permission = DB::select("
            select sum(coalesce(allow_create,0)) as allow_create,sum(coalesce(allow_delete,0)) as allow_delete,sum(coalesce(allow_show,0)) as allow_show,sum(coalesce(allow_edit,0)) as allow_edit from (
                select count(1) as allow_create,0 as allow_delete,0 as allow_show,0 as allow_edit from permissions p join role_has_permissions rp on rp.permission_id = p.id where rp.role_id = 1 and p.name like '%.create' and p.name like '".$this->module.".%'
                union 
                select 0 as allow_create,count(1) as allow_delete,0 as allow_show,0 as allow_edit from permissions p  join role_has_permissions rp on rp.permission_id = p.id where rp.role_id = 1 and p.name like '%.delete' and p.name like '".$this->module.".%'
                union 
                select 0 as allow_create,0 as allow_delete,count(1) as allow_show,0 as allow_edit from permissions p  join role_has_permissions rp on rp.permission_id = p.id where rp.role_id = 1 and p.name like '%.show' and p.name like '".$this->module.".%'
                union 
                select 0 as allow_create,0 as allow_delete,0 as allow_show,count(1) as allow_edit from permissions p  join role_has_permissions rp on rp.permission_id = p.id where rp.role_id = 1 and p.name like '%.edit' and p.name like '".$this->module.".%'
            ) a
        ");

        $permissions = Permission::join('role_has_permissions',function ($join) {
            $join->on(function($query){
                $query->on('role_has_permissions.permission_id', '=', 'permissions.id')
                ->where('role_has_permissions.role_id','=','1')->where('permissions.name','like','%.index%')->where('permissions.url','!=','null');
            });
           })->get(['permissions.name','permissions.url','permissions.remark','permissions.parent']);
       
        $this->data = [
            'menu' => 
                [
                    [
                        'icon' => 'fa fa-user-gear',
                        'title' => 'User Management',
                        'url' => 'javascript:;',
                        'caret' => true,
                        'sub_menu' => []
                    ],
                    [
                        'icon' => 'fa fa-box',
                        'title' => 'Product Management',
                        'url' => 'javascript:;',
                        'caret' => true,
                        'sub_menu' => []
                    ],
                    [
                        'icon' => 'fa fa-table',
                        'title' => 'Transactions',
                        'url' => 'javascript:;',
                        'caret' => true,
                        'sub_menu' => []
                    ],
                    [
                        'icon' => 'fa fa-chart-column',
                        'title' => 'Reports',
                        'url' => 'javascript:;',
                        'caret' => true,
                        'sub_menu' => []
                    ],
                    [
                        'icon' => 'fa fa-screwdriver-wrench',
                        'title' => 'Settings',
                        'url' => 'javascript:;',
                        'caret' => true,
                        'sub_menu' => []
                    ]  
                ]      
        ];

        foreach ($permissions as $key => $menu) {
            if($menu['parent']=='Users'){
                array_push($this->data['menu'][0]['sub_menu'], array(
                    'url' => $menu['url'],
                    'title' => $menu['remark'],
                    'route-name' => $menu['name']
                ));
            }
            if($menu['parent']=='Products'){
                array_push($this->data['menu'][1]['sub_menu'], array(
                    'url' => $menu['url'],
                    'title' => $menu['remark'],
                    'route-name' => $menu['name']
                ));
            }
            if($menu['parent']=='Transactions'){
                array_push($this->data['menu'][2]['sub_menu'], array(
                    'url' => $menu['url'],
                    'title' => $menu['remark'],
                    'route-name' => $menu['name']
                ));
            }
            if($menu['parent']=='Reports'){
                array_push($this->data['menu'][3]['sub_menu'], array(
                    'url' => $menu['url'],
                    'title' => $menu['remark'],
                    'route-name' => $menu['name']
                ));
            }
            if($menu['parent']=='Settings'){
                array_push($this->data['menu'][4]['sub_menu'], array(
                    'url' => $menu['url'],
                    'title' => $menu['remark'],
                    'route-name' => $menu['name']
                ));
            }
        }
    }

    public function index(Request $request) 
    {
        $data = $this->data;
        $keyword = "";
        $act_permission = $this->act_permission[0];
        $users = User::orderBy('id', 'ASC')->join('job_title as jt','jt.id','=','users.job_id')->where('users.name','!=','Admin')->paginate(10,['users.id','users.employee_id','users.name','jt.remark as job_title','users.join_date' ]);
        return view('pages.users.index', compact('users','data','keyword','act_permission'))->with('i', ($request->input('page', 1) - 1) * 5);
    }

    public function search(Request $request) 
    {
        $keyword = $request->search;
        $data = $this->data;

        if($request->export=='Export Excel'){
            return Excel::download(new UsersExport($keyword), 'users_'.Carbon::now()->format('YmdHis').'.xlsx');
        }else{
            $users = User::orderBy('id', 'ASC')->join('branch as b','b.id','=','users.branch_id')->join('job_title as jt','jt.id','=','users.job_id')->where('users.name','!=','Admin')->where('users.name','LIKE','%'.$keyword.'%')->paginate(10,['users.id','users.employee_id','users.name','jt.remark as job_title','b.remark as branch_name','users.join_date' ]);
            return view('pages.users.index', compact('users','data','keyword'))->with('i', ($request->input('page', 1) - 1) * 5);
        }
    }

    public function export(Request $request) 
    {
        $keyword = $request->search;
        return Excel::download(new UsersExport, 'users_'.Carbon::now()->format('YmdHis').'.xlsx');
    }

    /**
     * Show form for creating user
     * 
     * @return \Illuminate\Http\Response
     */
    public function create() 
    {
        $data = $this->data;
        $gender = ['Male','Female'];
        $active = [1,0];
        $usersReferral = User::get(['users.id','users.name']);
        return view('pages.users.create',[
            'roles' => Role::latest()->get(),
            'branchs' => Branch::latest()->get(),
            'userBranchs' => Branch::latest()->get()->pluck('remark')->toArray(),
            'jobTitles' => JobTitle::latest()->get(),
            'userJobTitles' => JobTitle::latest()->get()->pluck('remark')->toArray(),
            'departments' => Department::latest()->get(),
            'userDepartements' => Department::latest()->get()->pluck('remark')->toArray(),
            'gender' => $gender,
            'active' => $active,
            'data' => $data,
            'usersReferrals' => $usersReferral,
        ]);
    }

    /**
     * Store a newly created user
     * 
     * @param User $user
     * @param StoreUserRequest $request
     * 
     * @return \Illuminate\Http\Response
     */
    public function store(User $user, StoreUserRequest $request) 
    {
        //For demo purposes only. When creating user or inviting a user
        // you should create a generated random password and email it to the user


        if($request->file('photo_netizen_id') == null){
            $user->create(
                array_merge(
                    $request->validated(), 
                    ['password' => $request->get('password') ],
                    ['phone_no' => $request->get('phone_no') ],
                    ['join_date' => Carbon::parse($request->get('join_date'))->format('d/m/Y') ],
                    ['gender' => $request->get('gender') ],
                    ['netizen_id' => $request->get('netizen_id') ],
                    ['active' => '1' ],
                    ['city' => $request->get('city') ],
                    ['employee_id' => $request->get('employee_id') ],
                    ['job_id' => $request->get('job_id') ],
                    ['department_id' => $request->get('department_id') ],
                    ['address' => $request->get('address') ],
                    ['referral_id' => $request->get('referral_id') ],
                    ['birth_place' => $request->get('birth_place') ],
                    ['birth_date' => Carbon::parse($request->get('birth_date'))->format('d/m/Y')  ]
                )
            );
        }else{
            $file = $request->file('photo_netizen_id');
            $user->create(
                array_merge(
                    $request->validated(), 
                    ['password' => $request->get('password') ],
                    ['phone_no' => $request->get('phone_no') ],
                    ['join_date' => Carbon::parse($request->get('join_date'))->format('d/m/Y') ],
                    ['gender' => $request->get('gender') ],
                    ['netizen_id' => $request->get('netizen_id') ],
                    ['active' => '1' ],
                    ['city' => $request->get('city') ],
                    ['employee_id' => $request->get('employee_id') ],
                    ['photo_netizen_id' => $file->getClientOriginalName() ],
                    ['job_id' => $request->get('job_id') ],
                    ['department_id' => $request->get('department_id') ],
                    ['address' => $request->get('address') ],
                    ['referral_id' => $request->get('referral_id') ],
                    ['birth_place' => $request->get('birth_place') ],
                    ['birth_date' => Carbon::parse($request->get('birth_date'))->format('d/m/Y')  ]
                )
            );

            $img_file = $file->getClientOriginalName();
            $my_id = User::orderBy('id', 'desc')->first()->id;
            $final_fileimg = $my_id.'_'.$img_file;
            // upload file
            $folder_upload = 'images/user-files';
            $file->move($folder_upload,$img_file);

            $destination = '/images/user-files/'.$img_file;//or any extension such as jpeg,png
            $newdestination =  '/images/user-files/'.$final_fileimg;
            File::move(public_path($destination), public_path($newdestination));

        
            User::where(['id' => $my_id])->update( array_merge(
                    ['photo_netizen_id' => $final_fileimg],
            ));

        }

        $my_id = User::orderBy('id', 'desc')->first()->id;

        $rolex = Role::where('id', $request->get('role'))->first();
        $user_x = User::where(['id' => $my_id])->first();
        $user_x->assignRole($rolex);
        

        $arr = $request->get('branch_id');
        for ($i=0; $i < count($arr); $i++) { 
            UserBranch::create(
                array_merge(
                    ['user_id' => User::orderBy('id', 'desc')->first()->id],
                    ['branch_id' => (int)$arr[$i]],
                )
            );

            User::where(['id' => $my_id])->update( array_merge(
                    ['branch_id' => (int)$arr[$i] ],
            ));

            UserMutation::create(array_merge(
                ['user_id' => User::orderBy('id', 'desc')->first()->id ],
                ['job_id' => $request->get('job_id') ],
                ['branch_id' => (int)$arr[$i]],
                ['department_id' => $request->get('department_id') ],
            ));
        }

        return redirect()->route('users.index')
            ->withSuccess(__('User created successfully.'));
    }

    /**
     * Show user data
     * 
     * @param User $user
     * 
     * @return \Illuminate\Http\Response
     */
    public function show(User $user) 
    {
        $data = $this->data;
        $usersReferral = User::where('users.id','!=',$user->id)->get(['users.id','users.name']);
        $users = DB::select("select dt.remark as department,u.id,u.employee_id,u.name,jt.remark as job_title,string_agg(b.remark,',') as branch_name,u.join_date,u.phone_no,u.email,u.username,u.address,u.netizen_id,u.photo_netizen_id,u.photo,u.join_years,u.active,u.referral_id,u.city,u.gender,u.birth_place,u.birth_date 
                             from users u 
                             join users_branch ub on ub.user_id=u.id
                             join branch b on b.id = ub.branch_id
                             join departments dt on dt.id=u.department_id
                             join job_title jt on jt.id=u.job_id
                             where u.id = ? and u.name!='Admin' group by dt.remark,u.id,u.employee_id,u.name,jt.remark,u.join_date,u.phone_no,u.email,u.username,u.address,u.netizen_id,u.photo_netizen_id,u.photo,u.join_years,u.active,u.referral_id,u.city,u.gender,u.birth_place,u.birth_date  ; "
                             , [$user->id]);
        return view('pages.users.show', [
            'users' => $users[0],
            'user' => $user,
            'usersReferrals' => $usersReferral,
            'usersMutations' => UserMutation::join('job_title as j','j.id','=','users_mutation.job_id')->join('departments as d','d.id','=','users_mutation.department_id')->join('branch as b','b.id','=','users_mutation.branch_id')->where('users_mutation.user_id',$user->id)->orderBy('users_mutation.created_at','ASC')->get(['users_mutation.*','j.remark as job_name','b.remark as branch_name','d.remark as department_name']),
        ],compact('data'));
    }

    /**
     * Edit user data
     * 
     * @param User $user
     * 
     * @return \Illuminate\Http\Response
     */
    public function edit(User $user) 
    {
        $data = $this->data;
        $gender = ['Male','Female'];
        $active = [1,0];
        //$users = User::join('branch as b','b.id','=','users.branch_id')->join('department as dt','dt.id','=','users.department_id')->join('job_title as jt','jt.id','=','users.job_id')->where('users.name','!=','Admin')->where('users.id','=',$user->id)->get(['dt.remark as department','users.id','users.employee_id','users.name','jt.remark as job_title','b.remark as branch_name','users.join_date as join_date',"users.phone_no","users.email","users.username","users.address","users.netizen_id","users.photo_netizen_id","users.photo","users.join_years","users.active","users.referral_id","users.city","users.gender","users.birth_place","users.birth_date" ])->first();
        $users = DB::select("select dt.remark as department,u.id,u.employee_id,u.name,jt.remark as job_title,string_agg(b.id::character varying,',') as branch_name,u.join_date,u.phone_no,u.email,u.username,u.address,u.netizen_id,u.photo_netizen_id,u.photo,u.join_years,u.active,u.referral_id,u.city,u.gender,u.birth_place,u.birth_date 
                             from users u 
                             join users_branch ub on ub.user_id=u.id
                             join branch b on b.id = ub.branch_id
                             join departments dt on dt.id=u.department_id
                             join job_title jt on jt.id=u.job_id
                             where u.id = ? and u.name!='Admin' group by dt.remark,u.id,u.employee_id,u.name,jt.remark,u.join_date,u.phone_no,u.email,u.username,u.address,u.netizen_id,u.photo_netizen_id,u.photo,u.join_years,u.active,u.referral_id,u.city,u.gender,u.birth_place,u.birth_date  ; "
                             , [$user->id]);
        $usersReferral = User::where('users.id','!=',$user->id)->get(['users.id','users.name']);
        return view('pages.users.edit', [
            'user' => $users[0],
            'userRole' => $user->roles->pluck('name')->toArray(),
            'roles' => Role::latest()->get(),
            'branchs' => Branch::join('users_branch as ub','ub.branch_id','=','branch.id')->where('ub.user_id','=',$user->id)->get(),
            'userBranchs' => Branch::join('users_branch as ub','ub.branch_id','=','branch.id')->where('ub.user_id','=',$user->id)->get()->pluck('remark')->toArray(),
            'departments' => Department::latest()->get(),
            'userDepartements' => Department::latest()->get()->pluck('remark')->toArray(),
            'jobTitles' => JobTitle::latest()->get(),
            'userJobTitles' => JobTitle::latest()->get()->pluck('remark')->toArray(),
            'gender' => $gender,
            'active' => $active,
            'data' => $data,
            'usersReferrals' => $usersReferral,
        ]);
    }

    /**
     * Update user data
     * 
     * @param User $user
     * @param UpdateUserRequest $request
     * 
     * @return \Illuminate\Http\Response
     */
    public function update(User $user, UpdateUserRequest $request) 
    {
        DB::table('users_branch')->where('user_id', $user->id)->delete();

        $arr = $request->get('branch_id');

        for ($i=0; $i < count($arr); $i++) { 
            if(($user->department_id!=$request->get('department_id'))||($user->job_id!=$request->get('job_id'))||((int)$arr[$i]!=$user->branch_id)){
                UserMutation::create(array_merge(
                    ['user_id' => $user->id ],
                    ['job_id' => $request->get('job_id') ],
                    ['branch_id' => (int)$arr[$i]],
                    ['department_id' => $request->get('department_id') ],
                ));
            }

            UserBranch::create(
                array_merge(
                    ['user_id' => $user->id],
                    ['branch_id' => (int)$arr[$i]],
                )
            );

            $user->update( array_merge(
                 ['branch_id' => (int)$arr[$i] ],
            ));
        }

        $user->update($request->validated());
        $user->syncRoles($request->get('role'));
        $user->update( array_merge(
            $request->validated(), 
            ['phone_no' => $request->get('phone_no') ],
            ['join_date' => Carbon::parse($request->get('join_date'))->format('d/m/Y') ],
            ['gender' => $request->get('gender') ],
            ['netizen_id' => $request->get('netizen_id') ],
            ['city' => $request->get('city') ],
            ['employee_id' => $request->get('employee_id') ],
            ['job_id' => $request->get('job_id') ],
            ['department_id' => $request->get('department_id') ],
            ['address' => $request->get('address') ],
            ['referral_id' => $request->get('referral_id') ],
            ['birth_place' => $request->get('birth_place') ],
            ['birth_date' => Carbon::parse($request->get('birth_date'))->format('d/m/Y')  ]
        ));

        if($request->file('photo_netizen_ids') == null){

        }else{
            $file = $request->file('photo_netizen_ids');
            $user->update(['photo_netizen_id'=>$file->getClientOriginalName()]);
            
            // upload file
            $folder_upload = 'images/user-files';
            $file->move($folder_upload,$file->getClientOriginalName());
        }
        
        return redirect()->route('users.index')
            ->withSuccess(__('User updated successfully.'));
    }

    /**
     * Delete user data
     * 
     * @param User $user
     * 
     * @return \Illuminate\Http\Response
     */
    public function destroy(User $user) 
    {
        $user->delete();

        return redirect()->route('users.index')
            ->withSuccess(__('User deleted successfully.'));
    }
}


/*

git clone https://github.com/codeanddeploy/laravel8-authentication-example.git

if your using my previous tutorial navigate your project folder and run composer update



install packages

composer require spatie/laravel-permission
composer require laravelcollective/html

then run php artisan vendor:publish --provider="Spatie\Permission\PermissionServiceProvider"

php artisan migrate

php artisan make:migration create_posts_table

php artisan migrate

models
php artisan make:model Post

middleware
- create custom middleware
php artisan make:middleware PermissionMiddleware

register middleware
- 

routes

controllers

- php artisan make:controller UsersController
- php artisan make:controller PostsController
- php artisan make:controller RolesController
- php artisan make:controller PermissionsController

requests
- php artisan make:request StoreUserRequest
- php artisan make:request UpdateUserRequest

blade files

create command to lookup all routes
- php artisan make:command CreateRoutePermissionsCommand
- php artisan permission:create-permission-routes

seeder for default roles and create admin user
php artisan make:seeder CreateAdminUserSeeder
php artisan db:seed --class=CreateAdminUserSeeder



*/