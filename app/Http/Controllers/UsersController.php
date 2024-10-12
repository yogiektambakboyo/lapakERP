<?php

namespace App\Http\Controllers;

use Carbon\Carbon;
use App\Models\User;
use Illuminate\Http\Request;
use Spatie\Permission\Models\Role;
use App\Models\Branch;
use App\Models\JobTitle;
use App\Models\Product;
use App\Models\UserExperience;
use App\Models\Department;
use App\Models\UserBranch;
use App\Models\UserSkill;
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
use Auth;
use App\Models\Company;
use App\Http\Controllers\Lang;


class UsersController extends Controller
{
    /**
     * Display all users
     * 
     * @return \Illuminate\Http\Response
     */

    private $data,$act_permission,$module="users",$id=1;

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
    }

    public function index(Request $request) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $data = $this->data;
        $keyword = "";
        $act_permission = $this->act_permission[0];
        $branchs = Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']);
        $users = User::orderBy('id', 'ASC')
        ->join('job_title as jt','jt.id','=','users.job_id')
        ->join('users_branch as ub','ub.user_id', '=', 'users.id')
        ->join('users_branch as ub2','ub2.branch_id', '=', 'ub.branch_id')
        ->join('branch as bd','bd.id','=','ub.branch_id')
        ->where('ub2.user_id','=',$user->id)
        ->where('users.name','!=','Super Admin')
        ->get(['users.netizen_id','bd.remark as branch_name','users.active','users.id','users.employee_id','users.name','jt.remark as job_title','users.join_date','users.work_year','users.phone_no' ]);
        return view('pages.users.index',['company' => Company::get()->first(),'jobtitles'=>JobTitle::orderBy('remark','asc')->get(['id','remark'])] ,compact('request','branchs','users','data','keyword','act_permission'));
    }

    public function search(Request $request) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $keyword = $request->search;
        $data = $this->data;
        $act_permission = $this->act_permission[0];
        $enddate = date(Carbon::parse($request->filter_end_date)->format('Y-m-d'));
        $branchx = $request->filter_branch_id;
        $branchs = Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']);
        $jobtitlex = $request->filter_job_id;
        if($request->export=='Export Excel'){
            $strencode = base64_encode($keyword.'#'.$jobtitlex.'#'.$enddate.'#'.$branchx);
            return Excel::download(new UsersExport($strencode), 'users_'.Carbon::now()->format('YmdHis').'.xlsx');
        }else if($request->src=='Search'){
            $branchx = "";
            $enddate = "";
            $jobtitlex = "";
            $users = User::orderBy('id', 'ASC')->join('branch as b','b.id','=','users.branch_id')
            ->join('job_title as jt','jt.id','=','users.job_id')
            ->join('users_branch as ub','ub.user_id', '=', 'users.id')
            ->join('users_branch as ub2','ub2.branch_id', '=', 'ub.branch_id')
            ->where('ub2.user_id','=',$user->id)
            ->join('branch as bd','bd.id','=','ub.branch_id')
            ->where('users.name','!=','Super Admin')->where('users.name','ILIKE','%'.$keyword.'%')
            ->get(['users.netizen_id','bd.remark as branch_name','users.active','users.id','users.employee_id','users.name','jt.remark as job_title','b.remark as branch_name','users.join_date','users.work_year','users.phone_no' ]);
            $request->filter_branch_id = "";
            $request->filter_end_date = "";
            $request->filter_job_id = "";
            return view('pages.users.index', ['company' => Company::get()->first(),'jobtitles'=>JobTitle::orderBy('remark','asc')->get(['id','remark'])],compact('request','branchs','users','data','keyword','act_permission'))->with('i', ($request->input('page', 1) - 1) * 5);
        }else{
            $users = User::orderBy('id', 'ASC')->join('branch as b','b.id','=','users.branch_id')
            ->join('job_title as jt','jt.id','=','users.job_id')
            ->join('users_branch as ub','ub.user_id', '=', 'users.id')
            ->join('users_branch as ub2','ub2.branch_id', '=', 'ub.branch_id')
            ->join('branch as bd','bd.id','=','ub.branch_id')
            ->where('ub2.user_id','=',$user->id)
            ->where('users.name','!=','Super Admin')->where('users.name','ILIKE','%'.$keyword.'%')
            ->where('b.id','like','%'.$branchx.'%')
            ->where('jt.id','like','%'.$jobtitlex.'%')
            ->where('users.join_date','<=',$enddate)
            ->get(['users.netizen_id','bd.remark as branch_name','users.active','users.id','users.employee_id','users.name','jt.remark as job_title','b.remark as branch_name','users.join_date','users.work_year','users.phone_no' ]);
            return view('pages.users.index', ['company' => Company::get()->first(),'jobtitles'=>JobTitle::orderBy('remark','asc')->get(['id','remark'])],compact('request','branchs','users','data','keyword','act_permission'))->with('i', ($request->input('page', 1) - 1) * 5);
        }
    }

    public function export(Request $request) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

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
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $data = $this->data;
        $gender = ['Male','Female'];
        $active = [1,0];
        $usersReferral = User::get(['users.id','users.name']);
        return view('pages.users.create',[
            'roles' => Role::latest()->get(),
            'branchs' => Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']),
            'userBranchs' => Branch::latest()->get()->pluck('remark')->toArray(),
            'jobTitles' => JobTitle::latest()->get(),
            'userJobTitles' => JobTitle::latest()->get()->pluck('remark')->toArray(),
            'departments' => Department::latest()->get(),
            'userDepartements' => Department::latest()->get()->pluck('remark')->toArray(),
            'gender' => $gender,
            'active' => $active,
            'data' => $data,'company' => Company::get()->first(),
            'employeestatusx' => ['On Job Training','Permanent','Outsourcing','Contract','Probation','Cuti','Kampung'],
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

        $user->create(
            array_merge(
                $request->validated(),
                ['password' => $request->get('password') ],
                ['phone_no' => $request->get('phone_no') ],
                ['join_date' => Carbon::parse($request->get('join_date'))->format('Y-m-d') ],
                ['level_up_date' => Carbon::parse($request->get('level_up_date'))->format('Y-m-d') ],
                ['gender' => $request->get('gender') ],
                ['netizen_id' => $request->get('netizen_id') ],
                ['work_year' => $request->get('work_year') ],
                ['active' => '1' ],
                ['city' => $request->get('city') ],
                ['employee_id' => $request->get('employee_id') ],
                ['job_id' => $request->get('job_id') ],
                ['department_id' => $request->get('department_id') ],
                ['address' => $request->get('address') ],
                ['referral_id' => $request->get('referral_id') ],
                ['employee_status' => $request->get('employee_status') ],
                ['birth_place' => $request->get('birth_place') ],
                ['birth_date' => Carbon::parse($request->get('birth_date'))->format('Y-m-d')  ]
            )
        );

        $my_id = User::orderBy('id', 'desc')->first()->id;

        if($request->file('photo_netizen_id') == null){

        }else{
            $file = $request->file('photo_netizen_id');
            $img_file = $file->getClientOriginalName();
            $final_fileimg = md5($my_id.'_'.$img_file).'.'.$file->getClientOriginalExtension();
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


        if($request->file('photo') == null){

        }else{
            $file_photo = $request->file('photo');
            $img_file_photo = $file_photo->getClientOriginalName().'.'.$file_photo->getClientOriginalExtension();
            $final_fileimg_photo = md5($my_id.'_'.$img_file_photo).'.'.$file_photo->getClientOriginalExtension();
            
            // upload file
            $folder_upload = 'images/user-files';
            $file_photo->move($folder_upload,$img_file_photo);

            $destinationx = '/images/user-files/'.$img_file_photo;//or any extension such as jpeg,png
            $newdestinationx =  '/images/user-files/'.$final_fileimg_photo;
            File::move(public_path($destinationx), public_path($newdestinationx));

            User::where(['id' => $my_id])->update( array_merge(
                    ['photo' => $final_fileimg_photo],
            ));
        }


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
     * Store a newly created user skill
     * 
     *
     * @param Request $request
     * 
     * @return \Illuminate\Http\Response
     */
    public function storetraining(Request $request) 
    {

        DB::insert("INSERT INTO public.users_skills
        (users_id, modul, trainer, status, dated, updated_at, created_by, created_at)
        VALUES(".$request->get('user_id').", ".$request->get('module').", ".$request->get('trainer').", '".$request->get('status')."', '".Carbon::parse($request->get('dated'))->format('Y-m-d')."', null, 1, now());");
            
        $result = array_merge(
            ['status' => 'success'],
            ['data' => ''],
            ['message' => 'Save Successfully'],
        );    
        return $result;
    }

    public function checknetizen(String $netizen_id) 
    {

        $users = DB::select("select * from users where netizen_id='".$netizen_id."';");
        $result = array_merge(
            ['status' => 'success'],
            ['data' => $users],
            ['message' => 'Save Successfully'],
        );    
        return $result;
    }


    /**
     * Store a newly created user skill
     * 
     *
     * @param Request $request
     * 
     * @return \Illuminate\Http\Response
     */
    public function deletetraining(Request $request) 
    {

        DB::insert("DELETE FROM public.users_skills
        where users_id=".$request->get('user_id')." and status='".$request->get('status')."'  and modul=".$request->get('module')." and dated='".$request->get('dated')."'");
            
        $result = array_merge(
            ['status' => 'success'],
            ['data' => ''],
            ['message' => 'Save Successfully'],
        );    
        return $result;
    }



        /**
     * Store a newly created user skill
     * 
     *
     * @param Request $request
     * 
     * @return \Illuminate\Http\Response
     */
    public function storeexperience(Request $request) 
    {

        DB::insert("INSERT INTO public.users_experience
        (users_id, company, job_position, years, updated_at, created_by, created_at)
        VALUES(".$request->get('user_id').", '".$request->get('company')."', '".$request->get('job_position')."', '".$request->get('years')."', null, 1, now());");
            
        $result = array_merge(
            ['status' => 'success'],
            ['data' => ''],
            ['message' => 'Save Successfully'],
        );    
        return $result;
    }


    /**
     * Store a newly created user skill
     * 
     *
     * @param Request $request
     * 
     * @return \Illuminate\Http\Response
     */
    public function deleteexperience(Request $request) 
    {

        DB::insert("DELETE FROM public.users_experience
        where id=".$request->get('id').";");
            
        $result = array_merge(
            ['status' => 'success'],
            ['data' => ''],
            ['message' => 'Save Successfully'],
        );    
        return $result;
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
        $userx = Auth::user();
        $id = $userx->roles->first()->id;
        $this->getpermissions($id);

        $user_skill = UserSkill::join('product_sku as ps','ps.id','users_skills.modul')
        ->join('users as u','u.id','users_skills.users_id')->where('u.id','=',$user->id)->get(['u.id','ps.id as product_id','users_skills.dated','u.name','ps.remark','users_skills.status']);

        $product = Product::where('type_id','=','2')->orderBy('remark','ASC')->get(['id','abbr','remark']);
        $data = $this->data;
        $usersReferral = User::where('users.id','!=',$user->id)->get(['users.id','users.name']);
        $users = DB::select("select coalesce(u.level_up_date,'1988-01-01'::date) level_up_date,u.work_year,u.employee_status,dt.remark as department,u.id,u.employee_id,u.name,jt.remark as job_title,string_agg(b.remark,',') as branch_name,u.join_date,u.phone_no,u.email,u.username,u.address,u.netizen_id,u.photo_netizen_id,u.photo,u.join_years,u.active,u.referral_id,u.city,u.gender,u.birth_place,u.birth_date 
                             from users u 
                             join users_branch ub on ub.user_id=u.id
                             join branch b on b.id = ub.branch_id
                             join departments dt on dt.id=u.department_id
                             join job_title jt on jt.id=u.job_id
                             where u.id = ? and u.name!='Super Admin' group by u.level_up_date,dt.remark,u.id,u.employee_id,u.name,jt.remark,u.join_date,u.phone_no,u.email,u.username,u.address,u.netizen_id,u.photo_netizen_id,u.photo,u.join_years,u.active,u.referral_id,u.city,u.gender,u.birth_place,u.birth_date  ; "
                             , [$user->id]);
        return view('pages.users.show', [
            'users' => $users[0],
            'user' => $user,
            'products' => $product,
            'status' => ['Failed','In Training','Pass'],
            'userTrainers' => User::where('job_id','=','7')->get(['id','name']),
            'userSkills' => $user_skill,
            'userExperiences' => UserExperience::get(),
            'employeestatusx' => ['On Job Training','Permanent','Outsourcing','Contract','Probation','Cuti','Kampung'],
            'usersReferrals' => $usersReferral,'company' => Company::get()->first(),
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
        $userx = Auth::user();
        $id = $userx->roles->first()->id;
        $this->getpermissions($id);

        $data = $this->data;
        $gender = ['Male','Female'];
        $active = [1,0];
        $users = DB::select("select coalesce(u.level_up_date,'1988-01-01'::date) level_up_date,u.work_year,u.employee_status,dt.remark as department,u.id,u.employee_id,u.name,jt.remark as job_title,string_agg(b.id::character varying,',') as branch_name,u.join_date,u.phone_no,u.email,u.username,u.address,u.netizen_id,u.photo_netizen_id,u.photo,u.join_years,u.active,u.referral_id,u.city,u.gender,u.birth_place,u.birth_date 
                             from users u 
                             join users_branch ub on ub.user_id=u.id
                             join branch b on b.id = ub.branch_id
                             join departments dt on dt.id=u.department_id
                             join job_title jt on jt.id=u.job_id
                             where u.id = ? and u.name!='Super Admin' group by u.level_up_date,u.level_up_date,dt.remark,u.id,u.employee_id,u.name,jt.remark,u.join_date,u.phone_no,u.email,u.username,u.address,u.netizen_id,u.photo_netizen_id,u.photo,u.join_years,u.active,u.referral_id,u.city,u.gender,u.birth_place,u.birth_date  ; "
                             , [$user->id]);
        $usersReferral = User::where('users.id','!=',$user->id)->get(['users.id','users.name']);
        return view('pages.users.edit', [
            'user' => $users[0],
            'userRole' => $user->roles->pluck('name')->toArray(),
            'roles' => Role::latest()->get(),
            'branchs' => Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$userx->id)->get(['branch.id','branch.remark']),
            'userBranchs' => Branch::join('users_branch as ub','ub.branch_id','=','branch.id')->where('ub.user_id','=',$user->id)->get()->pluck('remark')->toArray(),
            'departments' => Department::latest()->get(),
            'userDepartements' => Department::latest()->get()->pluck('remark')->toArray(),
            'jobTitles' => JobTitle::latest()->get(),'company' => Company::get()->first(),
            'userJobTitles' => JobTitle::latest()->get()->pluck('remark')->toArray(),
            'gender' => $gender,
            'active' => $active,
            'data' => $data,
            'employeestatusx' => ['On Job Training','Permanent','Outsourcing','Contract','Probation','Cuti','Kampung'],
            'usersReferrals' => $usersReferral,
        ]);
    }

    public function editpassword(User $user) 
    {
        $userx = Auth::user();
        $id = $userx->roles->first()->id;
        $this->getpermissions($id);

        $data = $this->data;
        $gender = ['Male','Female'];
        $active = [1,0];
        $users = DB::select("select coalesce(u.level_up_date,'1988-01-01'::date) level_up_date,u.work_year,u.employee_status,dt.remark as department,u.id,u.employee_id,u.name,jt.remark as job_title,string_agg(b.id::character varying,',') as branch_name,u.join_date,u.phone_no,u.email,u.username,u.address,u.netizen_id,u.photo_netizen_id,u.photo,u.join_years,u.active,u.referral_id,u.city,u.gender,u.birth_place,u.birth_date 
                             from users u 
                             join users_branch ub on ub.user_id=u.id
                             join branch b on b.id = ub.branch_id
                             join departments dt on dt.id=u.department_id
                             join job_title jt on jt.id=u.job_id
                             where u.id = ? and u.name!='Super Admin' group by u.level_up_date,u.level_up_date,dt.remark,u.id,u.employee_id,u.name,jt.remark,u.join_date,u.phone_no,u.email,u.username,u.address,u.netizen_id,u.photo_netizen_id,u.photo,u.join_years,u.active,u.referral_id,u.city,u.gender,u.birth_place,u.birth_date  ; "
                             , [$user->id]);
        $usersReferral = User::where('users.id','!=',$user->id)->get(['users.id','users.name']);
        return view('pages.users.editpassword', [
            'user' => $users[0],
            'userRole' => $user->roles->pluck('name')->toArray(),
            'roles' => Role::latest()->get(),
            'branchs' => Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$userx->id)->get(['branch.id','branch.remark']),
            'userBranchs' => Branch::join('users_branch as ub','ub.branch_id','=','branch.id')->where('ub.user_id','=',$user->id)->get()->pluck('remark')->toArray(),
            'departments' => Department::latest()->get(),
            'userDepartements' => Department::latest()->get()->pluck('remark')->toArray(),
            'jobTitles' => JobTitle::latest()->get(),'company' => Company::get()->first(),
            'userJobTitles' => JobTitle::latest()->get()->pluck('remark')->toArray(),
            'gender' => $gender,
            'active' => $active,
            'data' => $data,
            'employeestatusx' => ['On Job Training','Permanent','Outsourcing','Contract','Probation','Leave'],
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
            ['join_date' => Carbon::parse($request->get('join_date'))->format('Y-m-d') ],
            ['level_up_date' => Carbon::parse($request->get('level_up_date'))->format('Y-m-d') ],
            ['gender' => $request->get('gender') ],
            ['netizen_id' => $request->get('netizen_id') ],
            ['city' => $request->get('city') ],
            ['active' => $request->get('active')==null?'0':'1' ],
            ['work_year' => $request->get('work_year') ],
            ['employee_id' => $request->get('employee_id') ],
            ['job_id' => $request->get('job_id') ],
            ['department_id' => $request->get('department_id') ],
            ['address' => $request->get('address') ],
            ['referral_id' => $request->get('referral_id') ],
            ['birth_place' => $request->get('birth_place') ],
            ['employee_status' => $request->get('employee_status') ],
            ['birth_date' => Carbon::parse($request->get('birth_date'))->format('Y-m-d')  ]
        ));

        if($request->file('photo_netizen_ids') == null){

        }else{
            $file = $request->file('photo_netizen_ids');
            $user->update(['photo_netizen_id'=>$file->getClientOriginalName()]);
            
            // upload file
            $folder_upload = 'images/user-files';
            $file->move($folder_upload,$file->getClientOriginalName());
        }

        if($request->file('photo') == null){

        }else{
            $file_photo = $request->file('photo');
            $user->update(['photo'=>$file_photo->getClientOriginalName()]);
            
            // upload file
            $folder_upload = 'images/user-files';
            $file_photo->move($folder_upload,$file_photo->getClientOriginalName());
        }
        
        return redirect()->route('users.index')
            ->withSuccess(__('User updated successfully.'));
    }

    public function updatepassword(User $user, Request $request) 
    {
        $user->update( array_merge( 
            ['password' => $request->get('password') ],
        ));

        
        return redirect()->route('users.index')
            ->withSuccess(__('Sukses Update Password.'));
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

        DB::select("
            delete from users_skills us where users_id = ".$user->id.";
        ");

        if($user->delete()){
            $result = array_merge(
                ['status' => 'success'],
                ['data' => $user->remark],
                ['message' => 'Delete Successfully'],
            );    
        }else{
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => $user->remark],
                ['message' => 'Delete failed'],
            );   
        }
        return $result;
    }

    public function getpermissions($role_id){
        $id = $role_id;
        $permissions = Permission::join('role_has_permissions',function ($join)  use ($id) {
            $join->on(function($query) use ($id) {
                $query->on('role_has_permissions.permission_id', '=', 'permissions.id')
                ->where('role_has_permissions.role_id','=',$id)->where('permissions.name','like','%.index%')->where('permissions.url','!=','null');
            });
           })->orderby('permissions.seq')->get(['permissions.name','permissions.url','permissions.remark','permissions.parent']);

           $this->data = [
            'menu' => 
                [
                    [
                        'icon' => 'fa fa-user-gear',
                        'title' => \Lang::get('home.user_management'),
                        'url' => 'javascript:;',
                        'caret' => true,
                        'sub_menu' => []
                    ],
                    [
                        'icon' => 'fa fa-box',
                        'title' => \Lang::get('home.product_management'),
                        'url' => 'javascript:;',
                        'caret' => true,
                        'sub_menu' => []
                    ],
		                           [
                            'icon' => 'fa fa-spa',
                            'title' => \Lang::get('home.service_management'),
                        'url' => 'javascript:;',
                        'caret' => true,
                        'sub_menu' => []
                    ],
                    [
                        'icon' => 'fa fa-table',
                        'title' => \Lang::get('home.transaction'),
                        'url' => 'javascript:;',
                        'caret' => true,
                        'sub_menu' => []
                    ],
                    [
                        'icon' => 'fa fa-chart-column',
                        'title' => \Lang::get('home.reports'),
                        'url' => 'javascript:;',
                        'caret' => true,
                        'sub_menu' => []
                    ],
                    [
                        'icon' => 'fa fa-screwdriver-wrench',
                        'title' => \Lang::get('home.settings'),
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
            if($menu['parent']=='Services'){
                array_push($this->data['menu'][2]['sub_menu'], array(
                    'url' => $menu['url'],
                    'title' => $menu['remark'],
                    'route-name' => $menu['name']
                ));
            }
            if($menu['parent']=='Transactions'){
                array_push($this->data['menu'][3]['sub_menu'], array(
                    'url' => $menu['url'],
                    'title' => $menu['remark'],
                    'route-name' => $menu['name']
                ));
            }	
            if($menu['parent']=='Reports'){
                array_push($this->data['menu'][4]['sub_menu'], array(
                    'url' => $menu['url'],
                    'title' => $menu['remark'],
                    'route-name' => $menu['name']
                ));
            }
            if($menu['parent']=='Settings'){
                array_push($this->data['menu'][5]['sub_menu'], array(
                    'url' => $menu['url'],
                    'title' => $menu['remark'],
                    'route-name' => $menu['name']
                ));
            }
        }


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