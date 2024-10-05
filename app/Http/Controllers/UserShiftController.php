<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use Spatie\Permission\Models\Permission;
use App\Models\Customer;
use App\Models\Branch;
use App\Models\Shift;
use App\Models\UserShift;
use App\Models\User;
use Auth;
use App\Exports\UserShiftExport;
use Illuminate\Support\Facades\DB;
use Maatwebsite\Excel\Facades\Excel;
use Carbon\Carbon;
use App\Models\Company;
use App\Http\Controllers\Lang;



class UserShiftController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    private $data,$act_permission,$module="customers",$id=1;

    public function __construct()
    {
        $this->middleware(function ($request, $next) {
            $this->user= Auth::user();
            $user = Auth::user();
            $role_id = $user->roles->first()->id;

            $this->act_permission = DB::select("
                select sum(coalesce(allow_create,0)) as allow_create,sum(coalesce(allow_delete,0)) as allow_delete,sum(coalesce(allow_show,0)) as allow_show,sum(coalesce(allow_edit,0)) as allow_edit from (
                    select count(1) as allow_create,0 as allow_delete,0 as allow_show,0 as allow_edit from permissions p join role_has_permissions rp on rp.permission_id = p.id where rp.role_id = ".$role_id." and p.name like '%.create' and p.name like '".$this->module.".%'
                    union 
                    select 0 as allow_create,count(1) as allow_delete,0 as allow_show,0 as allow_edit from permissions p  join role_has_permissions rp on rp.permission_id = p.id where rp.role_id = ".$role_id." and p.name like '%.delete' and p.name like '".$this->module.".%'
                    union 
                    select 0 as allow_create,0 as allow_delete,count(1) as allow_show,0 as allow_edit from permissions p  join role_has_permissions rp on rp.permission_id = p.id where rp.role_id = ".$role_id." and p.name like '%.show' and p.name like '".$this->module.".%'
                    union 
                    select 0 as allow_create,0 as allow_delete,0 as allow_show,count(1) as allow_edit from permissions p  join role_has_permissions rp on rp.permission_id = p.id where rp.role_id = ".$role_id." and p.name like '%.edit' and p.name like '".$this->module.".%'
                ) a
            ");   
            return $next($request);
        });   
    }


    public function index(Request $request)
    {   
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $user = Auth::user();
        $UsersShift = UserShift::join('branch as b','b.id','users_shift.branch_id')
                            ->join('users as u','u.id','=','users_shift.users_id')
                            ->join('users_branch as ub', function($join){
                                $join->on('ub.branch_id', '=', 'b.id');
                            })->where('ub.user_id', $user->id)->where('users_shift.dated','>=',Carbon::now()->startOfMonth())->paginate(10,['users_shift.branch_id','users_shift.users_id','users_shift.dated','users_shift.shift_id','users_shift.shift_remark','users_shift.shift_time_start','users_shift.shift_time_end','users_shift.remark','b.remark as branch_name','u.name','users_shift.id']);
        $data = $this->data;

        $request->search = "";
        $request->branch = "";
        $req = $request;
        $act_permission = $this->act_permission[0];
        $branchs = Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']);

        $act_permission = $this->act_permission[0];
        return view('pages.usersshift.index', [
            'usersshifts' => $UsersShift,'data' => $data , 'company' => Company::get()->first(), 'request' => $request, 'branchs' => $branchs , 'act_permission' => $act_permission         
        ]);
    }

    public function search(Request $request) 
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $keyword = $request->search;
        $data = $this->data;
        $act_permission = $this->act_permission[0];
        $branchx = $request->filter_branch_id;
        $begindate = Carbon::now()->startOfMonth();
        $enddate = Carbon::now();
        $branchs = Branch::join('users_branch as ub','ub.branch_id', '=', 'branch.id')->where('ub.user_id','=',$user->id)->get(['branch.id','branch.remark']);
        if($request->export=='Export Excel'){
            $strencode = base64_encode($keyword.'#'.$begindate.'#'.$enddate.'#'.$branchx.'#'.$user->id);
            return Excel::download(new UserShiftExport($strencode), 'usershift_'.Carbon::now()->format('YmdHis').'.xlsx');
        }else if($request->src=='Search'){
            $UsersShift = UserShift::join('branch as b','b.id','users_shift.branch_id')
                            ->join('users as u','u.id','=','users_shift.users_id')
                            ->join('users_branch as ub', function($join){
                                $join->on('ub.branch_id', '=', 'b.id');
                            })->where('ub.user_id', $user->id)->where('u.name','ilike','%'.$keyword.'%')->where('users_shift.dated','>=',Carbon::now()->startOfMonth())->paginate(10,['users_shift.branch_id','users_shift.users_id','users_shift.dated','users_shift.shift_id','users_shift.shift_remark','users_shift.shift_time_start','users_shift.shift_time_end','users_shift.remark','b.remark as branch_name','u.name','users_shift.id']);        
            $request->filter_branch_id = "";
            return view('pages.usersshift.index', [
                'usersshifts' => $UsersShift,'data' => $data , 'company' => Company::get()->first(), 'request' => $request, 'branchs' => $branchs , 'act_permission' => $act_permission         
            ]);
        }else{
            $UsersShift = UserShift::join('branch as b','b.id','users_shift.branch_id')
            ->join('users as u','u.id','=','users_shift.users_id')
            ->join('users_branch as ub', function($join){
                $join->on('ub.branch_id', '=', 'b.id');
            })->where('ub.user_id', $user->id)->where('ub.branch_id','ilike','%'.$branchx.'%')->where('users_shift.dated','>=',Carbon::now()->startOfMonth())->paginate(10,['users_shift.branch_id','users_shift.users_id','users_shift.dated','users_shift.shift_id','users_shift.shift_remark','users_shift.shift_time_start','users_shift.shift_time_end','users_shift.remark','b.remark as branch_name','u.name','users_shift.id']);        
            return view('pages.usersshift.index', [
            'usersshifts' => $UsersShift,'data' => $data , 'company' => Company::get()->first(), 'request' => $request, 'branchs' => $branchs , 'act_permission' => $act_permission         
            ]);
        }
    }


    /**
     * Show form for creating Customer
     * 
     * @return \Illuminate\Http\Response
     */
    public function create() 
    {  
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);
 
        $data = $this->data;
        $users = DB::select("
            select distinct u2.id,u2.name  from users_branch ub2 
            join users u2 on u2.id = ub2.user_id 
            where ub2.branch_id in (
            select ub.branch_id  from users u 
            join users_branch ub on ub.user_id = u.id 
            where u.id = 1) order by 2
        ");

        return view('pages.usersshift.create',[
            'data'=>$data,
            'branchs' => Branch::latest()->get(), 
            'company' => Company::get()->first(),
            'userBranchs' => Branch::latest()->get()->pluck('remark')->toArray(),
            'users' => $users,
            'shifts' => Shift::latest()->get(),
        ]);
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {   
    
        UserShift::create(
            array_merge( 
                ['branch_id' => $request->get('branch_id') ],
                ['users_id' => $request->get('users_id') ],
                ['dated' => Carbon::parse($request->get('dated'))->format('Y-m-d') ],
                ['shift_id' => $request->get('shift_id') ],
                ['remark' => $request->get('remark') ],
            )
        );

        $usershift = UserShift::where('branch_id','=',$request->get('branch_id'))
                                ->where('users_id','=',$request->get('users_id'))
                                ->where('dated','=',Carbon::parse($request->get('dated'))->format('Y-m-d'))
                                ->where('shift_id','=',$request->get('shift_id'));
        $shift_data = Shift::where('id','=',$request->get('shift_id'))->first();
        $usershift->update(
            array_merge(
                ['shift_remark' => $shift_data->remark ],
                ['shift_time_start' => $shift_data->time_start ],
                ['shift_time_end' => $shift_data->time_end ],
            )
        );


        return redirect()->route('usersshift.index')
            ->withSuccess(__('User Shift created successfully.'));
    }

    public function storeapi(Request $request)
    {   
    
        Customer::create(
            array_merge( 
                ['phone_no' => $request->get('phone_no') ],
                ['name' => $request->get('name') ],
                ['address' => $request->get('address') ],
                ['membership_id' => '1' ],
                ['abbr' => '1' ],
                ['branch_id' => $request->get('branch_id') ],
            )
        );

        $id = Customer::where('name','=',$request->get('name'))->max('id');
        $result = array_merge(
            ['status' => 'success'],
            ['data' => $id],
            ['message' => 'Save Successfully'],
        );

        return $result;
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  Customer  $Customer
     * @return \Illuminate\Http\Response
     */
    public function edit(UserShift $usersshift)
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);
        $data = $this->data;
        $users = DB::select("
            select distinct u2.id,u2.name  from users_branch ub2 
            join users u2 on u2.id = ub2.user_id 
            where ub2.branch_id in (
            select ub.branch_id  from users u 
            join users_branch ub on ub.user_id = u.id 
            where u.id = 1) order by 2
        ");
        return view('pages.usersshift.edit', [
            'usershift' => $usersshift ,
            'data' => $data ,
            'users' => $users,
            'branchs' => Branch::latest()->get(),
            'company' => Company::get()->first(),
            'shifts' => Shift::latest()->get(),
            'userBranchs' => Branch::latest()->get()->pluck('remark')->toArray()
        ]);
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  Customer  $Customer
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, UserShift $usersshift)
    {
        UserShift::where('id', $usersshift->id)
        ->update(
            array_merge( 
                ['branch_id' => $request->get('branch_id') ],
                ['users_id' => $request->get('users_id') ],
                ['dated' => Carbon::parse($request->get('dated'))->format('Y-m-d') ],
                ['shift_id' => $request->get('shift_id') ],
                ['remark' => $request->get('remark') ],
            )
        );

        $usershift = UserShift::where('branch_id','=',$request->get('branch_id'))
                                ->where('users_id','=',$request->get('users_id'))
                                ->where('dated','=',Carbon::parse($request->get('dated'))->format('Y-m-d'))
                                ->where('shift_id','=',$request->get('shift_id'));
        
        $shift_data = Shift::where('id','=',$request->get('shift_id'))->first();
        $usershift->update(
            array_merge(
                ['shift_remark' => $shift_data->remark ],
                ['shift_time_start' => $shift_data->time_start ],
                ['shift_time_end' => $shift_data->time_end ],
            )
        );

        return redirect()->route('usersshift.index')
            ->withSuccess(__('Customer updated successfully.'));
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\Post  $post
     * @return \Illuminate\Http\Response
     */
    public function destroy(UserShift $usersshift)
    {
        if($usersshift->delete()){
            $result = array_merge(
                ['status' => 'success'],
                ['data' => $usersshift->name],
                ['message' => 'Delete Successfully'],
            );    
        }else{
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => $usersshift->name],
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
                        'display' => '', 
                        'sub_menu' => []
                    ],
                    [
                        'icon' => 'fa fa-box',
                        'title' => \Lang::get('home.product_management'),
                        'url' => 'javascript:;',
                        'caret' => true,
                        'display' => '',
                        'sub_menu' => []
                    ],
		            [
                        'icon' => 'fa fa-box',
                        'title' => \Lang::get('home.service_management'),
                        'url' => 'javascript:;',
                        'caret' => true,
                        'display' => '',
                        'sub_menu' => []
                    ],
                    [
                        'icon' => 'fa fa-table',
                        'title' => \Lang::get('home.transaction'),
                        'url' => 'javascript:;',
                        'caret' => true,
                        'display' => '',
                        'sub_menu' => []
                    ],
                    [
                        'icon' => 'fa fa-chart-column',
                        'title' => \Lang::get('home.reports'),
                        'url' => 'javascript:;',
                        'caret' => true,
                        'display' => '',
                        'sub_menu' => []
                    ],
                    [
                        'icon' => 'fa fa-screwdriver-wrench',
                        'title' => \Lang::get('home.settings'),
                        'url' => 'javascript:;',
                        'caret' => true,
                        'display' => '',
                        'sub_menu' => []
                    ]  
                ]      
        ];

        $c_user = 0;
        $c_product = 0;
        $c_service = 0;
        $c_trans = 0;
        $c_report = 0;
        $c_setting = 0;

        foreach ($permissions as $key => $menu) {
            if($menu['parent']=='Users'){
                $c_user++;
                array_push($this->data['menu'][0]['sub_menu'], array(
                    'url' => $menu['url'],
                     'title' => \Lang::get('sidebar.'.str_replace(" ","",$menu['remark'])),
                    'route-name' => $menu['name']
                ));
            }
            if($menu['parent']=='Products'){
                $c_product++;
                array_push($this->data['menu'][1]['sub_menu'], array(
                    'url' => $menu['url'],
                     'title' => \Lang::get('sidebar.'.str_replace(" ","",$menu['remark'])),
                    'route-name' => $menu['name']
                ));
            }
            if($menu['parent']=='Services'){
                $c_service++;
                array_push($this->data['menu'][2]['sub_menu'], array(
                    'url' => $menu['url'],
                     'title' => \Lang::get('sidebar.'.str_replace(" ","",$menu['remark'])),
                    'route-name' => $menu['name']
                ));
            }
            if($menu['parent']=='Transactions'){
                $c_trans++;
                array_push($this->data['menu'][3]['sub_menu'], array(
                    'url' => $menu['url'],
                     'title' => \Lang::get('sidebar.'.str_replace(" ","",$menu['remark'])),
                    'route-name' => $menu['name']
                ));
            }	
            if($menu['parent']=='Reports'){
                $c_report++;
                array_push($this->data['menu'][4]['sub_menu'], array(
                    'url' => $menu['url'],
                     'title' => \Lang::get('sidebar.'.str_replace(" ","",$menu['remark'])),
                    'route-name' => $menu['name']
                ));
            }
            if($menu['parent']=='Settings'){
                $c_setting++;
                array_push($this->data['menu'][5]['sub_menu'], array(
                    'url' => $menu['url'],
                     'title' => \Lang::get('sidebar.'.str_replace(" ","",$menu['remark'])),
                    'route-name' => $menu['name']
                ));
            }
        }

        if($c_user == 0){
            $this->data['menu'][0]['display'] = 'd-none';
        }
        if($c_product == 0){
            $this->data['menu'][1]['display'] = 'd-none';
        }

        if($c_service == 0){
            $this->data['menu'][2]['display'] = 'd-none';
        }

        if($c_trans == 0){
            $this->data['menu'][3]['display'] = 'd-none';
        }

        if($c_report == 0){
            $this->data['menu'][4]['display'] = 'd-none';
        }

        if($c_setting == 0){
            $this->data['menu'][5]['display'] = 'd-none';
        }
    }
}
