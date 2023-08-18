<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//skucode,storecode,skuname,price,qty,img,dated,orderid,total
	$totallast="0";$total="0";$valuetoget="0";$discget="0";
	$user=$_POST["usercode"];
	$store=$_POST["storecode"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr=array("totallast"=>$totallast,"total"=>$total,"valuetoget"=>$valuetoget,"discget"=>$discget);
		}else{
			$query = "  select cast(sum(coalesce(totallast,0)) as int) totallast,cast(sum(coalesce(total,0)) as int) as total,cast(sum(coalesce(valuetoget,0)) as int) valuetoget,cast(sum(coalesce(discget,0)) as int) as discget from (
							select cast(total as int) totallast,0 as total,cast(total as int)*1.3 as valuetoget,0 as discget from x_order_detail d 
							join x_disc_detail_item i on i.skucode=d.skucode and disc_id='FF-130'
							where d.orderid in (
							select max(o.orderid) as orderid from x_order_master o
							join x_order_detail d on d.orderid=o.orderid
							join x_disc_detail_item i on i.skucode=d.skucode and i.disc_id='FF-130' 
							where o.usercode=:usercode and o.iscanceled='0')
							union
							select 0 as totallast,sum(cast(coalesce(o.qty,0)*coalesce(o.price,0) as int)) as total,0 as valuetoget,cast(sum(cast(coalesce(o.qty,0)*coalesce(o.price,0) as int))*0.05*1.3 as int) as discget from x_product_sku s 
							join x_orderdraft o on o.isinvoice='0' and o.usercode=:usercode and o.skucode=s.skucode
							join x_disc_detail_item i on i.skucode=o.skucode and i.disc_id='FF-130' 
							) a ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);	
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$totallast = $row["totallast"];
					$valuetoget = $row["valuetoget"];
					$discget = $row["discget"];
					$total = $row["total"];
					$arr=array("totallast"=>$totallast,"total"=>$total,"valuetoget"=>$valuetoget,"discget"=>$discget);
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