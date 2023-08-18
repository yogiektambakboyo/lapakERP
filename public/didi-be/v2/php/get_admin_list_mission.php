<?php
$method = $_SERVER['HTTP_USER_AGENT'];
$storecode=$_GET["storecode"];
set_time_limit(36000);

//if($method == 'SFA_Borwita_Android'){
	//$city="-";$username="-";$password="-";$name="-";$storecode="-";$usercode="-";$userrealname="-";$address="-";$longitude="0";$latitude="0";
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr=array("code"=>$code,"description"=>$description,"target_value"=>$target_value,"actual_value"=>$actual_value,"start_date"=>$start_date,"end_date"=>$end_date);
		}else{
			$query = "select code,description,target_value,0 as actual_value,start_date::date as start_date,end_date::date as end_date 
						from x_mission where :storecode like '%'||storecode||'%'  and active='1' and now() between start_date and end_date";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':storecode', $storecode, PDO::PARAM_STR,100);
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$code = $row["code"];
					$description = $row["description"];
					$target_value = $row["target_value"];
					$actual_value = $row["actual_value"];
					$start_date = $row["start_date"];
					$end_date = $row["end_date"];
					//,actual_value,start_date,end_date
					$arr[]=array("code"=>$code,"description"=>$description,"target_value"=>$target_value,"actual_value"=>$actual_value,"start_date"=>$start_date,"end_date"=>$end_date);
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

//else{
//	$resultcabang = [];
//	echo json_encode($resultcabang);
//}
?>