<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//skucode,storecode,skuname,price,qty,img
	$status="Failed Script";
	$brandnames=strtolower($_POST["brandname"]);
	$brandname=$_POST["brandname"];
	$storecode=$_POST["storecode"];
	$subcategorycode=$_POST["subcategorycode"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$status="Koneksi Server Gagal";
		}else{
			$isredundant = 0;
			$query = " select brandname as a from x_product_brand where LOWER(brandname)=:brandname and subcategorycode=:subcategorycode ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':brandname', $brandnames, PDO::PARAM_STR,100);
			$stmt->bindParam(':subcategorycode', $subcategorycode, PDO::PARAM_STR,50);	
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
				$isredundant = 1;
			}
			
			if($isredundant==1){
				$status = "Brand yang diinputkan sudah ada";
			}else{
				$code = 9999999999;
				$query = " select max(id)+1 as code from x_product_brand ";
				$stmt = $dbh->prepare($query);
				$stmt->execute();			
				while ($row = $stmt->fetch()) {
					$code = $row["code"];
				}
				
				$query = " INSERT INTO public.x_product_brand(
							brandcode, brandname, id, subcategorycode, created_by, created_date)
							select to_char(now(),'YYMMDDHHIISSSS'),:brandname,:code,:subcategorycode,:storecode,now() from x_product_brand where brandcode='001106'  ";
				$stmt = $dbh->prepare($query);
				$stmt->bindParam(':brandname', $brandname, PDO::PARAM_STR,100);	
				$stmt->bindParam(':subcategorycode', $subcategorycode, PDO::PARAM_STR,50);	
				$stmt->bindParam(':storecode', $storecode, PDO::PARAM_STR,50);	
				$stmt->bindParam(':code', $code, PDO::PARAM_STR,50);	
				
				if ($stmt->execute()) {
					$status = "1";
					$description = "ADDBRD - Add ".$brandname." (".$code.") by ".$storecode;
					$query = " INSERT INTO public.x_log_user_access(
								description, created_date, usercode)
								VALUES (:description, now(), :storecode)  ";
					$stmt = $dbh->prepare($query);
					$stmt->bindParam(':description', $description, PDO::PARAM_STR,50);	
					$stmt->bindParam(':storecode', $storecode, PDO::PARAM_STR,50);	
					$stmt->execute();
				}	
			}
		}
	}
	catch(PDOException $e)
	{
		echo $status;
	}
	echo $status;
//}
?>