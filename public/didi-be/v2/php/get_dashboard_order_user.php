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
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr=array("dated"=>$dated,"total"=>$total);
		}else{
			$query = "  select u.name as dated,sum(coalesce(d.total,0)) as total from x_order_master m
join x_order_detail d on d.orderid=m.orderid
join x_product_sku s on s.skucode=d.skucode
join x_product_brand b on b.brandcode=s.brandcode
join x_user u on u.usercode=m.usercode
where m.storecode=:storecode and dated between :begindate and :enddate and iscanceled='0'
group by u.name order by sum(coalesce(d.total,0)) desc limit 10";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);	
			$stmt->bindParam(':storecode', $store, PDO::PARAM_STR,50);	
			$stmt->bindParam(':begindate', $begindate, PDO::PARAM_STR,50);	
			$stmt->bindParam(':enddate', $enddate, PDO::PARAM_STR,50);	
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$dated = $row["dated"];
					$total = $row["total"];
					$arr[]=array("dated"=>$dated,"total"=>$total);
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