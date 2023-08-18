<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	
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
			
			$query = " select s.skucode as kode,s.printdesc as nama from x_product_sku s
join x_product_distribution d on d.skucode=s.skucode
where active='1' 
group by s.skucode,s.description
having count(d.storecode)>0  ";
			$stmt = $dbh->prepare($query);	
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