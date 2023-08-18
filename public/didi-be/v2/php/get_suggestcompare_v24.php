<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//skucode,storecode,skuname,price,qty,img
	$usercode="0";$username="0";$wssubscribercode="0";$wssubscribername="0";$skucode="0";$shortdesc="0";$pricemember="0";$pricews="0";$wsdidicode="0";$wsdidiname="0";$qty="0";
	$user=$_POST["usercode"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr[]=array("usercode"=>$usercode,"skuname"=>$skuname,"wssubscribercode"=>$wssubscribercode,"wssubscribername"=>$wssubscribername,"skucode"=>$skucode,"storecode"=>$storecode,"shortdesc"=>$shortdesc,"pricews"=>$pricews,"pricemember"=>$pricemember,"qty"=>$qty,"wsdidicode"=>$wsdidicode,"wsdidiname"=>$wsdidiname);
		}else{
			$query = " update x_orderdraft set storecode=0 where isinvoice='0' and usercode=:usercode3";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode3', $user, PDO::PARAM_STR,50);		
			$stmt->execute();
			
			/**$query = " select a.usercode,a.username,a.wssubscribercode,a.wssubscribername,a.skucode,a.shortdesc,a.pricemember,a.pricews,s.storecode as wsdidicode,s.name as wsdidiname from (
	select u.city,u.usercode,u.name as username,b.storecode as wssubscribercode,b.name as wssubscribername,k.skucode,k.shortdesc,MIN(CAST(p.price-((CAST(p.discount as numeric(10,2))/100)*p.price) as numeric(14,0))) as pricemember,CAST(ps.price as numeric(14,0)) as pricews from x_user u 
	join x_orderdraft o on o.usercode=u.usercode and o.storecode=0
	join x_store_master s on s.city=u.city and s.isdidiws='1'
	join x_store_master d on d.storecode=s.relatedws
	join x_store_master b on b.storecode=u.subscriber_store
	join x_product_price p on p.storecode=d.storecode and p.skucode=o.skucode
	join x_product_price ps on ps.storecode=b.storecode and ps.skucode=o.skucode
	join x_product_sku k on k.skucode=o.skucode																																			 
	where u.usercode=:usercode and o.isinvoice='0'
	group by u.city,u.usercode,u.name,b.storecode,b.name,k.skucode,k.shortdesc,p.price,o.sequence,ps.price
	order by o.sequence 
) a
join x_store_master s on s.city=a.city and s.isdidiws='1'
join x_store_master d on d.storecode=s.relatedws
join x_product_price p on p.storecode=d.storecode and p.skucode=a.skucode and (CAST(p.price-((CAST(p.discount as numeric(10,2))/100)*p.price) as numeric(14,0)))=a.pricemember ";
			**/
			$query = "  select a.qty,a.usercode,a.username,a.wssubscribercode,a.wssubscribername,a.skucode,a.shortdesc,a.pricemember,a.pricews,s.storecode as wsdidicode,s.name as wsdidiname from (
	select o.qty,u.city,u.usercode,u.name as username,b.storecode as wssubscribercode,b.name as wssubscribername,k.skucode,k.shortdesc,
	 CASE WHEN db.skucode IS NULL THEN 0 
		WHEN y.member_type=1 THEN MIN(CAST(COALESCE(COALESCE(p.pricemember_1,0),0) as numeric(14,0)))
		WHEN y.member_type=2 THEN MIN(CAST(COALESCE(COALESCE(p.pricemember_2,0),0) as numeric(14,0)))
		ELSE MIN(CAST((COALESCE(p.price,0)+((coalesce(p.price,0)*p.up_values)/100)) as numeric(14,0))) END as pricemember,
	 CASE WHEN dbs.skucode IS NULL THEN 0 
		WHEN y.member_type=1 THEN MIN(CAST(COALESCE(COALESCE(ps.pricemember_1,0),0) as numeric(14,0)))
		WHEN y.member_type=2 THEN MIN(CAST(COALESCE(COALESCE(ps.pricemember_2,0),0) as numeric(14,0)))
		ELSE CAST(COALESCE(ps.price,0) as numeric(14,0)) END as pricews from x_user u 
	join x_orderdraft o on o.usercode=u.usercode and o.storecode=0
	join x_product_sku k on k.skucode=o.skucode
	join x_user y on y.usercode=u.usercode																				
	join x_store_master s on s.city=u.city and s.isdidiws='1'
	join x_store_master sr on sr.storecode=s.relatedws
	join x_store_master b on b.storecode=u.subscriber_store
	left join x_product_price p on p.storecode=sr.storecode and p.skucode=o.skucode
	left join x_product_price ps on ps.storecode=b.storecode and ps.skucode=o.skucode	
	left join x_product_distribution db on db.storecode=sr.storecode and db.skucode=o.skucode and db.active='1'	
	left join x_product_distribution dbs on dbs.storecode=b.storecode and dbs.skucode=o.skucode and dbs.active='1'		
	where u.usercode=:usercode and o.isinvoice='0'
	group by y.member_type,db.skucode,dbs.skucode,o.qty,u.city,u.usercode,u.name,b.storecode,b.name,k.skucode,k.shortdesc,p.price,o.sequence,ps.price
	order by o.sequence 
) a
join x_store_master s on s.city=a.city and s.isdidiws='1'
left join x_product_price p on p.storecode=s.storecode and p.skucode=a.skucode and ( CAST(p.price-((CAST(p.discount as numeric(10,2))/100)*p.price) as numeric(14,0)) )=a.pricemember ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);		
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
				//$usercode="0";$username="0";$wssubscribercode="0";$wssubscribername="0";$skucode="0";$shortdesc="0";$pricemember="0";$pricews="0";$wsdidicode="0";$wsdidiname="0";$qty="0";
					$usercode = $row["usercode"];
					$username = $row["username"];
					$wssubscribercode = $row["wssubscribercode"];
					$wssubscribername = $row["wssubscribername"];
					$skucode = $row["skucode"];
					$storecode = $row["storecode"];
					$shortdesc = $row["shortdesc"];
					$pricemember = $row["pricemember"];
					$pricews = $row["pricews"];
					$qty = $row["qty"];
					$wsdidicode = $row["wsdidicode"];
					$wsdidiname = $row["wsdidiname"];
					$arr[]=array("usercode"=>$usercode,"skuname"=>$skuname,"wssubscribercode"=>$wssubscribercode,"wssubscribername"=>$wssubscribername,"skucode"=>$skucode,"storecode"=>$storecode,"shortdesc"=>$shortdesc,"pricews"=>$pricews,"pricemember"=>$pricemember,"qty"=>$qty,"wsdidicode"=>$wsdidicode,"wsdidiname"=>$wsdidiname);
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