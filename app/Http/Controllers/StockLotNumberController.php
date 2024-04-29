<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use Spatie\Permission\Models\Permission;
use Auth;
use DB;
use Spatie\Permission\Models\Role;
use App\Http\Controllers\Controller;
use App\Models\Company;
use App\Models\StockLotNumber;
use App\Models\StockLotNumberTemp;
use App\Http\Controllers\Lang;



class StockLotNumberController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    private $data,$act_permission,$module="stock_lotnumber",$id=1;

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

        $permissions = StockLotNumber::join('product_sku','product_sku.alias_code','=','stock_lotnumber.alias_code')->paginate(10);
        $data = $this->data;

        return view('pages.permissions.index_stock', [
            'permissions' => $permissions,'data' => $data, 'company' => Company::get()->first(), 'keyword' => ''
        ])->with('i', ($request->input('page', 1) - 1) * 5);
    }

    public function get_list(Request $request)
    {  
        $data_res = DB::select(" select * from stock_lotnumber limit 1000");
        return  array_merge([
            'status' => 'success',
            'data' => $data_res, 
            'message' => 'Get Data Succesfully'
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
            $permissions = StockLotNumber::join('product_sku','product_sku.alias_code','=','stock_lotnumber.alias_code')->where('no_surat','like','%'.$keyword.'%')->orWhere('product_sku.remark','like','%'.$keyword.'%')->orWhere('lot_number','like','%'.$keyword.'%')->orWhere('spkid','like','%'.$keyword.'%')->paginate(100);
            return view('pages.permissions.index_stock', ['permissions' => $permissions,'act_permission' => $act_permission,'company' => Company::get()->first()],compact('data','keyword'))->with('i', ($request->input('page', 1) - 1) * 5);
        }
    }

    public function store_api(Request $request) 
    {
        $res_data = $request->get('detail');
        $c_token = $request->get('token');
        $s_token = md5(date('Ymd'));


        if($request->get('user_agent')=="BaliFoamv1" && $c_token == $s_token){
            StockLotNumberTemp::truncate();
            
            $c_data = count($res_data);

            for ($i=0; $i < $c_data; $i++) { 
                $det = $res_data[$i];

                $recid = $det['recid'];
                $no_surat = $det['no_surat'];
                $spkid = $det['spkid'];
                $lot_number = $det['lot_number'];
                $alias_code = $det['alias_code'];
                $location = $det['location'];
                $category_name = $det['category_name'];
                $type_name = $det['type_name'];
                $product_name = $det['product_name'];
                $qty = $det['qty'];
                $point = $det['point'];
                $qty_available = $det['qty_available'];

                $insert_data = StockLotNumberTemp::create(
                    array_merge(
                        ['recid' => $recid ],
                        ['no_surat' => $no_surat ],
                        ['lot_number' => $lot_number ],
                        ['alias_code' => $alias_code ],
                        ['location' => $location ],
                        ['spkid' => $spkid ],
                        ['category_name' => $category_name ],
                        ['type_name' => $type_name ],
                        ['product_name' => $product_name ],
                        ['qty' => $qty ],
                        ['qty_available' => $qty_available ],
                        ['point' => $point ],
                    )
                );

            }

            DB::select("UPDATE product_category
                        SET    add_colum = t2.type_name,add_column_2 = t2.point, updated_at = now()
                        FROM   product_category t1
                        JOIN   temp_stock_lotnumber t2 ON t1.remark  = t2.category_name
                        WHERE  product_category.id = t1.id;");

            DB::select("INSERT into product_category(remark,created_at,type_id,recid,add_colum,add_column_2)
            select distinct category_name,now(),1,'',type_name,point  from temp_stock_lotnumber
            where category_name not in (
                select remark from product_category 
            );");


            DB::select("INSERT into product_sku(remark,abbr,alias_code,barcode,category_id,type_id,brand_id,created_at,created_by)
            select distinct product_name,product_name,alias_code,alias_code,pc.id as category_id,1,1,now(),1  from temp_stock_lotnumber t
            join product_category pc on pc.remark = t.category_name where t.alias_code not in 
            (select alias_code from product_sku);");

            DB::select("INSERT into stock_lotnumber(recid,no_surat,spkid,lot_number,alias_code,location,qty,qty_available)
            select recid,no_surat,spkid,lot_number,alias_code,location,qty,qty_available from temp_stock_lotnumber
            where recid not in (select recid from stock_lotnumber)");

            DB::select("delete from tmp_category;");
            DB::select("insert into tmp_category(alias_code,category_new,category_new_id,category_old,category_old_id)
            select distinct t.alias_code,t.category_name category_new,pc2.id category_new_id,pc.remark category_old, pc.id category_old_id  from
            temp_stock_lotnumber t
            join product_sku ps on ps.alias_code = t.alias_code 
            join product_category pc on pc.id  = ps.category_id  
            left join product_category pc2 on pc2.remark  = t.category_name  
            where  pc.remark != t.category_name;");

            DB::select("UPDATE product_sku
            SET    category_id = t2.category_new_id,updated_at = now()
            FROM   product_sku t1
            JOIN   tmp_category t2 ON t1.alias_code  = t2.alias_code
            WHERE  product_sku.alias_code = t1.alias_code;");


            $result = array_merge(
                ['status' => 'success'],
                ['data' => $res_data ],
                ['message' => 'Success insert '.$c_data.' data'],
            );
        }else{
            $result = array_merge(
                ['status' => 'failed'],
                ['data' => [] ],
                ['message' => 'Not authorized'],
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
}
