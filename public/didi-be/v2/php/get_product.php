<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	$kode="";$nama="";$barcode="";$price="";
	$categorycode=$_GET["categorycode"];
	$storecode=$_GET["storecode"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr=array("kode"=>$kode,"nama"=>$nama,"barcode"=>$barcode,"harga"=>$price);
		}else{
			$query = " select s.skucode as kode,coalesce(s.printdesc,'') as nama,s.barcode,coalesce(p.price,0) as price from x_product_sku s join x_product_distribution b on b.skucode=s.skucode and b.storecode=:storecode and b.active='1' left join x_product_price p on p.skucode=b.skucode and p.storecode=b.storecode where s.categorycode=:categorycode ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':categorycode', $categorycode, PDO::PARAM_STR,50);	
			$stmt->bindParam(':storecode', $storecode, PDO::PARAM_STR,50);	
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$kode = $row["kode"];
					$nama = $row["nama"];
					$barcode = $row["barcode"];
					$price = $row["price"];
					$arr[]=array("kode"=>$kode,"nama"=>$nama,"barcode"=>$barcode,"harga"=>$price);
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