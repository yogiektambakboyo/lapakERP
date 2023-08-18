<?php
$method = $_SERVER['HTTP_USER_AGENT'];
$citys=$_GET["city"];
$usercode=$_GET["usercode"];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	$city="-";$username="-";$password="-";$name="-";$storecode="-";$usercode="-";$userrealname="-";$address="-";$longitude="0";$latitude="0";
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr=array("usercode"=>$usercode,"name"=>$name,"address"=>$address);
		}else{
			$query = "select usercode,name,address from x_user where city=:city and active='1' and isposadmin='0' order by name";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':city', $citys, PDO::PARAM_STR,100);
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