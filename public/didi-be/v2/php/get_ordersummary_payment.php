<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//skucode,storecode,skuname,price,qty,img,dated,orderid,total
	$skucode="-";$storecode="-";$skuname="-";$price="0";$qty="0";$img="-";$dated="-";$orderid="-";$total="0";$status="-";$name="-";
	$user=$_POST["usercode"];
	$store=$_POST["storecode"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr=array("qty"=>$qty,"dated"=>$dated,"orderid"=>$orderid,"total"=>$total,"status"=>$status,"name"=>$name);
		}else{
			$query = "  select u.name,m.orderid,dated,m.total-(sum(coalesce(s.disc_value,0))) as total,sum(d.pcsqty) as qty,
 case when coalesce(y.nominal_outstanding,0)>0 then COALESCE(e.description,'Tunai')||coalesce(y.nominal_outstanding,0) 
	  when coalesce(y.nominal_outstanding,0)<=0 then COALESCE(e.description,'Tunai')||' '											
													end as status 
						from x_order_master m
						join x_order_detail d on d.orderid=m.orderid
						join x_user u on u.usercode=m.usercode
						left join x_order_payment y on y.orderid=m.orderid
						left join x_payment e on e.id=y.paymentid
						left JOIN x_order_disc s on s.orderid=d.orderid and s.skucode=d.skucode
						left join (select storecode,count(orderid) as jml from x_order_master where isprint='0' and iscanceled='0' and storecode=:storecode2 group by storecode) a on a.storecode=m.storecode
						where m.storecode=:storecode and m.dated between now() - INTERVAL '30 days' and CURRENT_DATE
						group by y.nominal_outstanding,e.description,u.name,m.orderid,dated,m.total,a.jml order by m.orderid desc ";
			$stmt = $dbh->prepare($query);	
			$stmt->bindParam(':storecode', $store, PDO::PARAM_STR,50);	
			$stmt->bindParam(':storecode2', $store, PDO::PARAM_STR,50);	
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$qty = $row["qty"];
					$dated = $row["dated"];
					$orderid = $row["orderid"];
					$total = $row["total"];
					$status = $row["status"];
					$name = $row["name"];
					$arr[]=array("qty"=>$qty,"dated"=>$dated,"orderid"=>$orderid,"total"=>$total,"status"=>$status,"name"=>$name);
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