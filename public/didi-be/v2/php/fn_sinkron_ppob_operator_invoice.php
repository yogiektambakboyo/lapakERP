<?php

$dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
	   

function pdoMultiInsert($tableName, $data, $pdoObject){
    
    $rowsSQL = array(); 
    $toBind = array();    
    $columnNames = array_keys($data[0]);
 
    foreach($data as $arrayIndex => $row){
        $params = array();
        foreach($row as $columnName => $columnValue){
            $param = ":" . $columnName . $arrayIndex;
            $params[] = $param;
            $toBind[$param] = $columnValue; 
        }
        $rowsSQL[] = "(" . implode(", ", $params) . ")";
    }
 
    $sql = "INSERT INTO ".$tableName." (" . implode(", ", $columnNames) . ") VALUES " . implode(", ", $rowsSQL);
 
    $pdoStatement = $pdoObject->prepare($sql);
 
    foreach($toBind as $param => $val){
        $pdoStatement->bindValue($param, $val);
    }
    
    return $pdoStatement->execute();
}

$someJSON = '[
   {
      "id":38,
      "product_name":"Pembayaran Pln",
      "pembayarankategori_id":"37",
      "status":"1"
   },
   {
      "id":39,
      "product_name":"Pembayaran Bpjs",
      "pembayarankategori_id":"38",
      "status":"1"
   },
   {
      "id":40,
      "product_name":"Pembayaran Kereta Api",
      "pembayarankategori_id":"39",
      "status":"1"
   },
   {
      "id":41,
      "product_name":"Pembayaran Asuransi",
      "pembayarankategori_id":"40",
      "status":"1"
   },
   {
      "id":42,
      "product_name":"Pembayaran Tv",
      "pembayarankategori_id":"41",
      "status":"1"
   },
   {
      "id":43,
      "product_name":"Pembayaran Pdam",
      "pembayarankategori_id":"42",
      "status":"1"
   },
   {
      "id":44,
      "product_name":"Pembayaran Telephone Kabel",
      "pembayarankategori_id":"43",
      "status":"1"
   },
   {
      "id":45,
      "product_name":"Telephone Pascabayar",
      "pembayarankategori_id":"44",
      "status":"1"
   },
   {
      "id":46,
      "product_name":"Zakat",
      "pembayarankategori_id":"45",
      "status":"1"
   }
]';
// Convert JSON string to Array
  $someArray = json_decode($someJSON, true);
  //print_r($someArray);        // Dump all data of the Array
  //echo $someArray[0]["name"]; // Access Array data

  // Convert JSON string to Object
  //$someObject = json_decode($someJSON);
  //print_r($someObject);      // Dump all data of the Object
  //echo $someObject[0]->name; // Access Object data
  
$arrresorder = array();

foreach ($someArray as $key => $row) {
    $id = $row["id"];
	$product_id = $row["product_id"];
	$product_name = $row["product_name"];
	$prefix = $row["prefix"];
	$pembeliankategori_id = $row["pembayarankategori_id"];
	$status = $row["status"];

	$arrresorder[]=array("id"=>$id,"product_id"=>$product_id,"product_name"=>$product_name,"prefix"=>$prefix,"pembeliankategori_id"=>$pembeliankategori_id,"status"=>$status);
	
  }
print_r($arrresorder);


if (!$dbh) {
			$arr=array("kode"=>$kode,"nama"=>$nama);
		}else{
			$resultord = pdoMultiInsert('x_ppob_operator_invoice', $arrresorder, $dbh);
		}





?>