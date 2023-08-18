<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	$counter = 0;$stat="500";
	$kode="#";$nama="#";$barcode="0";$price="0";
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr[]=array("kode"=>$kode,"nama"=>$nama,"barcode"=>$barcode,"harga"=>$price);
		}else{
			$query = " select r.skucode as kode,s.description as nama,r.id as barcode,r.poin as price from x_poin_redeem r
						join x_product_sku s on s.skucode=r.skucode
						where r.active='1' ";
			$stmt = $dbh->prepare($query);
			$stmt->execute();

			while ($row = $stmt->fetch()) {
					$kode = $row["kode"];
					$nama = $row["nama"];
					$barcode = $row["barcode"];
					$price = $row["price"];
					$arr[]=array("kode"=>$kode,"nama"=>$nama,"barcode"=>$barcode,"harga"=>$price);
					$counter++;
			}
			if($counter==0){
				$arr[]=array("kode"=>$kode,"nama"=>$nama,"barcode"=>$barcode,"harga"=>$price);
			}
			$stat="200";
		}
	}
	catch(PDOException $e)
	{
		$stat="100 - ".$e->getMessage();
		$resultcabang = array("data"=>$arr,"status"=>$stat,"count"=>$counter);
		echo json_encode($resultcabang);
		exit();
	}
	//$resultcabang = array("data"=>$arr,"status"=>$stat,"count"=>$counter);
	$resultcabang = $arr;
	echo json_encode($resultcabang);
//}
?>