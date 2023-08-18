<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	$categorycode="-";
	$categoryname="-";
	$storecode=$_GET["storecode"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr=array("categorycode"=>$categorycode,"categoryname"=>$categoryname);
		}else{
			
			$query = "select count(1) as c from x_store_master where storecode=:storecode and isdidiws='1' ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':storecode', $storecode, PDO::PARAM_STR,50);
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$c = $row["c"];
			}
			
			if(intval($c)>0){
				$query = " select s.categorycode,l.categoryname from x_product_log_view v 
				join x_product_sku s on s.skucode=v.skucode 
				join x_product_category l on l.categorycode=s.categorycode
				join x_store_master m on m.storecode=:storecode
				join x_store_master m2 on m2.storecode=m.relatedws
				join x_product_distribution d on d.active='1' and d.skucode=v.skucode and d.storecode=m2.storecode 
				group by s.categorycode,l.categoryname order by count(1) desc limit 3 ";
			$stmt = $dbh->prepare($query);	
			$stmt->bindParam(':storecode', $storecode, PDO::PARAM_STR,50);	
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$categorycode = $row["categorycode"];
					$categoryname = $row["categoryname"];
					$arr[]=array("categorycode"=>$categorycode,"categoryname"=>$categoryname);
				}
			}else{
				
				$query = " select s.categorycode,l.categoryname from x_product_log_view v join x_product_sku s on s.skucode=v.skucode join x_product_category l on l.categorycode=s.categorycode join x_product_distribution d on d.active='1' and d.skucode=v.skucode and d.storecode=:storecode group by s.categorycode,l.categoryname order by count(1) desc limit 3 ";
			$stmt = $dbh->prepare($query);	
			$stmt->bindParam(':storecode', $storecode, PDO::PARAM_STR,50);	
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$categorycode = $row["categorycode"];
					$categoryname = $row["categoryname"];
					$arr[]=array("categorycode"=>$categorycode,"categoryname"=>$categoryname);
				}
				
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