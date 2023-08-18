<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//skucode,storecode,skuname,price,qty,img,dated,orderid,total
	$skucode="-";$storecode="-";$skuname="-";$price="0";$qty="0";$img="-";$dated="-";$orderid="-";$total="0";$status="-";
	$user=$_POST["usercode"];
	$store=$_POST["storecode"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr=array("qty"=>$qty,"dated"=>$dated,"orderid"=>$orderid,"total"=>$total,"status"=>$status,"remark"=>"");
		}else{
			$query = "  select * from (
							select distinct remarks as orderid,
							SUM(f.qty) as qty,
							f.createdate::date as dated,
							sum(coalesce(f.price,0)*f.qty) as total,
							'Wishlist' as status,'' as remarks
							from x_order_wishlist f 
							join x_product_sku s on s.skucode=f.skucode  
							join x_user u on u.usercode=f.usercode 
							where f.isinvoice='0' and f.usercode=:usercode 
							group by f.remarks,f.createdate::date
						) a order by dated desc ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);	
			//$stmt->bindParam(':storecode', $store, PDO::PARAM_STR,50);	
			//$stmt->bindParam(':storecode2', $store, PDO::PARAM_STR,50);	
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$qty = $row["qty"];
					$dated = $row["dated"];
					$orderid = $row["orderid"];
					$total = $row["total"];
					$status = $row["status"];
					$remark = $row["remarks"];
					$arr[]=array("qty"=>$qty,"dated"=>$dated,"orderid"=>$orderid,"total"=>$total,"status"=>$status,"remark"=>$remark);
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