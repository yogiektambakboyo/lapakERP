<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DataTables;
use App\User;
use Illuminate\Support\Facades\DB;
use Illuminate\Foundation\Auth\AuthenticatesUsers;

class TransactionTransferController extends Controller

{

	/**

     * Displays front end view

     *

     * @return \Illuminate\View\View

     */

    public function index()

    {
		$results = DB::select("  select m.id,m.name as title,m.parent,m.link_url as url,m.sequence,m.icon as icon,count(n.id) as countparent from users u 
		join user_permission p on p.user_id=u.id and p.active='1'
		join user_roles_permission r on r.user_roles_id=p.user_roles_id and r.active='1'
		join menu m on m.id=r.menu_id and m.active='1'
		left join menu n on n.parent=m.id and n.active='1'
		where u.id=:user_id group by m.id,m.name,m.parent,m.link_url,m.sequence,m.icon order by sequence  ", ["user_id" => \Auth::user()->id]);
		$data = $results;
		return view('transaction-transfer',["menu_data"=>$data]);
    }
	
	public function indexReport()

    {
		$results = DB::select("  select m.id,m.name as title,m.parent,m.link_url as url,m.sequence,m.icon as icon,count(n.id) as countparent from users u 
		join user_permission p on p.user_id=u.id and p.active='1'
		join user_roles_permission r on r.user_roles_id=p.user_roles_id and r.active='1'
		join menu m on m.id=r.menu_id and m.active='1'
		left join menu n on n.parent=m.id and n.active='1'
		where u.id=:user_id group by m.id,m.name,m.parent,m.link_url,m.sequence,m.icon order by sequence  ", ["user_id" => \Auth::user()->id]);
		$data = $results;
		return view('report-transfer',["menu_data"=>$data]);
    }
	
	    /**

     * Display a listing of the resource.

     *

     * @return \Illuminate\Http\Response

     */

    public function imageUploadPost(Request $request)
    {
        request()->validate([
            'image' => 'required|image|mimes:jpeg,png,jpg|max:2048',
        ]);

		$orderid = $request->input('orderid');
		
        $imageName = $orderid.'.'.request()->image->getClientOriginalExtension();
        request()->image->move(public_path('images'), $imageName);
        return back()
            ->with('success','You have successfully upload image.')
            ->with('image',$imageName);
    }

    /**

     * Process ajax request.

     *

     * @return \Illuminate\Http\JsonResponse

     */


	
	public function getData()
    {
		$results = DB::select(" select t.orderid,u.usercode,u.name,u.city,t.code||' : '||t.note as code,t.target,t.harga_beli,t.harga from x_order_ppob_transfer t
								join x_user u on u.usercode=t.usercode
								where t.status='0' ");
		return DataTables::collection($results)->toJson();		
        //return Datatables::of(User::query())->make(true);
    }
	
	
	public function getDataHistory()
    {
		$results = DB::select(" select t.orderid,u.usercode,u.name,u.city,t.code,t.target,t.harga_beli,t.harga,
								case when status='0' then 'Dalam Proses '||t.note
								when status='1' then 'Berhasil Di Transfer '||t.note
								else 'Di Tolak - '||t.note end as status
								from x_order_ppob_transfer t
								join x_user u on u.usercode=t.usercode ");
		return DataTables::collection($results)->toJson();		
        //return Datatables::of(User::query())->make(true);
    }
	
	public function approveDeposit(Request $request)
	{
		$id = $request->input('id');
		$command = $request->input('command');
		$nominal = $request->input('nominal');
		$harga = $request->input('harga');
		
		
			
		
		$message = "";
			
		if($command=="1"){
			$inserted = DB::update("update x_order_ppob_transfer set status=:command,updated_date=now(),note=note||' Sukses - Transfer Berhasil' where orderid=:id ",
			['id'=>$id,'command'=>$command]);
			
			$inserted = DB::update("insert into public.x_log_deposit(usercode,nominal,description)
			select usercode,harga_beli,'APPROVE TRANSFER ID '||orderid from x_order_ppob_transfer where orderid=:id ",
			['id'=>$id]);
			
			//$inserted = DB::update("update x_deposit set updated_date=now(),nominal=nominal-:nominal,
			//key_chain=encrypt(CAST((nominal-:nominal) as character varying)::bytea,CAST('xXDIDI123Xx' as bytea),CAST('aes' as text))::character varying
			// where usercode=(select usercode from x_order_ppob_transfer where orderid=:id) ",
			//['id'=>$id,'nominal'=>$harga]);
			
			//select convert_from(decrypt(key_chain::bytea,'xXDIDI123Xx','aes'),'SQL_ASCII') from x_deposit;
			
			$message = "Selamat permintaan transfer anda sebesar ".$nominal." dengan kode ID : ".$id." telah disetujui";
			
			
		}else{
			$inserted = DB::update("update x_order_ppob_transfer set status=:command,updated_date=now(),note=note||' - Transfer ditolak' where orderid=:id ",
			['id'=>$id,'command'=>$command]);
			$inserted = DB::update("insert into public.x_log_deposit(usercode,nominal,description)
			select usercode,harga_beli,'REJECT TRANSFER ID '||orderid from x_order_ppob_transfer where orderid=:id ",
			['id'=>$id]);
			
			$message = "Mohon maaf permintaan transfer anda sebesar ".$nominal." dengan kode ID : ".$id." belum bisa kami terima, untuk info lebih lanjut bisa menghubungi admin kami.";
		}
		
		$token = DB::table('x_order_ppob_transfer')
		->join('x_user','x_user.usercode','=','x_order_ppob_transfer.usercode')
		->where('x_order_ppob_transfer.orderid', $id)->value('x_user.fcm_token');
		
		$path_to_firebase_cm = 'https://fcm.googleapis.com/fcm/send';
		
		
        $fields = array(
            'registration_id' => $token,
            'priority' => 10,
            'notification' => array('title' => 'DIDI', 'body' =>  $message ,'sound'=>'Default','image'=>'Notification Image' ),
			'to'=> $token
        );
        $headers = array(
            'Authorization:key=AAAAwg1wzJI:APA91bGZEyKf_H4uh7L9-b3BkPu9lnh-6R6cP4YmlIEeQnDbtR36VBTklS70_lZ5upLcjFuEyQ2OfEp3xe7NOeomjjT1tq3RTOK9HJsuPMyyAD6IsKzkA7px6WEMe8d7Kvpt3kM0nSKI',
            'Content-Type:application/json'
        );  
         
        // Open connection  
        $ch = curl_init(); 
        // Set the url, number of POST vars, POST data
        curl_setopt($ch, CURLOPT_URL, $path_to_firebase_cm); 
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_IPRESOLVE, CURL_IPRESOLVE_V4 );
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($fields));
        // Execute post   
        $result = curl_exec($ch); 
		 if ($result === FALSE) {
			die('Oops! FCM Send Error: ' . curl_error($ch));
		   }
        // Close connection      
        curl_close($ch);
			

		return $request->all();
	}
	
							
	

}
