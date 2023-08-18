<?php
$method = $_SERVER['HTTP_USER_AGENT'];
$usercode=$_POST["usercode"];
$passwordlama=$_POST["passwordlama"];
$passwordbaru=$_POST["passwordbaru"];
$result="0";

set_time_limit(36000);
if($method == 'DIDI_POS_Mobile'){
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			echo $result;
		}else{
			$query = " UPDATE x_user set password=:passwordbaru2,password_encryt=encrypt(CAST((:passwordbaru) as character varying)::bytea,CAST('xXDIDI123Xx' as bytea),CAST('aes' as text))::character varying where usercode=:usercode  ";
				$stmt = $dbh->prepare($query);
				$stmt->bindParam(':usercode', $usercode, PDO::PARAM_STR,50);
				$stmt->bindParam(':passwordbaru2', $passwordbaru, PDO::PARAM_STR,50);
				$stmt->bindParam(':passwordbaru', $passwordbaru, PDO::PARAM_STR,50);
				if($stmt->execute())
				{
					$result = "1";
					echo $result;
				}
				else{
					echo $result;
				}
				
		}
	}
	catch(PDOException $e)
	{
		echo $result;
	}
}
?>