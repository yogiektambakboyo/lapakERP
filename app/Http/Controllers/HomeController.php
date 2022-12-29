<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Spatie\Permission\Models\Permission;
use Auth;
use App\Models\Settings;
use App\Models\Company;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Lang;

class HomeController extends Controller
{
    private $data;
    public function index() 
    {
        $user = Auth::user();
        if($user != null){
            $join_date_renew = DB::select("UPDATE users SET join_years = case when extract(year from age(now(),join_date))<=0 then 1 else extract(year from age(now(),join_date)) end");  

            $id = $user->roles->first()->id;
            $permissions = Permission::join('role_has_permissions',function ($join)  use ($id) {
                $join->on(function($query) use ($id) {
                    $query->on('role_has_permissions.permission_id', '=', 'permissions.id')
                    ->where('role_has_permissions.role_id','=',$id)->where('permissions.name','like','%.index%')->where('permissions.url','!=','null');
                });
               })->orderby('permissions.remark')->get(['permissions.name','permissions.url','permissions.remark','permissions.parent']);

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



            $data = $this->data;

            $d_data = DB::select("
                select coalesce(sum(coalesce(im.total,0)),0) as total from users_branch ub 
                join customers c on c.branch_id = ub.branch_id 
                join invoice_master im on im.customers_id = c.id 
                where ub.user_id = ".$user->id."  and im.dated = now()::date                      
            ");

            $d_data_c = DB::select("
                select count(distinct im.invoice_no) as count_sales from users_branch ub 
                join customers c on c.branch_id = ub.branch_id 
                join invoice_master im on im.customers_id = c.id 
                where ub.user_id = ".$user->id."  and im.dated = now()::date                       
            ");

            $d_data_p = DB::select("
                select coalesce(sum(id.total+id.vat_total),0) as total_product  from users_branch ub 
                join customers c on c.branch_id = ub.branch_id 
                join invoice_master im on im.customers_id = c.id
                join invoice_detail id on id.invoice_no = im.invoice_no
                join product_sku ps on ps.id = id.product_id and ps.type_id not in (2,8)
                where ub.user_id = ".$user->id."  and im.dated = now()::date                       
            ");

            $d_data_t = DB::select("
                select u.name as user_name,sum(id.qty)  as counter
                from users_branch ub 
                join customers c on c.branch_id = ub.branch_id 
                join invoice_master im on im.customers_id = c.id
                join invoice_detail id on id.invoice_no = im.invoice_no
                join users u on u.id = id.assigned_to 
                where ub.user_id = ".$user->id."  and im.dated = now()::date 
                group by u.name order by 2 desc                    
            ");

            $d_data_s = DB::select("
                select coalesce(sum(id.total+id.vat_total),0) as total_service  from users_branch ub 
                join customers c on c.branch_id = ub.branch_id 
                join invoice_master im on im.customers_id = c.id
                join invoice_detail id on id.invoice_no = im.invoice_no
                join product_sku ps on ps.id = id.product_id and ps.type_id in (2,8)
                where ub.user_id = ".$user->id."  and im.dated = now()::date                     
            ");

            $d_data_r_p = DB::select("
                select ps.remark  as product_name,sum(id.qty)  as counter
                from users_branch ub 
                join customers c on c.branch_id = ub.branch_id 
                join invoice_master im on im.customers_id = c.id
                join invoice_detail id on id.invoice_no = im.invoice_no
                join product_sku ps on ps.id = id.product_id and ps.type_id = 1
                where ub.user_id = ".$user->id."  and im.dated = now()::date  
                group by ps.remark  order by 2 desc
            ");

            $d_data_r_s = DB::select("
                select ps.remark  as product_name,sum(id.qty)  as counter
                from users_branch ub 
                join customers c on c.branch_id = ub.branch_id 
                join invoice_master im on im.customers_id = c.id
                join invoice_detail id on id.invoice_no = im.invoice_no
                join product_sku ps on ps.id = id.product_id and ps.type_id = 2
                where ub.user_id = ".$user->id."  and im.dated = now()::date  
                group by ps.remark  order by 2 desc
            ");

            $has_period_stock = DB::select("
                select periode  from period_stock ps where ps.periode = to_char(now()::date,'YYYYMM')::int;
            ");

            if(count($has_period_stock)<=0){
                DB::select("insert into period_stock(periode,branch_id,product_id,balance_begin,balance_end,qty_in,qty_out,updated_at ,created_by,created_at)
                select to_char(now()::date,'YYYYMM')::int,ps.branch_id,product_id,ps.balance_end,ps.balance_end,0 as qty_in,0 as qty_out,null,1,now()  
                from period_stock ps where ps.periode = to_char(now()::date,'YYYYMM')::int-1;");
            }


            $has_shift_counter = DB::select("
                select users_id from shift_counter where created_at::date=now()::date;
            ");

            if(count($has_shift_counter)<=0){
                DB::select("insert into shift_counter(users_id,queue_no,created_by,created_at,branch_id)
                select u.id,row_number() over(partition by u.branch_id  order by u.name),1,now(),u.branch_id  from users u 
                join users_shift us on us.users_id = u.id and us.dated = now()::date
                where u.job_id = 2
                group by u.id,u.name;");
            }else{
                DB::select("
                    delete from shift_counter where created_at::date<now()::date;
                ");
            }

            $has_period_sell_price = DB::select("
                select period  from period_price_sell ps where ps.period = to_char(now()::date,'YYYYMM')::int;
            ");

            if(count($has_period_sell_price)<=0){
                DB::select("insert into public.period_price_sell(period, product_id, value, updated_at, updated_by, created_by, created_at, branch_id)
                SELECT to_char(now(),'YYYYMM')::int, product_id, value, null, null, 1, now(), branch_id
                FROM public.period_price_sell where period=to_char(now(),'YYYYMM')::int-1;");
            }
            
            return view('pages.home-index',[
                'd_data' => $d_data,
                'd_data_c' => $d_data_c,
                'd_data_p' => $d_data_p,
                'd_data_s' => $d_data_s,
                'd_data_t' => $d_data_t,
                'd_data_r_p' => $d_data_r_p,
                'd_data_r_s' => $d_data_r_s,
            ])->with('data',$data)->with('company',Company::get()->first());
        }else{
            $data = [];
            return view('pages.auth.login')->with('data',$data)->with('settings',Settings::get()->first())->with('company',Company::get()->first());
        }
    }

    public function getpermissions($role_id){
        $id = $role_id;
        $permissions = Permission::join('role_has_permissions',function ($join)  use ($id) {
            $join->on(function($query) use ($id) {
                $query->on('role_has_permissions.permission_id', '=', 'permissions.id')
                ->where('role_has_permissions.role_id','=',$id)->where('permissions.name','like','%.index%')->where('permissions.url','!=','null');
            });
           })->orderby('permissions.remark')->get(['permissions.name','permissions.url','permissions.remark','permissions.parent']);

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
