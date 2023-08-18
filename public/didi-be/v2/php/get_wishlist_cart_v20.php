<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//skucode,storecode,skuname,price,qty,img
	$status="0";
	$orderid=$_POST["orderid"];
	$usercode=$_POST["usercode"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$status="0";
		}else{
			$query = " delete from x_orderdraft where isinvoice='0' and skucode||usercode in (
				select m.skucode||m.usercode from x_order_wishlist m
				where m.remarks=:remarks and m.usercode=:usercode and isinvoice='0'
			) ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $usercode, PDO::PARAM_STR,50);	
			$stmt->bindParam(':remarks', $orderid, PDO::PARAM_STR,50);	
			$stmt->execute();
			
			$query = " insert into x_orderdraft(usercode,storecode,skucode,qty,price,sequence,createdate,isinvoice,relatedid) 
						select m.usercode,u.storecode,m.skucode,m.qty as qty,p.price+(((p.price*p.up_values))/100) as price,m.sequence,now()::timestamp,'0',TO_CHAR(NOW(),'YYYYMMDDHHMI')||'-OR-'||u.storecode||m.usercode 
						from x_order_wishlist m
						join x_user u on u.usercode=m.usercode
						join x_product_sku s on s.skucode=m.skucode 
						join x_store_master k on k.storecode=u.storecode
						join x_store_master l on l.storecode=k.relatedws
						left join x_product_distribution b on b.skucode=s.skucode and b.storecode=l.storecode 
						join x_product_price p on p.skucode=s.skucode and p.skucode=s.skucode and p.storecode=l.storecode
						where m.remarks=:remarks and m.usercode=:usercode";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $usercode, PDO::PARAM_STR,50);	
			$stmt->bindParam(':remarks', $orderid, PDO::PARAM_STR,50);			
			if ($stmt->execute()) {
					$status = "1";
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