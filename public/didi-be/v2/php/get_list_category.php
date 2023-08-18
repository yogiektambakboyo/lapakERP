<?php
$method = $_SERVER['HTTP_USER_AGENT'];
$usercode=$_GET["usercode"];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//$city="-";$username="-";$password="-";$name="-";$storecode="-";$usercode="-";$userrealname="-";$address="-";$longitude="0";$latitude="0";
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr=array("usercode"=>$usercode,"name"=>$name,"address"=>$address);
		}else{
			$query = "select categorycode as usercode,categoryname as name,'Aktif = '||CAST(active as character varying(1)) as address from x_product_category where  created_by=:created_by and active='1' order by categoryname";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':created_by', $usercode, PDO::PARAM_STR,100);
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

//else{
//	$resultcabang = [];
//	echo json_encode($resultcabang);
//}
?>