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
				$query = " 
select '0' as disc_value,x.skucode,x.storecode,s.description as skuname,case when f.upvalue<=0 then coalesce(p.price,0) else (coalesce(p.price,0)+((coalesce(p.price,0)*f.upvalue)/100)) end as price,x.qty,x.skucode||'.jpg' as img 
from x_orderdraft x 
join x_product_sku s on s.skucode=x.skucode  
join x_user u on u.usercode=x.usercode 
join x_store_master f on f.city=u.city and f.isdidiws='1'
left join x_product_price p on p.skucode=x.skucode and p.storecode=x.storecode 
where x.usercode=:usercode and x.isinvoice='0' ";
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
				
			}else{
				$query = " 
				select '0' as disc_value,x.skucode,x.storecode,s.description as skuname,case when f.upvalue<=0 then coalesce(p.price,0) else (coalesce(p.price,0)+((coalesce(p.price,0)*f.upvalue)/100)) end as price,x.qty,x.skucode||'.jpg' as img 
				from x_orderdraft x 
				join x_product_sku s on s.skucode=x.skucode  
				join x_user u on u.usercode=x.usercode 
				join x_store_master f on f.storecode=u.subscriber_store
				left join x_product_price p on p.skucode=x.skucode and p.storecode=f.storecode 
				where x.usercode=:usercode and x.isinvoice='0' ";
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