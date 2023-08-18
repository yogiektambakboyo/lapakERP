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
			
			if(intval($isfromdidi)>0){
				/**$query = " select coalesce(i.disc_value,0) as disc_value,x.skucode,x.storecode,s.description as skuname,
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
						where x.usercode=:usercode and x.isinvoice='0' and coalesce(p.price,0)>0 ";**/
						$query = " select a.*,coalesce(i.disc_value,0) as disc_value from (select skucode,uniquecode,usercode,storecode,skuname,img,qty,price from (select row_number() over(PARTITION BY skucode order by skucode,priority_values,price asc) as uniquecode,* from (
							select p.priority_values,u.usercode,s.skucode||'.jpg' as img,o.qty,u.city,o.storecode,s.skucode,s.description as skuname,coalesce(barcode,'') as barcode,coalesce(searchkey,'') searchkey,
							case when (p.up_values+p.up_values_system)<=0 then p.price else (p.price+((p.price*(p.up_values+p.up_values_system))/100)) end as price 
							from x_product_sku s
							join x_orderdraft o on o.skucode=o.skucode and isinvoice='0' and o.usercode=:usercode2
							join x_user u on u.usercode=o.usercode
							join x_store_master x on x.city=u.city and x.isdidiws='0'
							join x_product_distribution d on d.skucode=s.skucode and d.storecode=x.storecode and d.skucode=o.skucode
							join x_product_price p on p.storecode=x.storecode and p.skucode=d.skucode and p.price>0  and p.skucode=o.skucode
							where d.active='1'																		
						) g) d where uniquecode=1 ) a
						left join x_disc_master m on CAST(m.storecode as bigint)=a.storecode and now()::date between start_date and end_date and m.active='1'
						left join x_disc_detail_user d on CAST(a.usercode as character varying) like d.usercode
						left join x_disc_detail_item i on i.skucode=a.skucode and i.type='1' and a.qty between i.min_qty and i.max_qty
						left join x_disc_detail_item j on j.skucode=a.skucode and j.type='2' and (a.qty*coalesce(a.price,0)) between j.min_value and j.max_value	
						where a.usercode=:usercode and coalesce(a.price,0)>0 ";
				$stmt = $dbh->prepare($query);
				$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);		
				$stmt->bindParam(':usercode2', $user, PDO::PARAM_STR,50);		
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
			
					
			$query = " INSERT INTO public.x_log_user_access(usercode, description,ticket) 
						select t.usercode,'CheckOut',t.ticket from x_log_user_ticket t
						join x_user u on u.usercode=:usercode and u.usercode=t.usercode
						order by created_date desc limit 1  ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);
			$stmt->execute();
			
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