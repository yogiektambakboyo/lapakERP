<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//skucode,@Field("description") String description,@Field("categorycode") String categorycode,@Field("subcategorycode") String subcategorycode,@Field("brandcode") String brandcode,@Field("subbrandcode") String subbrandcode,@Field("casesize") String casesize,@Field("price") String price,@Field("storecode") String storecode
	$status="0";
	$nama=$_POST["nama"];
	$tgllahir=$_POST["tgllahir"];
	$handphone=$_POST["handphone"];
	$email=$_POST["email"];
	$ktp=$_POST["ktp"];
	$height=$_POST["height"];
	$width=$_POST["width"];
	$length=$_POST["length"];
	$filenamektp=$_POST["filenamektp"];
	$filenameperson=$_POST["filenameperson"];
	$filenameplace=$_POST["filenameplace"];
	$jamoperasional=$_POST["jamoperasional"];
	$provinsi=$_POST["provinsi"];
	$kabupaten=$_POST["kabupaten"];
	$alamat=$_POST["alamat"];
	$statustempat=$_POST["statustempat"];
	$catatan=$_POST["catatan"];
	$gender=$_POST["gender"];
	$longitude=$_POST["longitude"];
	$latitude=$_POST["latitude"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$status="0";
		}else{
			$query = " insert into x_partner
						(gender,name,birthdate,address,handphone,email,idcard,file_idcard,file_place,file_nameperson,operationaltime,province,city,longitude,latitude,placelength,placewidth,placeheight,living_status,note)
						values(:gender,:nama,:tgllahir,:alamat,:handphone,:email,:ktp,:filenamektp,:filenameplace,:filenameperson,:jamoperasional,:provinsi,:kabupaten,:longitude,:latitude,:length,:width,:height,:statustempat,:catatan) ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':nama', $nama, PDO::PARAM_STR,50);	
			$stmt->bindParam(':tgllahir', $tgllahir, PDO::PARAM_STR,50);	
			$stmt->bindParam(':handphone', $handphone, PDO::PARAM_STR,50);	
			$stmt->bindParam(':email', $email, PDO::PARAM_STR,50);	
			$stmt->bindParam(':ktp', $ktp, PDO::PARAM_STR,50);	
			$stmt->bindParam(':height', $height, PDO::PARAM_STR,50);	
			$stmt->bindParam(':width', $width, PDO::PARAM_STR,50);	
			$stmt->bindParam(':length', $length, PDO::PARAM_STR,50);	
			$stmt->bindParam(':filenamektp', $filenamektp, PDO::PARAM_STR,50);	
			$stmt->bindParam(':filenameplace', $filenameplace, PDO::PARAM_STR,50);	
			$stmt->bindParam(':filenameperson', $filenameperson, PDO::PARAM_STR,50);	
			$stmt->bindParam(':jamoperasional', $jamoperasional, PDO::PARAM_STR,50);	
			$stmt->bindParam(':kabupaten', $kabupaten, PDO::PARAM_STR,50);	
			$stmt->bindParam(':provinsi', $provinsi, PDO::PARAM_STR,50);	
			$stmt->bindParam(':alamat', $alamat, PDO::PARAM_STR,50);	
			$stmt->bindParam(':statustempat', $statustempat, PDO::PARAM_STR,50);	
			$stmt->bindParam(':catatan', $catatan, PDO::PARAM_STR,50);	
			$stmt->bindParam(':longitude', $longitude, PDO::PARAM_STR,50);				
			$stmt->bindParam(':latitude', $latitude, PDO::PARAM_STR,50);				
			$stmt->bindParam(':gender', $gender, PDO::PARAM_STR,50);				
			if($stmt->execute()) {
				$status = "1";
			}	
			
			$finalnama = "";
			$userd = str_replace("'", "", $nama);
			$arruser = explode(" ",$userd);
			$finalnama = $arruser[0]; 
			if(strlen($arruser[0])>25){
				$finalnama = substr($arruser[0],0,24);
			}
			
			$message= "Hai ".$finalnama.", Terima kasih sudah mendaftar sbg Partner DIDI, dokumenmu sudah diterima dan akan kami verifikasi maks 3x24 Jam";
			$query = "  INSERT INTO public.x_system_sms(target, message) VALUES (:target, :message); ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':target', $handphone, PDO::PARAM_STR,50);	
			$stmt->bindParam(':message', $message, PDO::PARAM_STR,50);	
			$stmt->execute();
		}
	}
	catch(PDOException $e)
	{
		echo $status;
	}
	echo $status;
//}
?>