<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'DIDI_POS_Mobile'){
	//skucode,storecode,skuname,price,qty,img
	$status="0";
	$user=$_POST["usercode"];
	$targets=$_POST["target"];
	$store=$_POST["storecode"];
	$bank=$_POST["bank"];
	$nominal=$_POST["nominal"];
	
	$isvalid="0";
	$success=true;
	
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
			$stmt->bindParam(':hargas', $nominal, PDO::PARAM_STR,50);	
			$stmt->bindParam(':hargas2', $nominal, PDO::PARAM_STR,50);	
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
				$isvalid = $row["isvalid"];
			}
			
			
			
			if(intval($isvalid)>0){
				
				//$query = " INSERT INTO public.x_log_order_ppob(orderid, description) VALUES (:trxid, :message) ";
				//$stmt = $dbh->prepare($query);
				//$stmt->bindParam(':trxid', 'XX', PDO::PARAM_STR,50);	
				//$stmt->bindParam(':message', 'Transfer', PDO::PARAM_STR,50);		
				//$stmt->execute();	
				
				
				
				$query = " SELECT public.insertorder_ppob_transfer(
						'X', 
						'1', 
						'".$user."', 
						'".$bank."', 
						'X', 
						'".$targets."', 
						'X', 
						'X', 
						'X', 
						'".$nominal."', 
						'".$store."', 
						'X', 
						'1', 
						'0', 
						'0'
					) as status ";
					$stmt = $dbh->prepare($query);
					/**$stmt->bindParam(':usercodes', '1446', PDO::PARAM_STR,50);	
					$stmt->bindParam(':storecodes', '1', PDO::PARAM_STR,50);	 
					$stmt->bindParam(':tipes', 'X', PDO::PARAM_STR,50);	
					$stmt->bindParam(':codes', 'vvv', PDO::PARAM_STR,50);	
					$stmt->bindParam(':targets', '000', PDO::PARAM_STR,50);	
					$stmt->bindParam(':produks', 'X', PDO::PARAM_STR,50);	
					$stmt->bindParam(':trxids', 'X', PDO::PARAM_STR,50);	
					$stmt->bindParam(':hargas', '1000', PDO::PARAM_STR,50);	
					$stmt->bindParam(':notes', 'X', PDO::PARAM_STR,50);		
					$stmt->bindParam(':mtrplns', 'X', PDO::PARAM_STR,50);	
					$stmt->bindParam(':tagihan_ids', 'X', PDO::PARAM_STR,50);	
					$stmt->bindParam(':tokenss', 'XX', PDO::PARAM_STR,50);	
					$stmt->bindParam(':statuss', '1', PDO::PARAM_STR,50);	
					$stmt->bindParam(':saldo_before_trxs', '0', PDO::PARAM_STR,50);	
					$stmt->bindParam(':saldo_after_trxs', '0', PDO::PARAM_STR,50);	**/
					$stmt->execute();			
					while ($row = $stmt->fetch()) {
						$status = $row["status"];
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