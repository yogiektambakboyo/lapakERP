<?php

use Illuminate\Support\Facades\Route;
use App\Models\User;

use Yajra\Datatables\Datatables;
use Illuminate\Http\Request;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::group(['namespace' => 'App\Http\Controllers'], function()
{   
    /**
     * Home Routes
     */
    Route::get('/', 'HomeController@index')->name('home.index');

    Route::group(['middleware' => ['guest']], function() {
        /**
         * Register Routes
         */
        Route::get('/register', 'RegisterController@show')->name('register.show');
        Route::post('/register', 'RegisterController@register')->name('register.perform');

        /**
         * Login Routes
         */
        Route::get('/login', 'LoginController@show')->name('login.show');
        Route::post('/login', 'LoginController@login')->name('login.perform');

    });


    /**Route::get('getUser', function (Request $request) {
        if ($request->ajax()) {
                $data = User::orderBy('id', 'ASC')->join('branch as b','b.id','=','users.branch_id')->join('job_title as jt','jt.id','=','users.job_id')->where('users.name','!=','Admin')->get(['users.id as id','users.employee_id as employee_id','users.name as name','jt.remark as job_title','b.remark as branch_name','users.join_date' ]);
                return DataTables::of($data)
                    ->addIndexColumn()
                    ->addColumn('action', function($row){
                        $actionBtn = '<a href="javascript:void(0)" class="edit btn btn-success btn-sm">Edit</a> <a href="javascript:void(0)" class="delete btn btn-danger btn-sm">Delete</a>';
                        return $actionBtn;
                    })
                    ->rawColumns(['action'])
                    ->make(true);
            }
    })->name('user.index'); **/

    Route::group(['middleware' => ['auth', 'permission']], function() {
        /**
         * Logout Routes
         */
        Route::get('/logout', 'LogoutController@perform')->name('logout.perform');

        /**
         * User Routes
         */
        Route::group(['prefix' => 'users'], function() {
            Route::get('/', 'UsersController@index')->name('users.index');
            Route::get('/create', 'UsersController@create')->name('users.create');
            Route::post('/create', 'UsersController@store')->name('users.store');
            Route::post('/addtraining', 'UsersController@storetraining')->name('users.addtraining');
            Route::post('/deletetraining', 'UsersController@deletetraining')->name('users.deletetraining');
            Route::post('/addexperience', 'UsersController@storeexperience')->name('users.addexperience');
            Route::post('/deleteexperience', 'UsersController@deleteexperience')->name('users.deleteexperience');
            Route::get('/search', 'UsersController@search')->name('users.search');
            Route::get('/{user}/show', 'UsersController@show')->name('users.show');
            Route::get('/{user}/edit', 'UsersController@edit')->name('users.edit');
            Route::patch('/{user}/update', 'UsersController@update')->name('users.update');
            Route::delete('/{user}/delete', 'UsersController@destroy')->name('users.destroy');
            Route::get('/export', 'UsersController@export')->name('users.export');
        });

         /**
         * Order Routes
         */
        Route::group(['prefix' => 'orders'], function() {
            Route::get('/', 'OrdersController@index')->name('orders.index');
            Route::get('/create', 'OrdersController@create')->name('orders.create');
            Route::get('/checkvoucher', 'OrdersController@checkvoucher')->name('orders.checkvoucher');
            Route::post('/create', 'OrdersController@store')->name('orders.store');
            Route::get('/search', 'OrdersController@search')->name('orders.search');
            Route::get('/{order}/show', 'OrdersController@show')->name('orders.show');
            Route::get('/{order}/edit', 'OrdersController@edit')->name('orders.edit');
            Route::get('/{order}/print', 'OrdersController@print')->name('orders.print');
            Route::get('/getproduct', 'OrdersController@getproduct')->name('orders.getproduct');
            Route::get('/gettimetable', 'OrdersController@gettimetable')->name('orders.gettimetable');
            Route::get('/{order}/getorder', 'OrdersController@getorder')->name('orders.getorder');
            Route::patch('/{order}/update', 'OrdersController@update')->name('orders.update');
            Route::delete('/{order}/delete', 'OrdersController@destroy')->name('orders.destroy');
            Route::get('/export', 'OrdersController@export')->name('orders.export');
        });

         /**
         * Invoice Routes
         */
        Route::group(['prefix' => 'invoices'], function() {
            Route::get('/', 'InvoicesController@index')->name('invoices.index');
            Route::get('/create', 'InvoicesController@create')->name('invoices.create');
            Route::post('/create', 'InvoicesController@store')->name('invoices.store');
            Route::get('/search', 'InvoicesController@search')->name('invoices.search');
            Route::get('/{invoice}/show', 'InvoicesController@show')->name('invoices.show');
            Route::get('/{invoice}/edit', 'InvoicesController@edit')->name('invoices.edit');
            Route::get('/{invoice}/print', 'InvoicesController@print')->name('invoices.print');
            Route::get('/getproduct', 'InvoicesController@getproduct')->name('invoices.getproduct');
            Route::get('/gettimetable', 'InvoicesController@gettimetable')->name('invoices.gettimetable');
            Route::get('/{invoice}/getinvoice', 'InvoicesController@getinvoice')->name('invoices.getinvoice');
            Route::patch('/{invoice}/update', 'InvoicesController@update')->name('invoices.update');
            Route::delete('/{invoice}/delete', 'InvoicesController@destroy')->name('invoices.destroy');
            Route::get('/export', 'InvoicesController@export')->name('invoices.export');
        });


         /**
         * Order Routes
         */
        Route::group(['prefix' => 'purchaseorders'], function() {
            Route::get('/', 'PurchaseOrderController@index')->name('purchaseorders.index');
            Route::get('/create', 'PurchaseOrderController@create')->name('purchaseorders.create');
            Route::post('/create', 'PurchaseOrderController@store')->name('purchaseorders.store');
            Route::post('/search', 'PurchaseOrderController@search')->name('purchaseorders.search');
            Route::get('/{purchase}/show', 'PurchaseOrderController@show')->name('purchaseorders.show');
            Route::get('/{purchase}/print', 'PurchaseOrderController@print')->name('purchaseorders.print');
            Route::get('/{purchase}/edit', 'PurchaseOrderController@edit')->name('purchaseorders.edit');
            Route::get('/getproduct', 'PurchaseOrderController@getproduct')->name('purchaseorders.getproduct');
            Route::get('/gettimetable', 'PurchaseOrderController@gettimetable')->name('purchaseorders.gettimetable');
            Route::get('/{purchase}/getorder', 'PurchaseOrderController@getorder')->name('purchaseorders.getorder');
            Route::patch('/{purchase}/update', 'PurchaseOrderController@update')->name('purchaseorders.update');
            Route::get('/{purchase}/getdocdata', 'PurchaseOrderController@getdocdata')->name('purchaseorders.getdocdata');
            Route::delete('/{purchase}/delete', 'PurchaseOrderController@destroy')->name('purchaseorders.destroy');
            Route::get('/export', 'PurchaseOrderController@export')->name('purchaseorders.export');
        });

         /**
         * Receive Routes
         */
        Route::group(['prefix' => 'receiveorders'], function() {
            Route::get('/', 'ReceiveOrderController@index')->name('receiveorders.index');
            Route::get('/create', 'ReceiveOrderController@create')->name('receiveorders.create');
            Route::post('/create', 'ReceiveOrderController@store')->name('receiveorders.store');
            Route::get('/search', 'ReceiveOrderController@search')->name('receiveorders.search');
            Route::get('/{receive}/show', 'ReceiveOrderController@show')->name('receiveorders.show');
            Route::get('/{receive}/edit', 'ReceiveOrderController@edit')->name('receiveorders.edit');
            Route::get('/getproduct', 'ReceiveOrderController@getproduct')->name('receiveorders.getproduct');
            Route::get('/gettimetable', 'ReceiveOrderController@gettimetable')->name('receiveorders.gettimetable');
            Route::get('/{receive}/getorder', 'ReceiveOrderController@getorder')->name('receiveorders.getorder');
            Route::patch('/{receive}/update', 'ReceiveOrderController@update')->name('receiveorders.update');
            Route::get('/{receive}/getdocdata', 'ReceiveOrderController@getdocdata')->name('receiveorders.getdocdata');
            Route::delete('/{receive}/delete', 'ReceiveOrderController@destroy')->name('receiveorders.destroy');
            Route::get('/export', 'ReceiveOrderController@export')->name('receiveorders.export');
            Route::get('/{receive}/print', 'ReceiveOrderController@print')->name('receiveorders.print');
        });



         /**
         * Product Routes
         */
        Route::group(['prefix' => 'products'], function() {
            Route::get('/', 'ProductsController@index')->name('products.index');
            Route::get('/create', 'ProductsController@create')->name('products.create');
            Route::post('/create', 'ProductsController@store')->name('products.store');
            Route::post('/createingredient', 'ProductsController@storeIngredients')->name('products.addingredients');
            Route::get('/search', 'ProductsController@search')->name('products.search');
            Route::get('/{product}/show', 'ProductsController@show')->name('products.show');
            Route::get('/{product}/edit', 'ProductsController@edit')->name('products.edit');
            Route::patch('/{product}/update', 'ProductsController@update')->name('products.update');
            Route::delete('/{product}/delete', 'ProductsController@destroy')->name('products.destroy');
            Route::get('/export', 'ProductsController@export')->name('products.export');
            Route::post('/deleteingredients', 'ProductsController@deleteIngredients')->name('products.deleteingredients');

        });

        /**
         * Product Brand
         */
        Route::group(['prefix' => 'productsbrand'], function() {
            Route::get('/', 'ProductsBrandController@index')->name('productsbrand.index');
            Route::get('/create', 'ProductsBrandController@create')->name('productsbrand.create');
            Route::post('/create', 'ProductsBrandController@store')->name('productsbrand.store');
            Route::get('/search', 'ProductsBrandController@search')->name('productsbrand.search');
            Route::get('/{productbrand}/show', 'ProductsBrandController@show')->name('productsbrand.show');
            Route::get('/{productbrand}/edit', 'ProductsBrandController@edit')->name('productsbrand.edit');
            Route::patch('/{productbrand}/update', 'ProductsBrandController@update')->name('productsbrand.update');
            Route::delete('/{productbrand}/delete', 'ProductsBrandController@destroy')->name('productsbrand.destroy');
            Route::get('/export', 'ProductsBrandController@export')->name('productsbrand.export');
        });


        /**
         * Product Price
         */
        Route::group(['prefix' => 'productsprice'], function() {
            Route::get('/', 'ProductsPriceController@index')->name('productsprice.index');
            Route::get('/create', 'ProductsPriceController@create')->name('productsprice.create');
            Route::post('/create', 'ProductsPriceController@store')->name('productsprice.store');
            Route::get('/search', 'ProductsPriceController@search')->name('productsprice.search');
            Route::get('/{branch}/{product}/show', 'ProductsPriceController@show')->name('productsprice.show');
            Route::get('/{branch}/{product}/edit', 'ProductsPriceController@edit')->name('productsprice.edit');
            Route::patch('/{branch}/{product}/update', 'ProductsPriceController@update')->name('productsprice.update');
            Route::delete('/{branch}/{product}/delete', 'ProductsPriceController@destroy')->name('productsprice.destroy');
            Route::get('/export', 'ProductsPriceController@export')->name('productsprice.export');
        });


        /**
         * Product Price Adjustment
         */
        Route::group(['prefix' => 'productspriceadj'], function() {
            Route::get('/', 'ProductsPriceAdjController@index')->name('productspriceadj.index');
            Route::get('/create', 'ProductsPriceAdjController@create')->name('productspriceadj.create');
            Route::post('/create', 'ProductsPriceAdjController@store')->name('productspriceadj.store');
            Route::get('/search', 'ProductsPriceAdjController@search')->name('productspriceadj.search');
            Route::get('/{branch}/{product}/show', 'ProductsPriceAdjController@show')->name('productspriceadj.show');
            Route::get('/{branch}/{product}/edit', 'ProductsPriceAdjController@edit')->name('productspriceadj.edit');
            Route::patch('/{branch}/{product}/{dated_start}/{dated_end}/update', 'ProductsPriceAdjController@update')->name('productspriceadj.update');
            Route::delete('/{branch}/{product}/{dated_start}/{dated_end}/delete', 'ProductsPriceAdjController@destroy')->name('productspriceadj.destroy');
            Route::get('/export', 'ProductsPriceAdjController@export')->name('productspriceadj.export');
        });

        /**
         * Product Voucher
         */
        Route::group(['prefix' => 'voucher'], function() {
            Route::get('/', 'VoucherController@index')->name('voucher.index');
            Route::get('/create', 'VoucherController@create')->name('voucher.create');
            Route::post('/create', 'VoucherController@store')->name('voucher.store');
            Route::get('/search', 'VoucherController@search')->name('voucher.search');
            Route::get('/{branch}/{product}/show', 'VoucherController@show')->name('voucher.show');
            Route::get('/{branch}/{product}/{dated_start}/{dated_end}/{voucher_code}/edit', 'VoucherController@edit')->name('voucher.edit');
            Route::patch('/{branch}/{product}/{dated_start}/{dated_end}/{voucher_code}/update', 'VoucherController@update')->name('voucher.update');
            Route::delete('/{branch}/{product}/{dated_start}/{dated_end}/{voucher_code}/delete', 'VoucherController@destroy')->name('voucher.destroy');
            Route::get('/export', 'VoucherController@export')->name('voucher.export');
        });

        /**
         * Product Distribution
         */
        Route::group(['prefix' => 'productsdistribution'], function() {
            Route::get('/', 'ProductsDistributionController@index')->name('productsdistribution.index');
            Route::get('/create', 'ProductsDistributionController@create')->name('productsdistribution.create');
            Route::post('/create', 'ProductsDistributionController@store')->name('productsdistribution.store');
            Route::get('/search', 'ProductsDistributionController@search')->name('productsdistribution.search');
            Route::get('/{branch}/{product}/show', 'ProductsDistributionController@show')->name('productsdistribution.show');
            Route::get('/{branch}/{product}/edit', 'ProductsDistributionController@edit')->name('productsdistribution.edit');
            Route::patch('/{branch}/{product}/update', 'ProductsDistributionController@update')->name('productsdistribution.update');
            Route::delete('/{branch}/{product}/delete', 'ProductsDistributionController@destroy')->name('productsdistribution.destroy');
            Route::get('/export', 'ProductsDistributionController@export')->name('productsdistribution.export');
        });

        /**
         * Product Commisions
         */
        Route::group(['prefix' => 'productscommision'], function() {
            Route::get('/', 'ProductsCommisionController@index')->name('productscommision.index');
            Route::get('/create', 'ProductsCommisionController@create')->name('productscommision.create');
            Route::post('/create', 'ProductsCommisionController@store')->name('productscommision.store');
            Route::get('/search', 'ProductsCommisionController@search')->name('productscommision.search');
            Route::get('/{branch}/{product}/show', 'ProductsCommisionController@show')->name('productscommision.show');
            Route::get('/{branch}/{product}/edit', 'ProductsCommisionController@edit')->name('productscommision.edit');
            Route::patch('/{branch}/{product}/update', 'ProductsCommisionController@update')->name('productscommision.update');
            Route::delete('/{branch}/{product}/delete', 'ProductsCommisionController@destroy')->name('productscommision.destroy');
            Route::get('/export', 'ProductsCommisionController@export')->name('productscommision.export');
        });

        /**
         * Product Commisions By Year
         */
        Route::group(['prefix' => 'productscommisionbyyear'], function() {
            Route::get('/', 'ProductsCommisionByYearController@index')->name('productscommisionbyyear.index');
            Route::get('/create', 'ProductsCommisionByYearController@create')->name('productscommisionbyyear.create');
            Route::post('/create', 'ProductsCommisionByYearController@store')->name('productscommisionbyyear.store');
            Route::get('/search', 'ProductsCommisionByYearController@search')->name('productscommisionbyyear.search');
            Route::get('/{branch}/{product}/show', 'ProductsCommisionByYearController@show')->name('productscommisionbyyear.show');
            Route::get('/{branch}/{product}/edit', 'ProductsCommisionByYearController@edit')->name('productscommisionbyyear.edit');
            Route::patch('/{branch}/{product}/update', 'ProductsCommisionByYearController@update')->name('productscommisionbyyear.update');
            Route::delete('/{branch}/{product}/delete', 'ProductsCommisionByYearController@destroy')->name('productscommisionbyyear.destroy');
            Route::get('/export', 'ProductsCommisionByYearController@export')->name('productscommisionbyyear.export');
        });



        /**
         * Product Point
         */
        Route::group(['prefix' => 'productspoint'], function() {
            Route::get('/', 'ProductsPointController@index')->name('productspoint.index');
            Route::get('/create', 'ProductsPointController@create')->name('productspoint.create');
            Route::post('/create', 'ProductsPointController@store')->name('productspoint.store');
            Route::get('/search', 'ProductsPointController@search')->name('productspoint.search');
            Route::get('/{branch}/{product}/show', 'ProductsPointController@show')->name('productspoint.show');
            Route::get('/{branch}/{product}/edit', 'ProductsPointController@edit')->name('productspoint.edit');
            Route::patch('/{branch}/{product}/update', 'ProductsPointController@update')->name('productspoint.update');
            Route::delete('/{branch}/{product}/delete', 'ProductsPointController@destroy')->name('productspoint.destroy');
            Route::get('/export', 'ProductsPointController@export')->name('productspoint.export');
        });


        /**
         * Product Stock
         */
        Route::group(['prefix' => 'productsstock'], function() {
            Route::get('/', 'ProductsStockController@index')->name('productsstock.index');
            Route::get('/create', 'ProductsStockController@create')->name('productsstock.create');
            Route::post('/create', 'ProductsStockController@store')->name('productsstock.store');
            Route::get('/search', 'ProductsStockController@search')->name('productsstock.search');
            Route::get('/{branch}/{product}/show', 'ProductsStockController@show')->name('productsstock.show');
            Route::get('/{branch}/{product}/edit', 'ProductsStockController@edit')->name('productsstock.edit');
            Route::patch('/{branch}/{product}/update', 'ProductsStockController@update')->name('productsstock.update');
            Route::delete('/{branch}/{product}/delete', 'ProductsStockController@destroy')->name('productsstock.destroy');
            Route::get('/export', 'ProductsStockController@export')->name('productsstock.export');
        });


        /**
         *  Posts Routes
         */
        Route::group(['prefix' => 'posts'], function() {
            Route::get('/', 'PostsController@index')->name('posts.index');
            Route::get('/create', 'PostsController@create')->name('posts.create');
            Route::post('/create', 'PostsController@store')->name('posts.store');
            Route::get('/{post}/show', 'PostsController@show')->name('posts.show');
            Route::get('/{post}/edit', 'PostsController@edit')->name('posts.edit');
            Route::patch('/{post}/update', 'PostsController@update')->name('posts.update');
            Route::delete('/{post}/delete', 'PostsController@destroy')->name('posts.destroy');
        });

        /**
         *  Branch
         */
        Route::group(['prefix' => 'branchs'], function() {
            Route::get('/', 'BranchsController@index')->name('branchs.index');
            Route::get('/create', 'BranchsController@create')->name('branchs.create');
            Route::post('/create', 'BranchsController@store')->name('branchs.store');
            Route::get('/{branch}/show', 'BranchsController@show')->name('branchs.show');
            Route::get('/{branch}/edit', 'BranchsController@edit')->name('branchs.edit');
            Route::patch('/{branch}/update', 'BranchsController@update')->name('branchs.update');
            Route::delete('/{branch}/delete', 'BranchsController@destroy')->name('branchs.destroy');
            Route::get('/export', 'BranchsController@export')->name('branchs.export');
            Route::get('/search', 'BranchsController@search')->name('branchs.search');
        });

        /**
         *  Company
         */
        Route::group(['prefix' => 'company'], function() {
            Route::get('/', 'CompanyController@index')->name('company.index');
            Route::get('/{company}/edit', 'CompanyController@edit')->name('company.edit');
            Route::patch('/{company}/update', 'CompanyController@update')->name('company.update');
        });

        /**
         *  Departement
         */
        Route::group(['prefix' => 'departments'], function() {
            Route::get('/', 'DepartmentsController@index')->name('departments.index');
            Route::get('/create', 'DepartmentsController@create')->name('departments.create');
            Route::post('/create', 'DepartmentsController@store')->name('departments.store');
            Route::get('/{department}/show', 'DepartmentsController@show')->name('departments.show');
            Route::get('/{department}/edit', 'DepartmentsController@edit')->name('departments.edit');
            Route::patch('/{department}/update', 'DepartmentsController@update')->name('departments.update');
            Route::delete('/{department}/delete', 'DepartmentsController@destroy')->name('departments.destroy');
        });

        /**
         *  Room
         */
        Route::group(['prefix' => 'rooms'], function() {
            Route::get('/', 'BranchRoomsController@index')->name('rooms.index');
            Route::get('/create', 'BranchRoomsController@create')->name('rooms.create');
            Route::post('/create', 'BranchRoomsController@store')->name('rooms.store');
            Route::get('/{room}/show', 'BranchRoomsController@show')->name('rooms.show');
            Route::get('/{room}/edit', 'BranchRoomsController@edit')->name('rooms.edit');
            Route::patch('/{room}/update', 'BranchRoomsController@update')->name('rooms.update');
            Route::delete('/{room}/delete', 'BranchRoomsController@destroy')->name('rooms.destroy');
            Route::get('/export', 'BranchRoomsController@export')->name('rooms.export');
            Route::get('/search', 'BranchRoomsController@search')->name('rooms.search');
        });


        /**
         *  UOM
         */
        Route::group(['prefix' => 'uoms'], function() {
            Route::get('/', 'UomController@index')->name('uoms.index');
            Route::get('/create', 'UomController@create')->name('uoms.create');
            Route::post('/create', 'UomController@store')->name('uoms.store');
            Route::get('/{uom}/show', 'UomController@show')->name('uoms.show');
            Route::get('/{uom}/edit', 'UomController@edit')->name('uoms.edit');
            Route::patch('/{uom}/update', 'UomController@update')->name('uoms.update');
            Route::delete('/{uom}/delete', 'UomController@destroy')->name('uoms.destroy');
        });


        /**
         *  Category
         */
        Route::group(['prefix' => 'categories'], function() {
            Route::get('/', 'CategoriesController@index')->name('categories.index');
            Route::get('/create', 'CategoriesController@create')->name('categories.create');
            Route::post('/create', 'CategoriesController@store')->name('categories.store');
            Route::get('/{category}/show', 'CategoriesController@show')->name('categories.show');
            Route::get('/{category}/edit', 'CategoriesController@edit')->name('categories.edit');
            Route::patch('/{category}/update', 'CategoriesController@update')->name('categories.update');
            Route::delete('/{category}/delete', 'CategoriesController@destroy')->name('categories.destroy');
        });



        /**
         *  Type
         */
        Route::group(['prefix' => 'types'], function() {
            Route::get('/', 'TypeController@index')->name('types.index');
            Route::get('/create', 'TypeController@create')->name('types.create');
            Route::post('/create', 'TypeController@store')->name('types.store');
            Route::get('/{type}/show', 'TypeController@show')->name('types.show');
            Route::get('/{type}/edit', 'TypeController@edit')->name('types.edit');
            Route::patch('/{type}/update', 'TypeController@update')->name('types.update');
            Route::delete('/{type}/delete', 'TypeController@destroy')->name('types.destroy');
        });


        /**
         *  Customers
         */
        Route::group(['prefix' => 'customers'], function() {
            Route::get('/', 'CustomersController@index')->name('customers.index');
            Route::get('/create', 'CustomersController@create')->name('customers.create');
            Route::post('/create', 'CustomersController@store')->name('customers.store');
            Route::post('/createapi', 'CustomersController@storeapi')->name('customers.storeapi');
            Route::get('/{customer}/show', 'CustomersController@show')->name('customers.show');
            Route::get('/{customer}/edit', 'CustomersController@edit')->name('customers.edit');
            Route::patch('/{customer}/update', 'CustomersController@update')->name('customers.update');
            Route::delete('/{customer}/delete', 'CustomersController@destroy')->name('customers.destroy');
            Route::get('/search', 'CustomersController@search')->name('customers.search');
            Route::get('/export', 'CustomersController@export')->name('customers.export');
        });

        /**
         *  Shift
         */
        Route::group(['prefix' => 'shift'], function() {
            Route::get('/', 'ShiftController@index')->name('shift.index');
            Route::get('/create', 'ShiftController@create')->name('shift.create');
            Route::post('/create', 'ShiftController@store')->name('shift.store');
            Route::post('/createapi', 'ShiftController@storeapi')->name('shift.storeapi');
            Route::get('/{shift}/show', 'ShiftController@show')->name('shift.show');
            Route::get('/{shift}/edit', 'ShiftController@edit')->name('shift.edit');
            Route::patch('/{shift}/update', 'ShiftController@update')->name('shift.update');
            Route::delete('/{shift}/delete', 'ShiftController@destroy')->name('shift.destroy');
            Route::get('/search', 'ShiftController@search')->name('shift.search');
            Route::get('/export', 'ShiftController@export')->name('shift.export');
        });

        /**
         *  Users Shift
         */
        Route::group(['prefix' => 'usersshift'], function() {
            Route::get('/', 'UserShiftController@index')->name('usersshift.index');
            Route::get('/create', 'UserShiftController@create')->name('usersshift.create');
            Route::post('/create', 'UserShiftController@store')->name('usersshift.store');
            Route::post('/createapi', 'UserShiftController@storeapi')->name('usersshift.storeapi');
            Route::get('/{usersshift}/show', 'UserShiftController@show')->name('usersshift.show');
            Route::get('/{usersshift}/edit', 'UserShiftController@edit')->name('usersshift.edit');
            Route::patch('/{usersshift}/update', 'UserShiftController@update')->name('usersshift.update');
            Route::delete('/{usersshift}/delete', 'UserShiftController@destroy')->name('usersshift.destroy');
            Route::get('/search', 'UserShiftController@search')->name('usersshift.search');
            Route::get('/export', 'UserShiftController@export')->name('usersshift.export');
        });

        /**
         *  Supllier
         */
        Route::group(['prefix' => 'suppliers'], function() {
            Route::get('/', 'SuppliersController@index')->name('suppliers.index');
            Route::get('/create', 'SuppliersController@create')->name('suppliers.create');
            Route::post('/create', 'SuppliersController@store')->name('suppliers.store');
            Route::post('/createapi', 'SuppliersController@storeapi')->name('suppliers.storeapi');
            Route::get('/{supplier}/show', 'SuppliersController@show')->name('suppliers.show');
            Route::get('/{supplier}/edit', 'SuppliersController@edit')->name('suppliers.edit');
            Route::patch('/{supplier}/update', 'SuppliersController@update')->name('suppliers.update');
            Route::delete('/{supplier}/delete', 'SuppliersController@destroy')->name('suppliers.destroy');
            Route::get('/search', 'SuppliersController@search')->name('suppliers.search');
            Route::get('/export', 'SuppliersController@export')->name('suppliers.export');
        });


        /**
         *  Report
         */
        Route::group(['prefix' => 'reports'], function() {
            Route::get('/cashier', 'ReportCashierComController@index')->name('reports.cashier.index');
            Route::get('/search_cashier', 'ReportCashierComController@search')->name('reports.cashier.search');
            Route::get('/terapist', 'ReportTerapistComController@index')->name('reports.terapist.index');
            Route::get('/search_terapist', 'ReportTerapistComController@search')->name('reports.terapist.search');
            Route::get('/closeshift', 'ReportCloseShiftController@index')->name('reports.closeshift.index');
            Route::get('/closeshift_getdata', 'ReportCloseShiftController@getdata')->name('reports.closeshift.getdata');
        });


        Route::resource('roles', RolesController::class);
        Route::resource('permissions', PermissionsController::class);
    });
});