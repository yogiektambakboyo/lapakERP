<?php
$method = $_SERVER['HTTP_USER_AGENT'];
$usercode=$_POST["usercode"];
$storecode=$_POST["storecode"];
$result="0";

set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//storecode=subquery.storecode,
    //price=subquery.price,
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			echo $result;
		}else{
			/**$query = " UPDATE x_orderdraft
SET relatedid=TO_CHAR(NOW(),'YYYYMMDDHHMI')||'-OR-'||:storecode3||:usercode3
FROM (
	select a.*,p.storecode from (
	select p.skucode,min(p.price) as price from x_orderdraft x
	join x_product_sku s on s.skucode=x.skucode
	join x_product_distribution d on d.skucode=x.skucode and active='1'
	join x_product_price p on p.skucode=x.skucode and p.storecode=d.storecode and p.price>0 
	where x.usercode=:usercode2 and x.storecode=:storecode2
	group by p.skucode
) a join x_product_price p on p.price=a.price and p.skucode=a.skucode
) AS subquery
WHERE x_orderdraft.skucode=subquery.skucode and x_orderdraft.usercode=:usercode and x_orderdraft.storecode=:storecode  ";**/

$query = " UPDATE x_orderdraft
SET relatedid=TO_CHAR(NOW(),'YYYYMMDDHHMI')||'-OR-'||:storecode3||:usercode3
WHERE usercode=:usercode and isinvoice='0' ";
			
				$stmt = $dbh->prepare($query);
				$stmt->bindParam(':usercode', $usercode, PDO::PARAM_STR,50);
				$stmt->bindParam(':usercode2', $usercode, PDO::PARAM_STR,50);
				$stmt->bindParam(':usercode3', $usercode, PDO::PARAM_STR,50);
				$stmt->bindParam(':storecode', $storecode, PDO::PARAM_STR,50);
				$stmt->bindParam(':storecode2', $storecode, PDO::PARAM_STR,50);
				$stmt->bindParam(':storecode3', $storecode, PDO::PARAM_STR,50);
			
				if($stmt->execute())
				{
					$result = "1";
					echo $result;
				}
				else{
					echo $result;
				}
				
		}
	}
	catch(PDOException $e)
	{
		echo $result;
	}
//}
?>