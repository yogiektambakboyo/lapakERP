<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//skucode,storecode,skuname,price,qty,img
	$status="0";
	$fcm_token = "";
	$orderid=$_POST["orderid"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$status="0";
		}else{
			
			$query = " update x_order_master set isdelivered='1',isprint='1' where orderid=:orderid ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':orderid', $orderid, PDO::PARAM_STR,50);				
						
			if ($stmt->execute()) {
				$query = "select calc_poin(:orderid) as status ";
				$stmt = $dbh->prepare($query);
				$stmt->bindParam(':orderid', $orderid, PDO::PARAM_STR,50);		
				$stmt->execute();			
				while ($row = $stmt->fetch()) {
						$status = $row["status"];
				}

				$query = "select distinct u.fcm_token,u.name from x_order_master m join x_user u on u.usercode=m.usercode where m.orderid=:orderid ";
				$stmt = $dbh->prepare($query);
				$stmt->bindParam(':orderid', $orderid, PDO::PARAM_STR,50);		
				$stmt->execute();

				$name ="";
				while ($row = $stmt->fetch()) {
						$fcm_token = $row["fcm_token"];
						$name = $row["name"];
				}	
				
				$url = 'https://fcm.googleapis.com/fcm/send';
				$fields = array (
						'to' => $fcm_token,
						'notification' => array (
								"body" => "Hai ".$name.", Order anda dengan ID ".$orderid." sudah terkirim yuk segera kasih ulasan mengenai order anda dan dapatkan poin tambahan.",
								"title" => "DIDI Poin Notification",
								"icon" => "myicon"
						)
				);
				$fields = json_encode ($fields);
				$headers = array (
						'Authorization: key=' . "AAAAwg1wzJI:APA91bGZEyKf_H4uh7L9-b3BkPu9lnh-6R6cP4YmlIEeQnDbtR36VBTklS70_lZ5upLcjFuEyQ2OfEp3xe7NOeomjjT1tq3RTOK9HJsuPMyyAD6IsKzkA7px6WEMe8d7Kvpt3kM0nSKI",
						'Content-Type: application/json'
				);

				$ch = curl_init ();
				curl_setopt ( $ch, CURLOPT_URL, $url );
				curl_setopt ( $ch, CURLOPT_POST, true );
				curl_setopt ( $ch, CURLOPT_HTTPHEADER, $headers );
				curl_setopt ( $ch, CURLOPT_RETURNTRANSFER, true );
				curl_setopt ( $ch, CURLOPT_POSTFIELDS, $fields );

				$result = curl_exec ( $ch );
				curl_close ( $ch );	
				
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