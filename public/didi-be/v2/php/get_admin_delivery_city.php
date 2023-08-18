<?php
$method = $_SERVER['HTTP_USER_AGENT'];
$provinceid=$_POST["provinceid"];
$usercode="0";$address="0";$latitude="0";$longitude="0";$handphone="0";$name="-";
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr=array("description"=>$description,"code"=>$code);
		}else{
			$query = " select cityid as code,cityname as description from x_province where provinceid=:provinceid ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':provinceid', $provinceid, PDO::PARAM_STR,50);
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$code = $row["code"];
					$description = $row["description"];
					$arr[]=array("description"=>$description,"code"=>$code);
				}	
		}
	}
	catch(PDOException $e)
	{
		$arr=array("description"=>$description,"code"=>$code);
		echo $arr;
	}
	$resultcabang = $arr;
	echo json_encode($resultcabang);
//}
?>