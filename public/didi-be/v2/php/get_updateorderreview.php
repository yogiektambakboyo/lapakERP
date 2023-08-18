<?php
$method = $_SERVER['HTTP_USER_AGENT'];
$orderid=$_POST["orderid"];
$description=$_POST["description"];
$action=$_POST["action"];
$result="0";

set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			echo $result;
		}else{
			$query = " UPDATE x_order_master set isreviewed=:action where orderid=:orderid  ";
				$stmt = $dbh->prepare($query);
				$stmt->bindParam(':orderid', $orderid, PDO::PARAM_STR,50);
				$stmt->bindParam(':action', $action, PDO::PARAM_STR,50);
				if($stmt->execute())
				{
					$result = "1";
					echo $result;
					
					if ($action == "1"){
							$query = " insert into x_poin select usercode,0,now()::timestamp from x_user where usercode not in (select usercode from x_poin)  ";
							$stmt = $dbh->prepare($query);
							$stmt->execute();
							
							$query = " update x_poin set updated_date=now()::timestamp,poin=poin+10 where usercode=(select usercode from x_order_master where orderid=:orderid)  ";
							$stmt = $dbh->prepare($query);
							$stmt->bindParam(':orderid', $orderid, PDO::PARAM_STR,50);
							$stmt->execute();
							
							$query = " INSERT INTO public.x_poin_history(
										 storecode, poin, description, created_date)
									select usercode,10 as poin,'Added Poin from Order ID '||x.orderid,now() 
									from x_order_master x
									join x_poin_rule r on r.id=1
									where x.orderid=:orderid  ";
							$stmt = $dbh->prepare($query);
							$stmt->bindParam(':orderid', $orderid, PDO::PARAM_STR,50);
							$stmt->execute();
							
							$query = " INSERT INTO public.x_order_review(
										 orderid,usercode, description, created_date)
									select :orderid2,usercode,:description,now() 
									from x_order_master x
									join x_poin_rule r on r.id=1
									where x.orderid=:orderid  ";
							$stmt = $dbh->prepare($query);
							$stmt->bindParam(':orderid', $orderid, PDO::PARAM_STR,50);
							$stmt->bindParam(':orderid2', $orderid, PDO::PARAM_STR,50);
							$stmt->bindParam(':description', $description, PDO::PARAM_STR,500);
							$stmt->execute();
					}
					
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