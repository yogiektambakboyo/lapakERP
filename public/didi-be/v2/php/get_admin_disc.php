<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//skucode,storecode,skuname,price,qty,img,dated,orderid,total
	$skucode="-";$storecode="-";$skuname="-";$disc_id="0";$min_qty="0";$max_qty="-";$disc_value="0";$start_date="-";$end_date="0";
	$store=$_POST["storecode"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
					$arr[]=array("status"=>$status,"skucode"=>$skucode,"storecode"=>$storecode,"skuname"=>$skuname,"disc_id"=>$disc_id,"start_date"=>$start_date,"end_date"=>$end_date,"min_qty"=>$min_qty,"max_qty"=>$max_qty,"disc_value"=>$disc_value);
		}else{
			$query = "  select COALESCE(i.skucode,'x') as status,s.description as skuname,m.storecode,m.disc_id,m.start_date,m.end_date,s.skucode,COALESCE(i.min_qty,0) as min_qty,COALESCE(i.max_qty,0) as max_qty,COALESCE(i.disc_value,0) as disc_value 
						from x_product_sku s 
						join x_product_distribution d on d.skucode=s.skucode and d.storecode=:storecode
						left join x_disc_master m on CAST(m.storecode as int)=d.storecode
						left join x_disc_detail_item i on i.disc_id=m.disc_id and i.skucode=d.skucode   ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':storecode', $store, PDO::PARAM_STR,50);	
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$disc_id = $row["disc_id"];
					$start_date = $row["start_date"];
					$end_date = $row["end_date"];
					$skucode = $row["skucode"];
					$min_qty = $row["min_qty"];
					$max_qty = $row["max_qty"];
					$disc_value = $row["disc_value"];
					$storecode = $row["storecode"];
					$skuname = $row["skuname"];
					$status = $row["status"];
					$arr[]=array("status"=>$status,"skucode"=>$skucode,"storecode"=>$storecode,"skuname"=>$skuname,"disc_id"=>$disc_id,"start_date"=>$start_date,"end_date"=>$end_date,"min_qty"=>$min_qty,"max_qty"=>$max_qty,"disc_value"=>$disc_value);
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