<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//skucode,storecode,skuname,price,qty,img
	$orderid="-";$poin="-";
	$user=$_POST["usercode"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr[]=array("orderid"=>$orderid,"poin"=>$poin);
		}else{
			$query = " select m.orderid, sum(coalesce(poin,0)) as poin from x_order_master m 
left join x_poin_history h on h.storecode=m.usercode and h.description like '%'||m.orderid||'%'
where m.isreviewed='0' and m.isdelivered='1' and m.usercode=:usercode
group by m.orderid order by m.orderid  ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);	
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$orderid = $row["orderid"];
					$poin = $row["poin"];
					$arr[]=array("orderid"=>$orderid,"poin"=>$poin);
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