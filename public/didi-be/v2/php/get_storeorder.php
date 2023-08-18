<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//skucode,storecode,skuname,price,qty,img,dated,orderid,total
	$skucode="-";$storecode="-";$skuname="-";$price="0";$qty="0";$img="-";$dated="-";$orderid="-";$total="0";$totalinv="0";$name="0";$picktime="0";$remarks="0";$storename="-";$address="-";$city="-";
	$store=$_POST["storecode"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr=array("storename"=>$storename,"address"=>$city,"city"=>$city,"skucode"=>$skucode,"storecode"=>$storecode,"skuname"=>$skuname,"price"=>$price,"qty"=>$qty,"dated"=>$dated,"orderid"=>$orderid,"total"=>$total,"picktime"=>$picktime,"remarks"=>$remarks,"totalinv"=>$totalinv,"name"=>$name);
		}else{
			$query = " INSERT INTO public.x_log_activity(users, description, createdate) VALUES (:storecode, 'ACCESS WS', now()::timestamp);  ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':storecode', $store, PDO::PARAM_STR,50);
			$stmt->execute();		
			

			$query = "  UPDATE x_order_master set isprint='1' WHERE usercode in (select usercode from x_user where isneedprint='0') ";
			$stmt = $dbh->prepare($query);
			$stmt->execute();		
			
			
			//skucode,storecode,skuname,price,qty,dated,orderid,total,picktime,remarks,totalinv,name
			$query = "   select f.name as storename,f.address,f.city,d.skucode,x.storecode,s.printdesc as skuname,coalesce(d.price,0) as price,d.pcsqty as qty,dated,x.orderid,d.total,x.picktime,COALESCE(x.remarks,'-') as remarks,(x.total-COALESCE(j.disc_value,0)) as totalinv,u.name
						 from x_order_master x 
						 join x_order_detail d on d.orderid=x.orderid 
						 join x_product_sku s on s.skucode=d.skucode  
						 join x_user u on u.usercode=x.usercode and u.isneedprint='1' 
						 join x_store_master f on f.storecode=x.storecode
						 left join x_product_price p on p.skucode=d.skucode and p.storecode=:storecode
						 left join (select orderid,sum(disc_value) as disc_value from x_order_disc group by orderid) j on j.orderid=x.orderid 
						 where x.orderid=(select orderid from x_order_master where storecode=:storecode2 and isprint='0' and iscanceled='0' limit 1) order by d.orderid,d.seq  ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':storecode2', $store, PDO::PARAM_STR,50);	
			$stmt->bindParam(':storecode', $store, PDO::PARAM_STR,50);	
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$skucode = $row["skucode"];
					$storecode = $row["storecode"];
					$skuname = $row["skuname"];
					$price = $row["price"];
					$qty = $row["qty"];
					$dated = $row["dated"];
					$orderid = $row["orderid"];
					$total = $row["total"];
					$totalinv = $row["totalinv"];
					$picktime = $row["picktime"];
					$remarks = $row["remarks"];
					$name = $row["name"];
					$storename = $row["storename"];
					$city = $row["city"];
					$address = $row["address"];
					$arr[]=array("storename"=>$storename,"address"=>$address,"city"=>$city,"skucode"=>$skucode,"storecode"=>$storecode,"skuname"=>$skuname,"price"=>$price,"qty"=>$qty,"dated"=>$dated,"orderid"=>$orderid,"total"=>$total,"picktime"=>$picktime,"remarks"=>$remarks,"totalinv"=>$totalinv,"name"=>$name);
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