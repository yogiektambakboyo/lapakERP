<?php
$method = $_SERVER['HTTP_USER_AGENT'];
$deviceid=$_POST["deviceid"];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr[]=array("address"=>$address,"storecode"=>$storecode,"storename"=>$name,"lastconnect"=>$lastconnect,"status"=>$status);
		}else{
			$query = " select l.storecode,m.name,m.address,max(COALESCE(to_char(a.createdate,'YYYY-MM-DD HH24:MI:SS'),'2017-01-01 00:00')) as lastconnect,sum(case when isprint='0' and iscanceled='0' then 1 else 0 end) as status from x_admin_user u
						join x_admin_link l on l.adminid=u.adminid
						join x_store_master m on m.storecode=l.storecode
						left join (select users,max(createdate) as createdate from x_log_activity group by users) a on a.users=m.storecode
						left join x_order_master o on o.storecode=m.storecode
						where u.deviceid=:deviceid
						group by l.storecode,m.name,m.address  ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':deviceid', $deviceid, PDO::PARAM_STR,50);
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$storecode = $row["storecode"];
					$name = $row["name"];
					$lastconnect = $row["lastconnect"];
					$address = $row["address"];
					$status = $row["status"];
					$arr[]=array("address"=>$address,"storecode"=>$storecode,"storename"=>$name,"lastconnect"=>$lastconnect,"status"=>$status);
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