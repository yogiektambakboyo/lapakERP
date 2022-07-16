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
            Route::post('/create', 'OrdersController@store')->name('orders.store');
            Route::get('/search', 'OrdersController@search')->name('orders.search');
            Route::get('/{order}/show', 'OrdersController@show')->name('orders.show');
            Route::get('/{order}/edit', 'OrdersController@edit')->name('orders.edit');
            Route::get('/getproduct', 'OrdersController@getproduct')->name('orders.getproduct');
            Route::get('/gettimetable', 'OrdersController@gettimetable')->name('orders.gettimetable');
            Route::get('/{order}/getorder', 'OrdersController@getorder')->name('orders.getorder');
            Route::patch('/{order}/update', 'OrdersController@update')->name('orders.update');
            Route::delete('/{order}/delete', 'OrdersController@destroy')->name('orders.destroy');
            Route::get('/export', 'OrdersController@export')->name('orders.export');
        });


         /**
         * Product Routes
         */
        Route::group(['prefix' => 'products'], function() {
            Route::get('/', 'ProductsController@index')->name('products.index');
            Route::get('/create', 'ProductsController@create')->name('products.create');
            Route::post('/create', 'ProductsController@store')->name('products.store');
            Route::get('/search', 'ProductsController@search')->name('products.search');
            Route::get('/{product}/show', 'ProductsController@show')->name('products.show');
            Route::get('/{product}/edit', 'ProductsController@edit')->name('products.edit');
            Route::patch('/{product}/update', 'ProductsController@update')->name('products.update');
            Route::delete('/{product}/delete', 'ProductsController@destroy')->name('products.destroy');
            Route::get('/export', 'ProductsController@export')->name('products.export');
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
        });

        /**
         *  Customer
         */
        Route::group(['prefix' => 'customers'], function() {
            Route::get('/', 'CustomersController@index')->name('customers.index');
            Route::get('/create', 'CustomersController@create')->name('customers.create');
            Route::post('/create', 'CustomersController@store')->name('customers.store');
            Route::get('/{customer}/show', 'CustomersController@show')->name('customers.show');
            Route::get('/{customer}/edit', 'CustomersController@edit')->name('customers.edit');
            Route::patch('/{customer}/update', 'CustomersController@update')->name('customers.update');
            Route::delete('/{customer}/delete', 'CustomersController@destroy')->name('customers.destroy');
        });


        Route::resource('roles', RolesController::class);
        Route::resource('permissions', PermissionsController::class);
    });
});