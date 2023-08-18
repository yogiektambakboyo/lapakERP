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
			$query = " INSERT INTO public.x_log_user_access(usercode, description,ticket) 
						select t.usercode,'History',t.ticket from x_log_user_ticket t
						join x_user u on u.usercode=:usercode and u.usercode=t.usercode
						order by created_date desc limit 1  ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);
			$stmt->execute();
			/**$query = " select CAST(total+deliveryfees as integer) as total,dated,orderid,qty,status,remarks from (select m.remarks,m.deliveryfees,m.orderid,m.dated,((SUM(d.pcsqty*d.price))-(SUM(COALESCE(z.disc_value,0)))) as total,sum(d.pcsqty) as qty,
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
			join x_store_master s on s.storecode=m.storecode
			join x_order_detail d on d.orderid=m.orderid
			left join (select 1 as idx,count(orderid) as jml from x_order_master where isprint='0' and iscanceled='0') a on a.idx=1
			left join x_order_disc z on z.orderid=m.orderid and z.skucode=d.skucode
			left join x_order_master t on t.orderid=m.orderid||'_f'
			where m.usercode=:usercode and m.dated between now() - INTERVAL '30 days' and CURRENT_DATE
			group by m.orderid,m.deliveryfees,a.jml,m.dated,m.iscanceled,m.isprint,s.isdidiws,t.orderid,t.isprint,m.uploadtime,m.remarks order by m.uploadtime desc )  a ";**/
			$query = " select CAST(total+deliveryfees as integer) as total,dated,orderid,qty,status,remarks from (select m.remarks,m.deliveryfees,m.orderid,m.dated,((SUM(d.pcsqty*d.price))-(SUM(COALESCE(z.disc_value,0)))) as total,sum(d.pcsqty) as qty,
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
			join x_store_master s on s.storecode=m.storecode
			join x_order_detail d on d.orderid=m.orderid
			left join (select 1 as idx,count(orderid) as jml from x_order_master where isprint='0' and iscanceled='0') a on a.idx=1
			left join x_order_disc z on z.orderid=m.orderid and z.skucode=d.skucode
			left join x_log_order_forwarded t2 on t2.orderid=m.orderid and t2.orderid=d.orderid
			left join x_order_master t on t.orderid=t2.orderid_forwarded
			where m.usercode=:usercode and m.dated between now() - INTERVAL '30 days' and CURRENT_DATE
			group by m.orderid,m.deliveryfees,a.jml,m.dated,m.iscanceled,m.isprint,s.isdidiws,t.orderid,t.isprint,m.uploadtime,m.remarks order by m.uploadtime desc )  a ";
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