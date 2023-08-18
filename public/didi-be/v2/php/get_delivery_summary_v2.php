<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//skucode,storecode,skuname,price,qty,img,dated,orderid,total
	$skucode="-";$storecode="-";$skuname="-";$price="0";$qty="0";$img="-";$dated="-";$orderid="-";$total="0";$status="-";$address="-";
	$user=$_POST["usercode"];
	$store=$_POST["storecode"];
	$isdelivered=$_POST["isdelivered"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr=array("isovertime"=>$isovertime,"longitude"=>$longitude,"latitude"=>$latitude,"qty"=>$qty,"dated"=>$dated,"orderid"=>$orderid,"total"=>$total,"status"=>$status,"remark"=>"","users"=>$users,"storename"=>$storename,"address"=>$address);
		}else{
			$query = " INSERT INTO public.x_log_user_access(usercode, description,ticket) 
						select t.usercode,'History Delivery',t.ticket from x_log_user_ticket t
						select t.usercode,'History ',t.ticket from x_log_user_ticket t
						join x_user u on u.usercode=:usercode and u.usercode=t.usercode
						order by created_date desc limit 1  ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);
			$stmt->execute();
			
			$query = " select latitude,longitude,
case when trim(to_char(current_date,'day'))=day_name and time_out>current_time::time then '1' else '0' end as isovertime
,address,users,storename,CAST(total+deliveryfees as integer) as total,dated,orderid,qty,status,remarkx as remarks from (select coalesce(u.longitude,'0') as longitude,coalesce(u.latitude,'0') as latitude,w.time_out,w.day_name,u.address,u.name as users,s.name as storename,case when y.isprogress='1' then ' - JOB ACTIVE - '||m.remarks else m.remarks end as remarkx,m.deliveryfees,m.orderid,m.dated,((SUM(d.pcsqty*d.price))-(SUM(COALESCE(z.disc_value,0)))) as total,sum(d.pcsqty) as qty,
			case when m.iscanceled='1' THEN 'BATAL' 
			when m.iscanceled='0' AND s.isdidiws='0' AND m.isprint='0' AND a.jml<=1 THEN 'TERPROSES' 
			when m.iscanceled='0' AND s.isdidiws='0'  AND m.isprint='0' AND a.jml>1 THEN 'ANTRI' 
			WHEN m.iscanceled='0' AND s.isdidiws='0'  AND m.isprint='1' THEN 'TERCETAK'
			when m.iscanceled='0' AND s.isdidiws='0'  AND s.isdidiws='1' THEN 'TERPROSES' 
			when m.iscanceled='0' AND s.isdidiws='1' AND t.orderid IS NULL THEN 'ANTRI'
			when m.iscanceled='0' AND s.isdidiws='1' AND t.orderid IS NOT NULL AND t.isprint='0' THEN 'TERPROSES' 
			when m.iscanceled='0' AND s.isdidiws='1' AND t.orderid IS NOT NULL AND t.isprint='1' THEN 'TERCETAK' 
			ELSE 'ANTRI' END as status 
			from x_order_master m
			join x_delivery_task y on y.order_id=m.orderid and y.isdelivered=:isdelivered and y.delivery_id=:usercode
			join x_store_master s on s.storecode=m.storecode
			join x_order_detail d on d.orderid=m.orderid
			join x_user u on u.usercode=m.usercode
			left join x_delivery_time_sheet w on w.day_name=trim(to_char(m.dated, 'day'))
			left join (select 1 as idx,count(orderid) as jml from x_order_master where isprint='0' and iscanceled='0') a on a.idx=1
			left join x_order_disc z on z.orderid=m.orderid and z.skucode=d.skucode
			left join x_log_order_forwarded t2 on t2.orderid=m.orderid and t2.orderid=d.orderid
			left join x_order_master t on t.orderid=t2.orderid_forwarded
			left join x_user ux on ux.usercode=t.usercode
			where m.iscanceled='0' and m.isdelivered=:isdelivered2 and m.dated between now() - INTERVAL '1800 days' and CURRENT_DATE
			group by u.longitude,u.latitude,w.time_out,w.day_name,y.isprogress,ux.name,u.address,u.name,s.name,m.orderid,m.deliveryfees,a.jml,m.dated,m.iscanceled,m.isprint,s.isdidiws,t.orderid,t.isprint,m.uploadtime,m.remarks order by m.uploadtime desc )  a  ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);	
			$stmt->bindParam(':isdelivered', $isdelivered, PDO::PARAM_STR,50);	
			$stmt->bindParam(':isdelivered2', $isdelivered, PDO::PARAM_STR,50);		
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$qty = $row["qty"];
					$dated = $row["dated"];
					$orderid = $row["orderid"];
					$total = $row["total"];
					$status = $row["status"];
					$remark = $row["remarks"];
					$users = $row["users"];
					$storename = $row["storename"];
					$address = $row["address"];
					$latitude = $row["latitude"];
					$longitude = $row["longitude"];
					$isovertime = $row["isovertime"];
					$arr[]=array("isovertime"=>$isovertime,"longitude"=>$longitude,"latitude"=>$latitude,"qty"=>$qty,"dated"=>$dated,"orderid"=>$orderid,"total"=>$total,"status"=>$status,"remark"=>$remark,"users"=>$users,"storename"=>$storename,"address"=>$address);
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