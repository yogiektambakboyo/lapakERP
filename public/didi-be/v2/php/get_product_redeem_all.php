<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
	$counter = 0;$stat="500";
//if($method == 'SFA_Borwita_Android'){
	$poin="0";$status="";$created_dated="";$description="Tidak ada data";$name="";$redeem_id="";
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr[]=array("name"=>$name,"redeem_id"=>$redeem_id,"poin"=>$poin,"status"=>$status,"created_dated"=>$created_dated,"description"=>$description);
		}else{
			$query = " select u.name,r.usercode,r.id as redeem_id,r.poin,r.status,r.created_dated::date as created_dated,p.skucode,s.description from x_poin_redeem_user r
						join x_poin_redeem p on p.id=r.redeem_id
						join x_user u on u.usercode=r.usercode
						join x_product_sku s on s.skucode=p.skucode order by r.created_dated::date desc ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $usercode, PDO::PARAM_STR,50);		
			$stmt->execute();
			$counter = 0;
			while ($row = $stmt->fetch()) {
					$name = $row["name"];
					$poin = $row["poin"];
					$redeem_id = $row["redeem_id"];
					$status = $row["status"];
					$created_dated = $row["created_dated"];
					$description = $row["description"];
					$arr[]=array("name"=>$name,"redeem_id"=>$redeem_id,"poin"=>$poin,"status"=>$status,"created_dated"=>$created_dated,"description"=>$description);
					$counter++;
				}
			if($counter==0){
				$arr[]=array("name"=>$name,"redeem_id"=>$redeem_id,"poin"=>$poin,"status"=>$status,"created_dated"=>$created_dated,"description"=>$description);
			}
			$stat="200";
		}
	}
	catch(PDOException $e)
	{
		$stat="100 - ".$e->getMessage();
		$resultcabang = array("data"=>$arr,"status"=>$stat,"count"=>$counter);
		echo json_encode($resultcabang);
		exit();
	}
	//$resultcabang = array("data"=>$arr,"status"=>$stat,"count"=>$counter);
	$resultcabang = $arr;
	echo json_encode($resultcabang);
//}
?>