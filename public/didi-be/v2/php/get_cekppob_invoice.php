<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);

function pdoMultiInsert($tableName, $data, $pdoObject){
    
    $rowsSQL = array(); 
    $toBind = array();    
    $columnNames = array_keys($data[0]);
 
    foreach($data as $arrayIndex => $row){
        $params = array();
        foreach($row as $columnName => $columnValue){
            $param = ":" . $columnName . $arrayIndex;
            $params[] = $param;
            $toBind[$param] = $columnValue; 
        }
        $rowsSQL[] = "(" . implode(", ", $params) . ")";
    }
 
    $sql = "INSERT INTO ".$tableName." (" . implode(", ", $columnNames) . ") VALUES " . implode(", ", $rowsSQL);
 
    $pdoStatement = $pdoObject->prepare($sql);
 
    foreach($toBind as $param => $val){
        $pdoStatement->bindValue($param, $val);
    }
    
    return $pdoStatement->execute();
}


//if($method == 'SFA_Borwita_Android'){
	//skucode,storecode,skuname,price,qty,img
	$status="0";
	$user=$_POST["usercode"];
	$targets=$_POST["target"];
	$store=$_POST["storecode"];
	$tipes=$_POST["tipes"];
	$codes=$_POST["codes"];
	$produks=$_POST["produks"];
	$hargas=$_POST["harga"];
	$mtrplns=$_POST["mtrpln"];
	$trxids="0";
	$tagihan_ids="0";
	$notes="0";
	$tokenss="0";
	$statuss="0";
	$saldo_before_trxs="0";
	$saldo_after_trxs="0";
	
	$isvalid="0";
	
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$status="0";
		}else{
			$query = " select case when nominal_didi>=:hargas AND nominal_user>=:hargas2  then '1' else '0' end as isvalid from (
							select sum(nominal_didi) nominal_didi,sum(nominal_user) nominal_user from (
							select 0 as nominal_didi,nominal as nominal_user from x_deposit where usercode=:usercode
							union 
							select nominal as nominal_didi,0 as nominal_user from x_deposit where usercode=0
							) a
						) b ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);	
			$stmt->bindParam(':hargas', $hargas, PDO::PARAM_STR,50);	
			$stmt->bindParam(':hargas2', $hargas, PDO::PARAM_STR,50);	
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
				$isvalid = $row["isvalid"];
			}
			
			if(intval($isvalid)>0){

				$url = 'https://tripay.co.id/api/v2/pembayaran/cek-tagihan';

				$header = array(
				   'Accept: application/json',
				   'Authorization: Bearer 2adc865d8ff7820421dc86463635cf10aad9db1db95d4b112071fbd775eb', // Ganti [apikey] dengan API KEY Anda
				);
				
				$data = array( 
						'product' => $codes,
						//'code' => $codes, // kode produk
						'phone' => $targets, // nohp pembeli
						'no_pelanggan' => $mtrplns,
						'pin' => '5501', // pin member
				);
				
				

				$ch = curl_init();
				curl_setopt($ch, CURLOPT_URL, $url);
				curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
				curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
				curl_setopt($ch, CURLOPT_HTTPHEADER, $header);
				curl_setopt($ch, CURLOPT_POST, 1);
				curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
				$result = curl_exec($ch);

				if(curl_errno($ch)){
				   return 'Request Error:' . curl_error($ch);
				}
			
				
				$someResult = '['.$result.']';
				$someArray = json_decode($someResult, true);
				
				$success = false;
				$trxid = "-";
				$datax = "-";
				$message = "-";
				
				foreach ($someArray as $key => $row) {
					$success = $row["success"];
					$dataArray = $row["data"];
					$message = $row["message"];				
				}
							
				if(($success)||$success=="true"){
					$status = "1";
					
					$id = $dataArray["id"];
					$tagihan_id = $dataArray["tagihan_id"];
					$product_name = $dataArray["product_name"];
					$phone = $dataArray["phone"];
					$no_pelanggan = $dataArray["no_pelanggan"];
					$nama = $dataArray["nama"];
					$periode = $dataArray["periode"];
					$status = "-";
					$expired = "-";
					$jumlah_tagihan = $dataArray["jumlah_tagihan"];
					$biaya_admin = $dataArray["admin"];
					$jumlah_bayar = $dataArray["jumlah_bayar"];	
					
					
					$arrresorder[]=array("id"=>$id,"tagihan_id"=>$tagihan_id,"product_name"=>$product_name,"phone"=>$phone,"no_pelanggan"=>$no_pelanggan,
				"nama"=>$nama,"periode"=>$periode,"status"=>$status,"expired"=>$expired,"jumlah_tagihan"=>$jumlah_tagihan,"jumlah_bayar"=>$jumlah_bayar,"biaya_admin"=>$biaya_admin);
				
					$resultord = pdoMultiInsert('x_ppob_check_payment', $arrresorder, $dbh);
				}else{
					if(strpos($message,'sudah melakukan pengecekan pembayaran')>0){
						$status = "1";
					}else{
						$status = "Server PPOB Respon Failed - ".$message;
					}
					
				}	
			}else{
				$status = "Deposit anda tidak cukup untuk melakukan transaksi ini";
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