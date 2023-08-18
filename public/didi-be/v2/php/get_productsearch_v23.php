<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	$kode="";$nama="";$barcode="";$price="";
	$keyword=$_GET["keyword"];
	$storecode=$_GET["storecode"];
	$usercode=$_GET["usercode"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr=array("kode"=>$kode,"nama"=>$nama,"barcode"=>$barcode,"harga"=>$price,"gambar"=>"");
		}else{
			$query = " select s.skucode as kode,s.description as nama,COALESCE(s.barcode,'XXXXXDD') as barcode,
				case when x.member_type=0 then p.price
						when x.member_type=1 then p.pricemember_1 
						when x.member_type=2 then p.pricemember_2 
						else p.price end as price
			from x_product_sku s 
			join x_user x on x.usercode=:usercode
			join x_product_subcategory g on g.categorycode=s.categorycode and g.subcategorycode=s.subcategorycode 
			join x_product_distribution b on b.skucode=s.skucode and b.storecode=:storecode  and b.active='1' 
			join x_product_price p on p.skucode=b.skucode and p.storecode=b.storecode 
			where s.subcategorycode=:keyword or s.categorycode=:keyword2 ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':keyword', $keyword, PDO::PARAM_STR,50);	
			$stmt->bindParam(':keyword2', $keyword, PDO::PARAM_STR,50);	
			$stmt->bindParam(':storecode', $storecode, PDO::PARAM_STR,50);	
			$stmt->bindParam(':usercode', $usercode, PDO::PARAM_STR,50);	
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$kode = $row["kode"];
					$nama = $row["nama"];
					$barcode = $row["barcode"];
					$price = $row["price"];
					$arr[]=array("kode"=>$kode,"nama"=>$nama,"barcode"=>$barcode,"harga"=>$price,"gambar"=>"");
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