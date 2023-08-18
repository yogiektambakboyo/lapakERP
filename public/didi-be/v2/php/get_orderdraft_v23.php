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
			$arr=array("skucode"=>$skucode,"storecode"=>$storecode,"skuname"=>$skuname,"price"=>$price,"qty"=>$qty,"img"=>$img);
		}else{
			
			$query = " update x_orderdraft set usercode=(usercode*-1) where isinvoice='0' and (storecode=1 or storecode=0) and usercode>0  ";
			$stmt = $dbh->prepare($query);
			$stmt->execute();
			
			
			$query = " UPDATE x_orderdraft set relatedid=TO_CHAR(NOW(),'YYYYMMDDHHMI')||'-OR-'||:storecode2||:usercode2 where usercode=:usercode and isinvoice='0'  ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);
			$stmt->bindParam(':usercode2', $user, PDO::PARAM_STR,50);
			$stmt->bindParam(':storecode', $store, PDO::PARAM_STR,50);
			$stmt->bindParam(':storecode2', $store, PDO::PARAM_STR,50);
			$stmt->execute();
			
			$query = " 	select case 
						when ux.member_type=0 then coalesce(p.price,0)
						when ux.member_type=1 then coalesce(p.pricemember_1,0)
						when ux.member_type=2 then coalesce(p.pricemember_2,0)
						else coalesce(p.price,0) END as price,
						x.skucode,x.storecode,s.description as skuname,x.qty,x.skucode||'.jpg' as img 
						from x_orderdraft x 
						join x_product_sku s on s.skucode=x.skucode  
						join x_user u on u.usercode=x.usercode 
						join x_user ux on ux.usercode=:usercode_mirror
						left join x_product_price p on p.skucode=x.skucode and p.storecode=:storecode
						where x.usercode=:usercode and x.storecode=:storecode2 and x.isinvoice='0' ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);	
			$stmt->bindParam(':usercode_mirror', $usercode_mirror, PDO::PARAM_STR,50);	
			$stmt->bindParam(':storecode', $store, PDO::PARAM_STR,50);
			$stmt->bindParam(':storecode2', $store, PDO::PARAM_STR,50);			
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$skucode = $row["skucode"];
					$storecode = $row["storecode"];
					$skuname = $row["skuname"];
					$price = $row["price"];
					$qty = $row["qty"];
					$img = $row["img"];
					$arr[]=array("skucode"=>$skucode,"storecode"=>$storecode,"skuname"=>$skuname,"price"=>$price,"qty"=>$qty,"img"=>$img);
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