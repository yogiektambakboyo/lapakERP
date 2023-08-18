<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//skucode,storecode,skuname,price,qty,img,dated,orderid,total
	$delivery_id=$_POST["delivery_id"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr=array("storename"=>$storename,"name"=>$name);
		}else{
			$query = "   select d.order_id,u.name from x_delivery_task d
						join x_order_master m on m.orderid=d.order_id
						join x_user u on u.usercode=m.usercode
						where delivery_id=:delivery_id and isprogress='0'
						order by dated asc ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':delivery_id', $delivery_id, PDO::PARAM_STR,50);	
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$name = $row["order_id"];
					$storename = $row["name"];
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