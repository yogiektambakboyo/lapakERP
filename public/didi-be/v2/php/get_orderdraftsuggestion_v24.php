<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//skucode,storecode,skuname,price,qty,img
	$skucode="-";$storecode="-";$skuname="-";$price="0";$qty="0";$img="-";$disc_value="0";
	$user=$_POST["usercode"];
	$store=$_POST["storecode"];
	$isfromdidi=$_POST["isfromdidi"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr=array("disc_value"=>$disc_value,"skucode"=>$skucode,"storecode"=>$storecode,"skuname"=>$skuname,"price"=>$price,"qty"=>$qty,"img"=>$img);
		}else{
			$query = " update x_orderdraft set usercode=(usercode*-1) where isinvoice='0' and (storecode=1 or storecode=0) and usercode>0  ";
			$stmt = $dbh->prepare($query);
			$stmt->execute();
			
			$query = " INSERT INTO public.x_log_user_access(usercode, description,ticket) 
						select t.usercode,'CheckOut',t.ticket from x_log_user_ticket t
						join x_user u on u.usercode=:usercode and u.usercode=t.usercode
						order by created_date desc limit 1  ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);
			$stmt->execute();
			
			if(intval($isfromdidi)>0){
				$query = " select coalesce(i.disc_value,0) as disc_value,x.skucode,x.storecode,s.description as skuname,
						CASE WHEN u.member_type=1 THEN coalesce(p.pricemember_1,0)+((coalesce(p.pricemember_1,0)*(p.up_values+p.up_values_system))/100) 
						WHEN u.member_type=2 THEN coalesce(p.pricemember_2,0)+((coalesce(p.pricemember_2,0)*(p.up_values+p.up_values_system))/100) 
						ELSE CAST((COALESCE(p.price,0)+((coalesce(p.price,0)*(p.up_values+p.up_values_system))/100)) as numeric(14,0)) END as price,
						x.qty,x.skucode||'.jpg' as img 
						from x_orderdraft x 
						join x_store_master g on g.storecode=x.storecode
						join x_store_master h on h.storecode=g.relatedws
						join x_product_sku s on s.skucode=x.skucode  
						join x_user u on u.usercode=x.usercode 
						join x_store_master f on f.city=u.city and f.isdidiws='1'
						join x_product_distribution db on db.storecode=h.storecode and db.skucode=x.skucode and db.active='1'	
						join x_product_price p on p.skucode=x.skucode and p.storecode=h.storecode
						left join x_disc_master m on CAST(m.storecode as bigint)=h.storecode and now()::date between start_date and end_date and m.active='1'
						left join x_disc_detail_user d on CAST(u.usercode as character varying) like d.usercode
						left join x_disc_detail_item i on i.skucode=x.skucode and i.type='1' and x.qty between i.min_qty and i.max_qty
						left join x_disc_detail_item j on j.skucode=x.skucode and j.type='2' and (x.qty*coalesce(p.price,0)) between j.min_value and j.max_value	
						where x.usercode=:usercode and x.isinvoice='0' and coalesce(p.price,0)>0 ";
				$stmt = $dbh->prepare($query);
				$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);		
				$stmt->execute();			
				while ($row = $stmt->fetch()) {
					$skucode = $row["skucode"];
					$storecode = $row["storecode"];
					$skuname = $row["skuname"];
					$price = $row["price"];
					$qty = $row["qty"];
					$img = $row["img"];
					$disc_value = $row["disc_value"];
					$arr[]=array("disc_value"=>$disc_value,"skucode"=>$skucode,"storecode"=>$storecode,"skuname"=>$skuname,"price"=>$price,"qty"=>$qty,"img"=>$img);
				}	
			}else{
				$query = " select coalesce(i.disc_value,0) as disc_value,x.skucode,x.storecode,s.description as skuname,
CASE WHEN u.member_type=1 THEN coalesce(p.pricemember_1,0)
WHEN u.member_type=2 THEN coalesce(p.pricemember_2,0)
ELSE CAST((COALESCE(p.price,0)) as numeric(14,0)) END as price,
x.qty,x.skucode||'.jpg' as img 
from x_orderdraft x 
join x_user u on u.usercode=x.usercode 
join x_store_master g on g.storecode=u.subscriber_store
join x_product_sku s on s.skucode=x.skucode  
join x_product_distribution db on db.storecode=g.storecode and db.skucode=x.skucode and db.active='1'	
join x_product_price p on p.skucode=x.skucode and p.storecode=g.storecode
left join x_disc_master m on CAST(m.storecode as bigint)=g.storecode and now()::date between start_date and end_date and m.active='1'
left join x_disc_detail_user d on CAST(u.usercode as character varying) like d.usercode
left join x_disc_detail_item i on i.skucode=x.skucode and i.type='1' and x.qty between i.min_qty and i.max_qty
left join x_disc_detail_item j on j.skucode=x.skucode and j.type='2' and (x.qty*coalesce(p.price,0)) between j.min_value and j.max_value	
where x.usercode=:usercode and x.isinvoice='0' and coalesce(p.price,0)>0  ";
				$stmt = $dbh->prepare($query);
				$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);		
				$stmt->execute();			
				while ($row = $stmt->fetch()) {
					$skucode = $row["skucode"];
					$storecode = $row["storecode"];
					$skuname = $row["skuname"];
					$price = $row["price"];
					$qty = $row["qty"];
					$img = $row["img"];
					$disc_value = $row["disc_value"];
					$arr[]=array("disc_value"=>$disc_value,"skucode"=>$skucode,"storecode"=>$storecode,"skuname"=>$skuname,"price"=>$price,"qty"=>$qty,"img"=>$img);
				}
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