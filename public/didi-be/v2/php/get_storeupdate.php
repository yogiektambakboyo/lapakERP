<?php
$method = $_SERVER['HTTP_USER_AGENT'];
$orderid=$_POST["orderid"];
$storecode=$_POST["storecode"];
$result="0";

set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			echo $result;
		}else{
			$query = " UPDATE x_order_master set isprint='1' where storecode=:storecode and orderid=:orderid  ";
				$stmt = $dbh->prepare($query);
				$stmt->bindParam(':orderid', $orderid, PDO::PARAM_STR,50);
				$stmt->bindParam(':storecode', $storecode, PDO::PARAM_STR,50);
				if($stmt->execute())
				{
					$result = "1";
					echo $result;
					
					$query = " insert into x_poin select usercode,0,now()::timestamp from x_user where usercode not in (select usercode from x_poin)  ";
					$stmt = $dbh->prepare($query);
					$stmt->execute();
					
					$query = " INSERT INTO public.x_log_order(orderid, description, created_date) VALUES (:orderid, 'Order Printed', now())  ";
					$stmt = $dbh->prepare($query);
					$stmt->bindParam(':orderid', $orderid, PDO::PARAM_STR,50);
					$stmt->execute();
					
					$query = " INSERT INTO public.x_log_order(orderid, description, created_date) select orderid,'Order Delivered by System',now() from x_order_master  where isprint='1' and dated>'2019-03-19' and storecode in (select storecode from  x_store_master where isneeddelivered='0') and isdelivered='0'  ";
					$stmt = $dbh->prepare($query);
					$stmt->execute();
					
					$query = " update x_order_master set isdelivered='1' where isprint='1' and dated>'2019-03-19' and storecode in (select storecode from  x_store_master where isneeddelivered='0') and isdelivered='0'  ";
					$stmt = $dbh->prepare($query);
					$stmt->execute();
					
					/**$query = " update x_poin set updated_date=now()::timestamp,poin=(select CAST((total-(total%value))/value*poin as INT) as poin from x_order_master x
								join x_poin_rule r on r.id=1
								where x.orderid=:orderid) where usercode=(select usercode from x_order_master where orderid=:orderid2)  ";
					$query = " update x_poin set updated_date=now()::timestamp,poin=10 where usercode=(select usercode from x_order_master where orderid=:orderid2)  ";
					$stmt = $dbh->prepare($query);
					$stmt->bindParam(':orderid', $orderid, PDO::PARAM_STR,50);
					$stmt->bindParam(':orderid2', $orderid, PDO::PARAM_STR,50);**/
					//$stmt->execute();
					
					/**$query = " INSERT INTO public.x_poin_history(
								 storecode, poin, description, created_date)
							select usercode,CAST((total-(total%value))/value*poin as INT) as poin,'Added Poin from Order ID '||x.orderid,now() 
							from x_order_master x
							join x_poin_rule r on r.id=1
							where x.orderid=:orderid  ";
					$query = " INSERT INTO public.x_poin_history(
								 storecode, poin, description, created_date)
							select usercode,10 as poin,'Added Poin from Order ID '||x.orderid,now() 
							from x_order_master x
							join x_poin_rule r on r.id=1
							where x.orderid=:orderid  ";
					$stmt = $dbh->prepare($query);
					$stmt->bindParam(':orderid', $orderid, PDO::PARAM_STR,50);
					//$stmt->execute();**/
					
					$query = "select calc_poin(:orderid) as status ";
					$stmt = $dbh->prepare($query);
					$stmt->bindParam(':orderid', $orderid, PDO::PARAM_STR,50);		
					$stmt->execute();

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
									"body" => "Hai ".$name.", Order anda dengan ID ".$orderid." sudah kami terima dan akan segera diproses lebih lanjut.",
									"title" => "DIDI",
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
					curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
					curl_setopt($ch, CURLOPT_IPRESOLVE, CURL_IPRESOLVE_V4 );
					curl_setopt ( $ch, CURLOPT_POSTFIELDS, $fields );

					curl_exec ( $ch );
					curl_close ( $ch );	
					
					
					
				}
				else{
					echo $result;
				}
				
		}
	}
	catch(PDOException $e)
	{
		echo $result;
	}
//}
?>