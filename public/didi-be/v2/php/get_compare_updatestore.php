<?php
$method = $_SERVER['HTTP_USER_AGENT'];
$usercode=$_POST["usercode"];
$storecode=$_POST["storecode"];
$isdidi=$_POST["isdidi"];
$result="0";

set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			echo $result;
		}else{
			$query = " UPDATE x_orderdraft set storecode=:storecode where usercode=:usercode and isinvoice='0'  ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $usercode, PDO::PARAM_STR,50);
			$stmt->bindParam(':storecode', $storecode, PDO::PARAM_STR,50);
			/**
			SELECT p.skucode,p.storecode,
								CASE WHEN u.member_type=1 THEN p.pricemember_1
								WHEN u.member_type=2 THEN p.pricemember_2
 								ELSE CAST(COALESCE(p.price,0)-((CAST(p.discount as numeric(10,2))/100)*COALESCE(p.price,0)) as numeric(14,0)) end as price from x_product_price p 
							join x_product_distribution d on d.skucode=p.skucode and d.storecode=p.storecode and d.active='1'
							join x_user u on u.usercode=:usercode1 
							where p.storecode=:storecode **/
			if($stmt->execute())
				
			{
				
				if($isdidi=="1"){
					$query = " UPDATE x_orderdraft
							SET price=subquery.price
							FROM (
							SELECT p.skucode,p.storecode,
								CASE WHEN u.member_type=1 THEN p.pricemember_1
								WHEN u.member_type=2 THEN p.pricemember_2
								ELSE CAST(COALESCE(p.price,0)-((CAST(p.discount as numeric(10,2))/100)*COALESCE(p.price,0)) as numeric(14,0)) end as price 
							from x_product_price p 
							join x_store_master s on s.storecode=:storecode
							join x_store_master h on h.storecode=s.relatedws and p.storecode=h.storecode																										   
							join x_product_distribution d on d.skucode=p.skucode and d.storecode=h.storecode and d.active='1'
							join x_user u on u.usercode=:usercode1 
							) AS subquery
							WHERE x_orderdraft.skucode=subquery.skucode and x_orderdraft.usercode=:usercode2 and isinvoice='0'  ";
				}else{
					$query = " UPDATE x_orderdraft
							SET price=subquery.price
							FROM (
							SELECT p.skucode,p.storecode,
								CASE WHEN u.member_type=1 THEN p.pricemember_1
								WHEN u.member_type=2 THEN p.pricemember_2
 								ELSE COALESCE(p.price,0) END as price from x_product_price p 
							join x_product_distribution d on d.skucode=p.skucode and d.storecode=p.storecode and d.active='1'
							join x_user u on u.usercode=:usercode1 
							where p.storecode=:storecode) AS subquery
							WHERE x_orderdraft.skucode=subquery.skucode and x_orderdraft.usercode=:usercode2 and isinvoice='0'  ";
				}
				$stmt = $dbh->prepare($query);
				$stmt->bindParam(':usercode1', $usercode, PDO::PARAM_STR,50);
				$stmt->bindParam(':usercode2', $usercode, PDO::PARAM_STR,50);
				$stmt->bindParam(':storecode', $storecode, PDO::PARAM_STR,50);
				if($stmt->execute())
					
				{
					$result = "1";
					echo $result;
				}
				else{
					echo $result;
				}
			}
			else{
				echo $result;
			}
				
		}
	}
	catch(PDOException $e)
	{
		echo $result;
	}
//}
?>