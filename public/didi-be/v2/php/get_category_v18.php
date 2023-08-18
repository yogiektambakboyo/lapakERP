<?php
$method = $_SERVER['HTTP_USER_AGENT'];
$storecode=$_POST["storecode"];
set_time_limit(36000);
//if($method == 'SFA_Borwita_Android'){
	$categorycode="";$categoryname="";$subcategorycode="";$subcategoryname="";$csequence="";$sequence="";$tab="";
	try {
	   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   if (!$dbh) {
			$arr=array("categorycode"=>$categorycode,"categoryname"=>$categoryname,"subcategorycode"=>$subcategorycode,"subcategoryname"=>$subcategoryname,"csequence"=>$csequence,"sequence"=>$sequence,"tab"=>$tab);
		}else{
			$query = "select tabline as tab,c.categorycode,categoryname,y.subcategorycode,y.subcategoryname,c.sequence as csequence,COALESCE(y.sequence,99999) as sequence 
				from x_product_category c
				join x_product_category_distribution d on d.categorycode=c.categorycode 
				join x_store_master m on m.storecode=:storecode and m.storegroup=d.storegroup
				join x_product_subcategory y on y.categorycode=c.categorycode
				order by c.sequence,y.sequence";
			$stmt = $dbh->prepare($query);
			$stmt->bindParam(':storecode', $storecode, PDO::PARAM_STR,50);
			$stmt->execute();			
			while ($row = $stmt->fetch()) {
					$categorycode = $row["categorycode"];
					$categoryname = $row["categoryname"];
					$subcategorycode = $row["subcategorycode"];
					$subcategoryname = $row["subcategoryname"];
					$csequence = $row["csequence"];
					$sequence = $row["sequence"];
					$tab = $row["tab"];
					$arr[]=array("categorycode"=>$categorycode,"categoryname"=>$categoryname,"subcategorycode"=>$subcategorycode,"subcategoryname"=>$subcategoryname,"csequence"=>$csequence,"sequence"=>$sequence,"tab"=>$tab);
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