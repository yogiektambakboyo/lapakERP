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
			$query = "  select s.printdesc as dated,sum(coalesce(d.total,0)) as total from x_product_sku s
						join x_product_brand b on b.brandcode=s.brandcode
						join x_product_distribution n on n.skucode=s.skucode and n.storecode=:storecode and active='1'
						left join x_order_master m on m.storecode=n.storecode and dated between :begindate and :enddate and iscanceled='0'
						left join x_order_detail d on d.skucode=s.skucode  and d.orderid=m.orderid
						group by s.printdesc order by sum(coalesce(d.total,0)) desc";
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