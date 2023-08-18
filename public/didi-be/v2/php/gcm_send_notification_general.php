<?php
include_once('fn_fcm.php');
include_once('fn_connectdb.php');

$gcm = new SendNotification();
$db = new connect();


$dbh = $db->connectDB();

$token = "";
$message = "Hai ";
$notifyID = "XXX";

if (!$dbh) {
	echo "Gagal ";
}else{
	$fcmRegIds = array();
	$query = " select fcm_token as fcm from x_user where usercode='898' ";
	$stmt = $dbh->prepare($query);
	//$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);		
	$stmt->execute();			
	while ($row = $stmt->fetch()) {
			$token = $row["fcm"];
			$a = $gcm->sendPushNotificationToFCMSever($token, $message, $notifyID);
			echo $a;
	}
}
		

?>