<?php
$method = $_SERVER['HTTP_USER_AGENT'];
$imei=$_POST["imei"];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//skucode,storecode,skuname,price,qty,img,dated,orderid,total
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr=array(
							"imei"=>$imei,
							"remarks"=>$remarks,
							"combingcode"=>$combingcode,
							"phone"=>$phone,
							"visit_start"=>$visit_start,
							"visit_end"=>$visit_end,
							"dated"=>$dated,
							"isinstalled"=>$isinstalled,
							"reason"=>$reason,
							"reason_desc"=>$reason_desc,
							"longitude"=>$longitude,
							"latitude"=>$latitude,
							"georeverse"=>$georeverse,
							"notes"=>$notes,
							"isbuy"=>$isbuy
					);
		}else{
			$query = "  select count(distinct o.orderid) as isbuy,c.imei,a.remarks,c.combingcode,c.phone,c.visit_start,c.visit_end,c.dated,c.isinstalled,r.description as reason,c.reason_desc,c.longitude,c.latitude,c.georeverse,coalesce(c.notes,'') notes from x_combing c
						join x_reason r on r.reasoncode=c.reason
						join x_admin_user a on a.deviceid=c.imei 
						left join x_user m on m.username=c.phone
						left join x_order_master o on o.usercode=m.usercode
						where c.imei like :imei 
						group by c.imei,a.remarks,c.combingcode,c.phone,c.visit_start,c.visit_end,c.dated,c.isinstalled,r.description,c.reason_desc,c.longitude,c.latitude,c.georeverse,c.notes";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':imei', $imei, PDO::PARAM_STR,100);
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$isbuy = $row["isbuy"];
					$imei = $row["imei"];
					$remarks = $row["remarks"];
					$combingcode = $row["combingcode"];
					$phone = $row["phone"];
					$visit_start = $row["visit_start"];
					$visit_end = $row["visit_end"];
					$dated = $row["dated"];
					$isinstalled = $row["isinstalled"];
					$reason = $row["reason"];
					$reason_desc = $row["reason_desc"];
					$longitude = $row["longitude"];
					$latitude = $row["latitude"];
					$georeverse = $row["georeverse"];
					$notes = $row["notes"];
					$arr[]=array(
							"imei"=>$imei,
							"remarks"=>$remarks,
							"combingcode"=>$combingcode,
							"phone"=>$phone,
							"visit_start"=>$visit_start,
							"visit_end"=>$visit_end,
							"dated"=>$dated,
							"isinstalled"=>$isinstalled,
							"reason"=>$reason,
							"reason_desc"=>$reason_desc,
							"longitude"=>$longitude,
							"latitude"=>$latitude,
							"georeverse"=>$georeverse,
							"notes"=>$notes,
							"isbuy"=>$isbuy
					);
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