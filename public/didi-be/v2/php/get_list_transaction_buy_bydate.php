<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//skucode,storecode,skuname,price,qty,img,dated,orderid,total
	$skucode="-";$storecode="-";$skuname="-";$price="0";$qty="0";$img="-";$dated="-";$orderid="-";$total="0";$status="-";$name="-";
	$user=$_POST["usercode"];
	$store=$_POST["storecode"];
	$begindate=$_POST["begindate"];
	$enddate=$_POST["enddate"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr=array("qty"=>$qty,"dated"=>$dated,"orderid"=>$orderid,"total"=>$total,"status"=>$status,"name"=>$name);
		}else{
			$query = "  select u.name,m.orderid,dated,m.total-(sum(coalesce(s.disc_value,0))) as total,sum(d.pcsqty) as qty,case when iscanceled='1' THEN 'BATAL' when iscanceled='0' AND isprint='0' AND a.jml<=1 and m.uploadtime>=now()::timestamp- interval '10 minutes' THEN 'TERPROSES' when iscanceled='0' AND isprint='0' AND sum(a.jml)>1 THEN 'ANTRI' WHEN iscanceled='0' AND isprint='1' THEN 'TERCETAK' ELSE 'ANTRI' END as status 
						from x_order_master m
						join x_order_detail d on d.orderid=m.orderid
						join x_user u on u.usercode=m.usercode
						join x_partner p on p.handphone=u.phoneno
						left join x_order_disc s on s.orderid=d.orderid and s.skucode=d.skucode
						left join (select storecode,count(orderid) as jml from x_order_master where isprint='0' and iscanceled='0' and storecode=:storecode group by storecode) a on a.storecode=m.storecode
						where u.usercode=:usercode and m.dated between :begindate and :enddate
						group by u.name,m.orderid,dated,m.total,a.jml order by m.orderid desc  ";
			$stmt = $dbh->prepare($query);	
			$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);	
			$stmt->bindParam(':begindate', $begindate, PDO::PARAM_STR,50);	
			$stmt->bindParam(':enddate', $enddate, PDO::PARAM_STR,50);	
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