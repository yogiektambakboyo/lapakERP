<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//skucode,storecode,skuname,price,qty,img
	$status="0";
	$user=$_POST["usercode"];
	$targets=$_POST["target"];
	$store=$_POST["storecode"];
	$tipes=$_POST["tipes"];
	$codes=$_POST["codes"];
	$produks=$_POST["produks"];
	$hargas=$_POST["harga"];
	$mtrplns=$_POST["mtrpln"];
	$trxids="0";
	$tagihan_ids="0";
	$notes="0";
	$tokenss="0";
	$statuss="0";
	$saldo_before_trxs="0";
	$saldo_after_trxs="0";
	
	$isvalid="0";
	
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$status="0";
		}else{
			$query = " select case when nominal_didi>=:hargas AND nominal_user>=:hargas2  then '1' else '0' end as isvalid from (
							select sum(nominal_didi) nominal_didi,sum(nominal_user) nominal_user from (
							select 0 as nominal_didi,nominal as nominal_user from x_deposit where usercode=:usercode
							union 
							select nominal as nominal_didi,0 as nominal_user from x_deposit where usercode=0
							) a
						) b ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);	
			$stmt->bindParam(':hargas', $hargas, PDO::PARAM_STR,50);	
			$stmt->bindParam(':hargas2', $hargas, PDO::PARAM_STR,50);	
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
				$isvalid = $row["isvalid"];
			}
			
			if(intval($isvalid)>0){
				$url = 'https://tripay.co.id/api/v2/transaksi/pembelian';

				$header = array(
				   'Accept: application/json',
				   'Authorization: Bearer 2adc865d8ff7820421dc86463635cf10aad9db1db95d4b112071fbd775eb', // Ganti [apikey] dengan API KEY Anda
				);
				
				if($tipes=="10"||$tipes==10){
					$data = array( 
						'inquiry' => 'PLN', // konstan I OR PLN
						'code' => $codes, // kode produk
						'phone' => $targets, // nohp pembeli
						'no_meter_pln' => $mtrplns, // khusus untuk pembelian token PLN prabayar
						'pin' => '5501', // pin member
					);
				}else{
					$data = array( 
						'inquiry' => 'I', // konstan I OR PLN
						'code' => $codes, // kode produk
						'phone' => $targets, // nohp pembeli
						'no_meter_pln' => '', // khusus untuk pembelian token PLN prabayar
						'pin' => '5501', // pin member
					);
				}

				

				$ch = curl_init();
				curl_setopt($ch, CURLOPT_URL, $url);
				curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
				curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
				curl_setopt($ch, CURLOPT_HTTPHEADER, $header);
				curl_setopt($ch, CURLOPT_POST, 1);
				curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
				$result = curl_exec($ch);

				if(curl_errno($ch)){
				   return 'Request Error:' . curl_error($ch);
				}
				
				$someResult = '['.$result.']';
				$someArray = json_decode($someResult, true);
				
				$success = false;
				$trxid = "-";
				
				foreach ($someArray as $key => $row) {
					$success = $row["success"];
					$trxid = $row["trxid"];
					$message = $row["success"].' - '.$row["message"];
				}
				
				$query = " INSERT INTO public.x_log_order_ppob(orderid, description) VALUES (:trxid, :message) ";
				$stmt = $dbh->prepare($query);
				$stmt->bindParam(':trxid', $trxid, PDO::PARAM_STR,50);	
				$stmt->bindParam(':message', $message, PDO::PARAM_STR,50);		
				$stmt->execute();	
				
				if(($success)||$success=="true"){
					$query = " SELECT public.insertorder_ppob(
						:tipes, 
						:storecodes, 
						:usercodes, 
						:codes, 
						:produks, 
						:targets, 
						:mtrplns, 
						:trxids, 
						:tagihan_ids, 
						:hargas, 
						:notes, 
						:tokenss, 
						:statuss, 
						:saldo_before_trxs, 
						:saldo_after_trxs
					) as status ";
					$stmt = $dbh->prepare($query);
					$stmt->bindParam(':usercodes', $user, PDO::PARAM_STR,50);	
					$stmt->bindParam(':storecodes', $store, PDO::PARAM_STR,50);	
					$stmt->bindParam(':tipes', $tipes, PDO::PARAM_STR,50);	
					$stmt->bindParam(':codes', $codes, PDO::PARAM_STR,50);	
					$stmt->bindParam(':targets', $targets, PDO::PARAM_STR,50);	
					$stmt->bindParam(':produks', $produks, PDO::PARAM_STR,50);	
					$stmt->bindParam(':trxids', $trxid, PDO::PARAM_STR,50);	
					$stmt->bindParam(':hargas', $hargas, PDO::PARAM_STR,50);	
					$stmt->bindParam(':notes', $notes, PDO::PARAM_STR,50);		
					$stmt->bindParam(':mtrplns', $mtrplns, PDO::PARAM_STR,50);	
					$stmt->bindParam(':tagihan_ids', $tagihan_ids, PDO::PARAM_STR,50);	
					$stmt->bindParam(':tokenss', $tokenss, PDO::PARAM_STR,50);	
					$stmt->bindParam(':statuss', $statuss, PDO::PARAM_STR,50);	
					$stmt->bindParam(':saldo_before_trxs', $saldo_before_trxs, PDO::PARAM_STR,50);	
					$stmt->bindParam(':saldo_after_trxs', $saldo_after_trxs, PDO::PARAM_STR,50);	
					$stmt->execute();			
					while ($row = $stmt->fetch()) {
						$status = $row["status"];
					}
				}else{
					$status = "Server PPOB Respon Failed - ".$message;
				}	
			}else{
				$status = "Deposit anda tidak cukup untuk melakukan transaksi ini";
			}
			
			
		}
	}
	catch(PDOException $e)
	{
		echo $status;
	}
	echo $status;
//}
?>