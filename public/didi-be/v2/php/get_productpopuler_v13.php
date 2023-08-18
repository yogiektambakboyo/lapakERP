<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	$kode="";$nama="";$barcode="";$price="";
	$usercode=$_GET["usercode"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr=array("kode"=>$kode,"nama"=>$nama,"barcode"=>$barcode,"harga"=>$price);
		}else{
			$query = "select count(1) as c from x_user u
			join x_store_master m on m.storecode=u.subscriber_store
			where u.usercode=:usercode and m.isdidiws='1' ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $usercode, PDO::PARAM_STR,50);
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$c = $row["c"];
			}
			
			if(intval($c)>0){
				$query = "  select * from (select row_number() over(PARTITION BY kode order by kode,priority_values,price asc) as uniquecode,* from (
							select p.priority_values,x.storecode,s.skucode as kode,s.printdesc as nama,coalesce(barcode,'') as barcode,coalesce(searchkey,'') searchkey,
							case when (p.up_values+p.up_values_system)<=0 then p.price else (p.price+((p.price*(p.up_values+p.up_values_system))/100)) end as price 
							from x_product_sku s
							join x_user u on u.usercode=:usercode
							join x_store_master x on x.city=u.city and x.isdidiws='0'
							join x_product_distribution d on d.skucode=s.skucode and d.storecode=x.storecode and d.active='1' 
							join x_product_price p on p.storecode=x.storecode and p.skucode=d.skucode and p.price>0
							join x_product_stock c on c.skucode=p.skucode and c.storecode=x.storecode and c.qty>0
							order by p.discount desc																	
						) g) d where uniquecode=1  limit 10 ";
			$stmt = $dbh->prepare($query);	
			$stmt->bindParam(':usercode', $usercode, PDO::PARAM_STR,50);	
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$kode = $row["kode"];
					$nama = $row["nama"];
					$barcode = $row["barcode"];
					$price = $row["price"];
					$arr[]=array("kode"=>$kode,"nama"=>$nama,"barcode"=>$barcode,"harga"=>$price);
				}	
				
			}else{
				$query = "  select s.skucode as kode,coalesce(s.printdesc,'') as nama,s.barcode,
							case when u.member_type=0 then p.price 
								 when u.member_type=1 then p.pricemember_1 
								 when u.member_type=2 then p.pricemember_2 
								 else p.price end as price 
				from x_product_sku s 
				join x_user u on u.usercode=:usercode
			join x_store_master y on y.storecode=u.storecode
			join x_product_distribution b on b.skucode=s.skucode and b.storecode=y.storecode and b.active='1' 
			join x_product_log_view v on v.skucode=s.skucode and v.skucode=b.skucode 
			join x_product_price p on p.skucode=b.skucode and p.storecode=b.storecode 
			group by s.skucode,p.price,s.description,s.barcode,u.member_type,p.price,p.pricemember_1,p.pricemember_2			
			order by count(v.skucode) desc limit 10 ";
			$stmt = $dbh->prepare($query);	
			$stmt->bindParam(':usercode', $usercode, PDO::PARAM_STR,50);	
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
	}
	catch(PDOException $e)
	{
		echo $e->getMessage();
	}
	$resultcabang = $arr;
	echo json_encode($resultcabang);
//}
?>