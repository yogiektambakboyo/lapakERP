<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\StockLotNumberController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});


Route::group(['prefix' => 'api_stocklot'], function() {
    //Route::get('/get_list', 'StockLotNumberController@api_get_list')->name('api_stocklot.get_list');
    //Route::post('/store', 'StockLotNumberController@api_store')->name('api_stocklot.store');
});

Route::get('api_lotnumber_get_list', [StockLotNumberController::class,'get_list']);
Route::post('api_lotnumber_store', [StockLotNumberController::class,'store_api']);