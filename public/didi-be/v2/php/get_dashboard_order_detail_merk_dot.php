<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//skucode,storecode,skuname,price,qty,img,dated,orderid,total
	$skucode="-";$storecode="-";$skuname="-";$price="0";$qty="0";$img="-";$dated="-";$orderid="-";$total="0";
	$user=$_POST["usercode"];
	$store=$_POST["storecode"];
	$begindate=$_POST["begindate"];
	$enddate=$_POST["enddate"];
	$keyword=$_POST["keyword"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr[]=array("name"=>$name,"totalqty"=>$totalqty,"total"=>$total);
		}else{
			$query = "  select u.name as name,sum(coalesce(d.total,0)) as total,count(distinct coalesce(o.orderid,'')) as totalqty from
						x_calendar c 
						join x_store_master m on m.storecode=:storecode
						join x_product_brand b on b.brandcode in (".$keyword.")
						join x_product_sku s on s.brandcode=b.brandcode
						join x_order_master o on o.dated=c.dated and o.storecode=m.storecode and iscanceled='0'
						join x_order_detail d on d.orderid=o.orderid and d.skucode=s.skucode
						join x_user u on u.usercode=o.usercode
						where c.dated between :begindate and :enddate
						group by u.name order by sum(coalesce(d.total,0)) desc ";
			$stmt = $dbh->prepare($query);	
			$stmt->bindParam(':storecode', $store, PDO::PARAM_STR,50);	
			$stmt->bindParam(':begindate', $begindate, PDO::PARAM_STR,50);	
			$stmt->bindParam(':enddate', $enddate, PDO::PARAM_STR,50);	
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$name = $row["name"];
					$total = $row["total"];
					$totalqty = $row["totalqty"];
					$arr[]=array("name"=>$name,"totalqty"=>$totalqty,"total"=>$total);
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