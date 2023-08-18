<?php
$method = $_SERVER['HTTP_USER_AGENT'];
$usercode=$_POST["usercode"];
$tipe=$_POST["tipe"];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	$code="-";$product_name="-";$price="-";$name="-";
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr[]=array("code"=>$code,"product_name"=>$product_name,"price"=>$price);
		}else{
			$query = " select code,operators||'-'||product_name as product_name,price from (
select code,product_name,price,operators,row_number() over(partition by code order by code,price asc) from (
select p.code,o.product_name as operators,p.product_name,cast(p.price+((p.price*d.up_values)/100) as int) as price from x_ppob_product p
join x_ppob_product_distribution d on d.code=p.code and d.active='1'
join x_ppob_operator o on o.id=p.pembelianoperator_id
join x_store_master s on s.storecode=d.storecode
join x_user r on r.city=s.city and r.usercode=:usercode
where p.status='1' and p.pembeliankategori_id=:tipe order by p.product_name
) a ) b where row_number=1 order by product_name ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $usercode, PDO::PARAM_STR,100);
			$stmt->bindParam(':tipe', $tipe, PDO::PARAM_STR,100);
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$code = $row["code"];
					$product_name = $row["product_name"];
					$price = $row["price"];
					$arr[]=array("code"=>$code,"product_name"=>$product_name,"price"=>$price);
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