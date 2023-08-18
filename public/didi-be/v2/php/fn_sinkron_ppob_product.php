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
      "id":1,
      "code":"AX5",
      "pembelianoperator_id":"1",
      "pembeliankategori_id":"1",
      "product_name":"AXIS 5000",
      "price":"5630",
      "status":"1"
   },
   {
      "id":2,
      "code":"AX10",
      "pembelianoperator_id":"1",
      "pembeliankategori_id":"1",
      "product_name":"AXIS 10000",
      "price":"10775",
      "status":"1"
   },
   {
      "id":3,
      "code":"AX25",
      "pembelianoperator_id":"1",
      "pembeliankategori_id":"1",
      "product_name":"AXIS 25000",
      "price":"24940",
      "status":"1"
   },
   {
      "id":4,
      "code":"AX30",
      "pembelianoperator_id":"1",
      "pembeliankategori_id":"1",
      "product_name":"AXIS 30000",
      "price":"29865",
      "status":"1"
   },
   {
      "id":5,
      "code":"AX50",
      "pembelianoperator_id":"1",
      "pembeliankategori_id":"1",
      "product_name":"AXIS 50000",
      "price":"49515",
      "status":"1"
   },
   {
      "id":6,
      "code":"AX100",
      "pembelianoperator_id":"1",
      "pembeliankategori_id":"1",
      "product_name":"AXIS 100000",
      "price":"98415",
      "status":"1"
   },
   {
      "id":7,
      "code":"AX15",
      "pembelianoperator_id":"1",
      "pembeliankategori_id":"1",
      "product_name":"AXIS 15000",
      "price":"15065",
      "status":"1"
   },
   {
      "id":8,
      "code":"AIGO1",
      "pembelianoperator_id":"2",
      "pembeliankategori_id":"2",
      "product_name":"VOUCHER AIGO 1GB 30HR",
      "price":"13390",
      "status":"1"
   },
   {
      "id":9,
      "code":"AIGO5",
      "pembelianoperator_id":"2",
      "pembeliankategori_id":"2",
      "product_name":"VOUCHER AIGO 5GB 30HR",
      "price":"43190",
      "status":"1"
   },
   {
      "id":10,
      "code":"AIGO3",
      "pembelianoperator_id":"2",
      "pembeliankategori_id":"2",
      "product_name":"VOUCHER AIGO 3GB 30HR",
      "price":"29040",
      "status":"1"
   },
   {
      "id":11,
      "code":"AIGO2",
      "pembelianoperator_id":"2",
      "pembeliankategori_id":"2",
      "product_name":"VOUCHER AIGO 2GB 30HR",
      "price":"22990",
      "status":"1"
   },
   {
      "id":12,
      "code":"AIGO8",
      "pembelianoperator_id":"2",
      "pembeliankategori_id":"2",
      "product_name":"VOUCHER AIGO 8GB 30HR",
      "price":"58490",
      "status":"1"
   },
   {
      "id":13,
      "code":"AIM5",
      "pembelianoperator_id":"3",
      "pembeliankategori_id":"2",
      "product_name":"VOUCHER AIGO MINI 5GB 15HR",
      "price":"32040",
      "status":"1"
   },
   {
      "id":14,
      "code":"AIM3",
      "pembelianoperator_id":"3",
      "pembeliankategori_id":"2",
      "product_name":"VOUCHER AIGO MINI 3GB 15HR",
      "price":"20340",
      "status":"1"
   },
   {
      "id":15,
      "code":"AIM2",
      "pembelianoperator_id":"3",
      "pembeliankategori_id":"2",
      "product_name":"VOUCHER AIGO MINI 2GB 7HR",
      "price":"15790",
      "status":"1"
   },
   {
      "id":16,
      "code":"AIM1",
      "pembelianoperator_id":"3",
      "pembeliankategori_id":"2",
      "product_name":"VOUCHER AIGO MINI 1GB 5HR",
      "price":"8455",
      "status":"1"
   },
   {
      "id":17,
      "code":"AXD300",
      "pembelianoperator_id":"4",
      "pembeliankategori_id":"2",
      "product_name":"BRONET 300MB 7HR",
      "price":"10690",
      "status":"1"
   },
   {
      "id":18,
      "code":"AXD1",
      "pembelianoperator_id":"4",
      "pembeliankategori_id":"2",
      "product_name":"BRONET 1GB 30HR",
      "price":"18340",
      "status":"1"
   },
   {
      "id":19,
      "code":"AXD2",
      "pembelianoperator_id":"4",
      "pembeliankategori_id":"2",
      "product_name":"BRONET 2GB 30HR",
      "price":"27440",
      "status":"1"
   },
   {
      "id":20,
      "code":"AXD3",
      "pembelianoperator_id":"4",
      "pembeliankategori_id":"2",
      "product_name":"BRONET 3GB 30HR",
      "price":"36740",
      "status":"1"
   },
   {
      "id":21,
      "code":"AXD5",
      "pembelianoperator_id":"4",
      "pembeliankategori_id":"2",
      "product_name":"BRONET 5GB 30HR",
      "price":"54840",
      "status":"1"
   },
   {
      "id":22,
      "code":"AXD8",
      "pembelianoperator_id":"4",
      "pembeliankategori_id":"2",
      "product_name":"BRONET 8GB 30HR",
      "price":"76490",
      "status":"1"
   },
   {
      "id":23,
      "code":"BO25",
      "pembelianoperator_id":"5",
      "pembeliankategori_id":"1",
      "product_name":"PULSA BOLT 25000",
      "price":"24840",
      "status":"1"
   },
   {
      "id":24,
      "code":"BO50",
      "pembelianoperator_id":"5",
      "pembeliankategori_id":"1",
      "product_name":"PULSA BOLT 50000",
      "price":"49340",
      "status":"1"
   },
   {
      "id":25,
      "code":"BO100",
      "pembelianoperator_id":"5",
      "pembeliankategori_id":"1",
      "product_name":"PULSA BOLT 100000",
      "price":"97665",
      "status":"0"
   },
   {
      "id":26,
      "code":"BO150",
      "pembelianoperator_id":"5",
      "pembeliankategori_id":"1",
      "product_name":"PULSA BOLT 150000",
      "price":"146265",
      "status":"0"
   },
   {
      "id":27,
      "code":"BO200",
      "pembelianoperator_id":"5",
      "pembeliankategori_id":"1",
      "product_name":"PULSA BOLT 200000",
      "price":"194890",
      "status":"0"
   },
   {
      "id":28,
      "code":"BO29",
      "pembelianoperator_id":"6",
      "pembeliankategori_id":"2",
      "product_name":"BOLT KUOTA 1.5GB 30HRI",
      "price":"28865",
      "status":"0"
   },
   {
      "id":29,
      "code":"BO49",
      "pembelianoperator_id":"6",
      "pembeliankategori_id":"2",
      "product_name":"BOLT KUOTA 3GB 30HRI",
      "price":"48315",
      "status":"0"
   },
   {
      "id":30,
      "code":"BO99",
      "pembelianoperator_id":"6",
      "pembeliankategori_id":"2",
      "product_name":"BOLT KUOTA 8GB 30HRI",
      "price":"96915",
      "status":"0"
   },
   {
      "id":31,
      "code":"BO149",
      "pembelianoperator_id":"6",
      "pembeliankategori_id":"2",
      "product_name":"BOLT KUOTA 13GB 30HRI",
      "price":"145540",
      "status":"0"
   },
   {
      "id":32,
      "code":"BO199",
      "pembelianoperator_id":"6",
      "pembeliankategori_id":"2",
      "product_name":"BOLT KUOTA 17GB 30HRI",
      "price":"194165",
      "status":"0"
   },
   {
      "id":33,
      "code":"C5",
      "pembelianoperator_id":"7",
      "pembeliankategori_id":"1",
      "product_name":"CERIA 5000",
      "price":"4890",
      "status":"0"
   },
   {
      "id":34,
      "code":"C10",
      "pembelianoperator_id":"7",
      "pembeliankategori_id":"1",
      "product_name":"CERIA 10000",
      "price":"9490",
      "status":"0"
   },
   {
      "id":35,
      "code":"C20",
      "pembelianoperator_id":"7",
      "pembeliankategori_id":"1",
      "product_name":"CERIA 20000",
      "price":"18690",
      "status":"0"
   },
   {
      "id":36,
      "code":"C50",
      "pembelianoperator_id":"7",
      "pembeliankategori_id":"1",
      "product_name":"CERIA 50000",
      "price":"48790",
      "status":"0"
   },
   {
      "id":37,
      "code":"C100",
      "pembelianoperator_id":"7",
      "pembeliankategori_id":"1",
      "product_name":"CERIA 100000",
      "price":"97290",
      "status":"0"
   },
   {
      "id":38,
      "code":"GJ250",
      "pembelianoperator_id":"8",
      "pembeliankategori_id":"3",
      "product_name":"SALDO GOJEK 250K",
      "price":"251840",
      "status":"1"
   },
   {
      "id":39,
      "code":"GJ200",
      "pembelianoperator_id":"8",
      "pembeliankategori_id":"3",
      "product_name":"SALDO GOJEK 200K",
      "price":"200990",
      "status":"1"
   },
   {
      "id":40,
      "code":"GJ150",
      "pembelianoperator_id":"8",
      "pembeliankategori_id":"3",
      "product_name":"SALDO GOJEK 150K",
      "price":"152340",
      "status":"1"
   },
   {
      "id":41,
      "code":"GJ100",
      "pembelianoperator_id":"8",
      "pembeliankategori_id":"3",
      "product_name":"SALDO GOJEK 100K",
      "price":"100990",
      "status":"1"
   },
   {
      "id":42,
      "code":"GJ50",
      "pembelianoperator_id":"8",
      "pembeliankategori_id":"3",
      "product_name":"SALDO GOJEK 50K",
      "price":"50990",
      "status":"1"
   },
   {
      "id":43,
      "code":"GJ25",
      "pembelianoperator_id":"8",
      "pembeliankategori_id":"3",
      "product_name":"SALDO GOJEK 25K",
      "price":"25990",
      "status":"1"
   },
   {
      "id":44,
      "code":"GJ20",
      "pembelianoperator_id":"8",
      "pembeliankategori_id":"3",
      "product_name":"SALDO GOJEK 20K",
      "price":"20640",
      "status":"1"
   },
   {
      "id":45,
      "code":"GJ5",
      "pembelianoperator_id":"8",
      "pembeliankategori_id":"3",
      "product_name":"SALDO GOJEK 5K",
      "price":"5640",
      "status":"1"
   },
   {
      "id":46,
      "code":"GJ10",
      "pembelianoperator_id":"8",
      "pembeliankategori_id":"3",
      "product_name":"SALDO GOJEK 10K",
      "price":"10990",
      "status":"1"
   },
   {
      "id":47,
      "code":"GJD75",
      "pembelianoperator_id":"9",
      "pembeliankategori_id":"3",
      "product_name":"SALDO GOJEK DRIVER 75K",
      "price":"76490",
      "status":"1"
   },
   {
      "id":48,
      "code":"GJD50",
      "pembelianoperator_id":"9",
      "pembeliankategori_id":"3",
      "product_name":"SALDO GOJEK DRIVER 50K",
      "price":"51490",
      "status":"1"
   },
   {
      "id":49,
      "code":"GJD20",
      "pembelianoperator_id":"9",
      "pembeliankategori_id":"3",
      "product_name":"SALDO GOJEK DRIVER 20K",
      "price":"21490",
      "status":"1"
   },
   {
      "id":50,
      "code":"GJD200",
      "pembelianoperator_id":"9",
      "pembeliankategori_id":"3",
      "product_name":"SALDO GOJEK DRIVER 200K",
      "price":"201490",
      "status":"1"
   },
   {
      "id":51,
      "code":"GJD150",
      "pembelianoperator_id":"9",
      "pembeliankategori_id":"3",
      "product_name":"SALDO GOJEK DRIVER 150K",
      "price":"151490",
      "status":"1"
   },
   {
      "id":52,
      "code":"GJD100",
      "pembelianoperator_id":"9",
      "pembeliankategori_id":"3",
      "product_name":"SALDO GOJEK DRIVER 100K",
      "price":"101490",
      "status":"1"
   },
   {
      "id":53,
      "code":"GLP10",
      "pembelianoperator_id":"10",
      "pembeliankategori_id":"4",
      "product_name":"GOOGLE PLAY - $10",
      "price":"147965",
      "status":"0"
   },
   {
      "id":54,
      "code":"GLP15",
      "pembelianoperator_id":"10",
      "pembeliankategori_id":"4",
      "product_name":"GOOGLE PLAY - $15",
      "price":"215115",
      "status":"0"
   },
   {
      "id":55,
      "code":"GLP25",
      "pembelianoperator_id":"10",
      "pembeliankategori_id":"4",
      "product_name":"GOOGLE PLAY - $25",
      "price":"360365",
      "status":"0"
   },
   {
      "id":56,
      "code":"GLP50",
      "pembelianoperator_id":"10",
      "pembeliankategori_id":"4",
      "product_name":"GOOGLE PLAY - $50",
      "price":"704365",
      "status":"0"
   },
   {
      "id":57,
      "code":"GLP100",
      "pembelianoperator_id":"10",
      "pembeliankategori_id":"4",
      "product_name":"GOOGLE PLAY - $100",
      "price":"1384315",
      "status":"0"
   },
   {
      "id":58,
      "code":"GP20",
      "pembelianoperator_id":"11",
      "pembeliankategori_id":"4",
      "product_name":"GOOGLE PLAY ID 20RB",
      "price":"23365",
      "status":"1"
   },
   {
      "id":59,
      "code":"GP150",
      "pembelianoperator_id":"11",
      "pembeliankategori_id":"4",
      "product_name":"GOOGLE PLAY ID 150RB",
      "price":"171340",
      "status":"1"
   },
   {
      "id":60,
      "code":"GP100",
      "pembelianoperator_id":"11",
      "pembeliankategori_id":"4",
      "product_name":"GOOGLE PLAY ID 100RB",
      "price":"115340",
      "status":"1"
   },
   {
      "id":61,
      "code":"GP50",
      "pembelianoperator_id":"11",
      "pembeliankategori_id":"4",
      "product_name":"GOOGLE PLAY ID 50RB",
      "price":"58015",
      "status":"1"
   },
   {
      "id":62,
      "code":"GP500",
      "pembelianoperator_id":"11",
      "pembeliankategori_id":"4",
      "product_name":"GOOGLE PLAY ID 500RB",
      "price":"564340",
      "status":"1"
   },
   {
      "id":63,
      "code":"GP300",
      "pembelianoperator_id":"11",
      "pembeliankategori_id":"4",
      "product_name":"GOOGLE PLAY ID 300RB",
      "price":"339340",
      "status":"1"
   },
   {
      "id":64,
      "code":"GB500",
      "pembelianoperator_id":"12",
      "pembeliankategori_id":"3",
      "product_name":"SALDO GRAB 500K",
      "price":"500765",
      "status":"1"
   },
   {
      "id":65,
      "code":"GB300",
      "pembelianoperator_id":"12",
      "pembeliankategori_id":"3",
      "product_name":"SALDO GRAB 300K",
      "price":"300765",
      "status":"1"
   },
   {
      "id":66,
      "code":"GB200",
      "pembelianoperator_id":"12",
      "pembeliankategori_id":"3",
      "product_name":"SALDO GRAB 200K",
      "price":"200765",
      "status":"1"
   },
   {
      "id":67,
      "code":"GB150",
      "pembelianoperator_id":"12",
      "pembeliankategori_id":"3",
      "product_name":"SALDO GRAB 150K",
      "price":"150765",
      "status":"1"
   },
   {
      "id":68,
      "code":"GB100",
      "pembelianoperator_id":"12",
      "pembeliankategori_id":"3",
      "product_name":"SALDO GRAB 100K",
      "price":"100765",
      "status":"1"
   },
   {
      "id":69,
      "code":"GB50",
      "pembelianoperator_id":"12",
      "pembeliankategori_id":"3",
      "product_name":"SALDO GRAB 50K",
      "price":"50765",
      "status":"1"
   },
   {
      "id":70,
      "code":"GB40",
      "pembelianoperator_id":"12",
      "pembeliankategori_id":"3",
      "product_name":"SALDO GRAB 40K",
      "price":"40765",
      "status":"1"
   },
   {
      "id":71,
      "code":"GB25",
      "pembelianoperator_id":"12",
      "pembeliankategori_id":"3",
      "product_name":"SALDO GRAB 25K",
      "price":"25765",
      "status":"1"
   },
   {
      "id":72,
      "code":"GB20",
      "pembelianoperator_id":"12",
      "pembeliankategori_id":"3",
      "product_name":"SALDO GRAB 20K",
      "price":"20765",
      "status":"1"
   },
   {
      "id":73,
      "code":"GB10",
      "pembelianoperator_id":"12",
      "pembeliankategori_id":"3",
      "product_name":"SALDO GRAB 10K",
      "price":"10915",
      "status":"1"
   },
   {
      "id":74,
      "code":"I5",
      "pembelianoperator_id":"13",
      "pembeliankategori_id":"1",
      "product_name":"INDOSAT 5000",
      "price":"6015",
      "status":"1"
   },
   {
      "id":75,
      "code":"I10",
      "pembelianoperator_id":"13",
      "pembeliankategori_id":"1",
      "product_name":"INDOSAT 10000",
      "price":"11015",
      "status":"1"
   },
   {
      "id":76,
      "code":"I25",
      "pembelianoperator_id":"13",
      "pembeliankategori_id":"1",
      "product_name":"INDOSAT 25000",
      "price":"24665",
      "status":"1"
   },
   {
      "id":77,
      "code":"I50",
      "pembelianoperator_id":"13",
      "pembeliankategori_id":"1",
      "product_name":"INDOSAT 50000",
      "price":"48915",
      "status":"1"
   },
   {
      "id":78,
      "code":"I100",
      "pembelianoperator_id":"13",
      "pembeliankategori_id":"1",
      "product_name":"INDOSAT 100000",
      "price":"96915",
      "status":"1"
   },
   {
      "id":79,
      "code":"I20",
      "pembelianoperator_id":"13",
      "pembeliankategori_id":"1",
      "product_name":"INDOSAT 20000",
      "price":"20125",
      "status":"1"
   },
   {
      "id":80,
      "code":"I30",
      "pembelianoperator_id":"13",
      "pembeliankategori_id":"1",
      "product_name":"INDOSAT 30000",
      "price":"29815",
      "status":"1"
   },
   {
      "id":81,
      "code":"IDB3",
      "pembelianoperator_id":"14",
      "pembeliankategori_id":"2",
      "product_name":"3GB+18GB(01-06)+4GB 4G, 30HR",
      "price":"43790",
      "status":"0"
   },
   {
      "id":82,
      "code":"IDB9",
      "pembelianoperator_id":"14",
      "pembeliankategori_id":"2",
      "product_name":"9GB+16GB(01-06)+5GB 4G, 60HR",
      "price":"59940",
      "status":"0"
   },
   {
      "id":83,
      "code":"IDB20",
      "pembelianoperator_id":"14",
      "pembeliankategori_id":"2",
      "product_name":"20GB+10GB(01-06)+5GB 4G, 60HR",
      "price":"86140",
      "status":"0"
   },
   {
      "id":84,
      "code":"IDX2",
      "pembelianoperator_id":"15",
      "pembeliankategori_id":"2",
      "product_name":"EXTRA 2GB",
      "price":"37140",
      "status":"1"
   },
   {
      "id":85,
      "code":"IDX4",
      "pembelianoperator_id":"15",
      "pembeliankategori_id":"2",
      "product_name":"EXTRA 4GB",
      "price":"52790",
      "status":"1"
   },
   {
      "id":86,
      "code":"IDX6",
      "pembelianoperator_id":"15",
      "pembeliankategori_id":"2",
      "product_name":"EXTRA 6GB",
      "price":"70915",
      "status":"1"
   },
   {
      "id":87,
      "code":"IFC1",
      "pembelianoperator_id":"16",
      "pembeliankategori_id":"2",
      "product_name":"FREEDOM M, 2+3GB 4G, 30HR",
      "price":"55315",
      "status":"1"
   },
   {
      "id":88,
      "code":"IFC3",
      "pembelianoperator_id":"16",
      "pembeliankategori_id":"2",
      "product_name":"FREEDOM L, 4+8GB 4G, 30HR",
      "price":"82540",
      "status":"1"
   },
   {
      "id":89,
      "code":"IFC5",
      "pembelianoperator_id":"16",
      "pembeliankategori_id":"2",
      "product_name":"FREEDOM XL, 8+12GB 4G, 30HR",
      "price":"117765",
      "status":"1"
   },
   {
      "id":90,
      "code":"IFC10",
      "pembelianoperator_id":"16",
      "pembeliankategori_id":"2",
      "product_name":"FREEDOM XXL, 12+25GB 4G, 30HR",
      "price":"141040",
      "status":"1"
   },
   {
      "id":91,
      "code":"IDM2",
      "pembelianoperator_id":"17",
      "pembeliankategori_id":"2",
      "product_name":"MINI 2GB+500MB LOKAL+3.5GB MALAM+500MB APPS 30HR",
      "price":"33265",
      "status":"1"
   },
   {
      "id":92,
      "code":"IDM1",
      "pembelianoperator_id":"17",
      "pembeliankategori_id":"2",
      "product_name":"MINI 1GB+500MB LOKAL+1GB MALAM+500MB APPS 30HR",
      "price":"16465",
      "status":"1"
   },
   {
      "id":93,
      "code":"IDN1",
      "pembelianoperator_id":"18",
      "pembeliankategori_id":"2",
      "product_name":"KUOTA 1GB 30HR",
      "price":"16815",
      "status":"1"
   },
   {
      "id":94,
      "code":"IDN2",
      "pembelianoperator_id":"18",
      "pembeliankategori_id":"2",
      "product_name":"KUOTA 2GB 30HR",
      "price":"32490",
      "status":"1"
   },
   {
      "id":95,
      "code":"IDN3",
      "pembelianoperator_id":"18",
      "pembeliankategori_id":"2",
      "product_name":"KUOTA 3GB + SMS SESAMA 30HR",
      "price":"47090",
      "status":"1"
   },
   {
      "id":96,
      "code":"IDN10",
      "pembelianoperator_id":"18",
      "pembeliankategori_id":"2",
      "product_name":"KUOTA 10GB + SMS&TELP SESAMA 30HR",
      "price":"87690",
      "status":"1"
   },
   {
      "id":97,
      "code":"IDN7",
      "pembelianoperator_id":"18",
      "pembeliankategori_id":"2",
      "product_name":"KUOTA 7GB + SMS SESAMA 30HR",
      "price":"67290",
      "status":"1"
   },
   {
      "id":98,
      "code":"IDN15",
      "pembelianoperator_id":"18",
      "pembeliankategori_id":"2",
      "product_name":"KUOTA 15GB + SMS&TELP SESAMA 30HR",
      "price":"114490",
      "status":"1"
   },
   {
      "id":99,
      "code":"IDN99",
      "pembelianoperator_id":"18",
      "pembeliankategori_id":"2",
      "product_name":"KUOTA UNLIMITED + SMS&TELP SESAMA 30HR",
      "price":"153190",
      "status":"1"
   },
   {
      "id":100,
      "code":"I5S",
      "pembelianoperator_id":"19",
      "pembeliankategori_id":"5",
      "product_name":"300 SMS SESAMA ISAT + 100 SMS OPERATOR LAIN",
      "price":"6514",
      "status":"1"
   },
   {
      "id":101,
      "code":"I10S",
      "pembelianoperator_id":"19",
      "pembeliankategori_id":"5",
      "product_name":"600 SMS SESAMA ISAT + 200 SMS OPERATOR LAIN",
      "price":"12040",
      "status":"1"
   },
   {
      "id":102,
      "code":"I25S",
      "pembelianoperator_id":"19",
      "pembeliankategori_id":"5",
      "product_name":"2000 SMS SESAMA ISAT + 500 SMS OPERATOR LAIN",
      "price":"28140",
      "status":"1"
   },
   {
      "id":103,
      "code":"IT4",
      "pembelianoperator_id":"20",
      "pembeliankategori_id":"5",
      "product_name":"TELEPON SESAMA ISAT UNLIMITED + 250MENIT ALL, 30HR",
      "price":"49115",
      "status":"1"
   },
   {
      "id":104,
      "code":"IT3",
      "pembelianoperator_id":"20",
      "pembeliankategori_id":"5",
      "product_name":"TELEPON SESAMA ISAT UNLIMITED, 30HR",
      "price":"24910",
      "status":"1"
   },
   {
      "id":105,
      "code":"IT12",
      "pembelianoperator_id":"20",
      "pembeliankategori_id":"5",
      "product_name":"TELEPON SESAMA ISAT UNLIMITED + 30MENIT ALL, 7HR",
      "price":"12990",
      "status":"1"
   },
   {
      "id":106,
      "code":"IT25",
      "pembelianoperator_id":"20",
      "pembeliankategori_id":"5",
      "product_name":"TELEPON SESAMA ISAT UNLIMITED + 60MENIT ALL, 30HR",
      "price":"25990",
      "status":"1"
   },
   {
      "id":107,
      "code":"IT2",
      "pembelianoperator_id":"20",
      "pembeliankategori_id":"5",
      "product_name":"TELEPON SESAMA ISAT UNLIMITED + 50MENIT ALL, 7HR",
      "price":"14715",
      "status":"1"
   },
   {
      "id":108,
      "code":"IT1",
      "pembelianoperator_id":"20",
      "pembeliankategori_id":"5",
      "product_name":"TELEPON SESAMA ISAT 1000 MENIT, 1HR",
      "price":"2965",
      "status":"1"
   },
   {
      "id":109,
      "code":"ITR5",
      "pembelianoperator_id":"21",
      "pembeliankategori_id":"6",
      "product_name":"INDOSAT TRANSFER PULSA 5000",
      "price":"5840",
      "status":"0"
   },
   {
      "id":110,
      "code":"ITR10",
      "pembelianoperator_id":"21",
      "pembeliankategori_id":"6",
      "product_name":"INDOSAT TRANSFER PULSA 10000",
      "price":"10715",
      "status":"1"
   },
   {
      "id":111,
      "code":"ITR25",
      "pembelianoperator_id":"21",
      "pembeliankategori_id":"6",
      "product_name":"INDOSAT TRANSFER PULSA 25000",
      "price":"23740",
      "status":"1"
   },
   {
      "id":112,
      "code":"ITR50",
      "pembelianoperator_id":"21",
      "pembeliankategori_id":"6",
      "product_name":"INDOSAT TRANSFER PULSA 50000",
      "price":"47240",
      "status":"1"
   },
   {
      "id":113,
      "code":"ITR100",
      "pembelianoperator_id":"21",
      "pembeliankategori_id":"6",
      "product_name":"INDOSAT TRANSFER PULSA 100000",
      "price":"95340",
      "status":"1"
   },
   {
      "id":114,
      "code":"ITR20",
      "pembelianoperator_id":"21",
      "pembeliankategori_id":"6",
      "product_name":"INDOSAT TRANSFER PULSA 20000",
      "price":"19915",
      "status":"1"
   },
   {
      "id":115,
      "code":"ITR15",
      "pembelianoperator_id":"21",
      "pembeliankategori_id":"6",
      "product_name":"INDOSAT TRANSFER PULSA 15000",
      "price":"15415",
      "status":"1"
   },
   {
      "id":116,
      "code":"ITR30",
      "pembelianoperator_id":"21",
      "pembeliankategori_id":"6",
      "product_name":"INDOSAT TRANSFER PULSA 30000",
      "price":"29715",
      "status":"1"
   },
   {
      "id":117,
      "code":"IDH1",
      "pembelianoperator_id":"22",
      "pembeliankategori_id":"2",
      "product_name":"YELLOW 1GB 1HR",
      "price":"2315",
      "status":"1"
   },
   {
      "id":118,
      "code":"IDH15",
      "pembelianoperator_id":"22",
      "pembeliankategori_id":"2",
      "product_name":"YELLOW 1GB 15HR",
      "price":"12340",
      "status":"1"
   },
   {
      "id":119,
      "code":"IDH7",
      "pembelianoperator_id":"22",
      "pembeliankategori_id":"2",
      "product_name":"YELLOW 1GB 7HR",
      "price":"8790",
      "status":"1"
   },
   {
      "id":120,
      "code":"IDH3",
      "pembelianoperator_id":"22",
      "pembeliankategori_id":"2",
      "product_name":"YELLOW 1GB 3HR",
      "price":"3665",
      "status":"1"
   },
   {
      "id":121,
      "code":"ITN10",
      "pembelianoperator_id":"23",
      "pembeliankategori_id":"7",
      "product_name":"ITUNES GIFT CARD $10",
      "price":"145365",
      "status":"1"
   },
   {
      "id":122,
      "code":"ITN15",
      "pembelianoperator_id":"23",
      "pembeliankategori_id":"7",
      "product_name":"ITUNES GIFT CARD $15",
      "price":"195365",
      "status":"1"
   },
   {
      "id":123,
      "code":"ITN25",
      "pembelianoperator_id":"23",
      "pembeliankategori_id":"7",
      "product_name":"ITUNES GIFT CARD $25",
      "price":"325365",
      "status":"1"
   },
   {
      "id":124,
      "code":"ITN50",
      "pembelianoperator_id":"23",
      "pembeliankategori_id":"7",
      "product_name":"ITUNES GIFT CARD $50",
      "price":"655365",
      "status":"1"
   },
   {
      "id":125,
      "code":"ITN100",
      "pembelianoperator_id":"23",
      "pembeliankategori_id":"7",
      "product_name":"ITUNES GIFT CARD $100",
      "price":"1375365",
      "status":"1"
   },
   {
      "id":126,
      "code":"OV50",
      "pembelianoperator_id":"24",
      "pembeliankategori_id":"8",
      "product_name":"ORANGE TV 50.000",
      "price":"46365",
      "status":"0"
   },
   {
      "id":127,
      "code":"OV80",
      "pembelianoperator_id":"24",
      "pembeliankategori_id":"8",
      "product_name":"ORANGE TV 80.000",
      "price":"73965",
      "status":"0"
   },
   {
      "id":128,
      "code":"OV100",
      "pembelianoperator_id":"24",
      "pembeliankategori_id":"8",
      "product_name":"ORANGE TV 100.000",
      "price":"92365",
      "status":"0"
   },
   {
      "id":129,
      "code":"OV150",
      "pembelianoperator_id":"24",
      "pembeliankategori_id":"8",
      "product_name":"ORANGE TV 150.000",
      "price":"138365",
      "status":"0"
   },
   {
      "id":130,
      "code":"OV300",
      "pembelianoperator_id":"24",
      "pembeliankategori_id":"8",
      "product_name":"ORANGE TV 300.000",
      "price":"276365",
      "status":"0"
   },
   {
      "id":131,
      "code":"OV1000",
      "pembelianoperator_id":"24",
      "pembeliankategori_id":"8",
      "product_name":"ORANGE TV 1.000.000",
      "price":"920365",
      "status":"0"
   },
   {
      "id":132,
      "code":"VO1000",
      "pembelianoperator_id":"25",
      "pembeliankategori_id":"9",
      "product_name":"SALDO OVO 1000K",
      "price":"1006440",
      "status":"1"
   },
   {
      "id":133,
      "code":"VO900",
      "pembelianoperator_id":"25",
      "pembeliankategori_id":"9",
      "product_name":"SALDO OVO 900K",
      "price":"906440",
      "status":"1"
   },
   {
      "id":134,
      "code":"VO800",
      "pembelianoperator_id":"25",
      "pembeliankategori_id":"9",
      "product_name":"SALDO OVO 800K",
      "price":"806440",
      "status":"1"
   },
   {
      "id":135,
      "code":"VO700",
      "pembelianoperator_id":"25",
      "pembeliankategori_id":"9",
      "product_name":"SALDO OVO 700K",
      "price":"706440",
      "status":"1"
   },
   {
      "id":136,
      "code":"VO600",
      "pembelianoperator_id":"25",
      "pembeliankategori_id":"9",
      "product_name":"SALDO OVO 600K",
      "price":"606440",
      "status":"1"
   },
   {
      "id":137,
      "code":"VO500",
      "pembelianoperator_id":"25",
      "pembeliankategori_id":"9",
      "product_name":"SALDO OVO 500K",
      "price":"501440",
      "status":"1"
   },
   {
      "id":138,
      "code":"VO400",
      "pembelianoperator_id":"25",
      "pembeliankategori_id":"9",
      "product_name":"SALDO OVO 400K",
      "price":"401440",
      "status":"1"
   },
   {
      "id":139,
      "code":"VO300",
      "pembelianoperator_id":"25",
      "pembeliankategori_id":"9",
      "product_name":"SALDO OVO 300K",
      "price":"301440",
      "status":"1"
   },
   {
      "id":140,
      "code":"VO200",
      "pembelianoperator_id":"25",
      "pembeliankategori_id":"9",
      "product_name":"SALDO OVO 200K",
      "price":"201440",
      "status":"1"
   },
   {
      "id":141,
      "code":"VO100",
      "pembelianoperator_id":"25",
      "pembeliankategori_id":"9",
      "product_name":"SALDO OVO 100K",
      "price":"101040",
      "status":"1"
   },
   {
      "id":142,
      "code":"VO50",
      "pembelianoperator_id":"25",
      "pembeliankategori_id":"9",
      "product_name":"SALDO OVO 50K",
      "price":"51040",
      "status":"1"
   },
   {
      "id":143,
      "code":"VO25",
      "pembelianoperator_id":"25",
      "pembeliankategori_id":"9",
      "product_name":"SALDO OVO 25K",
      "price":"26140",
      "status":"1"
   },
   {
      "id":144,
      "code":"VO10",
      "pembelianoperator_id":"25",
      "pembeliankategori_id":"9",
      "product_name":"SALDO OVO 10K",
      "price":"11190",
      "status":"0"
   },
   {
      "id":145,
      "code":"SM5",
      "pembelianoperator_id":"26",
      "pembeliankategori_id":"1",
      "product_name":"SMARTFREN 5000",
      "price":"5190",
      "status":"1"
   },
   {
      "id":146,
      "code":"SM10",
      "pembelianoperator_id":"26",
      "pembeliankategori_id":"1",
      "product_name":"SMARTFREN 10000",
      "price":"10115",
      "status":"1"
   },
   {
      "id":147,
      "code":"SM20",
      "pembelianoperator_id":"26",
      "pembeliankategori_id":"1",
      "product_name":"SMARTFREN 20000",
      "price":"19965",
      "status":"1"
   },
   {
      "id":148,
      "code":"SM25",
      "pembelianoperator_id":"26",
      "pembeliankategori_id":"1",
      "product_name":"SMARTFREN 25000",
      "price":"24815",
      "status":"1"
   },
   {
      "id":149,
      "code":"SM30",
      "pembelianoperator_id":"26",
      "pembeliankategori_id":"1",
      "product_name":"SMARTFREN 30000",
      "price":"29790",
      "status":"1"
   },
   {
      "id":150,
      "code":"SM50",
      "pembelianoperator_id":"26",
      "pembeliankategori_id":"1",
      "product_name":"SMARTFREN 50000",
      "price":"48740",
      "status":"1"
   },
   {
      "id":151,
      "code":"SM100",
      "pembelianoperator_id":"26",
      "pembeliankategori_id":"1",
      "product_name":"SMARTFREN 100000",
      "price":"97390",
      "status":"1"
   },
   {
      "id":152,
      "code":"SM60",
      "pembelianoperator_id":"26",
      "pembeliankategori_id":"1",
      "product_name":"SMARTFREN 60000",
      "price":"59090",
      "status":"1"
   },
   {
      "id":153,
      "code":"SM75",
      "pembelianoperator_id":"26",
      "pembeliankategori_id":"1",
      "product_name":"SMARTFREN 75000",
      "price":"74865",
      "status":"1"
   },
   {
      "id":154,
      "code":"SMV20",
      "pembelianoperator_id":"27",
      "pembeliankategori_id":"2",
      "product_name":"VOLUME 2GB + 2GB MALAM 7HR",
      "price":"19390",
      "status":"1"
   },
   {
      "id":155,
      "code":"SMV200",
      "pembelianoperator_id":"27",
      "pembeliankategori_id":"2",
      "product_name":"VOLUME 30GB + 30GB MALAM 30HR",
      "price":"190740",
      "status":"1"
   },
   {
      "id":156,
      "code":"SMV150",
      "pembelianoperator_id":"27",
      "pembeliankategori_id":"2",
      "product_name":"VOLUME 22.5GB + 22.5GB MALAM 30HR",
      "price":"143140",
      "status":"1"
   },
   {
      "id":157,
      "code":"SMV100",
      "pembelianoperator_id":"27",
      "pembeliankategori_id":"2",
      "product_name":"VOLUME 15GB + 15GB MALAM 30HR",
      "price":"90440",
      "status":"1"
   },
   {
      "id":158,
      "code":"SMV60",
      "pembelianoperator_id":"27",
      "pembeliankategori_id":"2",
      "product_name":"VOLUME 8GB + 8GB MALAM 30HR",
      "price":"54640",
      "status":"1"
   },
   {
      "id":159,
      "code":"SMV30",
      "pembelianoperator_id":"27",
      "pembeliankategori_id":"2",
      "product_name":"VOLUME 4GB + 4GB MALAM 14HR",
      "price":"28540",
      "status":"1"
   },
   {
      "id":160,
      "code":"SMD60",
      "pembelianoperator_id":"28",
      "pembeliankategori_id":"2",
      "product_name":"SMARTFREN KUOTA 2GB+12GB MDS 30HR",
      "price":"60390",
      "status":"0"
   },
   {
      "id":161,
      "code":"SMD50",
      "pembelianoperator_id":"28",
      "pembeliankategori_id":"2",
      "product_name":"SMARTFREN KUOTA 1.75GB 30HR",
      "price":"50465",
      "status":"0"
   },
   {
      "id":162,
      "code":"SMD100",
      "pembelianoperator_id":"28",
      "pembeliankategori_id":"2",
      "product_name":"SMARTFREN KUOTA 5GB+12GB MDS 30HR",
      "price":"100290",
      "status":"0"
   },
   {
      "id":163,
      "code":"SMD20",
      "pembelianoperator_id":"28",
      "pembeliankategori_id":"2",
      "product_name":"SMARTFREN KUOTA 300MB 7HR",
      "price":"12590",
      "status":"0"
   },
   {
      "id":164,
      "code":"SMD75",
      "pembelianoperator_id":"28",
      "pembeliankategori_id":"2",
      "product_name":"SMARTFREN KUOTA 3GB+3GB 30HR",
      "price":"75165",
      "status":"0"
   },
   {
      "id":165,
      "code":"SMD30",
      "pembelianoperator_id":"28",
      "pembeliankategori_id":"2",
      "product_name":"SMARTFREN KUOTA 650MB 7HR",
      "price":"25540",
      "status":"0"
   },
   {
      "id":166,
      "code":"SMD150",
      "pembelianoperator_id":"28",
      "pembeliankategori_id":"2",
      "product_name":"SMARTFREN KUOTA 9GB+9GB 30HR",
      "price":"149490",
      "status":"0"
   },
   {
      "id":167,
      "code":"SMD200",
      "pembelianoperator_id":"28",
      "pembeliankategori_id":"2",
      "product_name":"SMARTFREN KUOTA 14GB+14GB 30HR",
      "price":"199690",
      "status":"0"
   },
   {
      "id":168,
      "code":"S5",
      "pembelianoperator_id":"29",
      "pembeliankategori_id":"1",
      "product_name":"TELKOMSEL 5K",
      "price":"5290",
      "status":"1"
   },
   {
      "id":169,
      "code":"S10",
      "pembelianoperator_id":"29",
      "pembeliankategori_id":"1",
      "product_name":"TELKOMSEL 10K",
      "price":"10295",
      "status":"1"
   },
   {
      "id":170,
      "code":"S20",
      "pembelianoperator_id":"29",
      "pembeliankategori_id":"1",
      "product_name":"TELKOMSEL 20K",
      "price":"20055",
      "status":"1"
   },
   {
      "id":171,
      "code":"S25",
      "pembelianoperator_id":"29",
      "pembeliankategori_id":"1",
      "product_name":"TELKOMSEL 25K",
      "price":"24840",
      "status":"1"
   },
   {
      "id":172,
      "code":"S50",
      "pembelianoperator_id":"29",
      "pembeliankategori_id":"1",
      "product_name":"TELKOMSEL 50K",
      "price":"49415",
      "status":"1"
   },
   {
      "id":173,
      "code":"S100",
      "pembelianoperator_id":"29",
      "pembeliankategori_id":"1",
      "product_name":"TELKOMSEL 100K",
      "price":"97415",
      "status":"1"
   },
   {
      "id":174,
      "code":"S200",
      "pembelianoperator_id":"29",
      "pembeliankategori_id":"1",
      "product_name":"TELKOMSEL 200K",
      "price":"194840",
      "status":"1"
   },
   {
      "id":175,
      "code":"S150",
      "pembelianoperator_id":"29",
      "pembeliankategori_id":"1",
      "product_name":"TELKOMSEL 150K",
      "price":"145290",
      "status":"1"
   },
   {
      "id":176,
      "code":"S300",
      "pembelianoperator_id":"29",
      "pembeliankategori_id":"1",
      "product_name":"TELKOMSEL 300K",
      "price":"294215",
      "status":"1"
   },
   {
      "id":177,
      "code":"S1",
      "pembelianoperator_id":"29",
      "pembeliankategori_id":"1",
      "product_name":"TELKOMSEL 1K",
      "price":"1990",
      "status":"1"
   },
   {
      "id":178,
      "code":"STG5",
      "pembelianoperator_id":"30",
      "pembeliankategori_id":"2",
      "product_name":"20MB-40MB 7HR",
      "price":"5690",
      "status":"1"
   },
   {
      "id":179,
      "code":"STG10",
      "pembelianoperator_id":"30",
      "pembeliankategori_id":"2",
      "product_name":"50MB-110MB 7HR",
      "price":"9940",
      "status":"1"
   },
   {
      "id":180,
      "code":"STG20",
      "pembelianoperator_id":"30",
      "pembeliankategori_id":"2",
      "product_name":"200MB-420MB 7HR",
      "price":"14690",
      "status":"1"
   },
   {
      "id":181,
      "code":"STG50",
      "pembelianoperator_id":"30",
      "pembeliankategori_id":"2",
      "product_name":"800MB-1.5GB (+2GB VIDEOMAX) 30HR",
      "price":"48915",
      "status":"1"
   },
   {
      "id":182,
      "code":"STG100",
      "pembelianoperator_id":"30",
      "pembeliankategori_id":"2",
      "product_name":"2.5GB-4.5GB (+2GB VIDEOMAX) 30HR",
      "price":"96135",
      "status":"1"
   },
   {
      "id":183,
      "code":"STG25",
      "pembelianoperator_id":"30",
      "pembeliankategori_id":"2",
      "product_name":"270MB-750MB 30HR",
      "price":"24815",
      "status":"1"
   },
   {
      "id":184,
      "code":"SDA1",
      "pembelianoperator_id":"31",
      "pembeliankategori_id":"2",
      "product_name":"AS 1GB + 2GB VIDEOMAX 30HR",
      "price":"42565",
      "status":"1"
   },
   {
      "id":185,
      "code":"SDA5",
      "pembelianoperator_id":"31",
      "pembeliankategori_id":"2",
      "product_name":"AS 7GB + 2GB VIDEOMAX 30HR",
      "price":"176640",
      "status":"0"
   },
   {
      "id":186,
      "code":"SDA3",
      "pembelianoperator_id":"31",
      "pembeliankategori_id":"2",
      "product_name":"AS 3GB + 2GB VIDEOMAX 30HR",
      "price":"61739",
      "status":"1"
   },
   {
      "id":187,
      "code":"SDA2",
      "pembelianoperator_id":"31",
      "pembeliankategori_id":"2",
      "product_name":"AS 2GB + 2GB VIDEOMAX + (100MENIT & 100SMS) 30HR",
      "price":"67190",
      "status":"1"
   },
   {
      "id":188,
      "code":"SDA27",
      "pembelianoperator_id":"31",
      "pembeliankategori_id":"2",
      "product_name":"AS 2GB 7HR",
      "price":"37590",
      "status":"1"
   },
   {
      "id":189,
      "code":"SDA17",
      "pembelianoperator_id":"31",
      "pembeliankategori_id":"2",
      "product_name":"AS 1GB 7HR",
      "price":"30440",
      "status":"1"
   },
   {
      "id":190,
      "code":"SDA30",
      "pembelianoperator_id":"31",
      "pembeliankategori_id":"2",
      "product_name":"AS 30GB + 2GB VIDEOMAX 30HR",
      "price":"178715",
      "status":"1"
   },
   {
      "id":191,
      "code":"SDA15",
      "pembelianoperator_id":"31",
      "pembeliankategori_id":"2",
      "product_name":"AS 15GB + 2GB VIDEOMAX 30HR",
      "price":"116365",
      "status":"1"
   },
   {
      "id":192,
      "code":"SDA8",
      "pembelianoperator_id":"31",
      "pembeliankategori_id":"2",
      "product_name":"AS 8GB + 2GB VIDEOMAX 30HR",
      "price":"88990",
      "status":"1"
   },
   {
      "id":193,
      "code":"SDB8",
      "pembelianoperator_id":"32",
      "pembeliankategori_id":"2",
      "product_name":"BULK 8GB + 2GB VIDEOMAX 30HR",
      "price":"84840",
      "status":"1"
   },
   {
      "id":194,
      "code":"SDB3",
      "pembelianoperator_id":"32",
      "pembeliankategori_id":"2",
      "product_name":"BULK 4.5GB + 2GB VIDEOMAX 30HR",
      "price":"63940",
      "status":"1"
   },
   {
      "id":195,
      "code":"SDB35",
      "pembelianoperator_id":"32",
      "pembeliankategori_id":"2",
      "product_name":"BULK 50GB + 2GB VIDEOMAX 30HR",
      "price":"193940",
      "status":"1"
   },
   {
      "id":196,
      "code":"SDB25",
      "pembelianoperator_id":"32",
      "pembeliankategori_id":"2",
      "product_name":"BULK 25GB + 2GB VIDEOMAX 30HR",
      "price":"164190",
      "status":"1"
   },
   {
      "id":197,
      "code":"SDB12",
      "pembelianoperator_id":"32",
      "pembeliankategori_id":"2",
      "product_name":"BULK 12GB + 2GB VIDEOMAX 30HR",
      "price":"100940",
      "status":"1"
   },
   {
      "id":198,
      "code":"SDB1",
      "pembelianoperator_id":"32",
      "pembeliankategori_id":"2",
      "product_name":"BULK 2GB + 2GB VIDEOMAX 30HR",
      "price":"38690",
      "status":"1"
   },
   {
      "id":199,
      "code":"SS1",
      "pembelianoperator_id":"33",
      "pembeliankategori_id":"5",
      "product_name":"200 SMS KE SEMUA 1 HARI",
      "price":"1214",
      "status":"1"
   },
   {
      "id":200,
      "code":"SS5",
      "pembelianoperator_id":"33",
      "pembeliankategori_id":"5",
      "product_name":"1000 SMS KE SEMUA 5 HARI",
      "price":"4987",
      "status":"1"
   },
   {
      "id":201,
      "code":"ST50",
      "pembelianoperator_id":"34",
      "pembeliankategori_id":"5",
      "product_name":"TELEPON SESAMA TSEL 1000MENIT + ALL 100MENIT (30HR)",
      "price":"52890",
      "status":"1"
   },
   {
      "id":202,
      "code":"ST100",
      "pembelianoperator_id":"34",
      "pembeliankategori_id":"5",
      "product_name":"TELEPON SESAMA TSEL 2250MENIT + ALL 250MENIT (30HR)",
      "price":"117390",
      "status":"1"
   },
   {
      "id":203,
      "code":"ST25",
      "pembelianoperator_id":"34",
      "pembeliankategori_id":"5",
      "product_name":"TELEPON SESAMA TSEL 350MENIT + ALL 50MENIT (7HR)",
      "price":"25640",
      "status":"1"
   },
   {
      "id":204,
      "code":"ST20",
      "pembelianoperator_id":"34",
      "pembeliankategori_id":"5",
      "product_name":"TELEPON SESAMA TSEL 350MENIT + ALL 50MENIT (7HR)",
      "price":"20415",
      "status":"1"
   },
   {
      "id":205,
      "code":"ST10",
      "pembelianoperator_id":"34",
      "pembeliankategori_id":"5",
      "product_name":"TELEPON SESAMA TSEL 170MENIT + ALL 30MENIT (3HR)",
      "price":"10715",
      "status":"1"
   },
   {
      "id":206,
      "code":"ST5",
      "pembelianoperator_id":"34",
      "pembeliankategori_id":"5",
      "product_name":"TELEPON SESAMA TSEL 85MENIT + ALL 15MENIT (1HR)",
      "price":"5740",
      "status":"1"
   },
   {
      "id":207,
      "code":"ST15",
      "pembelianoperator_id":"34",
      "pembeliankategori_id":"5",
      "product_name":"TELEPON SESAMA TSEL 370MENIT + ALL 30MENIT (3HR)",
      "price":"14490",
      "status":"1"
   },
   {
      "id":208,
      "code":"ST8",
      "pembelianoperator_id":"34",
      "pembeliankategori_id":"5",
      "product_name":"TELEPON SESAMA TSEL 185MENIT + ALL 15MENIT (1HR)",
      "price":"8490",
      "status":"1"
   },
   {
      "id":209,
      "code":"ST26",
      "pembelianoperator_id":"34",
      "pembeliankategori_id":"5",
      "product_name":"TELEPON SESAMA TSEL 550MENIT + ALL 50MENIT (7HR)",
      "price":"25390",
      "status":"1"
   },
   {
      "id":210,
      "code":"ST120",
      "pembelianoperator_id":"34",
      "pembeliankategori_id":"5",
      "product_name":"TELEPON SESAMA TSEL 6250MENIT + ALL 250MENIT (30HR)",
      "price":"120190",
      "status":"1"
   },
   {
      "id":211,
      "code":"ST70",
      "pembelianoperator_id":"34",
      "pembeliankategori_id":"5",
      "product_name":"TELEPON SESAMA TSEL 2000MENIT + ALL 100MENIT (30HR)",
      "price":"69990",
      "status":"1"
   },
   {
      "id":212,
      "code":"STR10",
      "pembelianoperator_id":"35",
      "pembeliankategori_id":"6",
      "product_name":"TSEL TRANSFER PULSA 10000",
      "price":"11390",
      "status":"1"
   },
   {
      "id":213,
      "code":"STR20",
      "pembelianoperator_id":"35",
      "pembeliankategori_id":"6",
      "product_name":"TSEL TRANSFER PULSA 20000",
      "price":"21090",
      "status":"1"
   },
   {
      "id":214,
      "code":"STR25",
      "pembelianoperator_id":"35",
      "pembeliankategori_id":"6",
      "product_name":"TSEL TRANSFER PULSA 25000",
      "price":"25835",
      "status":"1"
   },
   {
      "id":215,
      "code":"STR50",
      "pembelianoperator_id":"35",
      "pembeliankategori_id":"6",
      "product_name":"TSEL TRANSFER PULSA 50000",
      "price":"49470",
      "status":"1"
   },
   {
      "id":216,
      "code":"STR100",
      "pembelianoperator_id":"35",
      "pembeliankategori_id":"6",
      "product_name":"TSEL TRANSFER PULSA 100000",
      "price":"95940",
      "status":"1"
   },
   {
      "id":217,
      "code":"STR5",
      "pembelianoperator_id":"35",
      "pembeliankategori_id":"6",
      "product_name":"TSEL TRANSFER PULSA 5000",
      "price":"6640",
      "status":"1"
   },
   {
      "id":218,
      "code":"T1",
      "pembelianoperator_id":"36",
      "pembeliankategori_id":"1",
      "product_name":"THREE 1000",
      "price":"1381",
      "status":"1"
   },
   {
      "id":219,
      "code":"T2",
      "pembelianoperator_id":"36",
      "pembeliankategori_id":"1",
      "product_name":"THREE 2000",
      "price":"2378",
      "status":"1"
   },
   {
      "id":220,
      "code":"T3",
      "pembelianoperator_id":"36",
      "pembeliankategori_id":"1",
      "product_name":"THREE 3000",
      "price":"3350",
      "status":"1"
   },
   {
      "id":221,
      "code":"T4",
      "pembelianoperator_id":"36",
      "pembeliankategori_id":"1",
      "product_name":"THREE 4000",
      "price":"4517",
      "status":"1"
   },
   {
      "id":222,
      "code":"T5",
      "pembelianoperator_id":"36",
      "pembeliankategori_id":"1",
      "product_name":"THREE 5000",
      "price":"5483",
      "status":"1"
   },
   {
      "id":223,
      "code":"T6",
      "pembelianoperator_id":"36",
      "pembeliankategori_id":"1",
      "product_name":"THREE 6000",
      "price":"6603",
      "status":"0"
   },
   {
      "id":224,
      "code":"T7",
      "pembelianoperator_id":"36",
      "pembeliankategori_id":"1",
      "product_name":"THREE 7000",
      "price":"7586",
      "status":"0"
   },
   {
      "id":225,
      "code":"T8",
      "pembelianoperator_id":"36",
      "pembeliankategori_id":"1",
      "product_name":"THREE 8000",
      "price":"8568",
      "status":"0"
   },
   {
      "id":226,
      "code":"T9",
      "pembelianoperator_id":"36",
      "pembeliankategori_id":"1",
      "product_name":"THREE 9000",
      "price":"9551",
      "status":"1"
   },
   {
      "id":227,
      "code":"T10",
      "pembelianoperator_id":"36",
      "pembeliankategori_id":"1",
      "product_name":"THREE 10000",
      "price":"10315",
      "status":"1"
   },
   {
      "id":228,
      "code":"T20",
      "pembelianoperator_id":"36",
      "pembeliankategori_id":"1",
      "product_name":"THREE 20000",
      "price":"19735",
      "status":"1"
   },
   {
      "id":229,
      "code":"T30",
      "pembelianoperator_id":"36",
      "pembeliankategori_id":"1",
      "product_name":"THREE 30000",
      "price":"29515",
      "status":"1"
   },
   {
      "id":230,
      "code":"T40",
      "pembelianoperator_id":"36",
      "pembeliankategori_id":"1",
      "product_name":"THREE 40000",
      "price":"39640",
      "status":"1"
   },
   {
      "id":231,
      "code":"T50",
      "pembelianoperator_id":"36",
      "pembeliankategori_id":"1",
      "product_name":"THREE 50000",
      "price":"49165",
      "status":"1"
   },
   {
      "id":232,
      "code":"T75",
      "pembelianoperator_id":"36",
      "pembeliankategori_id":"1",
      "product_name":"THREE 75000",
      "price":"74128",
      "status":"1"
   },
   {
      "id":233,
      "code":"T100",
      "pembelianoperator_id":"36",
      "pembeliankategori_id":"1",
      "product_name":"THREE 100000",
      "price":"97915",
      "status":"1"
   },
   {
      "id":234,
      "code":"T150",
      "pembelianoperator_id":"36",
      "pembeliankategori_id":"1",
      "product_name":"THREE 150000",
      "price":"147840",
      "status":"1"
   },
   {
      "id":235,
      "code":"T25",
      "pembelianoperator_id":"36",
      "pembeliankategori_id":"1",
      "product_name":"THREE 25000",
      "price":"24565",
      "status":"1"
   },
   {
      "id":236,
      "code":"TD5",
      "pembelianoperator_id":"37",
      "pembeliankategori_id":"2",
      "product_name":"KUOTA 5 GB 30HR",
      "price":"67890",
      "status":"1"
   },
   {
      "id":237,
      "code":"TD8",
      "pembelianoperator_id":"37",
      "pembeliankategori_id":"2",
      "product_name":"KUOTA 8 GB 30HR",
      "price":"101615",
      "status":"1"
   },
   {
      "id":238,
      "code":"TD1",
      "pembelianoperator_id":"37",
      "pembeliankategori_id":"2",
      "product_name":"KUOTA 1 GB 30HR",
      "price":"20790",
      "status":"1"
   },
   {
      "id":239,
      "code":"TD2",
      "pembelianoperator_id":"37",
      "pembeliankategori_id":"2",
      "product_name":"KUOTA 2 GB 30HR",
      "price":"32840",
      "status":"1"
   },
   {
      "id":240,
      "code":"TD3",
      "pembelianoperator_id":"37",
      "pembeliankategori_id":"2",
      "product_name":"KUOTA 3 GB 30HR",
      "price":"47640",
      "status":"1"
   },
   {
      "id":241,
      "code":"TD4",
      "pembelianoperator_id":"37",
      "pembeliankategori_id":"2",
      "product_name":"KUOTA 4 GB 30HR",
      "price":"50415",
      "status":"1"
   },
   {
      "id":242,
      "code":"TD6",
      "pembelianoperator_id":"37",
      "pembeliankategori_id":"2",
      "product_name":"KUOTA 6 GB 30HR",
      "price":"75890",
      "status":"1"
   },
   {
      "id":243,
      "code":"TD10",
      "pembelianoperator_id":"37",
      "pembeliankategori_id":"2",
      "product_name":"KUOTA 10 GB 30HR",
      "price":"123115",
      "status":"1"
   },
   {
      "id":244,
      "code":"TBM3",
      "pembelianoperator_id":"38",
      "pembeliankategori_id":"2",
      "product_name":"BM 1GB + 500MB MALAM 30HR",
      "price":"26540",
      "status":"1"
   },
   {
      "id":245,
      "code":"TBM1",
      "pembelianoperator_id":"38",
      "pembeliankategori_id":"2",
      "product_name":"BM 500MB + 500MB MALAM 30HR",
      "price":"16540",
      "status":"1"
   },
   {
      "id":246,
      "code":"TDC10",
      "pembelianoperator_id":"39",
      "pembeliankategori_id":"2",
      "product_name":"CINTA 10GB 90HR + 5GB 4G + 30GB WEEKEND + 20GB MALAM 30HR",
      "price":"102840",
      "status":"1"
   },
   {
      "id":247,
      "code":"TDC6",
      "pembelianoperator_id":"39",
      "pembeliankategori_id":"2",
      "product_name":"CINTA 6GB 90HR + 3GB 4G + 19GB WEEKEND + 20GB MALAM 30HR",
      "price":"75540",
      "status":"1"
   },
   {
      "id":248,
      "code":"TGM5",
      "pembelianoperator_id":"40",
      "pembeliankategori_id":"2",
      "product_name":"GETMORE 5GB 60HR",
      "price":"53840",
      "status":"1"
   },
   {
      "id":249,
      "code":"TGM3",
      "pembelianoperator_id":"40",
      "pembeliankategori_id":"2",
      "product_name":"GETMORE 3GB 60HR",
      "price":"38640",
      "status":"1"
   },
   {
      "id":250,
      "code":"TGM2",
      "pembelianoperator_id":"40",
      "pembeliankategori_id":"2",
      "product_name":"GETMORE 2GB 60HR",
      "price":"30690",
      "status":"1"
   },
   {
      "id":251,
      "code":"TDR42",
      "pembelianoperator_id":"41",
      "pembeliankategori_id":"2",
      "product_name":"REGULER 4.25GB",
      "price":"81340",
      "status":"1"
   },
   {
      "id":252,
      "code":"TDR65",
      "pembelianoperator_id":"41",
      "pembeliankategori_id":"2",
      "product_name":"REGULER 650MB",
      "price":"20590",
      "status":"1"
   },
   {
      "id":253,
      "code":"TDR12",
      "pembelianoperator_id":"41",
      "pembeliankategori_id":"2",
      "product_name":"REGULER 1.25GB",
      "price":"33090",
      "status":"1"
   },
   {
      "id":254,
      "code":"TDR20",
      "pembelianoperator_id":"41",
      "pembeliankategori_id":"2",
      "product_name":"REGULER 20MB",
      "price":"3215",
      "status":"1"
   },
   {
      "id":255,
      "code":"TDR30",
      "pembelianoperator_id":"41",
      "pembeliankategori_id":"2",
      "product_name":"REGULER 300MB",
      "price":"10815",
      "status":"1"
   },
   {
      "id":256,
      "code":"TDR80",
      "pembelianoperator_id":"41",
      "pembeliankategori_id":"2",
      "product_name":"REGULER 80MB",
      "price":"6065",
      "status":"1"
   },
   {
      "id":257,
      "code":"TT5",
      "pembelianoperator_id":"42",
      "pembeliankategori_id":"5",
      "product_name":"TELEPON 20MENIT 7HR ALL OPERATOR",
      "price":"5440",
      "status":"1"
   },
   {
      "id":258,
      "code":"TT15",
      "pembelianoperator_id":"42",
      "pembeliankategori_id":"5",
      "product_name":"TELEPON 60MENIT 30HR ALL OPERATOR",
      "price":"15765",
      "status":"1"
   },
   {
      "id":259,
      "code":"TT30",
      "pembelianoperator_id":"42",
      "pembeliankategori_id":"5",
      "product_name":"TELEPON 150MENIT 30HR ALL OPERATOR",
      "price":"31015",
      "status":"1"
   },
   {
      "id":260,
      "code":"TTR25",
      "pembelianoperator_id":"43",
      "pembeliankategori_id":"6",
      "product_name":"TRI TRANSFER PULSA 25K + MASA AKTIF",
      "price":"24940",
      "status":"1"
   },
   {
      "id":261,
      "code":"TTR20",
      "pembelianoperator_id":"43",
      "pembeliankategori_id":"6",
      "product_name":"TRI TRANSFER PULSA 20K + MASA AKTIF",
      "price":"19915",
      "status":"0"
   },
   {
      "id":262,
      "code":"TTR10",
      "pembelianoperator_id":"43",
      "pembeliankategori_id":"6",
      "product_name":"TRI TRANSFER PULSA 10K + MASA AKTIF",
      "price":"10385",
      "status":"0"
   },
   {
      "id":263,
      "code":"TTR5",
      "pembelianoperator_id":"43",
      "pembeliankategori_id":"6",
      "product_name":"TRI TRANSFER PULSA 5K + MASA AKTIF",
      "price":"5490",
      "status":"1"
   },
   {
      "id":264,
      "code":"TTR100",
      "pembelianoperator_id":"43",
      "pembeliankategori_id":"6",
      "product_name":"TRI TRANSFER PULSA 100K + MASA AKTIF",
      "price":"98290",
      "status":"1"
   },
   {
      "id":265,
      "code":"TTR50",
      "pembelianoperator_id":"43",
      "pembeliankategori_id":"6",
      "product_name":"TRI TRANSFER PULSA 50K + MASA AKTIF",
      "price":"49390",
      "status":"0"
   },
   {
      "id":266,
      "code":"TTR30",
      "pembelianoperator_id":"43",
      "pembeliankategori_id":"6",
      "product_name":"TRI TRANSFER PULSA 30K + MASA AKTIF",
      "price":"29840",
      "status":"1"
   },
   {
      "id":267,
      "code":"X5",
      "pembelianoperator_id":"44",
      "pembeliankategori_id":"1",
      "product_name":"XL REGULER 5000",
      "price":"5630",
      "status":"1"
   },
   {
      "id":268,
      "code":"X10",
      "pembelianoperator_id":"44",
      "pembeliankategori_id":"1",
      "product_name":"XL REGULER 10000",
      "price":"10775",
      "status":"1"
   },
   {
      "id":269,
      "code":"X25",
      "pembelianoperator_id":"44",
      "pembeliankategori_id":"1",
      "product_name":"XL REGULER 25000",
      "price":"24940",
      "status":"1"
   },
   {
      "id":270,
      "code":"X50",
      "pembelianoperator_id":"44",
      "pembeliankategori_id":"1",
      "product_name":"XL REGULER 50000",
      "price":"49515",
      "status":"1"
   },
   {
      "id":271,
      "code":"X100",
      "pembelianoperator_id":"44",
      "pembeliankategori_id":"1",
      "product_name":"XL REGULER 100000",
      "price":"98415",
      "status":"1"
   },
   {
      "id":272,
      "code":"X15",
      "pembelianoperator_id":"44",
      "pembeliankategori_id":"1",
      "product_name":"XL REGULER 15000",
      "price":"15040",
      "status":"1"
   },
   {
      "id":273,
      "code":"X30",
      "pembelianoperator_id":"44",
      "pembeliankategori_id":"1",
      "product_name":"XL REGULER 30000",
      "price":"29865",
      "status":"1"
   },
   {
      "id":274,
      "code":"XCX5",
      "pembelianoperator_id":"45",
      "pembeliankategori_id":"2",
      "product_name":"COMBO XTRA 5GB+5GB YTB+20MNT 30HR",
      "price":"53540",
      "status":"1"
   },
   {
      "id":275,
      "code":"XCX10",
      "pembelianoperator_id":"45",
      "pembeliankategori_id":"2",
      "product_name":"COMBO XTRA 10GB+10GB YTB+40MNT 30HR",
      "price":"80490",
      "status":"1"
   },
   {
      "id":276,
      "code":"XCX35",
      "pembelianoperator_id":"45",
      "pembeliankategori_id":"2",
      "product_name":"COMBO XTRA 35GB+35GB YTB+60MNT, 30HR",
      "price":"214790",
      "status":"1"
   },
   {
      "id":277,
      "code":"XCX20",
      "pembelianoperator_id":"45",
      "pembeliankategori_id":"2",
      "product_name":"COMBO XTRA 20GB+20GB YTB+60MNT 30HR",
      "price":"160290",
      "status":"1"
   },
   {
      "id":278,
      "code":"XCX15",
      "pembelianoperator_id":"45",
      "pembeliankategori_id":"2",
      "product_name":"COMBO XTRA 15GB+15GB YTB+60MNT 30HR",
      "price":"116690",
      "status":"1"
   },
   {
      "id":279,
      "code":"XH30",
      "pembelianoperator_id":"46",
      "pembeliankategori_id":"2",
      "product_name":"HOTROD 24JAM, 30HR, 800MB",
      "price":"29790",
      "status":"1"
   },
   {
      "id":280,
      "code":"XH54",
      "pembelianoperator_id":"46",
      "pembeliankategori_id":"2",
      "product_name":"HOTROD 24JAM, 30HR, 3GB",
      "price":"55340",
      "status":"1"
   },
   {
      "id":281,
      "code":"XH90",
      "pembelianoperator_id":"46",
      "pembeliankategori_id":"2",
      "product_name":"HOTROD 24JAM, 30HR, 6GB",
      "price":"91140",
      "status":"1"
   },
   {
      "id":282,
      "code":"XH117",
      "pembelianoperator_id":"46",
      "pembeliankategori_id":"2",
      "product_name":"HOTROD 24JAM, 30HR, 8GB",
      "price":"117890",
      "status":"1"
   },
   {
      "id":283,
      "code":"XH162",
      "pembelianoperator_id":"46",
      "pembeliankategori_id":"2",
      "product_name":"HOTROD 24JAM, 30HR, 12GB",
      "price":"163340",
      "status":"1"
   },
   {
      "id":284,
      "code":"XH198",
      "pembelianoperator_id":"46",
      "pembeliankategori_id":"2",
      "product_name":"HOTROD 24JAM, 30HR, 16GB",
      "price":"198340",
      "status":"1"
   },
   {
      "id":285,
      "code":"XH45",
      "pembelianoperator_id":"46",
      "pembeliankategori_id":"2",
      "product_name":"HOTROD 24JAM, 30HR, 1.5GB",
      "price":"46340",
      "status":"1"
   },
   {
      "id":286,
      "code":"XHE35",
      "pembelianoperator_id":"47",
      "pembeliankategori_id":"2",
      "product_name":"HOTROD XTRA 1GB, 60MNT,30HR,RP39RB",
      "price":"35815",
      "status":"0"
   },
   {
      "id":287,
      "code":"XHE80",
      "pembelianoperator_id":"47",
      "pembeliankategori_id":"2",
      "product_name":"HOTROD XTRA 4GB,150MNT,30HR,RP89RB",
      "price":"80815",
      "status":"0"
   },
   {
      "id":288,
      "code":"XHE115",
      "pembelianoperator_id":"47",
      "pembeliankategori_id":"2",
      "product_name":"HOTROD XTRA 6GB,200MNT,30HR,RP129RB",
      "price":"115815",
      "status":"0"
   },
   {
      "id":289,
      "code":"XHE825",
      "pembelianoperator_id":"47",
      "pembeliankategori_id":"2",
      "product_name":"HOTROD XTRA 8GB,225MNT,30HR,RP159RB",
      "price":"126915",
      "status":"1"
   },
   {
      "id":290,
      "code":"XHE145",
      "pembelianoperator_id":"47",
      "pembeliankategori_id":"2",
      "product_name":"HOTROD XTRA 10GB,250MNT,30HR,RP179RB",
      "price":"145815",
      "status":"0"
   },
   {
      "id":291,
      "code":"XHE190",
      "pembelianoperator_id":"47",
      "pembeliankategori_id":"2",
      "product_name":"HOTROD XTRA 16GB,300MNT,30HR,RP239RB",
      "price":"191915",
      "status":"1"
   },
   {
      "id":292,
      "code":"XT1",
      "pembelianoperator_id":"48",
      "pembeliankategori_id":"5",
      "product_name":"TELEPON 350MNT SESAMA+50MNT ALL 7HR",
      "price":"10740",
      "status":"1"
   },
   {
      "id":293,
      "code":"XT5",
      "pembelianoperator_id":"48",
      "pembeliankategori_id":"5",
      "product_name":"TELEPON 300MNT ALL 30HR",
      "price":"72515",
      "status":"1"
   },
   {
      "id":294,
      "code":"XT4",
      "pembelianoperator_id":"48",
      "pembeliankategori_id":"5",
      "product_name":"TELEPON 200MNT SESAMA+400SMS SESAMA 30HR",
      "price":"36515",
      "status":"1"
   },
   {
      "id":295,
      "code":"XT3",
      "pembelianoperator_id":"48",
      "pembeliankategori_id":"5",
      "product_name":"TELEPON 500MNT SESAMA 30HR",
      "price":"36015",
      "status":"1"
   },
   {
      "id":296,
      "code":"XT2",
      "pembelianoperator_id":"48",
      "pembeliankategori_id":"5",
      "product_name":"TELEPON 200MNT SESAMA 14HR",
      "price":"14890",
      "status":"1"
   },
   {
      "id":297,
      "code":"XT8",
      "pembelianoperator_id":"48",
      "pembeliankategori_id":"5",
      "product_name":"TELEPON 500MNT ALL 90HR",
      "price":"145740",
      "status":"1"
   },
   {
      "id":298,
      "code":"XT7",
      "pembelianoperator_id":"48",
      "pembeliankategori_id":"5",
      "product_name":"TELEPON 300MNT ALL 90HR",
      "price":"95890",
      "status":"1"
   },
   {
      "id":299,
      "code":"XTL8",
      "pembelianoperator_id":"49",
      "pembeliankategori_id":"5",
      "product_name":"TELEPON LUAR NEGERI 80MNT 1HR",
      "price":"24415",
      "status":"1"
   },
   {
      "id":300,
      "code":"XTL7",
      "pembelianoperator_id":"49",
      "pembeliankategori_id":"5",
      "product_name":"TELEPON LUAR NEGERI 20MNT 1HR",
      "price":"7690",
      "status":"1"
   },
   {
      "id":301,
      "code":"PLN20",
      "pembelianoperator_id":"50",
      "pembeliankategori_id":"10",
      "product_name":"VOUCHER PLN 20000",
      "price":"20339",
      "status":"1"
   },
   {
      "id":302,
      "code":"PLN50",
      "pembelianoperator_id":"50",
      "pembeliankategori_id":"10",
      "product_name":"VOUCHER PLN 50000",
      "price":"50339",
      "status":"1"
   },
   {
      "id":303,
      "code":"PLN100",
      "pembelianoperator_id":"50",
      "pembeliankategori_id":"10",
      "product_name":"VOUCHER PLN 100000",
      "price":"100339",
      "status":"1"
   },
   {
      "id":304,
      "code":"PLN200",
      "pembelianoperator_id":"50",
      "pembeliankategori_id":"10",
      "product_name":"VOUCHER PLN 200000",
      "price":"200339",
      "status":"1"
   },
   {
      "id":305,
      "code":"PLN500",
      "pembelianoperator_id":"50",
      "pembeliankategori_id":"10",
      "product_name":"VOUCHER PLN 500000",
      "price":"500330",
      "status":"1"
   },
   {
      "id":306,
      "code":"PLN1000",
      "pembelianoperator_id":"50",
      "pembeliankategori_id":"10",
      "product_name":"VOUCHER PLN 1000000",
      "price":"1000330",
      "status":"1"
   },
   {
      "id":307,
      "code":"BOX10",
      "pembelianoperator_id":"51",
      "pembeliankategori_id":"11",
      "product_name":"XBOX LIVE GIFT CARD $10",
      "price":"140365",
      "status":"0"
   },
   {
      "id":308,
      "code":"BOX15",
      "pembelianoperator_id":"51",
      "pembeliankategori_id":"11",
      "product_name":"XBOX LIVE GIFT CARD $15",
      "price":"206365",
      "status":"0"
   },
   {
      "id":309,
      "code":"BOX25",
      "pembelianoperator_id":"51",
      "pembeliankategori_id":"11",
      "product_name":"XBOX LIVE GIFT CARD $25",
      "price":"325365",
      "status":"0"
   },
   {
      "id":310,
      "code":"BOX50",
      "pembelianoperator_id":"51",
      "pembeliankategori_id":"11",
      "product_name":"XBOX LIVE GIFT CARD $50",
      "price":"643365",
      "status":"0"
   },
   {
      "id":311,
      "code":"BP50",
      "pembelianoperator_id":"52",
      "pembeliankategori_id":"11",
      "product_name":"GAME FACEBOOK - BOYAA POKER VOUCHER 50.000",
      "price":"45365",
      "status":"1"
   },
   {
      "id":312,
      "code":"BP100",
      "pembelianoperator_id":"52",
      "pembeliankategori_id":"11",
      "product_name":"GAME FACEBOOK - BOYAA POKER VOUCHER 100.000",
      "price":"90365",
      "status":"1"
   },
   {
      "id":313,
      "code":"BSF5",
      "pembelianoperator_id":"53",
      "pembeliankategori_id":"11",
      "product_name":"BSF VOUCHER 5.000",
      "price":"4865",
      "status":"1"
   },
   {
      "id":314,
      "code":"BSF10",
      "pembelianoperator_id":"53",
      "pembeliankategori_id":"11",
      "product_name":"BSF VOUCHER 10.000",
      "price":"9365",
      "status":"1"
   },
   {
      "id":315,
      "code":"BSF25",
      "pembelianoperator_id":"53",
      "pembeliankategori_id":"11",
      "product_name":"BSF VOUCHER 25.000",
      "price":"22865",
      "status":"1"
   },
   {
      "id":316,
      "code":"BSF50",
      "pembelianoperator_id":"53",
      "pembeliankategori_id":"11",
      "product_name":"BSF VOUCHER 50.000",
      "price":"45365",
      "status":"1"
   },
   {
      "id":317,
      "code":"BSF100",
      "pembelianoperator_id":"53",
      "pembeliankategori_id":"11",
      "product_name":"BSF VOUCHER 100.000",
      "price":"90365",
      "status":"1"
   },
   {
      "id":318,
      "code":"BSF500",
      "pembelianoperator_id":"53",
      "pembeliankategori_id":"11",
      "product_name":"BSF VOUCHER 500.000",
      "price":"450365",
      "status":"1"
   },
   {
      "id":319,
      "code":"CBL1",
      "pembelianoperator_id":"54",
      "pembeliankategori_id":"11",
      "product_name":"CABAL ONLINE 1000 GOLD",
      "price":"9665",
      "status":"0"
   },
   {
      "id":320,
      "code":"CBL3",
      "pembelianoperator_id":"54",
      "pembeliankategori_id":"11",
      "product_name":"CABAL ONLINE 3000 GOLD",
      "price":"27965",
      "status":"1"
   },
   {
      "id":321,
      "code":"CBL5",
      "pembelianoperator_id":"54",
      "pembeliankategori_id":"11",
      "product_name":"CABAL ONLINE 5000 GOLD",
      "price":"46365",
      "status":"1"
   },
   {
      "id":322,
      "code":"CBL10",
      "pembelianoperator_id":"54",
      "pembeliankategori_id":"11",
      "product_name":"CABAL ONLINE 10000 GOLD",
      "price":"92365",
      "status":"1"
   },
   {
      "id":323,
      "code":"CRY5",
      "pembelianoperator_id":"55",
      "pembeliankategori_id":"11",
      "product_name":"E-PINS 5000 CHERRY CREDITS",
      "price":"45365",
      "status":"1"
   },
   {
      "id":324,
      "code":"CRY10",
      "pembelianoperator_id":"55",
      "pembeliankategori_id":"11",
      "product_name":"E-PINS 10000 CHERRY CREDITS",
      "price":"90365",
      "status":"1"
   },
   {
      "id":325,
      "code":"CRY14",
      "pembelianoperator_id":"55",
      "pembeliankategori_id":"11",
      "product_name":"E-PINS 14000 CHERRY CREDITS",
      "price":"118465",
      "status":"1"
   },
   {
      "id":326,
      "code":"CRY20",
      "pembelianoperator_id":"55",
      "pembeliankategori_id":"11",
      "product_name":"E-PINS 20000 CHERRY CREDITS",
      "price":"168865",
      "status":"1"
   },
   {
      "id":327,
      "code":"DGC10",
      "pembelianoperator_id":"56",
      "pembeliankategori_id":"11",
      "product_name":"VOUCHER DIGICASH 10.000",
      "price":"9365",
      "status":"0"
   },
   {
      "id":328,
      "code":"DGC20",
      "pembelianoperator_id":"56",
      "pembeliankategori_id":"11",
      "product_name":"VOUCHER DIGICASH 20.000",
      "price":"18365",
      "status":"0"
   },
   {
      "id":329,
      "code":"DGC50",
      "pembelianoperator_id":"56",
      "pembeliankategori_id":"11",
      "product_name":"VOUCHER DIGICASH 50.000",
      "price":"46365",
      "status":"0"
   },
   {
      "id":330,
      "code":"DGC100",
      "pembelianoperator_id":"56",
      "pembeliankategori_id":"11",
      "product_name":"VOUCHER DIGICASH 100.000",
      "price":"92365",
      "status":"0"
   },
   {
      "id":331,
      "code":"DGC250",
      "pembelianoperator_id":"56",
      "pembeliankategori_id":"11",
      "product_name":"VOUCHER DIGICASH 250.000",
      "price":"225365",
      "status":"0"
   },
   {
      "id":332,
      "code":"FAV20",
      "pembelianoperator_id":"57",
      "pembeliankategori_id":"11",
      "product_name":"GAME FAVEO VOUCHER 20000",
      "price":"18365",
      "status":"1"
   },
   {
      "id":333,
      "code":"FAV50",
      "pembelianoperator_id":"57",
      "pembeliankategori_id":"11",
      "product_name":"GAME FAVEO VOUCHER 50000",
      "price":"45365",
      "status":"1"
   },
   {
      "id":334,
      "code":"FAV100",
      "pembelianoperator_id":"57",
      "pembeliankategori_id":"11",
      "product_name":"GAME FAVEO VOUCHER 100000",
      "price":"90365",
      "status":"1"
   },
   {
      "id":335,
      "code":"FBG30",
      "pembelianoperator_id":"58",
      "pembeliankategori_id":"11",
      "product_name":"FACEBOOK GAME CARD - 30000",
      "price":"29615",
      "status":"1"
   },
   {
      "id":336,
      "code":"FBG50",
      "pembelianoperator_id":"58",
      "pembeliankategori_id":"11",
      "product_name":"FACEBOOK GAME CARD - 50000",
      "price":"48515",
      "status":"1"
   },
   {
      "id":337,
      "code":"FBG100",
      "pembelianoperator_id":"58",
      "pembeliankategori_id":"11",
      "product_name":"FACEBOOK GAME CARD - 100000",
      "price":"96665",
      "status":"1"
   },
   {
      "id":338,
      "code":"FSB40",
      "pembelianoperator_id":"59",
      "pembeliankategori_id":"11",
      "product_name":"VOUCHER FASTBLACK 40 OP",
      "price":"9365",
      "status":"1"
   },
   {
      "id":339,
      "code":"FSB100",
      "pembelianoperator_id":"59",
      "pembeliankategori_id":"11",
      "product_name":"VOUCHER FASTBLACK 100 OP",
      "price":"22865",
      "status":"1"
   },
   {
      "id":340,
      "code":"FSB200",
      "pembelianoperator_id":"59",
      "pembeliankategori_id":"11",
      "product_name":"VOUCHER FASTBLACK 200 OP",
      "price":"45365",
      "status":"1"
   },
   {
      "id":341,
      "code":"FSB400",
      "pembelianoperator_id":"59",
      "pembeliankategori_id":"11",
      "product_name":"VOUCHER FASTBLACK 400 OP",
      "price":"90365",
      "status":"1"
   },
   {
      "id":342,
      "code":"GA10",
      "pembelianoperator_id":"60",
      "pembeliankategori_id":"11",
      "product_name":"ASIASOFT - 1.000-CASH",
      "price":"9365",
      "status":"1"
   },
   {
      "id":343,
      "code":"GA20",
      "pembelianoperator_id":"60",
      "pembeliankategori_id":"11",
      "product_name":"ASIASOFT - 2.000-CASH",
      "price":"18365",
      "status":"1"
   },
   {
      "id":344,
      "code":"GA50",
      "pembelianoperator_id":"60",
      "pembeliankategori_id":"11",
      "product_name":"ASIASOFT - 5.000-CASH",
      "price":"45365",
      "status":"1"
   },
   {
      "id":345,
      "code":"GA100",
      "pembelianoperator_id":"60",
      "pembeliankategori_id":"11",
      "product_name":"ASIASOFT - 10.000-CASH",
      "price":"90365",
      "status":"1"
   },
   {
      "id":346,
      "code":"GD10",
      "pembelianoperator_id":"61",
      "pembeliankategori_id":"11",
      "product_name":"GAME MAGIC CAMPUS - 55 DASA COIN",
      "price":"9565",
      "status":"1"
   },
   {
      "id":347,
      "code":"GD20",
      "pembelianoperator_id":"61",
      "pembeliankategori_id":"11",
      "product_name":"GAME MAGIC CAMPUS - 110 DASA COIN",
      "price":"18765",
      "status":"1"
   },
   {
      "id":348,
      "code":"GD50",
      "pembelianoperator_id":"61",
      "pembeliankategori_id":"11",
      "product_name":"GAME MAGIC CAMPUS - 275 DASA COIN",
      "price":"46365",
      "status":"1"
   },
   {
      "id":349,
      "code":"GD100",
      "pembelianoperator_id":"61",
      "pembeliankategori_id":"11",
      "product_name":"GAME MAGIC CAMPUS - 550 DASA COIN",
      "price":"92365",
      "status":"1"
   },
   {
      "id":350,
      "code":"GES10",
      "pembelianoperator_id":"62",
      "pembeliankategori_id":"11",
      "product_name":"60 MALL COIN",
      "price":"9865",
      "status":"1"
   },
   {
      "id":351,
      "code":"GES20",
      "pembelianoperator_id":"62",
      "pembeliankategori_id":"11",
      "product_name":"121 MALL COIN",
      "price":"19365",
      "status":"1"
   },
   {
      "id":352,
      "code":"GES50",
      "pembelianoperator_id":"62",
      "pembeliankategori_id":"11",
      "product_name":"309 MALL COIN",
      "price":"47865",
      "status":"1"
   },
   {
      "id":353,
      "code":"GES100",
      "pembelianoperator_id":"62",
      "pembeliankategori_id":"11",
      "product_name":"624 MALL COIN",
      "price":"95365",
      "status":"1"
   },
   {
      "id":354,
      "code":"GGM20",
      "pembelianoperator_id":"63",
      "pembeliankategori_id":"11",
      "product_name":"VOUCHER GOGAME 20.000",
      "price":"21565",
      "status":"1"
   },
   {
      "id":355,
      "code":"GGM50",
      "pembelianoperator_id":"63",
      "pembeliankategori_id":"11",
      "product_name":"VOUCHER GOGAME 50.000",
      "price":"53165",
      "status":"1"
   },
   {
      "id":356,
      "code":"GGM100",
      "pembelianoperator_id":"63",
      "pembeliankategori_id":"11",
      "product_name":"VOUCHER GOGAME 100.000",
      "price":"105865",
      "status":"1"
   },
   {
      "id":357,
      "code":"GGM200",
      "pembelianoperator_id":"63",
      "pembeliankategori_id":"11",
      "product_name":"VOUCHER GOGAME 200.000",
      "price":"210565",
      "status":"1"
   },
   {
      "id":358,
      "code":"GIH10",
      "pembelianoperator_id":"64",
      "pembeliankategori_id":"11",
      "product_name":"10.000 ICREDITS IAH GAMES",
      "price":"9365",
      "status":"1"
   },
   {
      "id":359,
      "code":"GIH20",
      "pembelianoperator_id":"64",
      "pembeliankategori_id":"11",
      "product_name":"20.000 ICREDITS IAH GAMES",
      "price":"18365",
      "status":"1"
   },
   {
      "id":360,
      "code":"GIH50",
      "pembelianoperator_id":"64",
      "pembeliankategori_id":"11",
      "product_name":"50.000 ICREDITS IAH GAMES",
      "price":"45365",
      "status":"1"
   },
   {
      "id":361,
      "code":"GIH100",
      "pembelianoperator_id":"64",
      "pembeliankategori_id":"11",
      "product_name":"100.000 ICREDITS IAH GAMES",
      "price":"90365",
      "status":"1"
   },
   {
      "id":362,
      "code":"GIN10",
      "pembelianoperator_id":"65",
      "pembeliankategori_id":"11",
      "product_name":"SHOWTIME KARAOKE 40 INCASH",
      "price":"9365",
      "status":"1"
   },
   {
      "id":363,
      "code":"GIN20",
      "pembelianoperator_id":"65",
      "pembeliankategori_id":"11",
      "product_name":"SHOWTIME KARAOKE 80 INCASH",
      "price":"18365",
      "status":"1"
   },
   {
      "id":364,
      "code":"GIN50",
      "pembelianoperator_id":"65",
      "pembeliankategori_id":"11",
      "product_name":"SHOWTIME KARAOKE 200 INCASH",
      "price":"45365",
      "status":"1"
   },
   {
      "id":365,
      "code":"GIN100",
      "pembelianoperator_id":"65",
      "pembeliankategori_id":"11",
      "product_name":"SHOWTIME KARAOKE 400 INCASH",
      "price":"90365",
      "status":"1"
   },
   {
      "id":366,
      "code":"GMM5",
      "pembelianoperator_id":"66",
      "pembeliankategori_id":"11",
      "product_name":"MATCHMOVE 50 MCASH",
      "price":"4865",
      "status":"1"
   },
   {
      "id":367,
      "code":"GMM10",
      "pembelianoperator_id":"66",
      "pembeliankategori_id":"11",
      "product_name":"MATCHMOVE 100 MCASH",
      "price":"9365",
      "status":"1"
   },
   {
      "id":368,
      "code":"GMM25",
      "pembelianoperator_id":"66",
      "pembeliankategori_id":"11",
      "product_name":"MATCHMOVE 250 MCASH",
      "price":"22865",
      "status":"1"
   },
   {
      "id":369,
      "code":"GMM50",
      "pembelianoperator_id":"66",
      "pembeliankategori_id":"11",
      "product_name":"MATCHMOVE 490 MCASH",
      "price":"45365",
      "status":"1"
   },
   {
      "id":370,
      "code":"GMM100",
      "pembelianoperator_id":"66",
      "pembeliankategori_id":"11",
      "product_name":"MATCHMOVE 980 MCASH",
      "price":"90365",
      "status":"1"
   },
   {
      "id":371,
      "code":"GMM200",
      "pembelianoperator_id":"66",
      "pembeliankategori_id":"11",
      "product_name":"MATCHMOVE 1160 MCASH",
      "price":"180365",
      "status":"1"
   },
   {
      "id":372,
      "code":"GMS1",
      "pembelianoperator_id":"67",
      "pembeliankategori_id":"11",
      "product_name":"VOUCHER GEMSCOOL 1.000 G-CASH",
      "price":"9790",
      "status":"1"
   },
   {
      "id":373,
      "code":"GMS2",
      "pembelianoperator_id":"67",
      "pembeliankategori_id":"11",
      "product_name":"VOUCHER GEMSCOOL 2.000 G-CASH",
      "price":"19190",
      "status":"1"
   },
   {
      "id":374,
      "code":"GMS3",
      "pembelianoperator_id":"67",
      "pembeliankategori_id":"11",
      "product_name":"VOUCHER GEMSCOOL 3.000 G-CASH",
      "price":"28590",
      "status":"1"
   },
   {
      "id":375,
      "code":"GMS5",
      "pembelianoperator_id":"67",
      "pembeliankategori_id":"11",
      "product_name":"VOUCHER GEMSCOOL 5.000 G-CASH",
      "price":"47390",
      "status":"1"
   },
   {
      "id":376,
      "code":"GMS10",
      "pembelianoperator_id":"67",
      "pembeliankategori_id":"11",
      "product_name":"VOUCHER GEMSCOOL 10.000 G-CASH",
      "price":"94390",
      "status":"1"
   },
   {
      "id":377,
      "code":"GMS20",
      "pembelianoperator_id":"67",
      "pembeliankategori_id":"11",
      "product_name":"VOUCHER GEMSCOOL 20.000 G-CASH",
      "price":"188390",
      "status":"1"
   },
   {
      "id":378,
      "code":"GMS30",
      "pembelianoperator_id":"67",
      "pembeliankategori_id":"11",
      "product_name":"VOUCHER GEMSCOOL 30.000 G-CASH",
      "price":"282390",
      "status":"1"
   },
   {
      "id":379,
      "code":"GOG10",
      "pembelianoperator_id":"68",
      "pembeliankategori_id":"11",
      "product_name":"1.000 O-CASH ORANGEGAME",
      "price":"9565",
      "status":"1"
   },
   {
      "id":380,
      "code":"GOG30",
      "pembelianoperator_id":"68",
      "pembeliankategori_id":"11",
      "product_name":"3.000 O-CASH ORANGEGAME",
      "price":"27965",
      "status":"1"
   },
   {
      "id":381,
      "code":"GOG50",
      "pembelianoperator_id":"68",
      "pembeliankategori_id":"11",
      "product_name":"5.000 O-CASH ORANGEGAME",
      "price":"46365",
      "status":"1"
   },
   {
      "id":382,
      "code":"GOG100",
      "pembelianoperator_id":"68",
      "pembeliankategori_id":"11",
      "product_name":"10.000 O-CASH ORANGEGAME",
      "price":"92365",
      "status":"1"
   },
   {
      "id":383,
      "code":"GPY10",
      "pembelianoperator_id":"69",
      "pembeliankategori_id":"11",
      "product_name":"26.000 PLAYPOINT-PLAYON",
      "price":"9365",
      "status":"1"
   },
   {
      "id":384,
      "code":"GPY30",
      "pembelianoperator_id":"69",
      "pembeliankategori_id":"11",
      "product_name":"78.000 PLAYPOINT-PLAYON",
      "price":"27365",
      "status":"1"
   },
   {
      "id":385,
      "code":"GPY50",
      "pembelianoperator_id":"69",
      "pembeliankategori_id":"11",
      "product_name":"130.000 PLAYPOINT-PLAYON",
      "price":"45365",
      "status":"1"
   },
   {
      "id":386,
      "code":"GPY100",
      "pembelianoperator_id":"69",
      "pembeliankategori_id":"11",
      "product_name":"260.000 PLAYPOINT-PLAYON",
      "price":"90365",
      "status":"1"
   },
   {
      "id":387,
      "code":"GQ10",
      "pembelianoperator_id":"70",
      "pembeliankategori_id":"11",
      "product_name":"VOUCHER QASH 2.300",
      "price":"9765",
      "status":"1"
   },
   {
      "id":388,
      "code":"GQ30",
      "pembelianoperator_id":"70",
      "pembeliankategori_id":"11",
      "product_name":"VOUCHER QASH 6.900",
      "price":"28565",
      "status":"1"
   },
   {
      "id":389,
      "code":"GQ50",
      "pembelianoperator_id":"70",
      "pembeliankategori_id":"11",
      "product_name":"VOUCHER QASH 11.500",
      "price":"47365",
      "status":"1"
   },
   {
      "id":390,
      "code":"GQ100",
      "pembelianoperator_id":"70",
      "pembeliankategori_id":"11",
      "product_name":"VOUCHER QASH 23.000",
      "price":"94365",
      "status":"1"
   },
   {
      "id":391,
      "code":"GQ300",
      "pembelianoperator_id":"70",
      "pembeliankategori_id":"11",
      "product_name":"VOUCHER QASH 69.000",
      "price":"270365",
      "status":"1"
   },
   {
      "id":392,
      "code":"GQ500",
      "pembelianoperator_id":"70",
      "pembeliankategori_id":"11",
      "product_name":"VOUCHER QASH 115.000",
      "price":"450365",
      "status":"1"
   },
   {
      "id":393,
      "code":"GQ1000",
      "pembelianoperator_id":"70",
      "pembeliankategori_id":"11",
      "product_name":"VOUCHER QASH 230.000",
      "price":"900365",
      "status":"1"
   },
   {
      "id":394,
      "code":"GST30",
      "pembelianoperator_id":"71",
      "pembeliankategori_id":"11",
      "product_name":"ROSE ONLINE 8000 KOIN",
      "price":"27365",
      "status":"0"
   },
   {
      "id":395,
      "code":"GST50",
      "pembelianoperator_id":"71",
      "pembeliankategori_id":"11",
      "product_name":"ROSE ONLINE 15000 KOIN",
      "price":"45365",
      "status":"0"
   },
   {
      "id":396,
      "code":"GST100",
      "pembelianoperator_id":"71",
      "pembeliankategori_id":"11",
      "product_name":"ROSE ONLINE 30000 KOIN",
      "price":"90365",
      "status":"0"
   },
   {
      "id":397,
      "code":"GTA10",
      "pembelianoperator_id":"72",
      "pembeliankategori_id":"11",
      "product_name":"1.000 TERA - TS2",
      "price":"9365",
      "status":"1"
   },
   {
      "id":398,
      "code":"GTA20",
      "pembelianoperator_id":"72",
      "pembeliankategori_id":"11",
      "product_name":"2.000 TERA - TS2",
      "price":"18365",
      "status":"1"
   },
   {
      "id":399,
      "code":"GTA30",
      "pembelianoperator_id":"72",
      "pembeliankategori_id":"11",
      "product_name":"3.000 TERA - TS2",
      "price":"27365",
      "status":"1"
   },
   {
      "id":400,
      "code":"GTA50",
      "pembelianoperator_id":"72",
      "pembeliankategori_id":"11",
      "product_name":"5.000 TERA - TS2",
      "price":"45365",
      "status":"1"
   },
   {
      "id":401,
      "code":"GTA100",
      "pembelianoperator_id":"72",
      "pembeliankategori_id":"11",
      "product_name":"10.000 TERA - TS2",
      "price":"90365",
      "status":"1"
   },
   {
      "id":402,
      "code":"GTA200",
      "pembelianoperator_id":"72",
      "pembeliankategori_id":"11",
      "product_name":"20.000 TERA - TS2",
      "price":"180365",
      "status":"1"
   },
   {
      "id":403,
      "code":"GTA300",
      "pembelianoperator_id":"72",
      "pembeliankategori_id":"11",
      "product_name":"30.000 TERA - TS2",
      "price":"270365",
      "status":"1"
   },
   {
      "id":404,
      "code":"GW15",
      "pembelianoperator_id":"73",
      "pembeliankategori_id":"11",
      "product_name":"GAMEWAVE VOUCHER 150 V-CASH",
      "price":"45365",
      "status":"1"
   },
   {
      "id":405,
      "code":"GW30",
      "pembelianoperator_id":"73",
      "pembeliankategori_id":"11",
      "product_name":"GAMEWAVE VOUCHER 300 V-CASH",
      "price":"90365",
      "status":"1"
   },
   {
      "id":406,
      "code":"GW60",
      "pembelianoperator_id":"73",
      "pembeliankategori_id":"11",
      "product_name":"GAMEWAVE VOUCHER 600 V-CASH",
      "price":"180365",
      "status":"1"
   },
   {
      "id":407,
      "code":"GW150",
      "pembelianoperator_id":"73",
      "pembeliankategori_id":"11",
      "product_name":"GAMEWAVE VOUCHER 1500 V-CASH",
      "price":"450365",
      "status":"1"
   },
   {
      "id":408,
      "code":"GW300",
      "pembelianoperator_id":"73",
      "pembeliankategori_id":"11",
      "product_name":"GAMEWAVE VOUCHER 3000 V-CASH",
      "price":"900365",
      "status":"1"
   },
   {
      "id":409,
      "code":"GWV10",
      "pembelianoperator_id":"74",
      "pembeliankategori_id":"11",
      "product_name":"GAMEWEB VOUCHER 10.000",
      "price":"9565",
      "status":"0"
   },
   {
      "id":410,
      "code":"GWV20",
      "pembelianoperator_id":"74",
      "pembeliankategori_id":"11",
      "product_name":"GAMEWEB VOUCHER 20.000",
      "price":"18765",
      "status":"1"
   },
   {
      "id":411,
      "code":"GWV50",
      "pembelianoperator_id":"74",
      "pembeliankategori_id":"11",
      "product_name":"GAMEWEB VOUCHER 50.000",
      "price":"46365",
      "status":"1"
   },
   {
      "id":412,
      "code":"GWV100",
      "pembelianoperator_id":"74",
      "pembeliankategori_id":"11",
      "product_name":"GAMEWEB VOUCHER 100.000",
      "price":"92365",
      "status":"1"
   },
   {
      "id":413,
      "code":"ID100",
      "pembelianoperator_id":"75",
      "pembeliankategori_id":"11",
      "product_name":"PLAYSTATION STORE PREPAID CARD V100",
      "price":"142865",
      "status":"1"
   },
   {
      "id":414,
      "code":"ID200",
      "pembelianoperator_id":"75",
      "pembeliankategori_id":"11",
      "product_name":"PLAYSTATION STORE PREPAID CARD V200",
      "price":"285365",
      "status":"1"
   },
   {
      "id":415,
      "code":"ID400",
      "pembelianoperator_id":"75",
      "pembeliankategori_id":"11",
      "product_name":"PLAYSTATION STORE PREPAID CARD V400",
      "price":"570365",
      "status":"1"
   },
   {
      "id":416,
      "code":"JM100",
      "pembelianoperator_id":"76",
      "pembeliankategori_id":"11",
      "product_name":"GAME FACEBOOK - JOOMBI VOUCHER 100.000",
      "price":"90365",
      "status":"1"
   },
   {
      "id":417,
      "code":"KRM10",
      "pembelianoperator_id":"77",
      "pembeliankategori_id":"11",
      "product_name":"KORAM GAME VOUCHER 10000",
      "price":"11065",
      "status":"1"
   },
   {
      "id":418,
      "code":"KRM50",
      "pembelianoperator_id":"77",
      "pembeliankategori_id":"11",
      "product_name":"KORAM GAME VOUCHER 50000",
      "price":"53165",
      "status":"1"
   },
   {
      "id":419,
      "code":"KRM100",
      "pembelianoperator_id":"77",
      "pembeliankategori_id":"11",
      "product_name":"KORAM GAME VOUCHER 100000",
      "price":"105865",
      "status":"1"
   },
   {
      "id":420,
      "code":"KRM200",
      "pembelianoperator_id":"77",
      "pembeliankategori_id":"11",
      "product_name":"KORAM GAME VOUCHER 200000",
      "price":"210665",
      "status":"1"
   },
   {
      "id":421,
      "code":"KRM500",
      "pembelianoperator_id":"77",
      "pembeliankategori_id":"11",
      "product_name":"KORAM GAME VOUCHER 500000",
      "price":"524365",
      "status":"1"
   },
   {
      "id":422,
      "code":"KRM1000",
      "pembelianoperator_id":"77",
      "pembeliankategori_id":"11",
      "product_name":"KORAM GAME VOUCHER 1000000",
      "price":"1047365",
      "status":"1"
   },
   {
      "id":423,
      "code":"KW10",
      "pembelianoperator_id":"78",
      "pembeliankategori_id":"11",
      "product_name":"KIWI CARD ONLINE VOUCHER 10.000",
      "price":"9665",
      "status":"1"
   },
   {
      "id":424,
      "code":"KW20",
      "pembelianoperator_id":"78",
      "pembeliankategori_id":"11",
      "product_name":"KIWI CARD ONLINE VOUCHER 20.000",
      "price":"18965",
      "status":"1"
   },
   {
      "id":425,
      "code":"KW30",
      "pembelianoperator_id":"78",
      "pembeliankategori_id":"11",
      "product_name":"KIWI CARD ONLINE VOUCHER 30.000",
      "price":"28265",
      "status":"1"
   },
   {
      "id":426,
      "code":"KW50",
      "pembelianoperator_id":"78",
      "pembeliankategori_id":"11",
      "product_name":"KIWI CARD ONLINE VOUCHER 50.000",
      "price":"46865",
      "status":"1"
   },
   {
      "id":427,
      "code":"KW100",
      "pembelianoperator_id":"78",
      "pembeliankategori_id":"11",
      "product_name":"KIWI CARD ONLINE VOUCHER 100.000",
      "price":"93365",
      "status":"1"
   },
   {
      "id":428,
      "code":"KW200",
      "pembelianoperator_id":"78",
      "pembeliankategori_id":"11",
      "product_name":"KIWI CARD ONLINE VOUCHER 200.000",
      "price":"186365",
      "status":"1"
   },
   {
      "id":429,
      "code":"KW300",
      "pembelianoperator_id":"78",
      "pembeliankategori_id":"11",
      "product_name":"KIWI CARD ONLINE VOUCHER 300.000",
      "price":"279365",
      "status":"1"
   },
   {
      "id":430,
      "code":"LYT10",
      "pembelianoperator_id":"79",
      "pembeliankategori_id":"11",
      "product_name":"2500 KOIN LYTO",
      "price":"10065",
      "status":"1"
   },
   {
      "id":431,
      "code":"LYT20",
      "pembelianoperator_id":"79",
      "pembeliankategori_id":"11",
      "product_name":"5500 KOIN LYTO",
      "price":"19765",
      "status":"1"
   },
   {
      "id":432,
      "code":"LYT35",
      "pembelianoperator_id":"79",
      "pembeliankategori_id":"11",
      "product_name":"10000 KOIN LYTO",
      "price":"34315",
      "status":"1"
   },
   {
      "id":433,
      "code":"LYT65",
      "pembelianoperator_id":"79",
      "pembeliankategori_id":"11",
      "product_name":"20000 KOIN LYTO",
      "price":"63415",
      "status":"1"
   },
   {
      "id":434,
      "code":"LYT175",
      "pembelianoperator_id":"79",
      "pembeliankategori_id":"11",
      "product_name":"57000 KOIN LYTO",
      "price":"170115",
      "status":"1"
   },
   {
      "id":435,
      "code":"LYT500",
      "pembelianoperator_id":"79",
      "pembeliankategori_id":"11",
      "product_name":"KOIN LYTO VOUCHER 500",
      "price":"485365",
      "status":"1"
   },
   {
      "id":436,
      "code":"MAIN5",
      "pembelianoperator_id":"80",
      "pembeliankategori_id":"11",
      "product_name":"VOUCHER MAINKAN.COM 5.000 I-POIN",
      "price":"5690",
      "status":"1"
   },
   {
      "id":437,
      "code":"MAIN10",
      "pembelianoperator_id":"80",
      "pembeliankategori_id":"11",
      "product_name":"VOUCHER MAINKAN.COM 10.000 I-POIN",
      "price":"11065",
      "status":"1"
   },
   {
      "id":438,
      "code":"MAIN25",
      "pembelianoperator_id":"80",
      "pembeliankategori_id":"11",
      "product_name":"VOUCHER MAINKAN.COM 25.000 I-POIN",
      "price":"26840",
      "status":"1"
   },
   {
      "id":439,
      "code":"MAIN50",
      "pembelianoperator_id":"80",
      "pembeliankategori_id":"11",
      "product_name":"VOUCHER MAINKAN.COM 50.000 I-POIN",
      "price":"53165",
      "status":"1"
   },
   {
      "id":440,
      "code":"MAIN100",
      "pembelianoperator_id":"80",
      "pembeliankategori_id":"11",
      "product_name":"VOUCHER MAINKAN.COM 100.000 I-POIN",
      "price":"105865",
      "status":"1"
   },
   {
      "id":441,
      "code":"MB10",
      "pembelianoperator_id":"81",
      "pembeliankategori_id":"11",
      "product_name":"MOBIUS - VOUCHER 10",
      "price":"9365",
      "status":"1"
   },
   {
      "id":442,
      "code":"MB30",
      "pembelianoperator_id":"81",
      "pembeliankategori_id":"11",
      "product_name":"MOBIUS - VOUCHER 30",
      "price":"27365",
      "status":"1"
   },
   {
      "id":443,
      "code":"MB50",
      "pembelianoperator_id":"81",
      "pembeliankategori_id":"11",
      "product_name":"MOBIUS - VOUCHER 50",
      "price":"45365",
      "status":"1"
   },
   {
      "id":444,
      "code":"MB100",
      "pembelianoperator_id":"81",
      "pembeliankategori_id":"11",
      "product_name":"MOBIUS - VOUCHER 100",
      "price":"90365",
      "status":"1"
   },
   {
      "id":445,
      "code":"MB200",
      "pembelianoperator_id":"81",
      "pembeliankategori_id":"11",
      "product_name":"MOBIUS - VOUCHER 200",
      "price":"180365",
      "status":"1"
   },
   {
      "id":446,
      "code":"MGC50",
      "pembelianoperator_id":"82",
      "pembeliankategori_id":"11",
      "product_name":"MOGCAZ - 50000",
      "price":"50365",
      "status":"1"
   },
   {
      "id":447,
      "code":"MGC100",
      "pembelianoperator_id":"82",
      "pembeliankategori_id":"11",
      "product_name":"MOGCAZ - 100000",
      "price":"100365",
      "status":"1"
   },
   {
      "id":448,
      "code":"MGC200",
      "pembelianoperator_id":"82",
      "pembeliankategori_id":"11",
      "product_name":"MOGCAZ - 200000",
      "price":"200365",
      "status":"1"
   },
   {
      "id":449,
      "code":"MGX10",
      "pembelianoperator_id":"83",
      "pembeliankategori_id":"11",
      "product_name":"VOUCHER MEGAXUS 10.000",
      "price":"11170",
      "status":"1"
   },
   {
      "id":450,
      "code":"MGX20",
      "pembelianoperator_id":"83",
      "pembeliankategori_id":"11",
      "product_name":"VOUCHER MEGAXUS 20.000",
      "price":"21950",
      "status":"1"
   },
   {
      "id":451,
      "code":"MGX50",
      "pembelianoperator_id":"83",
      "pembeliankategori_id":"11",
      "product_name":"VOUCHER MEGAXUS 50.000",
      "price":"54290",
      "status":"1"
   },
   {
      "id":452,
      "code":"MGX100",
      "pembelianoperator_id":"83",
      "pembeliankategori_id":"11",
      "product_name":"VOUCHER MEGAXUS 100.000",
      "price":"108190",
      "status":"1"
   },
   {
      "id":453,
      "code":"MGX200",
      "pembelianoperator_id":"83",
      "pembeliankategori_id":"11",
      "product_name":"VOUCHER MEGAXUS 200.000",
      "price":"215990",
      "status":"1"
   },
   {
      "id":454,
      "code":"MGX500",
      "pembelianoperator_id":"83",
      "pembeliankategori_id":"11",
      "product_name":"VOUCHER MEGAXUS 500.000",
      "price":"539390",
      "status":"1"
   },
   {
      "id":455,
      "code":"MOG20",
      "pembelianoperator_id":"84",
      "pembeliankategori_id":"11",
      "product_name":"MOGPLAY 20.000",
      "price":"18365",
      "status":"1"
   },
   {
      "id":456,
      "code":"MOG50",
      "pembelianoperator_id":"84",
      "pembeliankategori_id":"11",
      "product_name":"MOGPLAY 50.000",
      "price":"45365",
      "status":"1"
   },
   {
      "id":457,
      "code":"MOG100",
      "pembelianoperator_id":"84",
      "pembeliankategori_id":"11",
      "product_name":"MOGPLAY 100.000",
      "price":"90365",
      "status":"1"
   },
   {
      "id":458,
      "code":"MOG200",
      "pembelianoperator_id":"84",
      "pembeliankategori_id":"11",
      "product_name":"MOGPLAY 200.000",
      "price":"180365",
      "status":"1"
   },
   {
      "id":459,
      "code":"MOG500",
      "pembelianoperator_id":"84",
      "pembeliankategori_id":"11",
      "product_name":"MOGPLAY 500.000",
      "price":"450365",
      "status":"1"
   },
   {
      "id":460,
      "code":"MOL10",
      "pembelianoperator_id":"85",
      "pembeliankategori_id":"11",
      "product_name":"100 MOL POINT",
      "price":"10815",
      "status":"1"
   },
   {
      "id":461,
      "code":"MOL20",
      "pembelianoperator_id":"85",
      "pembeliankategori_id":"11",
      "product_name":"200 MOL POINT",
      "price":"21265",
      "status":"1"
   },
   {
      "id":462,
      "code":"MOL50",
      "pembelianoperator_id":"85",
      "pembeliankategori_id":"11",
      "product_name":"500 MOL POINT",
      "price":"52615",
      "status":"1"
   },
   {
      "id":463,
      "code":"MOL100",
      "pembelianoperator_id":"85",
      "pembeliankategori_id":"11",
      "product_name":"1000 MOL POINT",
      "price":"104865",
      "status":"1"
   },
   {
      "id":464,
      "code":"MOL200",
      "pembelianoperator_id":"85",
      "pembeliankategori_id":"11",
      "product_name":"2000 MOL POINT",
      "price":"209365",
      "status":"1"
   },
   {
      "id":465,
      "code":"MTN60",
      "pembelianoperator_id":"86",
      "pembeliankategori_id":"11",
      "product_name":"METIN 2 VOUCHER 60.000",
      "price":"54365",
      "status":"1"
   },
   {
      "id":466,
      "code":"MTN120",
      "pembelianoperator_id":"86",
      "pembeliankategori_id":"11",
      "product_name":"METIN 2 VOUCHER 120.000",
      "price":"108365",
      "status":"1"
   },
   {
      "id":467,
      "code":"MTN285",
      "pembelianoperator_id":"86",
      "pembeliankategori_id":"11",
      "product_name":"METIN 2 VOUCHER 285.000",
      "price":"256865",
      "status":"1"
   },
   {
      "id":468,
      "code":"MTN545",
      "pembelianoperator_id":"86",
      "pembeliankategori_id":"11",
      "product_name":"METIN 2 VOUCHER 545.000",
      "price":"490865",
      "status":"1"
   },
   {
      "id":469,
      "code":"MYC50",
      "pembelianoperator_id":"87",
      "pembeliankategori_id":"11",
      "product_name":"MYCARD 50 POINTS",
      "price":"24818",
      "status":"1"
   },
   {
      "id":470,
      "code":"MYC150",
      "pembelianoperator_id":"87",
      "pembeliankategori_id":"11",
      "product_name":"MYCARD 150 POINTS",
      "price":"73295",
      "status":"1"
   },
   {
      "id":471,
      "code":"MYC350",
      "pembelianoperator_id":"87",
      "pembeliankategori_id":"11",
      "product_name":"MYCARD 350 POINTS",
      "price":"163385",
      "status":"1"
   },
   {
      "id":472,
      "code":"MYC450",
      "pembelianoperator_id":"87",
      "pembeliankategori_id":"11",
      "product_name":"MYCARD 450 POINTS",
      "price":"210575",
      "status":"1"
   },
   {
      "id":473,
      "code":"MYC1000",
      "pembelianoperator_id":"87",
      "pembeliankategori_id":"11",
      "product_name":"MYCARD 1000 POINTS",
      "price":"463685",
      "status":"1"
   },
   {
      "id":474,
      "code":"PLC10",
      "pembelianoperator_id":"88",
      "pembeliankategori_id":"11",
      "product_name":"PLAYCIRCLE VOUCHER 10.000",
      "price":"9365",
      "status":"1"
   },
   {
      "id":475,
      "code":"PLC30",
      "pembelianoperator_id":"88",
      "pembeliankategori_id":"11",
      "product_name":"PLAYCIRCLE VOUCHER 30.000",
      "price":"27365",
      "status":"1"
   },
   {
      "id":476,
      "code":"PLC50",
      "pembelianoperator_id":"88",
      "pembeliankategori_id":"11",
      "product_name":"PLAYCIRCLE VOUCHER 50.000",
      "price":"45365",
      "status":"1"
   },
   {
      "id":477,
      "code":"PLC100",
      "pembelianoperator_id":"88",
      "pembeliankategori_id":"11",
      "product_name":"PLAYCIRCLE VOUCHER 100.000",
      "price":"90365",
      "status":"1"
   },
   {
      "id":478,
      "code":"PLF20",
      "pembelianoperator_id":"89",
      "pembeliankategori_id":"11",
      "product_name":"PLAYFISH COUPON 20.000",
      "price":"18365",
      "status":"1"
   },
   {
      "id":479,
      "code":"PLF50",
      "pembelianoperator_id":"89",
      "pembeliankategori_id":"11",
      "product_name":"PLAYFISH COUPON 50.000",
      "price":"45365",
      "status":"1"
   },
   {
      "id":480,
      "code":"PLF100",
      "pembelianoperator_id":"89",
      "pembeliankategori_id":"11",
      "product_name":"PLAYFISH COUPON 100.000",
      "price":"90365",
      "status":"1"
   },
   {
      "id":481,
      "code":"PLP26",
      "pembelianoperator_id":"90",
      "pembeliankategori_id":"11",
      "product_name":"VOUCHER PLAYPOINT 26000",
      "price":"9365",
      "status":"0"
   },
   {
      "id":482,
      "code":"PLP78",
      "pembelianoperator_id":"90",
      "pembeliankategori_id":"11",
      "product_name":"VOUCHER PLAYPOINT 78000",
      "price":"27365",
      "status":"1"
   },
   {
      "id":483,
      "code":"PLP130",
      "pembelianoperator_id":"90",
      "pembeliankategori_id":"11",
      "product_name":"VOUCHER PLAYPOINT 130000",
      "price":"45365",
      "status":"1"
   },
   {
      "id":484,
      "code":"PLP260",
      "pembelianoperator_id":"90",
      "pembeliankategori_id":"11",
      "product_name":"VOUCHER PLAYPOINT 260000",
      "price":"90365",
      "status":"1"
   },
   {
      "id":485,
      "code":"PLT20",
      "pembelianoperator_id":"91",
      "pembeliankategori_id":"11",
      "product_name":"GAME FACEBOOK - POOL LIVE TOUR VOUCHER 20.000",
      "price":"18365",
      "status":"1"
   },
   {
      "id":486,
      "code":"PW20",
      "pembelianoperator_id":"92",
      "pembeliankategori_id":"11",
      "product_name":"GAME FACEBOOK PICO WORLD VOUCHER 20.000",
      "price":"18365",
      "status":"1"
   },
   {
      "id":487,
      "code":"JM20",
      "pembelianoperator_id":"93",
      "pembeliankategori_id":"11",
      "product_name":"GAME FACEBOOK - JOOMBI VOUCHER 20.000",
      "price":"18365",
      "status":"1"
   },
   {
      "id":488,
      "code":"BP20",
      "pembelianoperator_id":"94",
      "pembeliankategori_id":"11",
      "product_name":"GAME FACEBOOK BOYAA POKER VOUCHER 20.000",
      "price":"18365",
      "status":"1"
   },
   {
      "id":489,
      "code":"PLT50",
      "pembelianoperator_id":"91",
      "pembeliankategori_id":"11",
      "product_name":"GAME FACEBOOK - POOL LIVE TOUR VOUCHER 50.000",
      "price":"45365",
      "status":"1"
   },
   {
      "id":490,
      "code":"PW50",
      "pembelianoperator_id":"92",
      "pembeliankategori_id":"11",
      "product_name":"GAME FACEBOOK - PICO WORLD VOUCHER 50.000",
      "price":"45365",
      "status":"1"
   },
   {
      "id":491,
      "code":"JM50",
      "pembelianoperator_id":"93",
      "pembeliankategori_id":"11",
      "product_name":"GAME FACEBOOK - JOOMBI VOUCHER 50.000",
      "price":"45365",
      "status":"1"
   },
   {
      "id":492,
      "code":"PLT100",
      "pembelianoperator_id":"91",
      "pembeliankategori_id":"11",
      "product_name":"GAME FACEBOOK - POOL LIVE TOUR VOUCHER 100.000",
      "price":"90365",
      "status":"1"
   },
   {
      "id":493,
      "code":"PUB5000",
      "pembelianoperator_id":"95",
      "pembeliankategori_id":"12",
      "product_name":"PUBG MOBILE 5000 UC",
      "price":"1002490",
      "status":"1"
   },
   {
      "id":494,
      "code":"PUB2500",
      "pembelianoperator_id":"95",
      "pembeliankategori_id":"12",
      "product_name":"PUBG MOBILE 2500 UC",
      "price":"502490",
      "status":"1"
   },
   {
      "id":495,
      "code":"PUB1250",
      "pembelianoperator_id":"95",
      "pembeliankategori_id":"12",
      "product_name":"PUBG MOBILE 1250 UC",
      "price":"252490",
      "status":"1"
   },
   {
      "id":496,
      "code":"PUB500",
      "pembelianoperator_id":"95",
      "pembeliankategori_id":"12",
      "product_name":"PUBG MOBILE 500 UC",
      "price":"102490",
      "status":"1"
   },
   {
      "id":497,
      "code":"PUB250",
      "pembelianoperator_id":"95",
      "pembeliankategori_id":"12",
      "product_name":"PUBG MOBILE 250 UC",
      "price":"52490",
      "status":"1"
   },
   {
      "id":498,
      "code":"PUB50",
      "pembelianoperator_id":"95",
      "pembeliankategori_id":"12",
      "product_name":"PUBG MOBILE 50 UC",
      "price":"12490",
      "status":"1"
   },
   {
      "id":499,
      "code":"PW100",
      "pembelianoperator_id":"96",
      "pembeliankategori_id":"11",
      "product_name":"GAME FACEBOOK - PICO WORLD VOUCHER 100.000",
      "price":"90365",
      "status":"1"
   },
   {
      "id":500,
      "code":"PYN25",
      "pembelianoperator_id":"97",
      "pembeliankategori_id":"11",
      "product_name":"PLAYNEXIA 25.000",
      "price":"22865",
      "status":"1"
   },
   {
      "id":501,
      "code":"PYN50",
      "pembelianoperator_id":"97",
      "pembeliankategori_id":"11",
      "product_name":"PLAYNEXIA 50.000",
      "price":"45365",
      "status":"1"
   },
   {
      "id":502,
      "code":"PYN100",
      "pembelianoperator_id":"97",
      "pembeliankategori_id":"11",
      "product_name":"PLAYNEXIA 100.000",
      "price":"90365",
      "status":"1"
   },
   {
      "id":503,
      "code":"PYN200",
      "pembelianoperator_id":"97",
      "pembeliankategori_id":"11",
      "product_name":"PLAYNEXIA 200.000",
      "price":"180365",
      "status":"1"
   },
   {
      "id":504,
      "code":"SOF20",
      "pembelianoperator_id":"98",
      "pembeliankategori_id":"11",
      "product_name":"GAME SOFTNYX VOUCHER 20000",
      "price":"18365",
      "status":"1"
   },
   {
      "id":505,
      "code":"SOF50",
      "pembelianoperator_id":"98",
      "pembeliankategori_id":"11",
      "product_name":"GAME SOFTNYX VOUCHER 50000",
      "price":"45365",
      "status":"1"
   },
   {
      "id":506,
      "code":"SOF100",
      "pembelianoperator_id":"98",
      "pembeliankategori_id":"11",
      "product_name":"GAME SOFTNYX VOUCHER 100000",
      "price":"90365",
      "status":"1"
   },
   {
      "id":507,
      "code":"SPN2",
      "pembelianoperator_id":"99",
      "pembeliankategori_id":"11",
      "product_name":"SPIN VOUCHER 2500",
      "price":"3115",
      "status":"1"
   },
   {
      "id":508,
      "code":"SPN10",
      "pembelianoperator_id":"99",
      "pembeliankategori_id":"11",
      "product_name":"SPIN VOUCHER 10000",
      "price":"11265",
      "status":"1"
   },
   {
      "id":509,
      "code":"SPN20",
      "pembelianoperator_id":"99",
      "pembeliankategori_id":"11",
      "product_name":"SPIN VOUCHER 20000",
      "price":"22215",
      "status":"1"
   },
   {
      "id":510,
      "code":"SPN30",
      "pembelianoperator_id":"99",
      "pembeliankategori_id":"11",
      "product_name":"SPIN VOUCHER 30000",
      "price":"33115",
      "status":"1"
   },
   {
      "id":511,
      "code":"SPN50",
      "pembelianoperator_id":"99",
      "pembeliankategori_id":"11",
      "product_name":"SPIN VOUCHER 50000",
      "price":"54815",
      "status":"1"
   },
   {
      "id":512,
      "code":"SPN100",
      "pembelianoperator_id":"99",
      "pembeliankategori_id":"11",
      "product_name":"SPIN VOUCHER 100000",
      "price":"109165",
      "status":"1"
   },
   {
      "id":513,
      "code":"SRT2",
      "pembelianoperator_id":"100",
      "pembeliankategori_id":"11",
      "product_name":"SERENITY VOUCHER 2500 KOIN",
      "price":"9465",
      "status":"1"
   },
   {
      "id":514,
      "code":"SRT8",
      "pembelianoperator_id":"100",
      "pembeliankategori_id":"11",
      "product_name":"SERENITY VOUCHER 8000 KOIN",
      "price":"27665",
      "status":"1"
   },
   {
      "id":515,
      "code":"SRT15",
      "pembelianoperator_id":"100",
      "pembeliankategori_id":"11",
      "product_name":"SERENITY VOUCHER 15000 KOIN",
      "price":"45865",
      "status":"1"
   },
   {
      "id":516,
      "code":"SRT30",
      "pembelianoperator_id":"100",
      "pembeliankategori_id":"11",
      "product_name":"SERENITY VOUCHER 30000 KOIN",
      "price":"91365",
      "status":"1"
   },
   {
      "id":517,
      "code":"STE12",
      "pembelianoperator_id":"101",
      "pembeliankategori_id":"11",
      "product_name":"STEAM - 12000",
      "price":"15040",
      "status":"1"
   },
   {
      "id":518,
      "code":"STE45",
      "pembelianoperator_id":"101",
      "pembeliankategori_id":"11",
      "product_name":"STEAM - 45000",
      "price":"53865",
      "status":"1"
   },
   {
      "id":519,
      "code":"STE60",
      "pembelianoperator_id":"101",
      "pembeliankategori_id":"11",
      "product_name":"STEAM - 60000",
      "price":"72605",
      "status":"1"
   },
   {
      "id":520,
      "code":"STE90",
      "pembelianoperator_id":"101",
      "pembeliankategori_id":"11",
      "product_name":"STEAM - 90000",
      "price":"101865",
      "status":"0"
   },
   {
      "id":521,
      "code":"STE120",
      "pembelianoperator_id":"101",
      "pembeliankategori_id":"11",
      "product_name":"STEAM - 120000",
      "price":"143865",
      "status":"1"
   },
   {
      "id":522,
      "code":"STE250",
      "pembelianoperator_id":"101",
      "pembeliankategori_id":"11",
      "product_name":"STEAM - 250000",
      "price":"293915",
      "status":"1"
   },
   {
      "id":523,
      "code":"STE600",
      "pembelianoperator_id":"101",
      "pembeliankategori_id":"11",
      "product_name":"STEAM - 600000",
      "price":"718365",
      "status":"1"
   },
   {
      "id":524,
      "code":"STE400",
      "pembelianoperator_id":"101",
      "pembeliankategori_id":"11",
      "product_name":"STEAM - 400000",
      "price":"477365",
      "status":"1"
   },
   {
      "id":525,
      "code":"TRV27",
      "pembelianoperator_id":"102",
      "pembeliankategori_id":"11",
      "product_name":"TRAVIAN VOUCHER 27.000",
      "price":"35365",
      "status":"1"
   },
   {
      "id":526,
      "code":"TRV63",
      "pembelianoperator_id":"102",
      "pembeliankategori_id":"11",
      "product_name":"TRAVIAN VOUCHER 63.500",
      "price":"84865",
      "status":"1"
   },
   {
      "id":527,
      "code":"TRV137",
      "pembelianoperator_id":"102",
      "pembeliankategori_id":"11",
      "product_name":"TRAVIAN VOUCHER 137.500",
      "price":"182365",
      "status":"1"
   },
   {
      "id":528,
      "code":"TRV265",
      "pembelianoperator_id":"102",
      "pembeliankategori_id":"11",
      "product_name":"TRAVIAN VOUCHER 265.000",
      "price":"351365",
      "status":"1"
   },
   {
      "id":529,
      "code":"UGC25",
      "pembelianoperator_id":"103",
      "pembeliankategori_id":"11",
      "product_name":"ULTIMATE GAME CARD 250 POINTS",
      "price":"25365",
      "status":"1"
   },
   {
      "id":530,
      "code":"UGC50",
      "pembelianoperator_id":"103",
      "pembeliankategori_id":"11",
      "product_name":"ULTIMATE GAME CARD 500 POINTS",
      "price":"61565",
      "status":"1"
   },
   {
      "id":531,
      "code":"UGC100",
      "pembelianoperator_id":"103",
      "pembeliankategori_id":"11",
      "product_name":"ULTIMATE GAME CARD 1.000 POINTS",
      "price":"122865",
      "status":"1"
   },
   {
      "id":532,
      "code":"UGC200",
      "pembelianoperator_id":"103",
      "pembeliankategori_id":"11",
      "product_name":"ULTIMATE GAME CARD 2.000 POINTS",
      "price":"239365",
      "status":"1"
   },
   {
      "id":533,
      "code":"UNI500",
      "pembelianoperator_id":"104",
      "pembeliankategori_id":"11",
      "product_name":"UNIPIN VOUCHER 500000",
      "price":"479215",
      "status":"1"
   },
   {
      "id":534,
      "code":"UNI300",
      "pembelianoperator_id":"104",
      "pembeliankategori_id":"11",
      "product_name":"UNIPIN VOUCHER 300000",
      "price":"287215",
      "status":"1"
   },
   {
      "id":535,
      "code":"UNI100",
      "pembelianoperator_id":"104",
      "pembeliankategori_id":"11",
      "product_name":"UNIPIN VOUCHER 100000",
      "price":"96415",
      "status":"1"
   },
   {
      "id":536,
      "code":"UNI50",
      "pembelianoperator_id":"104",
      "pembeliankategori_id":"11",
      "product_name":"UNIPIN VOUCHER 50000",
      "price":"48415",
      "status":"1"
   },
   {
      "id":537,
      "code":"UNI20",
      "pembelianoperator_id":"104",
      "pembeliankategori_id":"11",
      "product_name":"UNIPIN VOUCHER 20000",
      "price":"19515",
      "status":"1"
   },
   {
      "id":538,
      "code":"UNI10",
      "pembelianoperator_id":"104",
      "pembeliankategori_id":"11",
      "product_name":"UNIPIN VOUCHER 10000",
      "price":"9915",
      "status":"1"
   },
   {
      "id":539,
      "code":"VTC5",
      "pembelianoperator_id":"105",
      "pembeliankategori_id":"11",
      "product_name":"VTC ONLINE 5 VCOIN",
      "price":"4865",
      "status":"1"
   },
   {
      "id":540,
      "code":"VTC20",
      "pembelianoperator_id":"105",
      "pembeliankategori_id":"11",
      "product_name":"VTC ONLINE 20 VCOIN",
      "price":"9365",
      "status":"1"
   },
   {
      "id":541,
      "code":"VTC40",
      "pembelianoperator_id":"105",
      "pembeliankategori_id":"11",
      "product_name":"VTC ONLINE 40 VCOIN",
      "price":"18365",
      "status":"1"
   },
   {
      "id":542,
      "code":"VTC60",
      "pembelianoperator_id":"105",
      "pembeliankategori_id":"11",
      "product_name":"VTC ONLINE 60 VCOIN",
      "price":"27365",
      "status":"1"
   },
   {
      "id":543,
      "code":"VTC100",
      "pembelianoperator_id":"105",
      "pembeliankategori_id":"11",
      "product_name":"VTC ONLINE 100 VCOIN",
      "price":"45365",
      "status":"1"
   },
   {
      "id":544,
      "code":"VTC200",
      "pembelianoperator_id":"105",
      "pembeliankategori_id":"11",
      "product_name":"VTC ONLINE 200 VCOIN",
      "price":"90365",
      "status":"1"
   },
   {
      "id":545,
      "code":"VW15",
      "pembelianoperator_id":"106",
      "pembeliankategori_id":"11",
      "product_name":"VIWAWA VOUCHER 15.000",
      "price":"13865",
      "status":"1"
   },
   {
      "id":546,
      "code":"VW30",
      "pembelianoperator_id":"106",
      "pembeliankategori_id":"11",
      "product_name":"VIWAWA VOUCHER 30.000",
      "price":"27365",
      "status":"1"
   },
   {
      "id":547,
      "code":"VW60",
      "pembelianoperator_id":"106",
      "pembeliankategori_id":"11",
      "product_name":"VIWAWA VOUCHER 60.000",
      "price":"54365",
      "status":"1"
   },
   {
      "id":548,
      "code":"WIN4",
      "pembelianoperator_id":"107",
      "pembeliankategori_id":"11",
      "product_name":"WINNER CARD 4.000 GP",
      "price":"5765",
      "status":"1"
   },
   {
      "id":549,
      "code":"WIN8",
      "pembelianoperator_id":"107",
      "pembeliankategori_id":"11",
      "product_name":"WINNER CARD 8.000 GP",
      "price":"11265",
      "status":"1"
   },
   {
      "id":550,
      "code":"WIN16",
      "pembelianoperator_id":"107",
      "pembeliankategori_id":"11",
      "product_name":"WINNER CARD 16.000 GP",
      "price":"21865",
      "status":"1"
   },
   {
      "id":551,
      "code":"WIN24",
      "pembelianoperator_id":"107",
      "pembeliankategori_id":"11",
      "product_name":"WINNER CARD 24.000 GP",
      "price":"32615",
      "status":"1"
   },
   {
      "id":552,
      "code":"WIN40",
      "pembelianoperator_id":"107",
      "pembeliankategori_id":"11",
      "product_name":"WINNER CARD 40.000 GP",
      "price":"53990",
      "status":"1"
   },
   {
      "id":553,
      "code":"WIN80",
      "pembelianoperator_id":"107",
      "pembeliankategori_id":"11",
      "product_name":"WINNER CARD 80.000 GP",
      "price":"107515",
      "status":"1"
   },
   {
      "id":554,
      "code":"WIN160",
      "pembelianoperator_id":"107",
      "pembeliankategori_id":"11",
      "product_name":"WINNER CARD 160.000 GP",
      "price":"213665",
      "status":"1"
   },
   {
      "id":555,
      "code":"WVP10",
      "pembelianoperator_id":"108",
      "pembeliankategori_id":"11",
      "product_name":"VOUCHER WAVEGAME 40 COIN",
      "price":"9365",
      "status":"1"
   },
   {
      "id":556,
      "code":"WVP20",
      "pembelianoperator_id":"108",
      "pembeliankategori_id":"11",
      "product_name":"VOUCHER WAVEGAME 82 COIN",
      "price":"18365",
      "status":"1"
   },
   {
      "id":557,
      "code":"WVP50",
      "pembelianoperator_id":"108",
      "pembeliankategori_id":"11",
      "product_name":"VOUCHER WAVEGAME 210 COIN",
      "price":"45365",
      "status":"1"
   },
   {
      "id":558,
      "code":"WVP100",
      "pembelianoperator_id":"108",
      "pembeliankategori_id":"11",
      "product_name":"VOUCHER WAVEGAME 435 COIN",
      "price":"90365",
      "status":"1"
   },
   {
      "id":559,
      "code":"WVP250",
      "pembelianoperator_id":"108",
      "pembeliankategori_id":"11",
      "product_name":"VOUCHER WAVEGAME 1088 COIN",
      "price":"225365",
      "status":"1"
   },
   {
      "id":560,
      "code":"ZNG20",
      "pembelianoperator_id":"109",
      "pembeliankategori_id":"11",
      "product_name":"ZYNGA 20.000",
      "price":"26365",
      "status":"0"
   },
   {
      "id":561,
      "code":"ZNG50",
      "pembelianoperator_id":"109",
      "pembeliankategori_id":"11",
      "product_name":"ZYNGA 50.000",
      "price":"65365",
      "status":"0"
   },
   {
      "id":562,
      "code":"ZNG100",
      "pembelianoperator_id":"109",
      "pembeliankategori_id":"11",
      "product_name":"ZYNGA 100.000",
      "price":"130365",
      "status":"1"
   },
   {
      "id":563,
      "code":"DNA20",
      "pembelianoperator_id":"110",
      "pembeliankategori_id":"13",
      "product_name":"SALDO DANA 20K",
      "price":"20550",
      "status":"1"
   },
   {
      "id":564,
      "code":"DNA10",
      "pembelianoperator_id":"110",
      "pembeliankategori_id":"13",
      "product_name":"SALDO DANA 10K",
      "price":"10650",
      "status":"1"
   },
   {
      "id":565,
      "code":"DNA40",
      "pembelianoperator_id":"110",
      "pembeliankategori_id":"13",
      "product_name":"SALDO DANA 40K",
      "price":"41400",
      "status":"1"
   },
   {
      "id":566,
      "code":"DNA30",
      "pembelianoperator_id":"110",
      "pembeliankategori_id":"13",
      "product_name":"SALDO DANA 30K",
      "price":"31400",
      "status":"1"
   },
   {
      "id":567,
      "code":"DNA25",
      "pembelianoperator_id":"110",
      "pembeliankategori_id":"13",
      "product_name":"SALDO DANA 25K",
      "price":"25550",
      "status":"1"
   },
   {
      "id":568,
      "code":"DNA250",
      "pembelianoperator_id":"110",
      "pembeliankategori_id":"13",
      "product_name":"SALDO DANA 250K",
      "price":"250550",
      "status":"1"
   },
   {
      "id":569,
      "code":"DNA50",
      "pembelianoperator_id":"110",
      "pembeliankategori_id":"13",
      "product_name":"SALDO DANA 50K",
      "price":"50700",
      "status":"1"
   },
   {
      "id":570,
      "code":"DNA100",
      "pembelianoperator_id":"110",
      "pembeliankategori_id":"13",
      "product_name":"SALDO DANA 100K",
      "price":"100550",
      "status":"1"
   },
   {
      "id":571,
      "code":"DNA75",
      "pembelianoperator_id":"110",
      "pembeliankategori_id":"13",
      "product_name":"SALDO DANA 75K",
      "price":"75550",
      "status":"1"
   },
   {
      "id":572,
      "code":"DNA300",
      "pembelianoperator_id":"110",
      "pembeliankategori_id":"13",
      "product_name":"SALDO DANA 300K",
      "price":"300550",
      "status":"1"
   },
   {
      "id":573,
      "code":"DNA200",
      "pembelianoperator_id":"110",
      "pembeliankategori_id":"13",
      "product_name":"SALDO DANA 200K",
      "price":"200550",
      "status":"1"
   },
   {
      "id":574,
      "code":"DNA150",
      "pembelianoperator_id":"110",
      "pembeliankategori_id":"13",
      "product_name":"SALDO DANA 150K",
      "price":"150550",
      "status":"1"
   },
   {
      "id":575,
      "code":"DNA500",
      "pembelianoperator_id":"110",
      "pembeliankategori_id":"13",
      "product_name":"SALDO DANA 500K",
      "price":"500550",
      "status":"1"
   },
   {
      "id":576,
      "code":"DNA400",
      "pembelianoperator_id":"110",
      "pembeliankategori_id":"13",
      "product_name":"SALDO DANA 400K",
      "price":"400700",
      "status":"1"
   },
   {
      "id":577,
      "code":"LINK20",
      "pembelianoperator_id":"111",
      "pembeliankategori_id":"13",
      "product_name":"SALDO LINKAJA 20K",
      "price":"20700",
      "status":"1"
   },
   {
      "id":578,
      "code":"LINK10",
      "pembelianoperator_id":"111",
      "pembeliankategori_id":"13",
      "product_name":"SALDO LINKAJA 10K",
      "price":"10700",
      "status":"1"
   },
   {
      "id":579,
      "code":"LINK50",
      "pembelianoperator_id":"111",
      "pembeliankategori_id":"13",
      "product_name":"SALDO LINKAJA 50K",
      "price":"50700",
      "status":"1"
   },
   {
      "id":580,
      "code":"LINK40",
      "pembelianoperator_id":"111",
      "pembeliankategori_id":"13",
      "product_name":"SALDO LINKAJA 40K",
      "price":"40700",
      "status":"1"
   },
   {
      "id":581,
      "code":"LINK30",
      "pembelianoperator_id":"111",
      "pembeliankategori_id":"13",
      "product_name":"SALDO LINKAJA 30K",
      "price":"30700",
      "status":"1"
   },
   {
      "id":582,
      "code":"LINK500",
      "pembelianoperator_id":"111",
      "pembeliankategori_id":"13",
      "product_name":"SALDO LINKAJA 500K",
      "price":"502200",
      "status":"1"
   },
   {
      "id":583,
      "code":"LINK400",
      "pembelianoperator_id":"111",
      "pembeliankategori_id":"13",
      "product_name":"SALDO LINKAJA 400K",
      "price":"402200",
      "status":"1"
   },
   {
      "id":584,
      "code":"LINK300",
      "pembelianoperator_id":"111",
      "pembeliankategori_id":"13",
      "product_name":"SALDO LINKAJA 300K",
      "price":"302200",
      "status":"1"
   },
   {
      "id":585,
      "code":"LINK200",
      "pembelianoperator_id":"111",
      "pembeliankategori_id":"13",
      "product_name":"SALDO LINKAJA 200K",
      "price":"202200",
      "status":"1"
   },
   {
      "id":586,
      "code":"LINK100",
      "pembelianoperator_id":"111",
      "pembeliankategori_id":"13",
      "product_name":"SALDO LINKAJA 100K",
      "price":"101200",
      "status":"1"
   },
   {
      "id":587,
      "code":"S40",
      "pembelianoperator_id":"29",
      "pembeliankategori_id":"1",
      "product_name":"TELKOMSEL 40K",
      "price":"40050",
      "status":"1"
   },
   {
      "id":588,
      "code":"S90",
      "pembelianoperator_id":"29",
      "pembeliankategori_id":"1",
      "product_name":"TELKOMSEL 90K",
      "price":"89325",
      "status":"1"
   },
   {
      "id":589,
      "code":"S80",
      "pembelianoperator_id":"29",
      "pembeliankategori_id":"1",
      "product_name":"TELKOMSEL 80K",
      "price":"79400",
      "status":"1"
   },
   {
      "id":590,
      "code":"S75",
      "pembelianoperator_id":"29",
      "pembeliankategori_id":"1",
      "product_name":"TELKOMSEL 75K",
      "price":"74550",
      "status":"1"
   },
   {
      "id":591,
      "code":"S70",
      "pembelianoperator_id":"29",
      "pembeliankategori_id":"1",
      "product_name":"TELKOMSEL 70K",
      "price":"69500",
      "status":"1"
   },
   {
      "id":592,
      "code":"S60",
      "pembelianoperator_id":"29",
      "pembeliankategori_id":"1",
      "product_name":"TELKOMSEL 60K",
      "price":"59700",
      "status":"1"
   },
   {
      "id":593,
      "code":"S30",
      "pembelianoperator_id":"29",
      "pembeliankategori_id":"1",
      "product_name":"TELKOMSEL 30K",
      "price":"29650",
      "status":"1"
   },
   {
      "id":594,
      "code":"IFP4",
      "pembelianoperator_id":"112",
      "pembeliankategori_id":"2",
      "product_name":"2GB+1GB (01-06)+NELP 5MNT ALL 30HR",
      "price":"22750",
      "status":"1"
   },
   {
      "id":595,
      "code":"IFP20",
      "pembelianoperator_id":"112",
      "pembeliankategori_id":"2",
      "product_name":"11GB+4GB (01-06)+NELP 40MNT ALL 30HR",
      "price":"66000",
      "status":"1"
   },
   {
      "id":596,
      "code":"IFP14",
      "pembelianoperator_id":"112",
      "pembeliankategori_id":"2",
      "product_name":"7,5GB+3GB (01-06)+NELP 30MNT ALL 30HR",
      "price":"48250",
      "status":"1"
   },
   {
      "id":597,
      "code":"IFP8",
      "pembelianoperator_id":"112",
      "pembeliankategori_id":"2",
      "product_name":"4GB+2GB (01-06)+NELP 20MNT ALL 30HR",
      "price":"33500",
      "status":"1"
   },
   {
      "id":598,
      "code":"IFP50",
      "pembelianoperator_id":"112",
      "pembeliankategori_id":"2",
      "product_name":"25GB+10GB (01-06)+NELP 60MNT ALL 30HR",
      "price":"135500",
      "status":"1"
   },
   {
      "id":599,
      "code":"SDM11",
      "pembelianoperator_id":"113",
      "pembeliankategori_id":"2",
      "product_name":"MINI 1GB 1HR",
      "price":"12000",
      "status":"1"
   },
   {
      "id":600,
      "code":"SDM13",
      "pembelianoperator_id":"113",
      "pembeliankategori_id":"2",
      "product_name":"MINI 1GB 3HR",
      "price":"14400",
      "status":"1"
   },
   {
      "id":601,
      "code":"SDM27",
      "pembelianoperator_id":"113",
      "pembeliankategori_id":"2",
      "product_name":"MINI 2GB 7HR",
      "price":"37850",
      "status":"1"
   },
   {
      "id":602,
      "code":"SDM23",
      "pembelianoperator_id":"113",
      "pembeliankategori_id":"2",
      "product_name":"MINI 2GB 3HR",
      "price":"23250",
      "status":"1"
   },
   {
      "id":603,
      "code":"SDM17",
      "pembelianoperator_id":"113",
      "pembeliankategori_id":"2",
      "product_name":"MINI 1GB 7HR",
      "price":"22250",
      "status":"1"
   },
   {
      "id":604,
      "code":"SDM37",
      "pembelianoperator_id":"113",
      "pembeliankategori_id":"2",
      "product_name":"MINI 3GB 7HR",
      "price":"40750",
      "status":"1"
   },
   {
      "id":605,
      "code":"SDM51",
      "pembelianoperator_id":"113",
      "pembeliankategori_id":"2",
      "product_name":"MINI 5GB 1HR",
      "price":"26900",
      "status":"1"
   },
   {
      "id":606,
      "code":"SDM57",
      "pembelianoperator_id":"113",
      "pembeliankategori_id":"2",
      "product_name":"MINI 5GB 7HR",
      "price":"46900",
      "status":"1"
   },
   {
      "id":607,
      "code":"SDM53",
      "pembelianoperator_id":"113",
      "pembeliankategori_id":"2",
      "product_name":"MINI 5GB 3HR",
      "price":"30950",
      "status":"1"
   },
   {
      "id":608,
      "code":"SDM107",
      "pembelianoperator_id":"113",
      "pembeliankategori_id":"2",
      "product_name":"MINI 10GB 7HR",
      "price":"57750",
      "status":"1"
   },
   {
      "id":609,
      "code":"SDM103",
      "pembelianoperator_id":"113",
      "pembeliankategori_id":"2",
      "product_name":"MINI 10GB 3HR",
      "price":"38750",
      "status":"1"
   },
   {
      "id":610,
      "code":"SDM101",
      "pembelianoperator_id":"113",
      "pembeliankategori_id":"2",
      "product_name":"MINI 10GB 1HR",
      "price":"35000",
      "status":"1"
   },
   {
      "id":611,
      "code":"AXO4",
      "pembelianoperator_id":"114",
      "pembeliankategori_id":"2",
      "product_name":"VOUCHER OWSEM 1GB+3GB 4G 30HR",
      "price":"31775",
      "status":"1"
   },
   {
      "id":612,
      "code":"AXO2",
      "pembelianoperator_id":"114",
      "pembeliankategori_id":"2",
      "product_name":"VOUCHER OWSEM 1GB+1GB 4G 30HR",
      "price":"20775",
      "status":"1"
   },
   {
      "id":613,
      "code":"AXO12",
      "pembelianoperator_id":"114",
      "pembeliankategori_id":"2",
      "product_name":"VOUCHER OWSEM 3GB+9GB 4G 30HR",
      "price":"65675",
      "status":"1"
   },
   {
      "id":614,
      "code":"AXO8",
      "pembelianoperator_id":"114",
      "pembeliankategori_id":"2",
      "product_name":"VOUCHER OWSEM 2GB+6GB 4G 30HR",
      "price":"50675",
      "status":"1"
   },
   {
      "id":615,
      "code":"SMV65",
      "pembelianoperator_id":"27",
      "pembeliankategori_id":"2",
      "product_name":"VOLUME UNLIMITED 4G 30HR",
      "price":"65700",
      "status":"1"
   },
   {
      "id":616,
      "code":"SMDV10",
      "pembelianoperator_id":"115",
      "pembeliankategori_id":"2",
      "product_name":"VOUCHER 1.25GB + 1.75GB MALAM 7HR",
      "price":"10800",
      "status":"1"
   },
   {
      "id":617,
      "code":"SMDV30",
      "pembelianoperator_id":"115",
      "pembeliankategori_id":"2",
      "product_name":"VOUCHER 5GB + 5GB MALAM 30HR",
      "price":"25775",
      "status":"1"
   },
   {
      "id":618,
      "code":"SMDV65",
      "pembelianoperator_id":"115",
      "pembeliankategori_id":"2",
      "product_name":"VOUCHER UNLIMITED 4G 30HR",
      "price":"63775",
      "status":"1"
   },
   {
      "id":619,
      "code":"SMDV90",
      "pembelianoperator_id":"115",
      "pembeliankategori_id":"2",
      "product_name":"VOUCHER 15GB + 15GB MALAM 30HR",
      "price":"57775",
      "status":"1"
   },
   {
      "id":620,
      "code":"SMDV60",
      "pembelianoperator_id":"115",
      "pembeliankategori_id":"2",
      "product_name":"VOUCHER 8GB + 8GB MALAM 30HR",
      "price":"36775",
      "status":"1"
   },
   {
      "id":621,
      "code":"SMDV100",
      "pembelianoperator_id":"115",
      "pembeliankategori_id":"2",
      "product_name":"VOUCHER 30GB + 30GB MALAM 30HR",
      "price":"96775",
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
	$code = $row["code"];
	$pembelianoperator_id = $row["pembelianoperator_id"];
	$product_name = $row["product_name"];
	$pembeliankategori_id = $row["pembeliankategori_id"];
	$status = $row["status"];
	$price = $row["price"];

	$arrresorder[]=array("id"=>$id,"price"=>$price,"code"=>$code,"pembelianoperator_id"=>$pembelianoperator_id,"product_name"=>$product_name,"pembeliankategori_id"=>$pembeliankategori_id,"status"=>$status);
	
  }
print_r($arrresorder);


if (!$dbh) {
			$arr=array("kode"=>$kode,"nama"=>$nama);
		}else{
			$resultord = pdoMultiInsert('x_ppob_product', $arrresorder, $dbh);
		}





?>