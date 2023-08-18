<?php
$method = $_SERVER['HTTP_USER_AGENT'];
$storecode=$_POST["storecode"];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//$city="-";$username="-";$password="-";$name="-";$storecode="-";$usercode="-";$userrealname="-";$address="-";$longitude="0";$latitude="0";
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr=array("usercode"=>$usercode,"name"=>$name,"address"=>$address);
		}else{
			$query = "select distinct u.usercode,u.name,case when c.usercode is null then 'Belum' ELSE 'Komplit - ORDER ID '||c.orderid END as address from x_user u 
						left join (select max(orderid) as orderid,usercode from (
								select orderid,usercode,(pcsqty-(pcsqty%2))*disc_value as disc_val from (
									select m.orderid,m.usercode,min(pcsqty) as pcsqty,i.disc_value from x_order_master m
									join x_mission s on now() between s.start_date and s.end_date 
									join x_order_detail d on d.orderid=m.orderid
									join x_disc_detail_item i on i.disc_id='FF-500x' and i.skucode=d.skucode
									join x_user fg on fg.isposadmin='0' and fg.city='KUTA JAYA'
									where m.storecode=:storecode and m.uploadtime between s.start_date and s.end_date 
									and m.iscanceled='0' and m.isprint='1' and d.pcsqty>=i.min_qty and d.pcsqty<=i.max_qty
									group by m.orderid,m.usercode,i.disc_value
								) a ) b group by usercode 
						) c on c.usercode=u.usercode
						where u.isposadmin='0' and u.city='KUTA JAYA' ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':storecode', $storecode, PDO::PARAM_STR,100);
			$stmt->bindParam(':storecode2', $storecode, PDO::PARAM_STR,100);
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$usercode = $row["usercode"];
					$name = $row["name"];
					$address = $row["address"];
					$arr[]=array("usercode"=>$usercode,"name"=>$name,"address"=>$address);
				}	
		}
	}
	catch(PDOException $e)
	{
		echo $e->getMessage();
		$resultcabang = $arr;
		echo json_encode($resultcabang);
	}
	$resultcabang = $arr;
	echo json_encode($resultcabang);
//}
?>