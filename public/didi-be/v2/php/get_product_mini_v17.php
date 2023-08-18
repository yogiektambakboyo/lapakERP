<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	$storecode=$_GET["storecode"];
	
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr=array("kode"=>$kode,"nama"=>$nama);
		}else{
			$query = " delete from x_product_distribution where storecode=1 ";
			$stmt = $dbh->prepare($query);
			$stmt->execute();
			
			$query = " delete from x_product_price where storecode=1 ";
			$stmt = $dbh->prepare($query);
			$stmt->execute();
			
			$query = " INSERT INTO public.x_log_user_access(usercode, description,ticket) 
						select t.usercode,'Collect Data',t.ticket from x_log_user_ticket t
						join x_user u on u.username=:usercode and u.usercode=t.usercode
						order by created_date desc limit 1  ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $usercode, PDO::PARAM_STR,50);
			$stmt->execute();
			
			
			$query = " select distinct s.skucode as kode,s.printdesc as nama from x_product_sku s
						join x_product_distribution d on d.skucode=s.skucode and d.storecode=:storecode
						join x_store_master m on m.storecode=d.storecode
						join x_product_category_distribution f on f.categorycode=s.categorycode and f.storegroup=m.storegroup
						where d.active='1' ";
			$stmt = $dbh->prepare($query);	
			$stmt->bindParam(':storecode', $storecode, PDO::PARAM_STR,50);	
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$kode = $row["kode"];
					$nama = $row["nama"];
					$arr[]=array("kode"=>$kode,"nama"=>$nama);
				}	
		}
	}
	catch(PDOException $e)
	{
		//echo $e->getMessage();
		$arr=array("kode"=>"vvv","nama"=>"Koneksi Terputus");
	}
	$resultcabang = $arr;
	echo json_encode($resultcabang);
//}
?>