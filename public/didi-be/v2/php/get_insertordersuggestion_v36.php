<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//skucode,storecode,skuname,price,qty,img
	$status="0";
	$user=$_POST["usercode"];
	$picktime=$_POST["picktime"];
	$remarks=$_POST["remarks"];
	$isfromdidi=$_POST["isfromdidi"];
	$deliverycost=$_POST["deliverycost"];
	$disc=$_POST["disc"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$status="0";
		}else{		
			$query = " INSERT INTO public.x_log_user_access(usercode, description,ticket) 
						select t.usercode,'Order Submitted',t.ticket from x_log_user_ticket t
						join x_user u on u.usercode=:usercode and u.usercode=t.usercode
						order by created_date desc limit 1  ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);
			$stmt->execute();
			
			$query = " select distinct x.storecode from x_orderdraft x join x_product_sku s on s.skucode=x.skucode  join x_user u on u.usercode=x.usercode left join x_product_price p on p.skucode=x.skucode and p.storecode=x.storecode where x.usercode=:usercode and x.isinvoice='0' ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);		
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$storecode = $row["storecode"];
					$querys = " select insertorder_com_v36(:storecode,:usercode,:picktime,:remarks,:isfromdidi,:deliverycost,:disc) as status ";
					$stmts = $dbh->prepare($querys);
					$stmts->bindParam(':usercode', $user, PDO::PARAM_STR,50);		
					$stmts->bindParam(':picktime', $picktime, PDO::PARAM_STR,50);	
					$stmts->bindParam(':remarks', $remarks, PDO::PARAM_STR,50);	
					$stmts->bindParam(':storecode', $storecode, PDO::PARAM_STR,50);	
					$stmts->bindParam(':isfromdidi', $isfromdidi, PDO::PARAM_STR,50);	
					$stmts->bindParam(':deliverycost', $deliverycost, PDO::PARAM_STR,50);	
					$stmts->bindParam(':disc', $disc, PDO::PARAM_STR,50);
					$stmts->execute();			
					while ($rows = $stmts->fetch()) {
							$status = $rows["status"];
						}
				}		
		}
	}
	catch(PDOException $e)
	{
		echo $status;
	}
	echo $status;
//}
?>