<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);

//if($method == 'SFA_Borwita_Android'){
	//skucode,storecode,skuname,price,qty,img,dated,orderid,total
	$skucode="-";$storecode="-";$skuname="-";$price="0";$brandcode="0";$categorycode="-";$subcategorycode="-";$casesize="0";$prindesc="0";
	$pricem1="0";$pricem2="0";
	$store=$_POST["storecode"];
	$productcode=$_POST["skucode"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr=array("barcode"=>$barcode,"pricem1"=>$pricem1,"pricem2"=>$pricem2,"skucode"=>$skucode,"storecode"=>$storecode,"skuname"=>$skuname,"price"=>$price,"brandcode"=>$brandcode,"categorycode"=>$categorycode,"subcategorycode"=>$subcategorycode,"casesize"=>$casesize,"printdesc"=>$prindesc);
		}else{
			//storecode,skucode,skuname,price,brandcode,categorycode,subcategorycode,casesize
			$query = "select coalesce(s.barcode,'') as barcode,COALESCE(p.pricemember_1,'0') as pricem1,COALESCE(p.pricemember_2,'0') as pricem2,p.storecode,s.skucode,s.description as skuname,c.categoryname as categorycode,b.brandname as brandcode,g.subcategoryname as subcategorycode,s.casesize,CAST(p.price as INTEGER) price,s.printdesc 
from x_product_sku s
join x_product_category c on c.categorycode=s.categorycode
join x_product_subcategory g on g.subcategorycode=s.subcategorycode
join x_product_brand b on b.brandcode=s.brandcode
join x_product_price p on p.skucode=s.skucode and p.storecode=1 and s.skucode=:skucode LIMIT 1";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':storecode', $store, PDO::PARAM_STR,50);		
			$stmt->bindParam(':skucode', $productcode, PDO::PARAM_STR,50);		
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$skucode = $row["skucode"];
					$storecode = $row["storecode"];
					$skuname = $row["skuname"];
					$price = $row["price"];
					$brandcode = $row["brandcode"];
					$prindesc = $row["printdesc"];
					$categorycode = $row["categorycode"];
					$subcategorycode = $row["subcategorycode"];
					$casesize = $row["casesize"];
					$barcode = $row["barcode"];
					$arr=array("barcode"=>$barcode,"pricem1"=>$pricem1,"pricem2"=>$pricem2,"skucode"=>$skucode,"storecode"=>$storecode,"skuname"=>$skuname,"price"=>$price,"brandcode"=>$brandcode,"categorycode"=>$categorycode,"subcategorycode"=>$subcategorycode,"casesize"=>$casesize,"printdesc"=>$prindesc);
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