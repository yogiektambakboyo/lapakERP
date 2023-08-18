<?php
$method = $_SERVER['HTTP_USER_AGENT'];
$user=$_POST["usercode"];
$tipe=$_POST["tipe"];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr[]=array("file_attachment"=>$file_attachment,"id"=>$id,"usercode"=>$usercode,"nominal"=>$nominal,"isapproved"=>$isapproved,"created_date"=>$created_date);
		}else{
			
			$query = " insert into x_deposit select usercode,0,now(),now(),encrypt(CAST((0) as character varying)::bytea,CAST('xXDIDI123Xx' as bytea),CAST('aes' as text))::character varying from x_user where usercode not in (select usercode from x_deposit) ";
			$stmt = $dbh->prepare($query);
			$stmt->execute();
			
			
			$query = " select id,usercode,nominal,isapproved,coalesce(file_attachment,'-') file_attachment,to_char(created_date,'YYYY-MM-DD') created_date from x_deposit_order d where bank_account=:user order by created_date desc ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':user', $user, PDO::PARAM_STR,100);
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$id = $row["id"];
					$nominal = $row["nominal"];
					$isapproved = $row["isapproved"];
					$file_attachment = $row["file_attachment"];
					$created_date = $row["created_date"];
					$usercode = $row["usercode"];
					$file_attachment = $row["file_attachment"];
					$arr[]=array("file_attachment"=>$file_attachment,"id"=>$id,"usercode"=>$usercode,"nominal"=>$nominal,"isapproved"=>$isapproved,"created_date"=>$created_date);
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