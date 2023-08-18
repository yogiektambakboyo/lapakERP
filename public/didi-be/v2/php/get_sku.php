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
			$arr[]=array("kode"=>$kode,"nama"=>$nama,"active"=>"0");
		}else{
			$query = "  select s.skucode,s.printdesc from x_product_sku s
						join x_product_distribution d on d.skucode=s.skucode and d.storecode=:storecode and active='1'
						order by printdesc ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':storecode', $store, PDO::PARAM_STR,50);	
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$kode = $row["skucode"];
					$nama = $row["printdesc"];
					$arr[]=array("kode"=>$kode,"nama"=>$nama,"active"=>"0");
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