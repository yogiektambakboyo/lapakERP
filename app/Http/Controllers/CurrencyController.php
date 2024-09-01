<?php

namespace App\Http\Controllers;

use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use Spatie\Permission\Models\Permission;
use App\Models\Branch;
use App\Models\Currency;
use App\Exports\BranchsExport;
use Illuminate\Support\Facades\DB;
use Maatwebsite\Excel\Facades\Excel;
use App\Models\Company;
use Auth;
use App\Http\Controllers\Lang;


class CurrencyController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    private $data,$act_permission,$module="currency",$id=1;

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


    public function index()
    {   
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $branchs = Currency::all();
        $data = $this->data;
        $keyword = "";
        $act_permission = $this->act_permission[0];
        //$bahasa = App::getLocale();

        return view('pages.currency.index', [
            'branchs' => $branchs,'data' => $data , 'bahasa' => "",'keyword' => $keyword,'company' => Company::get()->first() ,'act_permission' => $act_permission
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


        if($request->export=='Export Excel'){
            return Excel::download(new BranchsExport($keyword), 'branchs_'.Carbon::now()->format('YmdHis').'.xlsx');
        }else{
            $branchs = Branch::orderBy('id', 'ASC')->where('branch.remark','LIKE','%'.$keyword.'%')->get();
            return view('pages.currency.index', ['act_permission' => $act_permission,'company' => Company::get()->first()],compact('branchs','data','keyword'))->with('i', ($request->input('page', 1) - 1) * 5);
        }
    }

    /**
     * Show form for creating branch
     * 
     * @return \Illuminate\Http\Response
     */
    public function create() 
    {  
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);
 
        $data = $this->data;
        return view('pages.currency.create',['data'=>$data ,'company' => Company::get()->first()]);
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {   
        $request->validate([
            'remark' => 'required|unique:currency'
        ]);

        Currency::create($request->all());

        return redirect()->route('currency.index')
            ->withSuccess(__('Currency '.$request->remark.' created successfully.'));
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  Branch  $branch
     * @return \Illuminate\Http\Response
     */
    public function edit(Branch $branch)
    {
        $user = Auth::user();
        $id = $user->roles->first()->id;
        $this->getpermissions($id);

        $data = $this->data;
        return view('pages.currency.edit', [
            'branch' => $branch ,'data' => $data, 'company' => Company::get()->first()
        ]);
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  Branch  $branch
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, Branch $branch)
    {
        $request->validate([
            'remark' => 'required|unique:branch,remark,'.$branch->id
        ]);

        $branch->update( array_merge(
            ['remark' => $request->get('remark') ],
            ['address' => $request->get('address') ],
            ['city' => $request->get('city') ],
            ['abbr' => $request->get('abbr') ],
        ));
        

        return redirect()->route('currency.index')
            ->withSuccess(__('Branch updated successfully.'));
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\Post  $post
     * @return \Illuminate\Http\Response
     */
    public function destroy(Currency $currency)
    {
        if($currency->delete()){
            $result = array_merge(
                ['status' => 'success'],
                ['data' => $currency->remark],
                ['message' => 'Delete Successfully'],
            );    
        }else{
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => $currency->remark],
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
                        'icon' => 'fa fa-box',
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
                     'title' => \Lang::get('sidebar.'.str_replace(" ","",$menu['remark'])),
                    'route-name' => $menu['name']
                ));
            }
            if($menu['parent']=='Products'){
                array_push($this->data['menu'][1]['sub_menu'], array(
                    'url' => $menu['url'],
                     'title' => \Lang::get('sidebar.'.str_replace(" ","",$menu['remark'])),
                    'route-name' => $menu['name']
                ));
            }
            if($menu['parent']=='Services'){
                array_push($this->data['menu'][2]['sub_menu'], array(
                    'url' => $menu['url'],
                     'title' => \Lang::get('sidebar.'.str_replace(" ","",$menu['remark'])),
                    'route-name' => $menu['name']
                ));
            }
            if($menu['parent']=='Transactions'){
                array_push($this->data['menu'][3]['sub_menu'], array(
                    'url' => $menu['url'],
                     'title' => \Lang::get('sidebar.'.str_replace(" ","",$menu['remark'])),
                    'route-name' => $menu['name']
                ));
            }	
            if($menu['parent']=='Reports'){
                array_push($this->data['menu'][4]['sub_menu'], array(
                    'url' => $menu['url'],
                     'title' => \Lang::get('sidebar.'.str_replace(" ","",$menu['remark'])),
                    'route-name' => $menu['name']
                ));
            }
            if($menu['parent']=='Settings'){
                array_push($this->data['menu'][5]['sub_menu'], array(
                    'url' => $menu['url'],
                     'title' => \Lang::get('sidebar.'.str_replace(" ","",$menu['remark'])),
                    'route-name' => $menu['name']
                ));
            }
        }


    }
}
