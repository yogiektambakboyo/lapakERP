<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//skucode,storecode,skuname,price,qty,img
	$status="0";
	$user=$_POST["orderid"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$status="0";
		}else{
	$query = " delete from x_orderdraft where isinvoice='0' and skucode||usercode||storecode in (
				select d.skucode||m.usercode||m.storecode from x_order_master m
				join x_order_detail d on d.orderid=m.orderid 
				join x_orderdraft f on f.qty=d.pcsqty and f.usercode=m.usercode and f.storecode=m.storecode and f.skucode=d.skucode and f.sequence=d.seq and f.isinvoice='0' where m.orderid=:orderid) ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':orderid', $user, PDO::PARAM_STR,50);	
			$stmt->execute();
			
			$query = " insert into x_orderdraft(usercode,storecode,skucode,qty,price,sequence,createdate,isinvoice) 
						select m.usercode,ux.storecode,d.skucode,d.pcsqty+d.caseqty as qty,p.price,d.seq,now()::timestamp,'0' from x_order_master m 
						join x_order_detail d on d.orderid=m.orderid 
						join x_user ux on ux.usercode=m.usercode
						join x_product_sku s on s.skucode=d.skucode 
						join x_product_distribution b on b.skucode=s.skucode and b.storecode=ux.storecode 
						join x_product_price p on p.skucode=s.skucode and p.skucode=s.skucode and p.storecode=ux.storecode 
						where m.orderid=:orderid  ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':orderid', $user, PDO::PARAM_STR,50);				
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