<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//skucode,storecode,skuname,price,qty,img
	$skucode="-";$storecode="-";$skuname="-";$price="0";$qty="0";$img="-";$disc_value="0";
	$user=$_POST["usercode"];
	$store=$_POST["storecode"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr=array("disc_value"=>$disc_value,"skucode"=>$skucode,"storecode"=>$storecode,"skuname"=>$skuname,"price"=>$price,"qty"=>$qty,"img"=>$img);
		}else{
			
			$query = " update x_orderdraft set usercode=(usercode*-1) where isinvoice='0' and (storecode=1 or storecode=0) and usercode>0  ";
			$stmt = $dbh->prepare($query);
			$stmt->execute();
		
			$query = " INSERT INTO public.x_log_user_access(usercode, description,ticket) 
						select t.usercode,'Cart',t.ticket from x_log_user_ticket t
						join x_user u on u.usercode=:usercode and u.usercode=t.usercode
						order by created_date desc limit 1  ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);
			$stmt->execute();
			
			$query = " INSERT INTO public.x_log_product_stock(
						storecode, skucode, qty, description, created_date)
						select storecode,skucode,999999,'RESTOCK',now() from x_product_stock where storecode||skucode in (select distinct s.storecode||s.skucode from x_product_stock s join x_store_master m on m.storecode=s.storecode and isstockcheck='0' where qty=0 ) ";
			$stmt = $dbh->prepare($query);
			$stmt->execute();
			
			
			$query = " update x_product_stock set qty=999999 where qty=0 and storecode in (select storecode from x_store_master where isstockcheck='0')  ";
			$stmt = $dbh->prepare($query);
			$stmt->execute();
			
			$query = " update x_orderdraft set usercode=usercode*(-1),storecode=storecode*(-1) where isinvoice='0' and usercode>0 and createdate<now()-INTERVAL '1 days' and skucode||storecode in (
						select skucode||storecode from x_log_price where createdate>now()-INTERVAL '1 days') ";
			$stmt = $dbh->prepare($query);
			$stmt->execute();
			
			$query = " update x_orderdraft set usercode=usercode*(-1),storecode=storecode*(-1) where isinvoice='0' and usercode>0 and createdate<now()-INTERVAL '2 days'  ";
			$stmt = $dbh->prepare($query);
			$stmt->execute();
			
			$query = " UPDATE x_orderdraft set relatedid=TO_CHAR(NOW(),'YYYYMMDDHHMI')||'-OR-'||:storecode2||:usercode2 where usercode=:usercode and isinvoice='0'  ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);
			$stmt->bindParam(':usercode2', $user, PDO::PARAM_STR,50);
			$stmt->bindParam(':storecode', $store, PDO::PARAM_STR,50);
			$stmt->bindParam(':storecode2', $store, PDO::PARAM_STR,50);
			$stmt->execute();
			
			$query = "select count(1) as c from x_user u
			join x_store_master m on m.storecode=u.subscriber_store
			where u.usercode=:usercode and m.isdidiws='1' ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$c = $row["c"];
			}
			
			if(intval($c)>0){
				/**$query = " 
				select u.city,'0' as disc_value,x.skucode,x.storecode,s.description as skuname,case when COALESCE((p.up_values+p.up_values_system),0)<=0 then cast(coalesce(p.price,0) as int) else cast((coalesce(p.price,0)+((coalesce(p.price,0)*(p.up_values+p.up_values_system))/100)) as int) end as price,x.qty,x.skucode||'.jpg' as img 
				from x_orderdraft x 
				join x_product_sku s on s.skucode=x.skucode  
				join x_user u on u.usercode=x.usercode 
				join x_store_master f on f.city=u.city and f.isdidiws='1'
				join x_store_master g on g.storecode=f.relatedws
				left join x_product_price p on p.skucode=x.skucode and p.storecode=g.storecode 
				where x.usercode=:usercode and x.isinvoice='0' ";**/
				$query = "select * from (select row_number() over(PARTITION BY skucode order by skucode,priority_values,price asc) as uniquecode,* from (
				select p.priority_values,s.skucode||'.jpg' as img,o.qty,'0' as disc_value,u.city,x.storecode,s.skucode,s.description as skuname,coalesce(barcode,'') as barcode,coalesce(searchkey,'') searchkey,
				case when (p.up_values+p.up_values_system)<=0 then p.price else (p.price+((p.price*(p.up_values+p.up_values_system))/100)) end as price 
				from x_product_sku s
				join x_orderdraft o on o.skucode=o.skucode and isinvoice='0' and o.usercode=:usercode
				join x_user u on u.usercode=o.usercode
				join x_store_master x on x.city=u.city and x.isdidiws='0'
				join x_product_distribution d on d.skucode=s.skucode and d.storecode=x.storecode and d.skucode=o.skucode
				join x_product_price p on p.storecode=x.storecode and p.skucode=d.skucode and p.price>0  and p.skucode=o.skucode
				join x_product_stock c on c.skucode=p.skucode and c.storecode=x.storecode and c.qty>0
				where d.active='1'																		
			) g) d where uniquecode=1";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);			
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$skucode = $row["skucode"];
					$storecode = $row["storecode"];
					$skuname = $row["skuname"];
					$price = $row["price"];
					$qty = $row["qty"];
					$img = $row["img"];
					$disc_value = $row["disc_value"];
					$arr[]=array("disc_value"=>$disc_value,"skucode"=>$skucode,"storecode"=>$storecode,"skuname"=>$skuname,"price"=>$price,"qty"=>$qty,"img"=>$img);
				}	
				
			}else{
				$query = " 
				select '0' as disc_value,x.skucode,x.storecode,s.description as skuname,
CASE WHEN u.member_type=1 THEN coalesce(p.pricemember_1,0)
			WHEN u.member_type=2 THEN coalesce(p.pricemember_2,0)
			ELSE CAST((COALESCE(p.price,0)) as numeric(14,0)) END as price,x.qty,x.skucode||'.jpg' as img 
				from x_orderdraft x 
				join x_product_sku s on s.skucode=x.skucode  
				join x_user u on u.usercode=x.usercode 
				join x_store_master f on f.storecode=u.subscriber_store
				left join x_product_price p on p.skucode=x.skucode and p.storecode=f.storecode 
				where x.usercode=:usercode and x.isinvoice='0'";
				$stmt = $dbh->prepare($query);
				$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);	
				//$stmt->bindParam(':storecode', $store, PDO::PARAM_STR,50);
				//$stmt->bindParam(':storecode2', $store, PDO::PARAM_STR,50);			
				$stmt->execute();			
				while ($row = $stmt->fetch()) {
						$skucode = $row["skucode"];
						$storecode = $row["storecode"];
						$skuname = $row["skuname"];
						$price = $row["price"];
						$qty = $row["qty"];
						$img = $row["img"];
						$disc_value = $row["disc_value"];
						$arr[]=array("disc_value"=>$disc_value,"skucode"=>$skucode,"storecode"=>$storecode,"skuname"=>$skuname,"price"=>$price,"qty"=>$qty,"img"=>$img);
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