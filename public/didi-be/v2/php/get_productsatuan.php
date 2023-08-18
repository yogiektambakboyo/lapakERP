<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	$kode="-";
	$skucodes=$_GET["skucode"];
	$storecode=$_GET["storecode"];
	$parent=$_GET["parent"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr=array("img"=>$photo,"skucode"=>$skucode,"name"=>$name,"price"=>$price);
		}else{
			$query = " select s.skucode,p.photo,s.description as name,COALESCE(h.price,0) as price from x_product_sku s join x_product_photo p on p.skucode=s.skucode left join x_product_price h on h.skucode=s.skucode and h.storecode=:storecode where s.parent=:skucode and s.skucode<>:skucode2 limit 1 ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':skucode', $parent, PDO::PARAM_STR,50);	
			$stmt->bindParam(':skucode2', $skucodes, PDO::PARAM_STR,50);	
			$stmt->bindParam(':storecode', $storecode, PDO::PARAM_STR,50);	
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$skucode = $row["skucode"];
					$photo = $row["photo"];
					$name = $row["name"];
					$price = $row["price"];
					$arr[]=array("img"=>$photo,"skucode"=>$skucode,"name"=>$name,"price"=>$price);
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