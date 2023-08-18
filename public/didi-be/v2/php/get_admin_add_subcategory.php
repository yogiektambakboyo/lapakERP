<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//skucode,storecode,skuname,price,qty,img
	$status="Failed Script";
	$subcategorynames=strtolower($_POST["subcategoryname"]);
	$subcategoryname=$_POST["subcategoryname"];
	$storecode=$_POST["storecode"];
	$categorycode=$_POST["categorycode"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$status="Koneksi Server Gagal";
		}else{
			$isredundant = 0;
			$query = " select brandname as a from x_product_subcategory where LOWER(subcategoryname)=:subcategoryname and categorycode=:categorycode ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':subcategoryname', $subcategoryname2, PDO::PARAM_STR,100);
			$stmt->bindParam(':categorycode', $categorycode, PDO::PARAM_STR,50);	
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
				$isredundant = 1;
			}
			
			if($isredundant==1){
				$status = "Sub Kategori yang diinputkan sudah ada";
			}else{
				$code = 9999999999;
				$query = " select max(id)+1 as code from x_product_subcategory ";
				$stmt = $dbh->prepare($query);
				$stmt->execute();			
				while ($row = $stmt->fetch()) {
					$code = $row["code"];
				}
				
				$query = " INSERT INTO public.x_product_subcategory(
							id, subcategorycode, subcategoryname, sequence, categorycode, created_by, created_date)
							select :code,to_char(now(),'YYMMDDHHIISSSS'),:subcategoryname,0,:categorycode,:storecode,now() from x_product_brand where brandcode='001106'  ";
				$stmt = $dbh->prepare($query);
				$stmt->bindParam(':subcategoryname', $subcategoryname, PDO::PARAM_STR,100);	
				$stmt->bindParam(':categorycode', $categorycode, PDO::PARAM_STR,50);	
				$stmt->bindParam(':storecode', $storecode, PDO::PARAM_STR,50);	
				$stmt->bindParam(':code', $code, PDO::PARAM_STR,50);	
				
				if ($stmt->execute()) {
					$status = "1";
					
					$query = " INSERT INTO public.x_product_brand(
							brandcode, brandname, id, subcategorycode, created_by, created_date)
							select to_char(now(),'YYMMDDHHIISSSS'),'-',CAST(to_char(now(),'YYMMDDHHII') as INT)+CAST(floor(random() * 100 + 1) as INT),subcategorycode,0,now() 
							from x_product_subcategory where subcategorycode not in 
							( select distinct coalesce(subcategorycode,'') from x_product_brand )";
					$stmt = $dbh->prepare($query);	
					$stmt->execute();
				
					$description = "ADDSUBCAT - Add ".$subcategoryname." (".$code.") by ".$storecode;
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