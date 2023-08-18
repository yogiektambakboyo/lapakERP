<?php
$method = $_SERVER['HTTP_USER_AGENT'];
$usercode=$_POST["usercode"];
$tipe=$_POST["tipe"];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	$code="-";$product_name="-";$price="-";$name="-";
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr[]=array("prefix"=>$prefix,"product_name"=>$product_name);
		}else{
			$query = "SELECT product_name,coalesce(prefix,'-') as prefix FROM public.x_ppob_operator_invoice where pembeliankategori_id=:tipe ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $usercode, PDO::PARAM_STR,100);
			$stmt->bindParam(':tipe', $tipe, PDO::PARAM_STR,100);
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$product_name = $row["product_name"];
					$prefix = $row["prefix"];
					$arr[]=array("prefix"=>$prefix,"product_name"=>$product_name);
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