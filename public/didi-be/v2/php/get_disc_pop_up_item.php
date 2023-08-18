<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//skucode,storecode,skuname,price,qty,img
	$skucode="-";$storecode="-";$skuname="-";$price="0";$qty="0";$img="-";
	$user=$_POST["usercode"];
	$usercode_mirror=$_POST["usercode_mirror"];
	$store=$_POST["storecode"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr=array("kode"=>$skucode,"barcode"=>"0","nama"=>$skuname,"harga"=>$price,"gambar"=>$img);
		}else{
			$query = " 	select case 
when ux.member_type=0 then coalesce(p.price,0)
when ux.member_type=1 then coalesce(p.pricemember_1,0)
when ux.member_type=2 then coalesce(p.pricemember_2,0)
else coalesce(p.price,0) END as price,
x.skucode,s.description as skuname,1 as qty,x.skucode||'.jpg' as img 
from x_disc_detail_item x 
join x_product_sku s on s.skucode=x.skucode  
join x_user ux on ux.usercode=:usercode
left join x_product_price p on p.skucode=x.skucode and p.storecode=:storecode
where x.disc_id='FF-ONEBUY5' ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);	
			$stmt->bindParam(':storecode', $store, PDO::PARAM_STR,50);			
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$skucode = $row["skucode"];
					$storecode = "0";
					$skuname = $row["skuname"];
					$price = $row["price"];
					$qty = $row["qty"];
					$img = $row["img"];
					$arr[]=array("kode"=>$skucode,"barcode"=>"0","nama"=>$skuname,"harga"=>$price,"gambar"=>$img);
				}	
		}
	}
	catch(PDOException $e)
	{
		echo $e->getMessage();
	}
	$resultcabang = $arr;
	echo json_encode($resultcabang);
//}
?>