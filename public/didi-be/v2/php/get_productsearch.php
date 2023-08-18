<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	$kode="";$nama="";$barcode="";$price="";
	$keyword=$_GET["keyword"];
	$storecode=$_GET["storecode"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr=array("kode"=>$kode,"nama"=>$nama,"barcode"=>$barcode,"harga"=>$price,"gambar"=>"");
		}else{
			$query = "select count(1) as c from x_store_master where storecode=:storecode and isdidiws='1' ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':storecode', $storecode, PDO::PARAM_STR,50);
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$c = $row["c"];
			}
			
			if(intval($c)>0){
				$query = " select * from (select row_number() over(PARTITION BY kode order by kode,priority_values,price asc) as uniquecode,* from (
							select p.priority_values,x.storecode,s.skucode as kode,s.printdesc as nama,coalesce(barcode,'') as barcode,coalesce(searchkey,'') searchkey,
							case when (p.up_values+p.up_values_system)<=0 then p.price else (p.price+((p.price*(p.up_values+p.up_values_system))/100)) end as price 
							from x_product_sku s
							join x_store_master u on u.storecode=:storecode
							join x_store_master x on x.city=u.city and x.isdidiws='0'
							join x_product_distribution d on d.skucode=s.skucode and d.storecode=x.storecode and d.active='1' 
							join x_product_price p on p.storecode=x.storecode and p.skucode=d.skucode and p.price>0
							join x_product_stock c on c.skucode=p.skucode and c.storecode=x.storecode and c.qty>0
							where s.subcategorycode=:keyword or s.categorycode=:keyword2																		
						) g) d where uniquecode=1";
				$stmt = $dbh->prepare($query);
				$stmt->bindParam(':keyword', $keyword, PDO::PARAM_STR,50);	
				$stmt->bindParam(':keyword2', $keyword, PDO::PARAM_STR,50);	
				$stmt->bindParam(':storecode', $storecode, PDO::PARAM_STR,50);	
				$stmt->execute();			
				while ($row = $stmt->fetch()) {
						$kode = $row["kode"];
						$nama = $row["nama"];
						$barcode = $row["barcode"];
						$price = $row["price"];
						$arr[]=array("kode"=>$kode,"nama"=>$nama,"barcode"=>$barcode,"harga"=>$price,"gambar"=>"");
					}	
			}else{
				
				$query = " select s.skucode as kode,s.description as nama,COALESCE(s.barcode,'XXXXXDD') as barcode,case when (p.up_values+p.up_values_system)<=0 then p.price else p.price end as price
				from x_product_sku s 
				join x_product_subcategory g on g.categorycode=s.categorycode and g.subcategorycode=s.subcategorycode 
				join x_product_distribution b on b.skucode=s.skucode and b.storecode=:storecode  and b.active='1' 
				join x_product_price p on p.skucode=b.skucode and p.storecode=b.storecode where s.subcategorycode=:keyword or s.categorycode=:keyword2 ";
				$stmt = $dbh->prepare($query);
				$stmt->bindParam(':keyword', $keyword, PDO::PARAM_STR,50);	
				$stmt->bindParam(':keyword2', $keyword, PDO::PARAM_STR,50);	
				$stmt->bindParam(':storecode', $storecode, PDO::PARAM_STR,50);	
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
	}
	catch(PDOException $e)
	{
		echo $e->getMessage();
	}
	$resultcabang = $arr;
	echo json_encode($resultcabang);
//}
?>