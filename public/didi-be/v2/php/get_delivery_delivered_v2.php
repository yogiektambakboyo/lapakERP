<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//skucode,storecode,skuname,price,qty,img
	$status="0";
	$orderid=$_POST["orderid"]."%";
	$orderids=$_POST["orderid"];
	$user=$_POST["usercode"];
	$reason=$_POST["reason"];
	$skucode=$_POST["skucode"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$status="0";
		}else{
			
			$query = " update x_order_master set isdelivered='1' where orderid like :orderid ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':orderid', $orderid, PDO::PARAM_STR,50);				
						
			if ($stmt->execute()) {
					$status = "1";
					$query = " update x_delivery_task set isdelivered='1' where order_id like :orderid and delivery_id=:usercode ";
					$stmt = $dbh->prepare($query);
					$stmt->bindParam(':orderid', $orderid, PDO::PARAM_STR,50);
					$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);
					$stmt->execute();	

					$query = " insert into x_order_detail_delivery(orderid,skucode,qty) 
								select orderid,skucode,pcsqty from x_order_detail where orderid like :orderid and skucode not in (".$skucode.")";
					$stmt = $dbh->prepare($query);
					$stmt->bindParam(':orderid', $orderids, PDO::PARAM_STR,50);
					$stmt->execute();	

					$partner_id = "0";
					$counters = 0;
					$query = " select p.id from x_user u join x_partner p on p.handphone=u.phoneno where u.usercode=:usercode  ";
					$stmt = $dbh->prepare($query);
					$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);		
					$stmt->execute();			
					while ($row = $stmt->fetch()) {
							$partner_id = $row["id"];
							$counters++;
					}
					
					if($counters>0){
							$query = " insert into x_product_hpp(storecode,skucode,price,created_date,stock_values,stock_qty)
										select s.storecode,k.skucode,
										case 
										when sum(coalesce(w.stock_values,0))>0 then cast((sum(coalesce(w.stock_values,0))+sum(d.total))/(sum(coalesce(w.stock_qty,0))+sum(d.pcsqty)) as bigint) 
										else d.price end
											as price,
										now(),
										case 
										when sum(coalesce(w.stock_values,0))>0 then cast((sum(coalesce(w.stock_values,0))+sum(d.total))/2 as bigint) 
										else cast(sum(d.total) as bigint)  end
											as stock_value,
										case 
										when sum(coalesce(w.stock_qty,0))>0 then cast((sum(coalesce(w.stock_qty,0))+sum(d.pcsqty))/2 as bigint) 
										else cast(sum(d.pcsqty) as bigint) end
											as stock_qty from
										x_partner p
										join x_user u on u.phoneno=p.handphone
										join x_store_master s on s.phoneno=p.handphone
										join x_order_master o on o.usercode=u.usercode and o.orderid=:orderid
										join x_partner_membership_sku k on k.id=p.membership
										join x_order_detail d on d.orderid=o.orderid and d.skucode=k.skucode
										left join (
											select storecode,skucode,price,stock_values,stock_qty from (select row_number() over(PARTITION BY storecode,skucode order by created_date desc) as uniquecode
											,storecode,skucode,price,stock_values,stock_qty
											from x_product_hpp
											group by storecode,skucode,created_date
											) b where uniquecode=1
										) w on w.storecode=s.storecode and w.skucode=k.skucode and w.skucode=d.skucode
										where p.status='1'
										group by s.storecode,k.skucode,d.price; ";
							$stmt = $dbh->prepare($query);
							$stmt->bindParam(':orderid', $orderids, PDO::PARAM_STR,50);
							$stmt->execute();
							
							
							$query = " UPDATE x_product_stock
								SET qty=(qty+subquery.pcsqty)
								FROM (select u.storecode,d.skucode,d.pcsqty from x_order_master m
										join x_order_detail d on d.orderid=m.orderid
										join x_user u on u.usercode=m.usercode
								where m.orderid=:orderid) 
								AS subquery
								WHERE x_product_stock.storecode=subquery.storecode and x_product_stock.skucode=subquery.skucode; ";
							$stmt = $dbh->prepare($query);
							$stmt->bindParam(':orderid', $orderids, PDO::PARAM_STR,50);
							$stmt->execute();
							
							$query = " INSERT INTO public.x_log_product_stock(
								storecode, skucode, qty, description, created_date)
								select m.storecode,d.skucode,d.pcsqty,' ORD ADD - '||m.orderid,now() from x_order_master m
								join x_order_detail d on d.orderid=m.orderid
								where m.orderid=:orderid; ";
							$stmt = $dbh->prepare($query);
							$stmt->bindParam(':orderid', $orderids, PDO::PARAM_STR,50);
							$stmt->execute();
					}
					
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