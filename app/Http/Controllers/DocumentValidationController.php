<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DataTables;
use App\User;
use Illuminate\Support\Facades\DB;

class DocumentValidationController extends Controller
{
    public function index($doc_num)
    {
		$results = DB::select("  select * from z_document where doc_num=:doc_num  ", ["doc_num" => $doc_num]);
		$data = $results;
		return DataTables::collection($results)->toJson();
    }
}
