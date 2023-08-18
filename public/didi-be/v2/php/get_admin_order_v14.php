<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//skucode,storecode,skuname,price,qty,img,dated,orderid,total
	$skucode="-";$storecode="-";$skuname="-";$price="0";$qty="0";$img="-";$dated="-";$orderid="-";$total="0";$storeallocate="0";
	$user=$_POST["usercode"];
	$store=$_POST["storecode"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr=array("storeallocate"=>$storeallocate,"remarks"=>"","skucode"=>$skucode,"storecode"=>$storecode,"skuname"=>$skuname,"price"=>$price,"qty"=>$qty,"img"=>$img,"dated"=>$dated,"orderid"=>$orderid,"total"=>$total);
		}else{
			$query = "  select CASE WHEN a.storecode IS NULL OR x.storecode=a.storecode THEN '-' ELSE g.name END as storeallocate,x.remarks,e.name as storename,d.skucode,x.storecode,s.description as skuname,coalesce(d.price,0) as price,d.pcsqty as qty,d.skucode||'.jpg' as img,dated,x.orderid,d.total 
						from x_order_master x 
						join x_order_detail d on d.orderid=x.orderid 
						join x_product_sku s on s.skucode=d.skucode  
						join x_user e on e.usercode=x.usercode
						left join x_order_allocate a on a.orderid=x.orderid and a.skucode=d.skucode
						left join x_store_master g on g.storecode=a.storecode
						where x.storecode=:storecode and x.dated>=now()- interval '30 day' order by d.orderid,d.seq ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':deviceid', $user, PDO::PARAM_STR,50);	
			$stmt->bindParam(':storecode', $store, PDO::PARAM_STR,50);	
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
					$storename = $row["storename"];
					$remarks = $row["remarks"];
					$storeallocate = $row["storeallocate"];
					$arr[]=array("storeallocate"=>$storeallocate,"remarks"=>$remarks,"skucode"=>$skucode,"storecode"=>$storecode,"skuname"=>$skuname,"price"=>$price,"qty"=>$qty,"img"=>$img,"dated"=>$dated,"orderid"=>$orderid,"total"=>$total);
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