<?php
$method = $_SERVER['HTTP_USER_AGENT'];
$usercode=$_POST["usercode"];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr[]=array("name"=>$name,"storename"=>$storename);
		}else{
			$query = "select distinct usercode as name,name as storename from x_user where issuspend='0' and city in 
(
	select distinct s.city from x_admin_user u
	join x_admin_link l on l.adminid=u.adminid
	join x_store_master s on s.storecode=l.storecode
	where deviceid=:usercode
) and usercode>0 order by name";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $usercode, PDO::PARAM_STR,100);
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$name = $row["name"];
					$storename = $row["storename"];
					$arr[]=array("name"=>$name,"storename"=>$storename);
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