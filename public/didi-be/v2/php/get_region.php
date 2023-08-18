<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	$counter = 0;$stat="500";
	$kode="#";$nama="#";$barcode="0";$price="0";
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr[]=array("kode"=>$kode);
		}else{
			$query = " select DISTINCT CITY as city from x_store_master 
						where city not in ('LAMONGAN','BANDUNG','CIMAHI','CICADAS') and isdidiws='1' and city not like '%DEMO%' and city not like '%DUMM%'  and city not like '%SYSTEM%'
						order by city";
			$stmt = $dbh->prepare($query);
			$stmt->execute();

			while ($row = $stmt->fetch()) {
					$kode = $row["city"];
					$arr[]=array("kode"=>$kode);
					$counter++;
			}
			if($counter==0){
				$arr[]=array("kode"=>$kode);
			}
			$stat="200";
		}
	}
	catch(PDOException $e)
	{
		$stat="100 - ".$e->getMessage();
		$resultcabang = array("kode"=>$kode);
		echo json_encode($resultcabang);
		exit();
	}
	//$resultcabang = array("data"=>$arr,"status"=>$stat,"count"=>$counter);
	$resultcabang = $arr;
	echo json_encode($resultcabang);
//}
?>