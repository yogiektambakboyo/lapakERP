<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//skucode,storecode,skuname,price,qty,img
	$status="0";
	$user=$_POST["usercode"];
	$store=$_POST["storecode"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$status="0";
		}else{
			$query = " INSERT INTO public.x_orderdraft(
						usercode, storecode, skucode, qty, price, sequence, createdate, isinvoice, relatedid, isfrombarcode)
						select x.usercode, b.storecode, s.skucode, 1 as qty,
						case when x.member_type=0 then p.price
						when x.member_type=1 then p.pricemember_1 
						when x.member_type=2 then p.pricemember_2 
						else p.price end as price,to_char(now(),'YYYYMMDDHHIISSMS') as sequence, now() as createdate, '0', NULL, '0'
						from x_product_sku s 
						join x_disc_detail_item i on i.skucode=s.skucode and i.disc_id='FF-ONEBUY5'
						join x_user x on x.usercode=:usercode
						join x_product_subcategory g on g.categorycode=s.categorycode and g.subcategorycode=s.subcategorycode 
						join x_product_distribution b on b.skucode=s.skucode and b.storecode=:storecode  and b.active='1' 
						join x_product_price p on p.skucode=b.skucode and p.storecode=b.storecode
						where s.skucode not in (select skucode from x_orderdraft where usercode=:usercode2 and isinvoice='0' and storecode=:storecode2) ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);	
			$stmt->bindParam(':storecode', $store, PDO::PARAM_STR,50);	
			$stmt->bindParam(':usercode2', $user, PDO::PARAM_STR,50);	
			$stmt->bindParam(':storecode2', $store, PDO::PARAM_STR,50);
			//$stmt->execute();			
			if ($stmt->execute()) {
					$status = "1";
					
					$query = " UPDATE x_orderdraft set isfrompopup=1 where usercode=:usercode and isinvoice='0'  ";
					$stmt = $dbh->prepare($query);
					$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);
					$stmt->execute();
				}	
		}
	}
	catch(PDOException $e)
	{
		echo $status;
	}
	echo $status;
//}
?>