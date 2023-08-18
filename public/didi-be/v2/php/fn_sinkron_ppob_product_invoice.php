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
      "code":"ADIRA",
      "product_name":"Adira Finance",
      "biaya_admin":"3500",
      "pembayaranoperator_id":"1",
      "pembayarankategori_id":"4",
      "status":"0"
   },
   {
      "id":2,
      "code":"BAF",
      "product_name":"Bussan Auto Finance",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"1",
      "pembayarankategori_id":"4",
      "status":"0"
   },
   {
      "id":3,
      "code":"WOM",
      "product_name":"Wahana Ottomitra Multiartha",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"1",
      "pembayarankategori_id":"4",
      "status":"0"
   },
   {
      "id":4,
      "code":"MAF",
      "product_name":"Mega Central Finance",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"1",
      "pembayarankategori_id":"4",
      "status":"0"
   },
   {
      "id":5,
      "code":"MAF",
      "product_name":"Mega Auto Finance",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"1",
      "pembayarankategori_id":"4",
      "status":"0"
   },
   {
      "id":6,
      "code":"FIF",
      "product_name":"FIF Finance",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"1",
      "pembayarankategori_id":"4",
      "status":"0"
   },
   {
      "id":7,
      "code":"ANZPL",
      "product_name":"ANZ PL",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"1",
      "pembayarankategori_id":"4",
      "status":"0"
   },
   {
      "id":8,
      "code":"PLN",
      "product_name":"PLN",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"8",
      "pembayarankategori_id":"11",
      "status":"0"
   },
   {
      "id":9,
      "code":"TELKOM",
      "product_name":"TELKOMVISION",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"5",
      "pembayarankategori_id":"8",
      "status":"0"
   },
   {
      "id":10,
      "code":"TELKOM",
      "product_name":"YES TV",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"6",
      "pembayarankategori_id":"9",
      "status":"0"
   },
   {
      "id":11,
      "code":"AORATV",
      "product_name":"AORA TV",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"6",
      "pembayarankategori_id":"9",
      "status":"0"
   },
   {
      "id":12,
      "code":"INDOVISION",
      "product_name":"INDOVISION",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"6",
      "pembayarankategori_id":"9",
      "status":"0"
   },
   {
      "id":13,
      "code":"TELKOM",
      "product_name":"TELKOM PSTN (Telp Rumah)",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"5",
      "pembayarankategori_id":"8",
      "status":"0"
   },
   {
      "id":14,
      "code":"TELKOM",
      "product_name":"TELKOM SPEEDY",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"5",
      "pembayarankategori_id":"8",
      "status":"0"
   },
   {
      "id":15,
      "code":"TELKOM",
      "product_name":"TELKOM FLEXI",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"5",
      "pembayarankategori_id":"8",
      "status":"0"
   },
   {
      "id":16,
      "code":"NEXMEDIATV",
      "product_name":"NEXMEDIA",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"6",
      "pembayarankategori_id":"9",
      "status":"0"
   },
   {
      "id":17,
      "code":"HALO",
      "product_name":"Telkomsel Halo",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"7",
      "pembayarankategori_id":"10",
      "status":"0"
   },
   {
      "id":18,
      "code":"FLEXI",
      "product_name":"Flexi Classy",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"7",
      "pembayarankategori_id":"10",
      "status":"0"
   },
   {
      "id":19,
      "code":"XPLOR",
      "product_name":"XL Pascabayar",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"7",
      "pembayarankategori_id":"10",
      "status":"0"
   },
   {
      "id":20,
      "code":"MATRIX",
      "product_name":"Indosat Matrix",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"7",
      "pembayarankategori_id":"10",
      "status":"0"
   },
   {
      "id":21,
      "code":"ESIA",
      "product_name":"Esia Pascabayar",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"7",
      "pembayarankategori_id":"10",
      "status":"0"
   },
   {
      "id":22,
      "code":"THREEPASCA",
      "product_name":"Three Pascabayar",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"7",
      "pembayarankategori_id":"10",
      "status":"0"
   },
   {
      "id":23,
      "code":"SMARFRENPASCA",
      "product_name":"Smartfren Pascabayar",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"7",
      "pembayarankategori_id":"10",
      "status":"0"
   },
   {
      "id":24,
      "code":"BIGTV",
      "product_name":"BIG TV",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"6",
      "pembayarankategori_id":"9",
      "status":"0"
   },
   {
      "id":25,
      "code":"INNOVATE",
      "product_name":"INNOVATE",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"6",
      "pembayarankategori_id":"9",
      "status":"0"
   },
   {
      "id":26,
      "code":"PGN",
      "product_name":"PGN",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"9",
      "pembayarankategori_id":"12",
      "status":"0"
   },
   {
      "id":27,
      "code":"TELKOM",
      "product_name":"INDIHOME",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"5",
      "pembayarankategori_id":"8",
      "status":"0"
   },
   {
      "id":28,
      "code":"FIRSTMEDIA",
      "product_name":"FIRSTMEDIA",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"6",
      "pembayarankategori_id":"9",
      "status":"0"
   },
   {
      "id":29,
      "code":"TOPTV",
      "product_name":"TOP TV",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"6",
      "pembayarankategori_id":"9",
      "status":"0"
   },
   {
      "id":30,
      "code":"CBN",
      "product_name":"CBN",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"2",
      "pembayarankategori_id":"5",
      "status":"0"
   },
   {
      "id":31,
      "code":"INDOSATNET",
      "product_name":"IndosatNet",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"6",
      "pembayarankategori_id":"9",
      "status":"0"
   },
   {
      "id":32,
      "code":"CENTRINNET",
      "product_name":"CentrinNet",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"6",
      "pembayarankategori_id":"9",
      "status":"0"
   },
   {
      "id":33,
      "code":"XPLOR",
      "product_name":"JOOMBIVOC",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"2",
      "pembayarankategori_id":"5",
      "status":"0"
   },
   {
      "id":34,
      "code":"ORANGETV",
      "product_name":"ORANGE TV",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"6",
      "pembayarankategori_id":"9",
      "status":"0"
   },
   {
      "id":35,
      "code":"BPJS",
      "product_name":"BPJS Kesehatan",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"3",
      "pembayarankategori_id":"6",
      "status":"0"
   },
   {
      "id":36,
      "code":"SINARMASLIFE",
      "product_name":"Sinarmas Life",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"3",
      "pembayarankategori_id":"6",
      "status":"0"
   },
   {
      "id":37,
      "code":"SINARMAS",
      "product_name":"Sinarmas",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"3",
      "pembayarankategori_id":"6",
      "status":"0"
   },
   {
      "id":38,
      "code":"AIA",
      "product_name":"AIA",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"3",
      "pembayarankategori_id":"6",
      "status":"0"
   },
   {
      "id":39,
      "code":"PRUDENTIAL",
      "product_name":"Prudential",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"3",
      "pembayarankategori_id":"6",
      "status":"0"
   },
   {
      "id":40,
      "code":"PDAMPLJ",
      "product_name":"PDAM PALYJA - Jakarta",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"4",
      "pembayarankategori_id":"7",
      "status":"0"
   },
   {
      "id":41,
      "code":"PDAMATR",
      "product_name":"PDAM Aetra - Jakarta",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"4",
      "pembayarankategori_id":"7",
      "status":"0"
   },
   {
      "id":42,
      "code":"PDAMBDG",
      "product_name":"PDAM Bandung",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"4",
      "pembayarankategori_id":"7",
      "status":"0"
   },
   {
      "id":43,
      "code":"PDAMKBDG",
      "product_name":"PDAM Kab Bandung",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"4",
      "pembayarankategori_id":"7",
      "status":"0"
   },
   {
      "id":44,
      "code":"PDAMMLG",
      "product_name":"PDAM Malang",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"4",
      "pembayarankategori_id":"7",
      "status":"0"
   },
   {
      "id":45,
      "code":"PDAMKMLG",
      "product_name":"PDAM Kab. Malang",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"4",
      "pembayarankategori_id":"7",
      "status":"0"
   },
   {
      "id":46,
      "code":"PDAMPLB",
      "product_name":"PDAM Palembang",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"4",
      "pembayarankategori_id":"7",
      "status":"0"
   },
   {
      "id":47,
      "code":"PDAMJMB",
      "product_name":"PDAM Jambi",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"4",
      "pembayarankategori_id":"7",
      "status":"0"
   },
   {
      "id":48,
      "code":"PDAMBDL",
      "product_name":"PDAM Lampung",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"4",
      "pembayarankategori_id":"7",
      "status":"0"
   },
   {
      "id":49,
      "code":"PDAMBLP",
      "product_name":"PDAM Balikpapan",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"4",
      "pembayarankategori_id":"7",
      "status":"0"
   },
   {
      "id":50,
      "code":"PDAMBYL",
      "product_name":"PDAM Boyolali",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"4",
      "pembayarankategori_id":"7",
      "status":"0"
   },
   {
      "id":51,
      "code":"PDAMGRBK",
      "product_name":"PDAM Grobogan",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"4",
      "pembayarankategori_id":"7",
      "status":"0"
   },
   {
      "id":52,
      "code":"PDAMKBRY",
      "product_name":"PDAM Kubu Raya",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"4",
      "pembayarankategori_id":"7",
      "status":"0"
   },
   {
      "id":53,
      "code":"PDAMMND",
      "product_name":"PDAM Manado",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"4",
      "pembayarankategori_id":"7",
      "status":"0"
   },
   {
      "id":54,
      "code":"PDAMPSM",
      "product_name":"PDAM Makassar",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"4",
      "pembayarankategori_id":"7",
      "status":"0"
   },
   {
      "id":55,
      "code":"PDAMSMR",
      "product_name":"PDAM Semarang",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"4",
      "pembayarankategori_id":"7",
      "status":"0"
   },
   {
      "id":56,
      "code":"PDAMKSMR",
      "product_name":"PDAM Kab. Semarang",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"4",
      "pembayarankategori_id":"7",
      "status":"0"
   },
   {
      "id":57,
      "code":"PDAMCLP",
      "product_name":"PDAM Cilacap",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"4",
      "pembayarankategori_id":"7",
      "status":"0"
   },
   {
      "id":58,
      "code":"PDAMMJK",
      "product_name":"PDAM Mojokerto",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"4",
      "pembayarankategori_id":"7",
      "status":"0"
   },
   {
      "id":59,
      "code":"PDAMBNK",
      "product_name":"PDAM Bangkalan",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"4",
      "pembayarankategori_id":"7",
      "status":"0"
   },
   {
      "id":60,
      "code":"PDAMKBN",
      "product_name":"PDAM Kebumen",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"4",
      "pembayarankategori_id":"7",
      "status":"0"
   },
   {
      "id":61,
      "code":"PDAMPKL",
      "product_name":"PDAM Pekalongan",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"4",
      "pembayarankategori_id":"7",
      "status":"0"
   },
   {
      "id":62,
      "code":"PDAMKGR",
      "product_name":"PDAM Karanganyar",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"4",
      "pembayarankategori_id":"7",
      "status":"0"
   },
   {
      "id":63,
      "code":"PDAMSRG",
      "product_name":"PDAM Sragen",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"4",
      "pembayarankategori_id":"7",
      "status":"0"
   },
   {
      "id":64,
      "code":"PDAMBJS",
      "product_name":"PDAM Banjarmasin",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"4",
      "pembayarankategori_id":"7",
      "status":"0"
   },
   {
      "id":65,
      "code":"PDAMKDL",
      "product_name":"PDAM Kendal",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"4",
      "pembayarankategori_id":"7",
      "status":"0"
   },
   {
      "id":66,
      "code":"PDAMMDN",
      "product_name":"PDAM Madiun",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"4",
      "pembayarankategori_id":"7",
      "status":"0"
   },
   {
      "id":67,
      "code":"PDAMPRG",
      "product_name":"PDAM Purbalingga",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"4",
      "pembayarankategori_id":"7",
      "status":"0"
   },
   {
      "id":68,
      "code":"PDAMBBS",
      "product_name":"PDAM Brebes",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"4",
      "pembayarankategori_id":"7",
      "status":"0"
   },
   {
      "id":69,
      "code":"PDAMBLL",
      "product_name":"PDAM Buleleng",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"4",
      "pembayarankategori_id":"7",
      "status":"0"
   },
   {
      "id":70,
      "code":"PDAMMTM",
      "product_name":"PDAM Giri Menang Mataram",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"4",
      "pembayarankategori_id":"7",
      "status":"0"
   },
   {
      "id":71,
      "code":"PDAMPWJ",
      "product_name":"PDAM Purworejo",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"4",
      "pembayarankategori_id":"7",
      "status":"0"
   },
   {
      "id":72,
      "code":"PDAMWGI",
      "product_name":"PDAM Wonogiri",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"4",
      "pembayarankategori_id":"7",
      "status":"0"
   },
   {
      "id":73,
      "code":"PDAMLTG",
      "product_name":"PDAM Lombok Tengah",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"4",
      "pembayarankategori_id":"7",
      "status":"0"
   },
   {
      "id":74,
      "code":"PDAMKSLM",
      "product_name":"PDAM Sleman",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"4",
      "pembayarankategori_id":"7",
      "status":"0"
   },
   {
      "id":75,
      "code":"PDAMIBJ",
      "product_name":"PDAM Intan Banjar",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"4",
      "pembayarankategori_id":"7",
      "status":"0"
   },
   {
      "id":76,
      "code":"PDAMBJR",
      "product_name":"PDAM Banjar",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"4",
      "pembayarankategori_id":"7",
      "status":"0"
   },
   {
      "id":77,
      "code":"PDAMSTB",
      "product_name":"PDAM Situbondo",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"4",
      "pembayarankategori_id":"7",
      "status":"0"
   },
   {
      "id":78,
      "code":"PDAMTMG",
      "product_name":"PDAM Temanggung",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"4",
      "pembayarankategori_id":"7",
      "status":"0"
   },
   {
      "id":79,
      "code":"PDAMBRB",
      "product_name":"PDAM Barabai",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"4",
      "pembayarankategori_id":"7",
      "status":"0"
   },
   {
      "id":80,
      "code":"PDAMKJBR",
      "product_name":"PDAM Jember",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"4",
      "pembayarankategori_id":"7",
      "status":"0"
   },
   {
      "id":81,
      "code":"PDAMWSB",
      "product_name":"PDAM Wonosobo",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"4",
      "pembayarankategori_id":"7",
      "status":"0"
   },
   {
      "id":82,
      "code":"PDAMSLT",
      "product_name":"PDAM Salatiga",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"4",
      "pembayarankategori_id":"7",
      "status":"0"
   },
   {
      "id":83,
      "code":"PDAMRBG",
      "product_name":"PDAM Rembang",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"4",
      "pembayarankategori_id":"7",
      "status":"0"
   },
   {
      "id":84,
      "code":"PDAMSRK",
      "product_name":"PDAM Surakarta",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"4",
      "pembayarankategori_id":"7",
      "status":"0"
   },
   {
      "id":85,
      "code":"PDAMPBG",
      "product_name":"PDAM Probolinggo",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"4",
      "pembayarankategori_id":"7",
      "status":"0"
   },
   {
      "id":86,
      "code":"PDAMKBDW",
      "product_name":"PDAM Kab. Bondowoso",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"4",
      "pembayarankategori_id":"7",
      "status":"0"
   },
   {
      "id":358,
      "code":"PLNPRAH",
      "product_name":"PLN Prabayar \/ Token",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"38",
      "pembayarankategori_id":"37",
      "status":"0"
   },
   {
      "id":359,
      "code":"PLNPASCH",
      "product_name":"PLN Pasca Bayar",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"38",
      "pembayarankategori_id":"37",
      "status":"1"
   },
   {
      "id":360,
      "code":"PLNNONH",
      "product_name":"PLN Non Taglist",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"38",
      "pembayarankategori_id":"37",
      "status":"1"
   },
   {
      "id":361,
      "code":"ASRBPJSKS",
      "product_name":"Pembayaran BPJS",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"39",
      "pembayarankategori_id":"38",
      "status":"1"
   },
   {
      "id":362,
      "code":"MKAI",
      "product_name":"Tiket Kereta Api",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"40",
      "pembayarankategori_id":"39",
      "status":"1"
   },
   {
      "id":363,
      "code":"ASRJWS",
      "product_name":"Asuransi Jiwasraya",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"41",
      "pembayarankategori_id":"40",
      "status":"1"
   },
   {
      "id":364,
      "code":"TVINDVS",
      "product_name":"Indovision, Top TV, Okevision",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"42",
      "pembayarankategori_id":"41",
      "status":"1"
   },
   {
      "id":365,
      "code":"TVTLKMV",
      "product_name":"Transvision, Telkomvision, Yes TV",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"42",
      "pembayarankategori_id":"41",
      "status":"1"
   },
   {
      "id":366,
      "code":"TVKMVPRE",
      "product_name":"Voucher Telkomvision Pra Combo",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"42",
      "pembayarankategori_id":"41",
      "status":"1"
   },
   {
      "id":367,
      "code":"TELVISCOS",
      "product_name":"Voucher Telkomvision Pra Cosmo",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"42",
      "pembayarankategori_id":"41",
      "status":"1"
   },
   {
      "id":368,
      "code":"TELVISFIL",
      "product_name":"Voucher Telkomvision Pra Film",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"42",
      "pembayarankategori_id":"41",
      "status":"1"
   },
   {
      "id":369,
      "code":"TELVISHEM",
      "product_name":"Voucher Telkomvision Pra Hemat",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"42",
      "pembayarankategori_id":"41",
      "status":"1"
   },
   {
      "id":370,
      "code":"TELVISOLA",
      "product_name":"Voucher Telkomvision Pra Olahraga",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"42",
      "pembayarankategori_id":"41",
      "status":"1"
   },
   {
      "id":371,
      "code":"TELVISPEL",
      "product_name":"Voucher Telkomvision Pra Pelangi",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"42",
      "pembayarankategori_id":"41",
      "status":"1"
   },
   {
      "id":372,
      "code":"TELVISPEN",
      "product_name":"Voucher Telkomvision Pra Pendidikan",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"42",
      "pembayarankategori_id":"41",
      "status":"1"
   },
   {
      "id":373,
      "code":"TVNEX",
      "product_name":"Nex Media",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"42",
      "pembayarankategori_id":"41",
      "status":"1"
   },
   {
      "id":374,
      "code":"TVTOPAS",
      "product_name":"Topas TV",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"42",
      "pembayarankategori_id":"41",
      "status":"1"
   },
   {
      "id":375,
      "code":"TVORANGE",
      "product_name":"Orange TV",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"42",
      "pembayarankategori_id":"41",
      "status":"1"
   },
   {
      "id":376,
      "code":"TVORG50",
      "product_name":"Orange TV (50.000)",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"42",
      "pembayarankategori_id":"41",
      "status":"1"
   },
   {
      "id":377,
      "code":"TVORG80",
      "product_name":"Orange TV (80.000)",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"42",
      "pembayarankategori_id":"41",
      "status":"1"
   },
   {
      "id":378,
      "code":"TVORG100",
      "product_name":"Orange TV (100.000)",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"42",
      "pembayarankategori_id":"41",
      "status":"1"
   },
   {
      "id":379,
      "code":"TVORG300",
      "product_name":"Orange TV (300.000)",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"42",
      "pembayarankategori_id":"41",
      "status":"1"
   },
   {
      "id":380,
      "code":"TVBIG",
      "product_name":"BIG TV",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"42",
      "pembayarankategori_id":"41",
      "status":"1"
   },
   {
      "id":381,
      "code":"TVINNOV",
      "product_name":"INNOVATE TV",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"42",
      "pembayarankategori_id":"41",
      "status":"1"
   },
   {
      "id":382,
      "code":"TVSKYFAM6",
      "product_name":"SKYNINDO TV FAMILY 6 BLN (240.000)",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"42",
      "pembayarankategori_id":"41",
      "status":"1"
   },
   {
      "id":383,
      "code":"TVSKYFAM12",
      "product_name":"SKYNINDO TV FAMILY 12 BLN (480.000)",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"42",
      "pembayarankategori_id":"41",
      "status":"1"
   },
   {
      "id":384,
      "code":"TVSKYFAM1",
      "product_name":"SKYNINDO TV FAMILY 1 BLN (40.000)",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"42",
      "pembayarankategori_id":"41",
      "status":"1"
   },
   {
      "id":385,
      "code":"TVSKYMAN1",
      "product_name":"SKYNINDO TV MANDARIN 1 BLN (140.000)",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"42",
      "pembayarankategori_id":"41",
      "status":"1"
   },
   {
      "id":386,
      "code":"TVSKYDEL1",
      "product_name":"SKYNINDO TV DELUXE 1 BLN (80.000)",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"42",
      "pembayarankategori_id":"41",
      "status":"1"
   },
   {
      "id":387,
      "code":"TVSKYDEL12",
      "product_name":"SKYNINDO TV DELUXE 12 BLN (960.000)",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"42",
      "pembayarankategori_id":"41",
      "status":"1"
   },
   {
      "id":388,
      "code":"TVSKYMAN3",
      "product_name":"SKYNINDO TV MANDARIN 3 BLN (420.000)",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"42",
      "pembayarankategori_id":"41",
      "status":"1"
   },
   {
      "id":389,
      "code":"TVSKYDEL3",
      "product_name":"SKYNINDO TV DELUXE 3 BLN (240.000)",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"42",
      "pembayarankategori_id":"41",
      "status":"1"
   },
   {
      "id":390,
      "code":"TVSKYDEL6",
      "product_name":"SKYNINDO TV DELUXE 6 BLN (480.000)",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"42",
      "pembayarankategori_id":"41",
      "status":"1"
   },
   {
      "id":391,
      "code":"TVSKYFAM3",
      "product_name":"SKYNINDO TV FAMILY 3 BLN (120.000)",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"42",
      "pembayarankategori_id":"41",
      "status":"1"
   },
   {
      "id":392,
      "code":"TVSKYMAN12",
      "product_name":"SKYNINDO TV MANDARIN 12 BLN (1.680.000)",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"42",
      "pembayarankategori_id":"41",
      "status":"1"
   },
   {
      "id":393,
      "code":"TVSKYMAN6",
      "product_name":"SKYNINDO TV MANDARIN 6 BLN (840.000)",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"42",
      "pembayarankategori_id":"41",
      "status":"1"
   },
   {
      "id":394,
      "code":"TVKV100",
      "product_name":"K VISION (100.000)",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"42",
      "pembayarankategori_id":"41",
      "status":"1"
   },
   {
      "id":395,
      "code":"TVKV1000",
      "product_name":"K VISION (1.000.000)",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"42",
      "pembayarankategori_id":"41",
      "status":"1"
   },
   {
      "id":396,
      "code":"TVKV125",
      "product_name":"K VISION (125.000)",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"42",
      "pembayarankategori_id":"41",
      "status":"1"
   },
   {
      "id":397,
      "code":"TVKV150",
      "product_name":"K VISION (150.000)",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"42",
      "pembayarankategori_id":"41",
      "status":"1"
   },
   {
      "id":398,
      "code":"TVKV175",
      "product_name":"K VISION (175.000)",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"42",
      "pembayarankategori_id":"41",
      "status":"1"
   },
   {
      "id":399,
      "code":"TVKV200",
      "product_name":"K VISION (200.000)",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"42",
      "pembayarankategori_id":"41",
      "status":"1"
   },
   {
      "id":400,
      "code":"TVKV250",
      "product_name":"K VISION (250.000)",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"42",
      "pembayarankategori_id":"41",
      "status":"1"
   },
   {
      "id":401,
      "code":"TVKV300",
      "product_name":"K VISION (300.000)",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"42",
      "pembayarankategori_id":"41",
      "status":"1"
   },
   {
      "id":402,
      "code":"TVKV50",
      "product_name":"K VISION (50.000)",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"42",
      "pembayarankategori_id":"41",
      "status":"1"
   },
   {
      "id":403,
      "code":"TVKV500",
      "product_name":"K VISION (500.000)",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"42",
      "pembayarankategori_id":"41",
      "status":"1"
   },
   {
      "id":404,
      "code":"TVKV75",
      "product_name":"K VISION (75.000)",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"42",
      "pembayarankategori_id":"41",
      "status":"1"
   },
   {
      "id":405,
      "code":"TVKV750",
      "product_name":"K VISION (750.000)",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"42",
      "pembayarankategori_id":"41",
      "status":"1"
   },
   {
      "id":406,
      "code":"WAAETRA",
      "product_name":"AETRA JAKARTA",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"43",
      "pembayarankategori_id":"42",
      "status":"1"
   },
   {
      "id":407,
      "code":"WAPLYJ",
      "product_name":"PALYJA JAKARTA",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"43",
      "pembayarankategori_id":"42",
      "status":"1"
   },
   {
      "id":408,
      "code":"WABOGOR",
      "product_name":"PDAM KAB. BOGOR",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"43",
      "pembayarankategori_id":"42",
      "status":"1"
   },
   {
      "id":409,
      "code":"WABDG",
      "product_name":"PDAM KOTA BANDUNG",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"43",
      "pembayarankategori_id":"42",
      "status":"1"
   },
   {
      "id":410,
      "code":"WAKOSOLO",
      "product_name":"PDAM KOTA SURAKARTA",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"43",
      "pembayarankategori_id":"42",
      "status":"1"
   },
   {
      "id":411,
      "code":"WABGK",
      "product_name":"PDAM KAB. BANGKALAN",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"43",
      "pembayarankategori_id":"42",
      "status":"1"
   },
   {
      "id":412,
      "code":"WABONDO",
      "product_name":"PDAM KAB. BONDOWOSO",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"43",
      "pembayarankategori_id":"42",
      "status":"1"
   },
   {
      "id":413,
      "code":"WABAL",
      "product_name":"PDAM KAB. BALANGAN",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"43",
      "pembayarankategori_id":"42",
      "status":"1"
   },
   {
      "id":414,
      "code":"WAGROGOT",
      "product_name":"PDAM KOTA TANAH GROGOT",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"43",
      "pembayarankategori_id":"42",
      "status":"1"
   },
   {
      "id":415,
      "code":"WALMPNG",
      "product_name":"PDAM KOTA BANDAR LAMPUNG",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"43",
      "pembayarankategori_id":"42",
      "status":"1"
   },
   {
      "id":416,
      "code":"WAJAMBI",
      "product_name":"PDAM KOTA JAMBI",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"43",
      "pembayarankategori_id":"42",
      "status":"1"
   },
   {
      "id":417,
      "code":"WAGROBGAN",
      "product_name":"PDAM KAB. GROBOGAN",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"43",
      "pembayarankategori_id":"42",
      "status":"1"
   },
   {
      "id":418,
      "code":"WAPURWORE",
      "product_name":"PDAM KAB. PURWOREJO",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"43",
      "pembayarankategori_id":"42",
      "status":"1"
   },
   {
      "id":419,
      "code":"WABATANG",
      "product_name":"PDAM KAB. BATANG",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"43",
      "pembayarankategori_id":"42",
      "status":"1"
   },
   {
      "id":420,
      "code":"WABJN",
      "product_name":"PDAM KAB. BOJONEGORO",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"43",
      "pembayarankategori_id":"42",
      "status":"1"
   },
   {
      "id":421,
      "code":"WAJMBR",
      "product_name":"PDAM KAB. JEMBER",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"43",
      "pembayarankategori_id":"42",
      "status":"1"
   },
   {
      "id":422,
      "code":"WAKABMLG",
      "product_name":"PDAM KAB. MALANG",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"43",
      "pembayarankategori_id":"42",
      "status":"1"
   },
   {
      "id":423,
      "code":"WAMJK",
      "product_name":"PDAM KAB. MOJOKERTO",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"43",
      "pembayarankategori_id":"42",
      "status":"1"
   },
   {
      "id":424,
      "code":"WAPASU",
      "product_name":"PDAM KAB. PASURUAN",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"43",
      "pembayarankategori_id":"42",
      "status":"1"
   },
   {
      "id":425,
      "code":"WASDA",
      "product_name":"PDAM KAB. SIDOARJO",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"43",
      "pembayarankategori_id":"42",
      "status":"1"
   },
   {
      "id":426,
      "code":"WASITU",
      "product_name":"PDAM KAB. SITUBONDO",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"43",
      "pembayarankategori_id":"42",
      "status":"1"
   },
   {
      "id":427,
      "code":"WAKOPASU",
      "product_name":"PDAM KOTA PASURUAN",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"43",
      "pembayarankategori_id":"42",
      "status":"1"
   },
   {
      "id":428,
      "code":"WASAMPANG",
      "product_name":"PDAM KAB. SAMPANG",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"43",
      "pembayarankategori_id":"42",
      "status":"1"
   },
   {
      "id":429,
      "code":"WAKUBURAYA",
      "product_name":"PDAM KAB. KUBU RAYA",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"43",
      "pembayarankategori_id":"42",
      "status":"1"
   },
   {
      "id":430,
      "code":"WAPONTI",
      "product_name":"PDAM KOTA PONTIANAK",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"43",
      "pembayarankategori_id":"42",
      "status":"1"
   },
   {
      "id":431,
      "code":"WATAPIN",
      "product_name":"PDAM KAB. TAPIN",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"43",
      "pembayarankategori_id":"42",
      "status":"1"
   },
   {
      "id":432,
      "code":"WAIBANJAR",
      "product_name":"PDAM KOTA BANJARBARU",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"43",
      "pembayarankategori_id":"42",
      "status":"1"
   },
   {
      "id":433,
      "code":"WAGIRIMM",
      "product_name":"PDAM KOTA MATARAM",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"43",
      "pembayarankategori_id":"42",
      "status":"1"
   },
   {
      "id":434,
      "code":"WAMANADO",
      "product_name":"PDAM KOTA MANADO",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"43",
      "pembayarankategori_id":"42",
      "status":"1"
   },
   {
      "id":435,
      "code":"WAPLMBNG",
      "product_name":"PDAM KOTA PALEMBANG",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"43",
      "pembayarankategori_id":"42",
      "status":"1"
   },
   {
      "id":436,
      "code":"SPEEDY",
      "product_name":"Speedy",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"44",
      "pembayarankategori_id":"43",
      "status":"1"
   },
   {
      "id":437,
      "code":"TELEPON",
      "product_name":"Telkom",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"44",
      "pembayarankategori_id":"43",
      "status":"1"
   },
   {
      "id":438,
      "code":"HPTSEL",
      "product_name":"Telkomsel (Halo)",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"45",
      "pembayarankategori_id":"44",
      "status":"1"
   },
   {
      "id":439,
      "code":"HPXL",
      "product_name":"XL (Xplore)",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"45",
      "pembayarankategori_id":"44",
      "status":"1"
   },
   {
      "id":440,
      "code":"HPMTRIX",
      "product_name":"Indosat (Matrix)",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"45",
      "pembayarankategori_id":"44",
      "status":"1"
   },
   {
      "id":441,
      "code":"HPESIA",
      "product_name":"Esia (Postpaid)",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"45",
      "pembayarankategori_id":"44",
      "status":"1"
   },
   {
      "id":442,
      "code":"HPFREN",
      "product_name":"FREN, MOBI, HEPI (POSTPAID)",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"45",
      "pembayarankategori_id":"44",
      "status":"1"
   },
   {
      "id":443,
      "code":"HPSMART",
      "product_name":"SMARTFREN (Postpaid)",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"45",
      "pembayarankategori_id":"44",
      "status":"1"
   },
   {
      "id":444,
      "code":"HPTHREE",
      "product_name":"THREE (Postpaid)",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"45",
      "pembayarankategori_id":"44",
      "status":"1"
   },
   {
      "id":445,
      "code":"RZZ",
      "product_name":"Zakat",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"46",
      "pembayarankategori_id":"45",
      "status":"1"
   },
   {
      "id":446,
      "code":"RZDUK",
      "product_name":"DONASI UANG KEMBALIAN",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"46",
      "pembayarankategori_id":"45",
      "status":"1"
   },
   {
      "id":447,
      "code":"RZIS",
      "product_name":"INFAQ-SHADAQOH",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"46",
      "pembayarankategori_id":"45",
      "status":"1"
   },
   {
      "id":448,
      "code":"RZQK",
      "product_name":"QURBAN KAMBING",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"46",
      "pembayarankategori_id":"45",
      "status":"1"
   },
   {
      "id":449,
      "code":"RZQS17",
      "product_name":"QURBAN SAPI 1\/7 (RETAIL)",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"46",
      "pembayarankategori_id":"45",
      "status":"1"
   },
   {
      "id":450,
      "code":"RZQS",
      "product_name":"QURBAN SAPI",
      "biaya_admin":"3000",
      "pembayaranoperator_id":"46",
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
	$code = $row["code"];
	$product_name = $row["product_name"];
	$price = $row["biaya_admin"];
	$pembelianoperator_id = $row["pembayaranoperator_id"];
	$pembeliankategori_id = $row["pembayarankategori_id"];
	$status = $row["status"];
	

	$arrresorder[]=array("id"=>$id,"price"=>$price,"code"=>$code,"pembelianoperator_id"=>$pembelianoperator_id,"product_name"=>$product_name,"pembeliankategori_id"=>$pembeliankategori_id,"status"=>$status);
	
  }
print_r($arrresorder);


if (!$dbh) {
			$arr=array("kode"=>$kode,"nama"=>$nama);
		}else{
			$resultord = pdoMultiInsert('x_ppob_product_invoice', $arrresorder, $dbh);
			print_r($resultord);
		}

?>