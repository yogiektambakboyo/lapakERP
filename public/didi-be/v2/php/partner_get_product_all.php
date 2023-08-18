<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
if($method == 'DIDI_POS_Mobile'){
	$storecode=$_POST["storecode"];
	$usercode=$_POST["usercode"];
	$downloaddate=$_POST["downloaddate"];
	
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr=array("kode"=>$kode,"nama"=>$nama,"harga"=>$harga,"barcode"=>$barcode);
		}else{
		
			$query = " INSERT INTO public.x_log_user_access(usercode, description,ticket) 
						select t.usercode,'Collect Data',t.ticket from x_log_user_ticket t
						join x_user u on u.username=:usercode and u.usercode=t.usercode
						order by created_date desc limit 1  ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $usercode, PDO::PARAM_STR,50);
			$stmt->execute();
			
			$query = " select distinct s.skucode as kode,s.printdesc as nama,coalesce(s.barcode,'xxxxxFF') as barcode,
						COALESCE(p.price,0) as harga
						from x_product_sku s
						left join x_product_price p on p.storecode=:storecode and p.skucode=s.skucode
						where s.skucode in (select skucode from x_product_price where storecode=:storecode2 and createdate>=:downloaddate)
						";
			$stmt = $dbh->prepare($query);	
			$stmt->bindParam(':storecode', $storecode, PDO::PARAM_STR,50);	
			$stmt->bindParam(':storecode2', $storecode, PDO::PARAM_STR,50);	
			$stmt->bindParam(':downloaddate', $downloaddate, PDO::PARAM_STR,50);	
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$kode = $row["kode"];
					$nama = $row["nama"];
					$harga = $row["harga"];
					$barcode = $row["barcode"];
					$arr[]=array("kode"=>$kode,"nama"=>$nama,"harga"=>$harga,"barcode"=>$barcode);
				}	
		}
	}
	catch(PDOException $e)
	{
		$arr=array("kode"=>"vvv","nama"=>"Koneksi Terputus","harga"=>"","barcode"=>"");
	}
	$resultcabang = $arr;
	echo json_encode($resultcabang);
}
?>