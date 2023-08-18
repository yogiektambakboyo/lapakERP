<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//skucode,storecode,skuname,price,qty,img,dated,orderid,total
	$deviceid=$_POST["deviceid"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr=array("storename"=>$storename,"name"=>$name);
		}else{
			$query = "   select e.name as storename,g.name
							from x_order_master m
							join x_order_detail d on d.orderid=m.orderid
							join x_admin_link l on l.storecode=m.storecode
							join x_user e on e.usercode=m.usercode
							join x_store_master g on g.storecode=m.storecode
							join x_admin_user u on u.adminid=l.adminid and u.deviceid=:deviceid
							left join (select storecode,count(orderid) as jml from x_order_master where isprint='0' and iscanceled='0' group by storecode) a on a.storecode=m.storecode
							where m.uploadtime<=now()::timestamp- interval '10 minutes' and iscanceled='0' and isprint='0' LIMIT 1 ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':deviceid', $deviceid, PDO::PARAM_STR,50);	
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$name = $row["name"];
					$storename = $row["storename"];
					$arr[]=array("storename"=>$storename,"name"=>$name);
				}	
		}
	}
	catch(PDOException $e)
	{
		echo $e->getMessage();
	}
	$resultcabang = $arr;
	echo json_encode($resultcabang);
//}
?>