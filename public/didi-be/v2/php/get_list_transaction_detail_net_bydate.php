<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
if($method == 'DIDI_POS_Mobile'){
	$skucode="-";$storecode="-";$skuname="-";$price="0";$qty="0";$img="-";$dated="-";$orderid="-";$total="0";
	$user=$_POST["usercode"];
	$store=$_POST["storecode"];
	$begindate=$_POST["begindate"];
	$enddate=$_POST["enddate"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr=array("skucode"=>$skucode,"storecode"=>$storecode,"skuname"=>$skuname,"price"=>$price,"qty"=>$qty,"img"=>$img,"dated"=>$dated,"orderid"=>$orderid,"total"=>$total);
		}else{
			$query = "  select d.skucode,x.storecode,s.description as skuname,coalesce(pp.price_hpp,0) as price,d.pcsqty as qty,d.skucode||'.jpg' as img,dated,x.orderid,d.total 
			from x_order_master x 
			join x_order_detail d on d.orderid=x.orderid 
			join x_product_sku s on s.skucode=d.skucode 
			left join x_order_detail_hpp pp on pp.orderid=d.orderid and pp.skucode=d.skucode
			join x_user u on u.usercode=x.usercode 
			where x.storecode=:storecode and x.dated between :begindate and :enddate order by x.orderid desc ";
			$stmt = $dbh->prepare($query);
			//$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);	
			$stmt->bindParam(':storecode', $store, PDO::PARAM_STR,50);	
			$stmt->bindParam(':begindate', $begindate, PDO::PARAM_STR,50);	
			$stmt->bindParam(':enddate', $enddate, PDO::PARAM_STR,50);yl;
			
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$skucode = $row["skucode"];
					$storecode = $row["storecode"];
					$skuname = $row["skuname"];
					$price = $row["price"];
					$qty = $row["qty"];
					$img = $row["img"];
					$dated = $row["dated"];
					$orderid = $row["orderid"];
					$total = $row["total"];
					$arr[]=array("skucode"=>$skucode,"storecode"=>$storecode,"skuname"=>$skuname,"price"=>$price,"qty"=>$qty,"img"=>$img,"dated"=>$dated,"orderid"=>$orderid,"total"=>$total);
				}	
		}
	}
	catch(PDOException $e)
	{
		echo $e->getMessage();
	}
	$resultcabang = $arr;
	echo json_encode($resultcabang);
}
?>