<?php
$method = $_SERVER['HTTP_USER_AGENT'];
$user=$_POST["usercode"];
set_time_limit(36000);
//if($method == 'DIDI_POS_Mobile'){
	//
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr[]=array("bank_name"=>$bank_name,"account_no"=>$account_no,"account_name"=>$account_name);
		}else{
			$query = " select bank_name,account_no,account_name from x_bank_account where active='1' and branch_name != '-' ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':user', $user, PDO::PARAM_STR,100);
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$bank_name = $row["bank_name"];
					$account_no = $row["account_no"];
					$account_name = $row["account_name"];
					$arr[]=array("bank_name"=>$bank_name,"account_no"=>$account_no,"account_name"=>$account_name);
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