<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//skucode,storecode,skuname,price,qty,img
	$status="Failed Script";
	$categoryname=$_POST["categoryname"];
	$categorynames=strtolower($_POST["categoryname"]);
	$storecode=$_POST["storecode"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$status="Koneksi Server Gagal";
		}else{
			$isredundant = 0;
			$query = " select categoryname as a from x_product_category where LOWER(categoryname)=:categoryname ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':categoryname', $categorynames, PDO::PARAM_STR,50);	
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
				$isredundant = 1;
			}
			
			if($isredundant==1){
				$status = "Kategori yang diinputkan sudah ada";
			}else{
				$code = 9999999999;
				$query = " select max(id)+1 as code from x_product_category ";
				$stmt = $dbh->prepare($query);
				$stmt->execute();			
				while ($row = $stmt->fetch()) {
					$code = $row["code"];
				}
				
				$query = "INSERT INTO public.x_product_category(
						  categorycode, categoryname, id, sequence, active, tabline, created_by, created_date)
							select to_char(now(),'YYMMDDHHIISSSS'),:categoryname,:code,0,'1','0',:storecode,now() from x_product_brand where brandcode='001106'  ";
				$stmt = $dbh->prepare($query);
				$stmt->bindParam(':categoryname', $categoryname, PDO::PARAM_STR,100);	
				$stmt->bindParam(':storecode', $storecode, PDO::PARAM_STR,50);	
				$stmt->bindParam(':code', $code, PDO::PARAM_STR,50);	
				
				if ($stmt->execute()) {
					$status = "1";
					
					$query = "INSERT INTO public.x_product_category_distribution(
								categorycode, active, description, storegroup)
								VALUES (:code, '1', '-', 1) ";
					$stmt = $dbh->prepare($query);
					$stmt->bindParam(':code', $code, PDO::PARAM_STR,50);
					$stmt->execute();
					
					$query = "INSERT INTO public.x_product_category_distribution(
								categorycode, active, description, storegroup)
								VALUES (:code, '1', '-', 2) ";
					$stmt = $dbh->prepare($query);
					$stmt->bindParam(':code', $code, PDO::PARAM_STR,50);
					$stmt->execute();
				
					
					$description = "ADDBRD - Add ".$categoryname." (".$code.") by ".$storecode;
					$query = " INSERT INTO public.x_log_user_access(
								description, created_date, usercode)
								VALUES (:description, now(), :storecode)  ";
					$stmt = $dbh->prepare($query);
					$stmt->bindParam(':description', $description, PDO::PARAM_STR,50);	
					$stmt->bindParam(':storecode', $storecode, PDO::PARAM_STR,50);	
					$stmt->execute();
					
					$query = " INSERT INTO public.x_product_subcategory(
							id, subcategorycode, subcategoryname, sequence, categorycode, created_by, created_date)
							select CAST(to_char(now(),'YYMMDDHHII') as INT)+CAST(floor(random() * 100 + 1) as INT),to_char(now(),'YYMMDDHHIISSSS'),'-',0,categorycode,:storecode,now() from x_product_category where categorycode not in (
								select distinct coalesce(categorycode,'') from x_product_subcategory
							)  ";
					$stmt = $dbh->prepare($query);	
					$stmt->bindParam(':storecode', $storecode, PDO::PARAM_STR,50);	
					$stmt->execute();
				
					$query = "INSERT INTO public.x_product_brand(
							brandcode, brandname, id, subcategorycode, created_by, created_date)
							select to_char(now(),'YYMMDDHHIISSSS')||CAST(floor(random() * 1000 + 1) as INT)||'','-',CAST(to_char(now(),'YYMMDDHHII') as INT)+CAST(floor(random() * 100 + 1) as INT),subcategorycode,:storecode,now() 
							from x_product_subcategory where subcategorycode not in 
							( select distinct coalesce(subcategorycode,'') from x_product_brand )";
					$stmt = $dbh->prepare($query);	
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