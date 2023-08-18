<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
if($method == 'DIDI_POS_Mobile'){
	//skucode,storecode,skuname,price,qty,img,dated,orderid,total
	$skucode="-";$storecode="-";$skuname="-";$price="0";$qty="0";$img="-";$categoryname="-";$subcategoryname="-";$active="0";$isempty="0";$pricem1="0";$pricem2="0";
	$store=$_POST["storecode"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr=array("searchkey"=>"","barcode"=>"","pricem1"=>$pricem1,"pricem2"=>$pricem2,"skucode"=>$skucode,"storecode"=>$storecode,"skuname"=>$skuname,"price"=>$price,"qty"=>$qty,"img"=>$img,"categoryname"=>$categoryname,"subcategoryname"=>$subcategoryname,"active"=>$active,"isempty"=>$isempty);
		}else{
			$query = " select COALESCE(s.searchkey,'') as searchkey,h.stock_values as barcode,COALESCE(p.pricemember_1,'0') as pricem1,COALESCE(p.pricemember_2,'0') as pricem2,d.storecode,s.skucode,s.shortdesc as skuname,COALESCE(p.price,'0') as price,COALESCE(t.qty,'0') as qty,categoryname,subcategoryname,COALESCE(d.active,'0') as active,'-' as img,COALESCE(d.emptystock,'0') as isempty from x_product_sku s
						join x_product_category c on c.categorycode=s.categorycode
						join x_product_subcategory b on b.subcategorycode=s.subcategorycode
						join x_product_distribution d on d.skucode=s.skucode and d.storecode=:storecode
						join x_product_price p on p.skucode=s.skucode and p.storecode=d.storecode
						join x_product_stock t on t.storecode=d.storecode and t.skucode=s.skucode
						join x_product_hpp h on h.storecode=d.storecode and h.skucode=d.skucode ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':storecode', $store, PDO::PARAM_STR,50);		
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$skucode = $row["skucode"];
					$storecode = $row["storecode"];
					$skuname = $row["skuname"];
					$price = $row["price"];
					$qty = $row["qty"];
					$img = $row["img"];
					$categoryname = $row["categoryname"];
					$subcategoryname = $row["subcategoryname"];
					$active = $row["active"];
					$isempty = $row["isempty"];
					$pricem1 = $row["pricem1"];
					$pricem2 = $row["pricem2"];
					$barcode = $row["barcode"];
					$searchkey = $row["searchkey"];
					$arr[]=array("searchkey"=>$searchkey,"barcode"=>$barcode,"pricem1"=>$pricem1,"pricem2"=>$pricem2,"skucode"=>$skucode,"storecode"=>$storecode,"skuname"=>$skuname,"price"=>$price,"qty"=>$qty,"img"=>$img,"categoryname"=>$categoryname,"subcategoryname"=>$subcategoryname,"active"=>$active,"isempty"=>$isempty);
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