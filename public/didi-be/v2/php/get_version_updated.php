<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//skucode,storecode,skuname,price,qty,img,dated,orderid,total
	$skucode="-";$storecode="-";$skuname="-";$price="0";$qty="0";$img="-";$dated="-";$orderid="-";$total="0";
	$user=$_POST["usercode"];
	$store=$_POST["storecode"];
	$app=$_POST["app"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr[]=array("url"=>$url,"version"=>$version,"message"=>$message,"ismust"=>$ismust);
		}else{
			$query = "  SELECT version,url,message,ismust FROM public.x_version where app=:app limit 1";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':app', $app, PDO::PARAM_STR,50);	
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$version = $row["version"];
					$url = $row["url"];
					$message = $row["message"];
					$ismust = $row["ismust"];
					$arr[]=array("url"=>$url,"version"=>$version,"message"=>$message,"ismust"=>$ismust);
				}	
		}
	}
	catch(PDOException $e)
	{
		echo $e->getMessage();
	}
	$resultcabang = $arr;
	echo json_encode($resultcabang);
//}
?>