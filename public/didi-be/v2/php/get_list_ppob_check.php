<?php
$method = $_SERVER['HTTP_USER_AGENT'];
$usercode=$_POST["usercode"];
$tipe=$_POST["tipes"];
$no_pelanggan=$_POST["no_pelanggan"];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr[]=array("code"=>$code,"product_name"=>$product_name,"price"=>$price);
		}else{
			$query = " select * from x_ppob_check_payment where no_pelanggan=:no_pelanggan";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':no_pelanggan', $no_pelanggan, PDO::PARAM_STR,100);
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$id = $row["id"];
					$tagihan_id = $row["tagihan_id"];
					$product_name = $row["product_name"];
					$phone = $row["phone"];
					$no_pelanggan = $row["no_pelanggan"];
					$nama = $row["nama"];
					$periode = $row["periode"];
					$status = $row["status"];
					$expired = $row["expired"];
					$jumlah_tagihan = $row["jumlah_tagihan"];
					$biaya_admin = $row["biaya_admin"];
					$jumlah_bayar = $row["jumlah_bayar"];
					
					$arr[]=array("id"=>$id,"tagihan_id"=>$tagihan_id,"product_name"=>$product_name,"phone"=>$phone,"no_pelanggan"=>$no_pelanggan,"nama"=>$nama,"periode"=>$periode,"status"=>$status,"expired"=>$expired,"jumlah_tagihan"=>$jumlah_tagihan,"biaya_admin"=>$biaya_admin,"jumlah_bayar"=>$jumlah_bayar);
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