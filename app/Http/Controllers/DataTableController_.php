<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Input;
use Redirect;
use DataTables;
use App\User;

class DataTableController extends Controller
{    
    /**

     * Displays front end view

     *

     * @return \Illuminate\View\View

     */

    public function index()

    {

    	return view('datatables');

    }

    /**

     * Process ajax request.

     *

     * @return \Illuminate\Http\JsonResponse

     */

    public function getData()

    {

        return Datatables::of(User::query())->make(true);

    }
}