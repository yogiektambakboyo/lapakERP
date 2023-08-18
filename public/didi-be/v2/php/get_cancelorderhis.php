<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//skucode,storecode,skuname,price,qty,img
	$status="0";
	$orderid=$_POST["orderid"];
	$user=$_POST["usercode"];
	$reason=$_POST["reason"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$status="0";
		}else{
			
			/**$query = "select case when count(x.orderid)>=1 then '1' else '0' end as device 
from x_order_master x
join x_order_detail d on d.orderid=x.orderid
join x_orderdraft f on f.qty=d.pcsqty and f.usercode=x.usercode and f.storecode=x.storecode and f.skucode=d.skucode and f.sequence=d.seq and f.isinvoice='1'
 where f.relatedid=:orderid and x.isprint='1' ";**/
 
			$query = " select sum(device) as device from (
select case when count(x.orderid)>=1 then 1 else 0 end as device 
from x_order_master x
join x_order_detail d on d.orderid=x.orderid
join x_orderdraft f on f.qty=d.pcsqty and f.usercode=x.usercode and f.storecode=x.storecode and f.skucode=d.skucode and f.sequence=d.seq and f.isinvoice='1'
 where f.relatedid=:orderid and x.isprint='1'
union
select 1 as device from x_order_master where  orderid=:orderid2 and isprint='1'
) a ";
			$stmtcek = $dbh->prepare($query);			
			$stmtcek->bindParam(':orderid', $orderid, PDO::PARAM_STR,50);
			$stmtcek->bindParam(':orderid2', $orderid, PDO::PARAM_STR,50);
			$resultcek=$stmtcek->execute();

			if (!$resultcek) {
				$status="4";
				echo $status;
				exit;
			}else{
				
				
				while ($row = $stmtcek->fetch()) 
				{
					$status = $row["device"]; 
				}

				if ($status=="0") 
				{
					
					$query = " UPDATE x_order_master
SET iscanceled='1'
FROM (select distinct x.orderid 
from x_order_master x
join x_order_detail d on d.orderid=x.orderid
join x_orderdraft f on f.qty=d.pcsqty and f.usercode=x.usercode and f.storecode=x.storecode and f.skucode=d.skucode and f.sequence=d.seq and f.isinvoice='1'
 where f.relatedid=:orderid) as s
WHERE s.orderid=x_order_master.orderid  ";
					$stmt = $dbh->prepare($query);
					$stmt->bindParam(':orderid', $orderid, PDO::PARAM_STR,50);	
					$stmt->execute();

					$query = " UPDATE x_order_master
							SET iscanceled='1' where orderid=:orderid and isprint='0' ";
					$stmt = $dbh->prepare($query);
					$stmt->bindParam(':orderid', $orderid, PDO::PARAM_STR,50);	
					
								
					if ($stmt->execute()) {
							$status = "1";
							$query = " INSERT INTO x_log_cancel_order(usercode, orderid, reason, createdate) VALUES (:usercode, :orderid, :reason, now()::timestamp);  ";
							$stmt = $dbh->prepare($query);
							$stmt->bindParam(':orderid', $orderid, PDO::PARAM_STR,50);	
							$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);	
							$stmt->bindParam(':reason', $reason, PDO::PARAM_STR,50);	
							$stmt->execute();
						}	
					
				}else{
					$status = "3";
				}
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