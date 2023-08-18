<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	$fulldescription="-";$review="0";$weight="0";$stock="0";$categoryname="0";$brandname="0";$viewed="0";$sold="0";$parent="-";$media="-";$ops="-";
	$skucode=$_GET["skucode"];
	$usercode=$_GET["usercode"];
	$storecode=$_GET["storecode"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr=array("media"=>$media,"ops"=>$ops,"parent"=>$parent,"fulldescription"=>$fulldescription,"review"=>$review,"weight"=>$weight,"stock"=>$stock,"categoryname"=>$categoryname,"brandname"=>$brandname,"sold"=>$sold,"viewed"=>$viewed);
		}else{
			$query = " INSERT INTO x_product_log_view(usercode, skucode, createdate)VALUES (:usercode, :skucode, now()) ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $usercode, PDO::PARAM_STR,50);
			$stmt->bindParam(':skucode', $skucode, PDO::PARAM_STR,50);
			$stmt->execute();		
			
			$query = " select COALESCE(i.description,'-') as media,COALESCE(o.description,'-') as ops,s.parent,count(g.skucode)||' dari '||count(u.usercode)||' toko membeli produk ini' as sold,s.skucode,s.fulldescription,'0' as review,weight,COALESCE(q.qty,'0') as stock,c.categoryname,b.brandname,0 as viewed 
			from x_product_sku s 
			join x_product_category c on c.categorycode=s.categorycode 
			join x_product_brand b on b.brandcode=s.brandcode  
			left join (select distinct skucode,storecode from x_order_detail x join x_order_master m on m.orderid=x.orderid and m.storecode=:storecode1) g on g.skucode=s.skucode 
			left join x_user u on u.storecode=:storecode  
			left join x_product_media_support i on i.skucode=s.skucode and now()::timestamp::date between i.startdate and i.enddate 
			left join x_product_ops_support o on o.skucode=s.skucode and now()::timestamp::date between o.startdate and o.enddate
			left join x_product_stock q on q.skucode=s.skucode and q.storecode=u.storecode
			where s.skucode=:skucode
			group by q.qty,s.parent,s.skucode,s.fulldescription,weight,c.categoryname,b.brandname,i.description,o.description ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':skucode', $skucode, PDO::PARAM_STR,50);	
			$stmt->bindParam(':storecode', $storecode, PDO::PARAM_STR,50);	
			$stmt->bindParam(':storecode1', $storecode, PDO::PARAM_STR,50);	
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$fulldescription = $row["fulldescription"];
					$review = $row["review"];
					$weight = $row["weight"];
					$stock = $row["stock"];
					$categoryname = $row["categoryname"];
					$brandname = $row["brandname"];
					$viewed = $row["viewed"];
					$sold = $row["sold"];
					$parent = $row["parent"];
					$media = $row["media"];
					$ops = $row["ops"];
					$arr[]=array("media"=>$media,"ops"=>$ops,"parent"=>$parent,"fulldescription"=>$fulldescription,"review"=>$review,"weight"=>$weight,"stock"=>$stock,"categoryname"=>$categoryname,"brandname"=>$brandname,"sold"=>$sold,"viewed"=>$viewed);
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