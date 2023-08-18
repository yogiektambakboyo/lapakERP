<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//skucode,storecode,skuname,price,qty,img,dated,orderid,total
	$skucode="-";$storecode="-";$skuname="-";$price="0";$qty="0";$img="-";$dated="-";$orderid="-";$total="0";
	$user=$_POST["usercode"];
	$store=$_POST["storecode"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr=array("skucode"=>$skucode,"storecode"=>$storecode,"skuname"=>$skuname,"price"=>$price,"qty"=>$qty,"img"=>$img,"dated"=>$dated,"orderid"=>$orderid,"total"=>$total);
		}else{
			/**$query = "  select * from (
							select distinct d.orderid,d.seq,f.relatedid as orderid,d.skucode,x.storecode,s.description as skuname,coalesce(d.price,0) as price,d.pcsqty as qty,d.skucode||'.jpg' as img,dated,coalesce(d.price,0)*d.pcsqty as total from x_order_master x 
							join x_order_detail d on d.orderid=x.orderid
							join x_orderdraft f on f.qty=d.pcsqty and f.usercode=x.usercode and f.skucode=d.skucode and f.sequence=d.seq and f.isinvoice='1'
							join x_product_sku s on s.skucode=d.skucode  
							join x_user u on u.usercode=x.usercode 
							where x.usercode=:usercode and x.dated between now() - INTERVAL '30 days' and CURRENT_DATE order by d.orderid,d.seq
						) a order by a.dated desc ";**/
						
			$query = "  select * from (
							select distinct d.orderid,d.seq,d.skucode,x.storecode,s.description as skuname,coalesce(d.price,0) as price,d.pcsqty as qty,d.skucode||'.jpg' as img,dated,coalesce(d.price,0)*d.pcsqty as total from x_order_master x 
							join x_order_detail d on d.orderid=x.orderid
							join x_orderdraft f on f.qty=d.pcsqty and f.usercode=x.usercode and f.skucode=d.skucode and f.sequence=d.seq and f.isinvoice='1'
							join x_product_sku s on s.skucode=d.skucode  
							join x_user u on u.usercode=x.usercode 
							where x.usercode=:usercode and x.dated between now() - INTERVAL '30 days' and CURRENT_DATE order by d.orderid,d.seq
						) a order by a.dated desc ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);	
			//$stmt->bindParam(':storecode', $store, PDO::PARAM_STR,50);	
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$skucode = $row["skucode"];
					$storecode = $row["storecode"];
					$skuname = $row["skuname"];
					$price = $row["price"];
					$qty = $row["qty"];
					$img = $row["img"];
					$dated = $row["dated"];
					$orderid = $row["orderid"];
					$total = $row["total"];
					$arr[]=array("skucode"=>$skucode,"storecode"=>$storecode,"skuname"=>$skuname,"price"=>$price,"qty"=>$qty,"img"=>$img,"dated"=>$dated,"orderid"=>$orderid,"total"=>$total);
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