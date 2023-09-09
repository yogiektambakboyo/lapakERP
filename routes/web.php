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
                        $actionBtn = '<a href="javascript:void(0)" class="edit btn btn-success btn-sm">Edit</a> <a href="javascript:void(0)" class="delete btn btn-danger btn-sm">@lang('general.lbl_delete')</a>';
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
            Route::get('/{user}/editpassword', 'UsersController@editpassword')->name('users.editpassword');
            Route::patch('/{user}/update', 'UsersController@update')->name('users.update');
            Route::post('/{user}/updatepassword', 'UsersController@updatepassword')->name('users.updatepassword');
            Route::delete('/{user}/delete', 'UsersController@destroy')->name('users.destroy');
            Route::get('/export', 'UsersController@export')->name('users.export');
            Route::get('/{netizen_id}/checknetizen', 'UsersController@checknetizen')->name('users.checknetizen');
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
            Route::get('/{order}/printthermal', 'OrdersController@printthermal')->name('orders.printthermal');
            Route::get('/getproduct', 'OrdersController@getproduct')->name('orders.getproduct');
            Route::get('/getproduct_nostock', 'OrdersController@getproduct_nostock')->name('orders.getproduct_nostock');
            Route::get('/gettimetable', 'OrdersController@gettimetable')->name('orders.gettimetable');
            Route::get('/{order}/getorder', 'OrdersController@getorder')->name('orders.getorder');
            Route::patch('/{order}/update', 'OrdersController@update')->name('orders.update');
            Route::delete('/{order}/delete', 'OrdersController@destroy')->name('orders.destroy');
            Route::get('/export', 'OrdersController@export')->name('orders.export');
            Route::get('/{order}/grid', 'OrdersController@grid')->name('orders.grid');
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
            Route::patch('/{invoice}/checkout', 'InvoicesController@checkout')->name('invoices.checkout');
            Route::get('/{invoice}/edit', 'InvoicesController@edit')->name('invoices.edit');
            Route::get('/{invoice}/print', 'InvoicesController@print')->name('invoices.print');
            Route::get('/{invoice}/printsj', 'InvoicesController@printsj')->name('invoices.printsj');
            Route::get('/{invoice}/printspk', 'InvoicesController@printspk')->name('invoices.printspk');
            Route::get('/{invoice}/printthermal', 'InvoicesController@printthermal')->name('invoices.printthermal');
            Route::get('/getproduct', 'InvoicesController@getproduct')->name('invoices.getproduct');
            Route::get('/gettimetable', 'InvoicesController@gettimetable')->name('invoices.gettimetable');
            Route::post('/getfreeterapist', 'InvoicesController@getfreeterapist')->name('invoices.getfreeterapist');
            Route::get('/gettimetable_room', 'InvoicesController@gettimetable_room')->name('invoices.gettimetable_room');
            Route::get('/getterapisttable', 'InvoicesController@getterapisttable')->name('invoices.getterapisttable');
            Route::get('/{invoice}/getinvoice', 'InvoicesController@getinvoice')->name('invoices.getinvoice');
            Route::patch('/{invoice}/update', 'InvoicesController@update')->name('invoices.update');
            Route::delete('/{invoice}/delete', 'InvoicesController@destroy')->name('invoices.destroy');
            Route::get('/export', 'InvoicesController@export')->name('invoices.export');
        });

        /**
         * Invoice Internal Routes
         */
        Route::group(['prefix' => 'invoicesinternal'], function() {
            Route::get('/', 'InvoicesInternalController@index')->name('invoicesinternal.index');
            Route::get('/create', 'InvoicesInternalController@create')->name('invoicesinternal.create');
            Route::post('/create', 'InvoicesInternalController@store')->name('invoicesinternal.store');
            Route::get('/search', 'InvoicesInternalController@search')->name('invoicesinternal.search');
            Route::get('/{invoice}/show', 'InvoicesInternalController@show')->name('invoicesinternal.show');
            Route::patch('/{invoice}/checkout', 'InvoicesInternalController@checkout')->name('invoicesinternal.checkout');
            Route::get('/{invoice}/edit', 'InvoicesInternalController@edit')->name('invoicesinternal.edit');
            Route::get('/{invoice}/print', 'InvoicesInternalController@print')->name('invoicesinternal.print');
            Route::get('/{invoice}/printsj', 'InvoicesInternalController@printsj')->name('invoicesinternal.printsj');
            Route::get('/{invoice}/printspk', 'InvoicesInternalController@printspk')->name('invoicesinternal.printspk');
            Route::get('/{invoice}/printthermal', 'InvoicesInternalController@printthermal')->name('invoicesinternal.printthermal');
            Route::get('/getproduct', 'InvoicesInternalController@getproduct')->name('invoicesinternal.getproduct');
            Route::get('/gettimetable', 'InvoicesInternalController@gettimetable')->name('invoicesinternal.gettimetable');
            Route::get('/{invoice}/getinvoice', 'InvoicesInternalController@getinvoice')->name('invoicesinternal.getinvoice');
            Route::patch('/{invoice}/update', 'InvoicesInternalController@update')->name('invoicesinternal.update');
            Route::delete('/{invoice}/delete', 'InvoicesInternalController@destroy')->name('invoicesinternal.destroy');
            Route::get('/export', 'InvoicesInternalController@export')->name('invoicesinternal.export');
        });

        /**
         * Picking Routes
         */
        Route::group(['prefix' => 'picking'], function() {
            Route::get('/', 'PickingController@index')->name('picking.index');
            Route::get('/create', 'PickingController@create')->name('picking.create');
            Route::post('/create', 'PickingController@store')->name('picking.store');
            Route::get('/search', 'PickingController@search')->name('picking.search');
            Route::get('/{picking}/show', 'PickingController@show')->name('picking.show');
            Route::patch('/{picking}/checkout', 'PickingController@checkout')->name('picking.checkout');
            Route::get('/{picking}/edit', 'PickingController@edit')->name('picking.edit');
            Route::get('/{picking}/print', 'PickingController@print')->name('picking.print');
            Route::get('/getproduct', 'PickingController@getproduct')->name('picking.getproduct');
            Route::get('/gettimetable', 'PickingController@gettimetable')->name('picking.gettimetable');
            Route::get('/{picking}/getdoc_data', 'PickingController@getdoc_data')->name('picking.getdoc_data');
            Route::patch('/{picking}/update', 'PickingController@update')->name('picking.update');
            Route::delete('/{picking}/delete', 'PickingController@destroy')->name('picking.destroy');
            Route::get('/export', 'PickingController@export')->name('picking.export');
            Route::get('/{doc_no}/getdocdatapicked', 'PickingController@getdocdatapicked')->name('picking.getdocdatapicked');
            Route::get('/{branch_id}/getdocdatapickedlist', 'PickingController@getdocdatapickedlist')->name('picking.getdocdatapickedlist');

        });


        /**
         * Packing Routes
         */
        Route::group(['prefix' => 'packing'], function() {
            Route::get('/', 'PackingController@index')->name('packing.index');
            Route::get('/create', 'PackingController@create')->name('packing.create');
            Route::post('/create', 'PackingController@store')->name('packing.store');
            Route::get('/search', 'PackingController@search')->name('packing.search');
            Route::get('/{packing}/show', 'PackingController@show')->name('packing.show');
            Route::patch('/{packing}/checkout', 'PackingController@checkout')->name('packing.checkout');
            Route::get('/{packing}/edit', 'PackingController@edit')->name('packing.edit');
            Route::get('/{packing}/print', 'PackingController@print')->name('packing.print');
            Route::get('/getproduct', 'PackingController@getproduct')->name('packing.getproduct');
            Route::get('/gettimetable', 'PackingController@gettimetable')->name('packing.gettimetable');
            Route::get('/{packing}/getdoc_data', 'PackingController@getdoc_data')->name('packing.getdoc_data');
            Route::patch('/{packing}/update', 'PackingController@update')->name('packing.update');
            Route::delete('/{packing}/delete', 'PackingController@destroy')->name('packing.destroy');
            Route::get('/export', 'PackingController@export')->name('packing.export');
            Route::get('/{doc_no}/getdocdatapacked', 'PackingController@getdocdatapacked')->name('packing.getdocdatapacked');
            Route::get('/{branch_id}/getdocdatapackedlist', 'PackingController@getdocdatapackedlist')->name('packing.getdocdatapackedlist');
        });

         /**
         * Shipment Routes
         */
        Route::group(['prefix' => 'shipment'], function() {
            Route::get('/', 'ShipmentController@index')->name('shipment.index');
            Route::get('/create', 'ShipmentController@create')->name('shipment.create');
            Route::post('/create', 'ShipmentController@store')->name('shipment.store');
            Route::get('/search', 'ShipmentController@search')->name('shipment.search');
            Route::get('/{shipment}/show', 'ShipmentController@show')->name('shipment.show');
            Route::patch('/{shipment}/checkout', 'ShipmentController@checkout')->name('shipment.checkout');
            Route::get('/{shipment}/edit', 'ShipmentController@edit')->name('shipment.edit');
            Route::get('/{shipment}/print', 'ShipmentController@print')->name('shipment.print');
            Route::get('/getproduct', 'ShipmentController@getproduct')->name('shipment.getproduct');
            Route::get('/gettimetable', 'ShipmentController@gettimetable')->name('shipment.gettimetable');
            Route::get('/{shipment}/getdoc_data', 'ShipmentController@getdoc_data')->name('shipment.getdoc_data');
            Route::patch('/{shipment}/update', 'ShipmentController@update')->name('shipment.update');
            Route::delete('/{shipment}/delete', 'ShipmentController@destroy')->name('shipment.destroy');
            Route::get('/export', 'ShipmentController@export')->name('shipment.export');
        });


        /**
         * Return Sell Routes
         */
        Route::group(['prefix' => 'returnsell'], function() {
            Route::get('/', 'ReturnSellController@index')->name('returnsell.index');
            Route::get('/create', 'ReturnSellController@create')->name('returnsell.create');
            Route::post('/create', 'ReturnSellController@store')->name('returnsell.store');
            Route::get('/search', 'ReturnSellController@search')->name('returnsell.search');
            Route::get('/{returnsell}/show', 'ReturnSellController@show')->name('returnsell.show');
            Route::get('/{returnsell}/edit', 'ReturnSellController@edit')->name('returnsell.edit');
            Route::get('/{returnsell}/print', 'ReturnSellController@print')->name('returnsell.print');
            Route::get('/{returnsell}/printthermal', 'ReturnSellController@printthermal')->name('returnsell.printthermal');
            Route::get('/getproduct', 'ReturnSellController@getproduct')->name('returnsell.getproduct');
            Route::get('/getproducts', 'ReturnSellController@getproducts')->name('returnsell.getproducts');
            Route::get('/gettimetable', 'ReturnSellController@gettimetable')->name('returnsell.gettimetable');
            Route::get('/{returnsell}/getinvoice', 'ReturnSellController@getinvoice')->name('returnsell.getinvoice');
            Route::patch('/{returnsell}/update', 'ReturnSellController@update')->name('returnsell.update');
            Route::delete('/{returnsell}/delete', 'ReturnSellController@destroy')->name('returnsell.destroy');
            Route::get('/export', 'ReturnSellController@export')->name('returnsell.export');
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

        Route::group(['prefix' => 'purchaseordersinternal'], function() {
            Route::get('/', 'PurchaseOrderInternalController@index')->name('purchaseordersinternal.index');
            Route::get('/create', 'PurchaseOrderInternalController@create')->name('purchaseordersinternal.create');
            Route::post('/create', 'PurchaseOrderInternalController@store')->name('purchaseordersinternal.store');
            Route::post('/search', 'PurchaseOrderInternalController@search')->name('purchaseordersinternal.search');
            Route::get('/{purchase}/show', 'PurchaseOrderInternalController@show')->name('purchaseordersinternal.show');
            Route::get('/{purchase}/print', 'PurchaseOrderInternalController@print')->name('purchaseordersinternal.print');
            Route::get('/{purchase}/edit', 'PurchaseOrderInternalController@edit')->name('purchaseordersinternal.edit');
            Route::get('/getproduct', 'PurchaseOrderInternalController@getproduct')->name('purchaseordersinternal.getproduct');
            Route::get('/gettimetable', 'PurchaseOrderInternalController@gettimetable')->name('purchaseordersinternal.gettimetable');
            Route::get('/{purchase}/getorder', 'PurchaseOrderInternalController@getorder')->name('purchaseordersinternal.getorder');
            Route::patch('/{purchase}/update', 'PurchaseOrderInternalController@update')->name('purchaseordersinternal.update');
            Route::patch('/{purchase}/updatestatus', 'PurchaseOrderInternalController@updatestatus')->name('purchaseordersinternal.updatestatus');
            Route::get('/{purchase}/getdocdata', 'PurchaseOrderInternalController@getdocdata')->name('purchaseordersinternal.getdocdata');
            Route::get('/{branch_id}/getdocdatabyvendor', 'PurchaseOrderInternalController@getdocdatabyvendor')->name('purchaseordersinternal.getdocdatabyvendor');
            Route::get('/{branch_id}/getdocdatanotpicked', 'PurchaseOrderInternalController@getdocdatanotpicked')->name('purchaseordersinternal.getdocdatanotpicked');
            Route::get('/{branch_id}/getdocdatapicked', 'PurchaseOrderInternalController@getdocdatapicked')->name('purchaseordersinternal.getdocdatapicked');
            Route::delete('/{purchase}/delete', 'PurchaseOrderInternalController@destroy')->name('purchaseordersinternal.destroy');
            Route::get('/export', 'PurchaseOrderInternalController@export')->name('purchaseordersinternal.export');
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
         * Service Routes
         */
        Route::group(['prefix' => 'services'], function() {
            Route::get('/', 'ServicesController@index')->name('services.index');
            Route::get('/create', 'ServicesController@create')->name('services.create');
            Route::post('/create', 'ServicesController@store')->name('services.store');
            Route::post('/createingredient', 'ServicesController@storeIngredients')->name('services.addingredients');
            Route::get('/search', 'ServicesController@search')->name('services.search');
            Route::get('/{product}/show', 'ServicesController@show')->name('services.show');
            Route::get('/{product}/edit', 'ServicesController@edit')->name('services.edit');
            Route::patch('/{product}/update', 'ServicesController@update')->name('services.update');
            Route::delete('/{product}/delete', 'ServicesController@destroy')->name('services.destroy');
            Route::get('/export', 'ServicesController@export')->name('services.export');
            Route::post('/deleteingredients', 'ServicesController@deleteIngredients')->name('services.deleteingredients');

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
         * Service Brand
         */
        Route::group(['prefix' => 'servicesbrand'], function() {
            Route::get('/', 'ServicesBrandController@index')->name('servicesbrand.index');
            Route::get('/create', 'ServicesBrandController@create')->name('servicesbrand.create');
            Route::post('/create', 'ServicesBrandController@store')->name('servicesbrand.store');
            Route::get('/search', 'ServicesBrandController@search')->name('servicesbrand.search');
            Route::get('/{productbrand}/show', 'ServicesBrandController@show')->name('servicesbrand.show');
            Route::get('/{productbrand}/edit', 'ServicesBrandController@edit')->name('servicesbrand.edit');
            Route::patch('/{productbrand}/update', 'ServicesBrandController@update')->name('servicesbrand.update');
            Route::delete('/{productbrand}/delete', 'ServicesBrandController@destroy')->name('servicesbrand.destroy');
            Route::get('/export', 'ServicesBrandController@export')->name('servicesbrand.export');
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
         * Petty Cash
         */
        Route::group(['prefix' => 'petty'], function() {
            Route::get('/', 'PettyController@index')->name('petty.index');
            Route::get('/create', 'PettyController@create')->name('petty.create');
            Route::post('/create', 'PettyController@store')->name('petty.store');
            Route::get('/search', 'PettyController@search')->name('petty.search');
            Route::get('/{petty}/show', 'PettyController@show')->name('petty.show');
            Route::patch('/{petty}/checkout', 'PettyController@checkout')->name('petty.checkout');
            Route::get('/{petty}/edit', 'PettyController@edit')->name('petty.edit');
            Route::get('/{petty}/print', 'PettyController@print')->name('petty.print');
            Route::get('/{petty}/printsj', 'PettyController@printsj')->name('petty.printsj');
            Route::get('/{petty}/printspk', 'PettyController@printspk')->name('petty.printspk');
            Route::get('/{petty}/printthermal', 'PettyController@printthermal')->name('petty.printthermal');
            Route::get('/getproduct', 'PettyController@getproduct')->name('petty.getproduct');
            Route::get('/gettimetable', 'PettyController@gettimetable')->name('petty.gettimetable');
            Route::get('/{petty}/getinvoice', 'PettyController@getinvoice')->name('petty.getinvoice');
            Route::patch('/{petty}/update', 'PettyController@update')->name('petty.update');
            Route::delete('/{petty}/delete', 'PettyController@destroy')->name('petty.destroy');
            Route::get('/export', 'PettyController@export')->name('petty.export');
        });

         /**
         * Petty Product Cash
         */
        Route::group(['prefix' => 'pettyproduct'], function() {
            Route::get('/', 'PettyProductController@index')->name('pettyproduct.index');
            Route::get('/create', 'PettyProductController@create')->name('pettyproduct.create');
            Route::post('/create', 'PettyProductController@store')->name('pettyproduct.store');
            Route::get('/search', 'PettyProductController@search')->name('pettyproduct.search');
            Route::get('/{petty}/show', 'PettyProductController@show')->name('pettyproduct.show');
            Route::patch('/{petty}/checkout', 'PettyProductController@checkout')->name('pettyproduct.checkout');
            Route::get('/{petty}/edit', 'PettyProductController@edit')->name('pettyproduct.edit');
            Route::get('/{petty}/print', 'PettyProductController@print')->name('pettyproduct.print');
            Route::get('/{petty}/printsj', 'PettyProductController@printsj')->name('pettyproduct.printsj');
            Route::get('/{petty}/printspk', 'PettyProductController@printspk')->name('pettyproduct.printspk');
            Route::get('/{petty}/printthermal', 'PettyProductController@printthermal')->name('pettyproduct.printthermal');
            Route::get('/getproduct', 'PettyProductController@getproduct')->name('pettyproduct.getproduct');
            Route::get('/gettimetable', 'PettyProductController@gettimetable')->name('pettyproduct.gettimetable');
            Route::get('/{petty}/getinvoice', 'PettyProductController@getinvoice')->name('pettyproduct.getinvoice');
            Route::patch('/{petty}/update', 'PettyProductController@update')->name('pettyproduct.update');
            Route::delete('/{petty}/delete', 'PettyProductController@destroy')->name('pettyproduct.destroy');
            Route::get('/export', 'PettyProductController@export')->name('pettyproduct.export');
        });

        /**
         * Service Price
         */
        Route::group(['prefix' => 'servicesprice'], function() {
            Route::get('/', 'ServicesPriceController@index')->name('servicesprice.index');
            Route::get('/create', 'ServicesPriceController@create')->name('servicesprice.create');
            Route::post('/create', 'ServicesPriceController@store')->name('servicesprice.store');
            Route::get('/search', 'ServicesPriceController@search')->name('servicesprice.search');
            Route::get('/{branch}/{product}/show', 'ServicesPriceController@show')->name('servicesprice.show');
            Route::get('/{branch}/{product}/edit', 'ServicesPriceController@edit')->name('servicesprice.edit');
            Route::patch('/{branch}/{product}/update', 'ServicesPriceController@update')->name('servicesprice.update');
            Route::delete('/{branch}/{product}/delete', 'ServicesPriceController@destroy')->name('servicesprice.destroy');
            Route::get('/export', 'ServicesPriceController@export')->name('servicesprice.export');
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
         * Product Service Adjustment
         */
        Route::group(['prefix' => 'servicespriceadj'], function() {
            Route::get('/', 'ServicesPriceAdjController@index')->name('servicespriceadj.index');
            Route::get('/create', 'ServicesPriceAdjController@create')->name('servicespriceadj.create');
            Route::post('/create', 'ServicesPriceAdjController@store')->name('servicespriceadj.store');
            Route::get('/search', 'ServicesPriceAdjController@search')->name('servicespriceadj.search');
            Route::get('/{branch}/{product}/show', 'ServicesPriceAdjController@show')->name('servicespriceadj.show');
            Route::get('/{branch}/{product}/edit', 'ServicesPriceAdjController@edit')->name('servicespriceadj.edit');
            Route::patch('/{branch}/{product}/{dated_start}/{dated_end}/update', 'ServicesPriceAdjController@update')->name('servicespriceadj.update');
            Route::delete('/{branch}/{product}/{dated_start}/{dated_end}/delete', 'ServicesPriceAdjController@destroy')->name('servicespriceadj.destroy');
            Route::get('/export', 'ServicesPriceAdjController@export')->name('servicespriceadj.export');
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

        Route::group(['prefix' => 'bufferstock'], function() {
            Route::get('/', 'BufferStockController@index')->name('bufferstock.index');
            Route::get('/create', 'BufferStockController@create')->name('bufferstock.create');
            Route::post('/create', 'BufferStockController@store')->name('bufferstock.store');
            Route::get('/search', 'BufferStockController@search')->name('bufferstock.search');
            Route::get('/{id}/show', 'BufferStockController@show')->name('bufferstock.show');
            Route::get('/{rec_id}/edit', 'BufferStockController@edit')->name('bufferstock.edit');
            Route::patch('/{id}/update', 'BufferStockController@update')->name('bufferstock.update');
            Route::delete('/{id}/delete', 'BufferStockController@destroy')->name('bufferstock.destroy');
            Route::get('/export', 'BufferStockController@export')->name('bufferstock.export');
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
         * Service Distribution
         */
        Route::group(['prefix' => 'servicesdistribution'], function() {
            Route::get('/', 'ServicesDistributionController@index')->name('servicesdistribution.index');
            Route::get('/create', 'ServicesDistributionController@create')->name('servicesdistribution.create');
            Route::post('/create', 'ServicesDistributionController@store')->name('servicesdistribution.store');
            Route::get('/search', 'ServicesDistributionController@search')->name('servicesdistribution.search');
            Route::get('/{branch}/{product}/show', 'ServicesDistributionController@show')->name('servicesdistribution.show');
            Route::get('/{branch}/{product}/edit', 'ServicesDistributionController@edit')->name('servicesdistribution.edit');
            Route::patch('/{branch}/{product}/update', 'ServicesDistributionController@update')->name('servicesdistribution.update');
            Route::delete('/{branch}/{product}/delete', 'ServicesDistributionController@destroy')->name('servicesdistribution.destroy');
            Route::get('/export', 'ServicesDistributionController@export')->name('servicesdistribution.export');
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
         * Service Commisions
         */
        Route::group(['prefix' => 'servicescommision'], function() {
            Route::get('/', 'ServicesCommisionController@index')->name('servicescommision.index');
            Route::get('/create', 'ServicesCommisionController@create')->name('servicescommision.create');
            Route::post('/create', 'ServicesCommisionController@store')->name('servicescommision.store');
            Route::get('/search', 'ServicesCommisionController@search')->name('servicescommision.search');
            Route::get('/{branch}/{product}/show', 'ServicesCommisionController@show')->name('servicescommision.show');
            Route::get('/{branch}/{product}/edit', 'ServicesCommisionController@edit')->name('servicescommision.edit');
            Route::patch('/{branch}/{product}/update', 'ServicesCommisionController@update')->name('servicescommision.update');
            Route::delete('/{branch}/{product}/delete', 'ServicesCommisionController@destroy')->name('servicescommision.destroy');
            Route::get('/export', 'ServicesCommisionController@export')->name('servicescommision.export');
        });

        /**
         * Product Commisions By Year
         */
        Route::group(['prefix' => 'productscommisionbyyear'], function() {
            Route::get('/', 'ProductsCommisionByYearController@index')->name('productscommisionbyyear.index');
            Route::get('/create', 'ProductsCommisionByYearController@create')->name('productscommisionbyyear.create');
            Route::post('/create', 'ProductsCommisionByYearController@store')->name('productscommisionbyyear.store');
            Route::get('/search', 'ProductsCommisionByYearController@search')->name('productscommisionbyyear.search');
            Route::get('/{branch}/{product}/{jobs_id}/show', 'ProductsCommisionByYearController@show')->name('productscommisionbyyear.show');
            Route::get('/{branch}/{product}/{jobs_id}/{years}/edit', 'ProductsCommisionByYearController@edit')->name('productscommisionbyyear.edit');
            Route::patch('/{branch}/{product}/{jobs_id}/{years}/update', 'ProductsCommisionByYearController@update')->name('productscommisionbyyear.update');
            Route::delete('/{branch}/{product}/{jobs_id}/{years}/delete', 'ProductsCommisionByYearController@destroy')->name('productscommisionbyyear.destroy');
            Route::get('/export', 'ProductsCommisionByYearController@export')->name('productscommisionbyyear.export');
        });

        /**
         * Service Commisions By Year
         */
        Route::group(['prefix' => 'servicescommisionbyyear'], function() {
            Route::get('/', 'ServicesCommisionByYearController@index')->name('servicescommisionbyyear.index');
            Route::get('/create', 'ServicesCommisionByYearController@create')->name('servicescommisionbyyear.create');
            Route::post('/create', 'ServicesCommisionByYearController@store')->name('servicescommisionbyyear.store');
            Route::get('/search', 'ServicesCommisionByYearController@search')->name('servicescommisionbyyear.search');
            Route::get('/{branch}/{product}/{jobs_id}/show', 'ServicesCommisionByYearController@show')->name('servicescommisionbyyear.show');
            Route::post('/show_year', 'ServicesCommisionByYearController@show_year')->name('servicescommisionbyyear.show_year');
            Route::get('/{branch}/{product}/{jobs_id}/{years}/edit', 'ServicesCommisionByYearController@edit')->name('servicescommisionbyyear.edit');
            Route::patch('/{branch}/{product}/{jobs_id}/{years}/update', 'ServicesCommisionByYearController@update')->name('servicescommisionbyyear.update');
            Route::delete('/{branch}/{product}/{jobs_id}/{years}/delete', 'ServicesCommisionByYearController@destroy')->name('servicescommisionbyyear.destroy');
            Route::get('/export', 'ServicesCommisionByYearController@export')->name('servicescommisionbyyear.export');
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
         * Product Point
         */
        Route::group(['prefix' => 'servicespoint'], function() {
            Route::get('/', 'ServicesPointController@index')->name('servicespoint.index');
            Route::get('/create', 'ServicesPointController@create')->name('servicespoint.create');
            Route::post('/create', 'ServicesPointController@store')->name('servicespoint.store');
            Route::get('/search', 'ServicesPointController@search')->name('servicespoint.search');
            Route::get('/{branch}/{product}/show', 'ServicesPointController@show')->name('servicespoint.show');
            Route::get('/{branch}/{product}/edit', 'ServicesPointController@edit')->name('servicespoint.edit');
            Route::patch('/{branch}/{product}/update', 'ServicesPointController@update')->name('servicespoint.update');
            Route::delete('/{branch}/{product}/delete', 'ServicesPointController@destroy')->name('servicespoint.destroy');
            Route::get('/export', 'ServicesPointController@export')->name('servicespoint.export');
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
            Route::get('/clone', 'BranchsController@clone')->name('branchs.clone');
            Route::post('/clone_store', 'BranchsController@clone_store')->name('branchs.clone_store');
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
         *  UOM Service
         */
        Route::group(['prefix' => 'uomservice'], function() {
            Route::get('/', 'UomServiceController@index')->name('uomservice.index');
            Route::get('/create', 'UomServiceController@create')->name('uomservice.create');
            Route::post('/create', 'UomServiceController@store')->name('uomservice.store');
            Route::get('/{uom}/show', 'UomServiceController@show')->name('uomservice.show');
            Route::get('/{uom}/edit', 'UomServiceController@edit')->name('uomservice.edit');
            Route::patch('/{uom}/update', 'UomServiceController@update')->name('uomservice.update');
            Route::delete('/{uom}/delete', 'UomServiceController@destroy')->name('uomservice.destroy');
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
         *  Category Service
         */
        Route::group(['prefix' => 'categoriesservice'], function() {
            Route::get('/', 'CategoriesServiceController@index')->name('categoriesservice.index');
            Route::get('/create', 'CategoriesServiceController@create')->name('categoriesservice.create');
            Route::post('/create', 'CategoriesServiceController@store')->name('categoriesservice.store');
            Route::get('/{category}/show', 'CategoriesServiceController@show')->name('categoriesservice.show');
            Route::get('/{category}/edit', 'CategoriesServiceController@edit')->name('categoriesservice.edit');
            Route::patch('/{category}/update', 'CategoriesServiceController@update')->name('categoriesservice.update');
            Route::delete('/{category}/delete', 'CategoriesServiceController@destroy')->name('categoriesservice.destroy');
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
         *  Customers
         */
        Route::group(['prefix' => 'sales'], function() {
            Route::get('/', 'SalesController@index')->name('sales.index');
            Route::get('/create', 'SalesController@create')->name('sales.create');
            Route::post('/create', 'SalesController@store')->name('sales.store');
            Route::post('/createapi', 'SalesController@storeapi')->name('sales.storeapi');
            Route::get('/{sales}/show', 'SalesController@show')->name('sales.show');
            Route::get('/{sales}/edit', 'SalesController@edit')->name('sales.edit');
            Route::patch('/{sales}/update', 'SalesController@update')->name('sales.update');
            Route::delete('/{sales}/delete', 'SalesController@destroy')->name('sales.destroy');
            Route::get('/search', 'SalesController@search')->name('sales.search');
            Route::get('/export', 'SalesController@export')->name('sales.export');
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
         *  Branch Shift
         */
        Route::group(['prefix' => 'branchshift'], function() {
            Route::get('/', 'BranchShiftController@index')->name('branchshift.index');
            Route::get('/create', 'BranchShiftController@create')->name('branchshift.create');
            Route::post('/create', 'BranchShiftController@store')->name('branchshift.store');
            Route::post('/createapi', 'BranchShiftController@storeapi')->name('branchshift.storeapi');
            Route::get('/{branchshift}/show', 'BranchShiftController@show')->name('branchshift.show');
            Route::get('/{branchshift}/edit', 'BranchShiftController@edit')->name('branchshift.edit');
            Route::patch('/{branchshift}/update', 'BranchShiftController@update')->name('branchshift.update');
            Route::delete('/{branchshift}/delete', 'BranchShiftController@destroy')->name('branchshift.destroy');
            Route::get('/search', 'BranchShiftController@search')->name('branchshift.search');
            Route::get('/export', 'BranchShiftController@export')->name('branchshift.export');
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
         *  Other
         */
        Route::group(['prefix' => 'other'], function() {
            Route::get('/notif', 'OtherController@notif')->name('other.notif');
            Route::post('/notifread', 'OtherController@notifread')->name('other.notifread');
            Route::get('/notifindex', 'OtherController@notifindex')->name('other.notifindex');
        });


        /**
         *  Report
         */
        Route::group(['prefix' => 'reports'], function() {
            Route::get('/cashier', 'ReportCashierComController@index')->name('reports.cashier.index');
            Route::get('/search_cashier', 'ReportCashierComController@search')->name('reports.cashier.search');
            Route::get('/sales_trip', 'ReportSalesTripController@index')->name('reports.sales_trip.index');
            Route::get('/search_sales_trip', 'ReportSalesTripController@search')->name('reports.sales_trip.search');
            Route::get('/sales_trip_detail', 'ReportSalesTripDetailController@index')->name('reports.sales_trip_detail.index');
            Route::get('/search_sales_trip_detail', 'ReportSalesTripDetailController@search')->name('reports.sales_trip_detail.search');
            Route::get('/customer_reg', 'ReportCustomerRegController@index')->name('reports.customer_reg.index');
            Route::get('/search_customer_reg', 'ReportCustomerRegController@search')->name('reports.customer_reg.search');
            Route::post('/approve_customer_reg', 'ReportCustomerRegController@approve')->name('reports.customer_reg.approve');
            Route::get('/terapist', 'ReportTerapistComController@index')->name('reports.terapist.index');
            Route::get('/search_terapist', 'ReportTerapistComController@search')->name('reports.terapist.search');
            Route::get('/terapistdaily', 'ReportTerapistComDailyController@index')->name('reports.terapistdaily.index');
            Route::get('/search_terapistdaily', 'ReportTerapistComDailyController@search')->name('reports.terapistdaily.search');
            Route::get('/closeshift', 'ReportCloseShiftController@index')->name('reports.closeshift.index');
            Route::get('/closeshift_getdata', 'ReportCloseShiftController@getdata')->name('reports.closeshift.getdata');
            Route::get('/closeshift_search', 'ReportCloseShiftController@search')->name('reports.closeshift.search');
            Route::get('/closeday', 'ReportCloseDayController@index')->name('reports.closeday.index');
            Route::get('/closeday_getdata', 'ReportCloseDayController@getdata')->name('reports.closeday.getdata');
            Route::get('/closeday_getdata_daily', 'ReportCloseDayController@getdata_daily')->name('reports.closeday.getdata_daily');
            Route::get('/closeday_search', 'ReportCloseDayController@search')->name('reports.closeday.search');
            Route::get('/invoice', 'ReportInvoiceController@index')->name('reports.invoice.index');
            Route::get('/invoice_search', 'ReportInvoiceController@search')->name('reports.invoice.search');
            Route::get('/invoicedetail', 'ReportInvoiceDetailController@index')->name('reports.invoicedetail.index');
            Route::get('/invoicedetail_search', 'ReportInvoiceDetailController@search')->name('reports.invoicedetail.search');
            Route::get('/purchase', 'ReportPurchaseController@index')->name('reports.purchase.index');
            Route::get('/purchase_search', 'ReportPurchaseController@search')->name('reports.purchase.search');
            Route::get('/receive', 'ReportReceiveController@index')->name('reports.receive.index');
            Route::get('/receive_search', 'ReportReceiveController@search')->name('reports.receive.search');
            Route::get('/stock', 'ReportStockController@index')->name('reports.stock.index');
            Route::get('/stock_search', 'ReportStockController@search')->name('reports.stock.search');
            Route::get('/stockmutation', 'ReportStockMutationController@index')->name('reports.stockmutation.index');
            Route::get('/stockmutation_search', 'ReportStockMutationController@search')->name('reports.stockmutation.search');
            Route::get('/stockmutationdetail', 'ReportStockMutationDetailController@index')->name('reports.stockmutationdetail.index');
            Route::get('/stockmutationdetail_search', 'ReportStockMutationDetailController@search')->name('reports.stockmutationdetail.search');
            Route::get('/customer', 'ReportCustomerController@index')->name('reports.customer.index');
            Route::get('/customer_search', 'ReportCustomerController@search')->name('reports.customer.search');
            Route::get('/referral', 'ReportReferralController@index')->name('reports.referral.index');
            Route::get('/referral_search', 'ReportReferralController@search')->name('reports.referral.search');
            Route::get('/usertracking', 'ReportUserTrackingController@index')->name('reports.usertracking.index');
            Route::get('/usertracking_search', 'ReportUserTrackingController@search')->name('reports.usertracking.search');
            Route::get('/omsetdetail', 'ReportOmsetDetailController@index')->name('reports.omsetdetail.index');
            Route::get('/omsetdetaildetail_search', 'ReportOmsetDetailController@search')->name('reports.omsetdetail.search');
            Route::get('/returnsell', 'ReportReturnSellController@index')->name('reports.returnsell.index');
            Route::get('/returnsell_search', 'ReportReturnSellController@search')->name('reports.returnsell.search');
            Route::get('/returnselldetail', 'ReportReturnSellDetailController@index')->name('reports.returnselldetail.index');
            Route::get('/returnselldetail_search', 'ReportReturnSellDetailController@search')->name('reports.returnselldetail.search');
        });


        Route::resource('roles', RolesController::class);
        Route::resource('permissions', PermissionsController::class);
    });
});