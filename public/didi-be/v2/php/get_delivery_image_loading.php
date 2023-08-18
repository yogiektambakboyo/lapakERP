<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr[]=array("path"=>$code,"showtime"=>$description);
		}else{
			$query = " select path as code,showtime as description from x_image where now() between start_date and end_date and active='1' ";
			$stmt = $dbh->prepare($query);
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$code = $row["code"];
					$description = $row["description"];
					$arr[]=array("path"=>$code,"showtime"=>$description);
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