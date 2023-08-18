<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr[]=array("kode"=>$kode,"nama"=>$nama,"barcode"=>$barcode,"searchkey"=>$searchkey);
		}else{
			$query = " INSERT INTO public.x_log_user_access(usercode, description,ticket) 
						select t.usercode,'Collect Data',t.ticket from x_log_user_ticket t
						join x_user u on u.username=:usercode and u.usercode=t.usercode
						order by created_date desc limit 1  ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $usercode, PDO::PARAM_STR,50);
			$stmt->execute();
			
			
			$query = " select s.skucode as kode,s.printdesc as nama,coalesce(barcode,'') as barcode,coalesce(searchkey,'') searchkey from x_product_sku s
join x_product_distribution d on d.skucode=s.skucode
where active='1' 
group by s.skucode,s.description
having count(d.storecode)>0  ";
			$stmt = $dbh->prepare($query);	
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$kode = $row["kode"];
					$nama = $row["nama"];
					$barcode = $row["barcode"];
					$searchkey = $row["searchkey"];
					$arr[]=array("kode"=>$kode,"nama"=>$nama,"barcode"=>$barcode,"searchkey"=>$searchkey);
				}	
		}
	}
	catch(PDOException $e)
	{
		//echo $e->getMessage();
		$arr[]=array("kode"=>"yyyy","nama"=>"Koneksi Terputus","barcode"=>$barcode,"searchkey"=>$searchkey);
	}
	$resultcabang = $arr;
	echo json_encode($resultcabang);
//}
?>