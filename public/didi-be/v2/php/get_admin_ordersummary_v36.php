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
			$arr=array("storeallocate"=>"0","storename"=>$storename,"qty"=>$qty,"dated"=>$dated,"orderid"=>$orderid,"total"=>$total,"status"=>$status);
		}else{
			$query = "  select storeallocate,storename,orderid,dated,total,sum(qty) as qty,status from (select m.uploadtime,CASE WHEN ax.orderid IS NULL OR ax.storecode=m.storecode OR v.orderid IS NULL THEN '0' ELSE '1' END as storeallocate,e.name as storename,m.orderid,dated,m.total,sum(d.pcsqty) as qty,case when isdelivered='1' and iscanceled='0' then 'TERKIRIM' when iscanceled='1' THEN 'BATAL' when iscanceled='0' AND isprint='0' AND a.jml<=1 and m.uploadtime>=now()::timestamp- interval '10 minutes' THEN 'TERPROSES' when iscanceled='0' AND isprint='0' AND sum(a.jml)>1 THEN 'ANTRI' WHEN iscanceled='0' AND isprint='1' THEN 'TERCETAK' ELSE 'ANTRI' END as status 
						from x_order_master m
						join x_order_detail d on d.orderid=m.orderid
						join x_admin_link l on l.storecode=m.storecode
						join x_user e on e.usercode=m.usercode
						join x_admin_user u on u.adminid=l.adminid  and u.deviceid=:deviceid
						left join (select storecode,count(orderid) as jml from x_order_master where isprint='0' and iscanceled='0' group by storecode) a on a.storecode=m.storecode
						left join x_order_allocate ax on ax.orderid=d.orderid and ax.skucode=d.skucode
						left join x_order_detail v on v.orderid=d.orderid||'_f'||ax.storecode and v.skucode=d.skucode
						where m.storecode=:storecode and m.dated>=now()- interval '30 day'
						group by v.orderid,m.uploadtime,m.storecode,ax.storecode,ax.orderid,m.orderid,dated,m.total,a.jml,e.name order by m.uploadtime desc
	) s group by storeallocate,storename,orderid,dated,total,status,uploadtime order by uploadtime desc ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':deviceid', $user, PDO::PARAM_STR,50);	
			$stmt->bindParam(':storecode', $store, PDO::PARAM_STR,50);	
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$qty = $row["qty"];
					$dated = $row["dated"];
					$orderid = $row["orderid"];
					$total = $row["total"];
					$status = $row["status"];
					$storename = $row["storename"];
					$storeallocate = $row["storeallocate"];
					$arr[]=array("storeallocate"=>$storeallocate,"storename"=>$storename,"qty"=>$qty,"dated"=>$dated,"orderid"=>$orderid,"total"=>$total,"status"=>$status);
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