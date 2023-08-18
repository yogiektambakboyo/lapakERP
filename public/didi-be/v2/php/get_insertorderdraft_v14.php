<?php
$method = $_SERVER['HTTP_USER_AGENT'];
$usercode=$_POST["usercode"];
$storecode=$_POST["storecode"];
$skucode=$_POST["skucode"];
$qty=$_POST["qty"];
$price=$_POST["price"];
$sequence=$_POST["sequence"];
$isfrombarcode=$_POST["isfrombarcode"];
$result="0";
$c="0";

set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			echo $result;
		}else{
			
			$message = 'ORDXX - Order '.$skucode.' Qty '.$qty.' Price '.$price;
		
			$query = " INSERT INTO public.x_log_user_access(usercode, description,ticket) 
						select t.usercode,:message,t.ticket from x_log_user_ticket t
						join x_user u on u.usercode=:usercode and u.usercode=t.usercode
						order by created_date desc limit 1  ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);
			$stmt->bindParam(':message', $message, PDO::PARAM_STR,50);
			$stmt->execute();
			
			$query = " INSERT INTO public.x_product_log_view(usercode, skucode, createdate) VALUES ( :usercode, :skucode, now())  ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $usercode, PDO::PARAM_STR,50);
			$stmt->bindParam(':skucode', $skucode, PDO::PARAM_STR,50);
			$stmt->execute();
			
			
			$query = " select count(skucode) as c from x_orderdraft where usercode=:usercode and storecode=(select storecode from x_user where usercode=:usercode2) and skucode=:skucode and isinvoice='0' ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $usercode, PDO::PARAM_STR,50);
			$stmt->bindParam(':usercode2', $usercode, PDO::PARAM_STR,50);
			//$stmt->bindParam(':storecode', $storecode, PDO::PARAM_STR,50);
			$stmt->bindParam(':skucode', $skucode, PDO::PARAM_STR,50);
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$c = $row["c"];
				}
			
			$query = " UPDATE x_orderdraft set relatedid=TO_CHAR(NOW(),'YYYYMMDDHHMI')||'-OR-'||:storecode2||:usercode2 where usercode=:usercode and isinvoice='0'  ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $usercode, PDO::PARAM_STR,50);
			$stmt->bindParam(':usercode2', $usercode, PDO::PARAM_STR,50);
			$stmt->bindParam(':storecode', $storecode, PDO::PARAM_STR,50);
			$stmt->bindParam(':storecode2', $storecode, PDO::PARAM_STR,50);
			$stmt->execute();
				
			if(intval($c)>0){
				$query = " UPDATE x_orderdraft set qty=qty+(:qty),price=:price,sequence=:sequence where usercode=:usercode and storecode=(select storecode from x_user where usercode=:usercode2) and skucode=:skucode  and isinvoice='0'  ";
				$stmt = $dbh->prepare($query);
				$stmt->bindParam(':usercode', $usercode, PDO::PARAM_STR,50);
				$stmt->bindParam(':usercode2', $usercode, PDO::PARAM_STR,50);
				$stmt->bindParam(':storecode', $storecode, PDO::PARAM_STR,50);
				$stmt->bindParam(':skucode', $skucode, PDO::PARAM_STR,50);
				$stmt->bindParam(':qty', $qty, PDO::PARAM_STR,50);
				$stmt->bindParam(':price', $price, PDO::PARAM_STR,50);
				$stmt->bindParam(':sequence', $sequence, PDO::PARAM_STR,50);
				if($stmt->execute())
				{
					$result = "1";
					echo $result;
				}
				else{
					echo $result;
				}
				
			}else{
				$query = " DELETE FROM x_orderdraft WHERE isinvoice='0' and usercode=:usercode and skucode=:skucode ";
				$stmt = $dbh->prepare($query);
				$stmt->bindParam(':usercode', $usercode, PDO::PARAM_STR,50);
				$stmt->bindParam(':skucode', $skucode, PDO::PARAM_STR,50);
				$stmt->execute();
				
				//$query = " INSERT INTO x_orderdraft(usercode, storecode, skucode, qty, price, sequence, createdate,isinvoice,isfrombarcode) VALUES (:usercode, :storecode, :skucode, :qty, :price, :sequence, now(),'0',:isfrombarcode) ";
				$query = " INSERT INTO x_orderdraft(usercode, storecode, skucode, qty, price, sequence, createdate,isinvoice,isfrombarcode) select usercode,storecode, :skucode, :qty, :price, :sequence, now(),'0',:isfrombarcode from x_user where usercode=:usercode2 ";
				$stmt = $dbh->prepare($query);
				$stmt->bindParam(':usercode', $usercode, PDO::PARAM_STR,50);
				$stmt->bindParam(':usercode2', $usercode, PDO::PARAM_STR,50);
				$stmt->bindParam(':storecode', $storecode, PDO::PARAM_STR,50);
				$stmt->bindParam(':skucode', $skucode, PDO::PARAM_STR,50);
				$stmt->bindParam(':qty', $qty, PDO::PARAM_STR,50);
				$stmt->bindParam(':price', $price, PDO::PARAM_STR,50);
				$stmt->bindParam(':sequence', $sequence, PDO::PARAM_STR,50);
				$stmt->bindParam(':isfrombarcode', $isfrombarcode, PDO::PARAM_STR,50);
				if($stmt->execute())
				{
					$result = "1";
					echo $result;
				}
				else{
					echo $result;
				}
			}
			
			$query = " update x_orderdraft set usercode=(usercode*-1) where isinvoice='0' and (storecode=1 or storecode=0) and usercode>0  ";
			$stmt = $dbh->prepare($query);
			$stmt->execute();
				
		}
	}
	catch(PDOException $e)
	{
		echo $result;
	}
//}
?>