<?php
$method = $_SERVER['HTTP_USER_AGENT'];
$user=$_GET["username"];
$pass=$_GET["password"];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	$username="-";$password="-";$name="-";$storecode="-";$usercode="-";$userrealname="-";$useraddress="-";$longitude="0";$latitude="0";
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr=array("username"=>$username,"password"=>$password,"store"=>$name,"storecode"=>$storecode,"usercode"=>$usercode,"userrealname"=>$userrealname,"useraddress"=>$useraddress,"longitude"=>$longitude,"latitude"=>$latitude);
		}else{
			$query = " INSERT INTO public.x_log_user_ticket(usercode) select usercode from x_user where username=:usercode  ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);
			$stmt->execute();
			
			$query = " INSERT INTO public.x_log_user_access(usercode, description,ticket) 
						select t.usercode,'Login',t.ticket from x_log_user_ticket t
						join x_user u on u.username=:usercode and u.usercode=t.usercode
						order by created_date desc limit 1  ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);
			$stmt->execute();			
			
			$arr=array("username"=>$username,"password"=>$password,"store"=>$name,"storecode"=>$storecode,"usercode"=>$usercode,"userrealname"=>$userrealname,"useraddress"=>$useraddress,"longitude"=>$longitude,"latitude"=>$latitude);
			$query = "select username,password,name,storecode,usercode,address,longitude,latitude from x_user where username=:username and password=:password and active='1' ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':username', $user, PDO::PARAM_STR,50);
			$stmt->bindParam(':password', $pass, PDO::PARAM_STR,50);
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$username = $row["username"];
					$password = $row["password"];
					$name = $row["name"];
					$storecode = $row["storecode"];
					$usercode = $row["usercode"];
					$userrealname = $row["name"];
					$useraddress = $row["address"];
					$longitude = $row["longitude"];
					$latitude = $row["latitude"];
					$arr=array("username"=>$username,"password"=>$password,"store"=>$name,"storecode"=>$storecode,"usercode"=>$usercode,"userrealname"=>$userrealname,"useraddress"=>$useraddress,"longitude"=>$longitude,"latitude"=>$latitude);
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