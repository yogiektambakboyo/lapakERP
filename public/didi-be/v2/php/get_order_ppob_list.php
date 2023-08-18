<?php
$method = $_SERVER['HTTP_USER_AGENT'];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	//skucode,storecode,skuname,price,qty,img,dated,orderid,total
	$skucode="-";$storecode="-";$skuname="-";$price="0";$qty="0";$img="-";$dated="-";$orderid="-";$total="0";$status="-";
	$user=$_POST["usercode"];
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr=array("qty"=>$qty,"dated"=>$dated,"orderid"=>$orderid,"total"=>$total,"status"=>$status,"remark"=>"");
		}else{
			$query = " INSERT INTO public.x_log_user_access(usercode, description,ticket) 
						select t.usercode,'History PPOB',t.ticket from x_log_user_ticket t
						join x_user u on u.usercode=:usercode and u.usercode=t.usercode
						order by created_date desc limit 1  ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);
			$stmt->execute();
			
			$query = " select * from (select note as remarks,produk as status,target as qty,harga as total,orderid,to_char(created_date,'YYYY-MM-DD') as dated from x_order_ppob p 
							where usercode=:usercode 
							union 
							select note as remarks,code as status,target as qty,harga as total,orderid,to_char(created_date,'YYYY-MM-DD') as dated from x_order_ppob_transfer p 
							where usercode=:usercode2) a
							order by dated desc ";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':usercode', $user, PDO::PARAM_STR,50);	
			$stmt->bindParam(':usercode2', $user, PDO::PARAM_STR,50);	
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$qty = $row["qty"];
					$dated = $row["dated"];
					$orderid = $row["orderid"];
					$total = $row["total"];
					$status = $row["status"];
					$remark = $row["remarks"];
					$arr[]=array("qty"=>$qty,"dated"=>$dated,"orderid"=>$orderid,"total"=>$total,"status"=>$status,"remark"=>$remark);
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