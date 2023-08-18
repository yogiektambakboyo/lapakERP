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
      "id": 1,
      "product_id": "AX",
      "product_name": "AXIS",
      "prefix": "0831,0832,0838",
      "pembeliankategori_id": "1",
      "status": "1"
    },
    {
      "id": 2,
      "product_id": "AIGO",
      "product_name": "AXIS AIGO (AKTIVASI *838*KODE#)",
      "prefix": "0831,0832,0838",
      "pembeliankategori_id": "2",
      "status": "1"
    },
    {
      "id": 3,
      "product_id": "AIM",
      "product_name": "AXIS AIGO MINI (AKTIVASI *838*KODE#)",
      "prefix": "0831,0832,0838",
      "pembeliankategori_id": "2",
      "status": "1"
    },
    {
      "id": 4,
      "product_id": "AXD",
      "product_name": "AXIS DATA BRONET",
      "prefix": "0831,0832,0838",
      "pembeliankategori_id": "2",
      "status": "1"
    },
    {
      "id": 5,
      "product_id": "BO",
      "product_name": "BOLT",
      "prefix": "998,999",
      "pembeliankategori_id": "1",
      "status": "1"
    },
    {
      "id": 6,
      "product_id": "BO",
      "product_name": "BOLT KUOTA",
      "prefix": "998,999",
      "pembeliankategori_id": "2",
      "status": "1"
    },
    {
      "id": 7,
      "product_id": "C",
      "product_name": "CERIA",
      "prefix": "0828",
      "pembeliankategori_id": "1",
      "status": "1"
    },
    {
      "id": 8,
      "product_id": "GJ",
      "product_name": "GOJEK",
      "prefix": null,
      "pembeliankategori_id": "3",
      "status": "1"
    },
    {
      "id": 9,
      "product_id": "GJD",
      "product_name": "GOJEK DRIVER",
      "prefix": null,
      "pembeliankategori_id": "3",
      "status": "1"
    },
    {
      "id": 10,
      "product_id": "GLP",
      "product_name": "GOOGLE PLAY",
      "prefix": null,
      "pembeliankategori_id": "4",
      "status": "1"
    },
    {
      "id": 11,
      "product_id": "GP",
      "product_name": "GOOGLE PLAY ID",
      "prefix": null,
      "pembeliankategori_id": "4",
      "status": "1"
    },
    {
      "id": 12,
      "product_id": "GB",
      "product_name": "GRAB",
      "prefix": null,
      "pembeliankategori_id": "3",
      "status": "1"
    },
    {
      "id": 13,
      "product_id": "I",
      "product_name": "INDOSAT",
      "prefix": "0856,0857,0858,0815,0816,0855,0814",
      "pembeliankategori_id": "1",
      "status": "1"
    },
    {
      "id": 14,
      "product_id": "IDB",
      "product_name": "INDOSAT BOMBER",
      "prefix": "0856,0857,0858,0815,0816,0855,0814",
      "pembeliankategori_id": "2",
      "status": "1"
    },
    {
      "id": 15,
      "product_id": "IDX",
      "product_name": "INDOSAT DATA EXTRA",
      "prefix": "0856,0857,0858,0815,0816,0855,0814",
      "pembeliankategori_id": "2",
      "status": "1"
    },
    {
      "id": 16,
      "product_id": "IFC",
      "product_name": "INDOSAT DATA FREEDOM",
      "prefix": "0856,0857,0858,0815,0816,0855,0814",
      "pembeliankategori_id": "2",
      "status": "1"
    },
    {
      "id": 17,
      "product_id": "IDM",
      "product_name": "INDOSAT DATA MINI",
      "prefix": "0856,0857,0858,0815,0816,0855,0814",
      "pembeliankategori_id": "2",
      "status": "1"
    },
    {
      "id": 18,
      "product_id": "IDN",
      "product_name": "INDOSAT DATA REGULER",
      "prefix": "0856,0857,0858,0815,0816,0855,0814",
      "pembeliankategori_id": "2",
      "status": "1"
    },
    {
      "id": 19,
      "product_id": "IS",
      "product_name": "INDOSAT SMS",
      "prefix": "0856,0857,0858,0815,0816,0855,0814",
      "pembeliankategori_id": "5",
      "status": "1"
    },
    {
      "id": 20,
      "product_id": "IT",
      "product_name": "INDOSAT TELEPON",
      "prefix": "0856,0857,0858,0815,0816,0855,0814",
      "pembeliankategori_id": "5",
      "status": "1"
    },
    {
      "id": 21,
      "product_id": "ITR",
      "product_name": "INDOSAT TRANSFER PULSA",
      "prefix": "0856,0857,0858,0815,0816,0855,0814",
      "pembeliankategori_id": "6",
      "status": "1"
    },
    {
      "id": 22,
      "product_id": "IDH",
      "product_name": "INDOSAT YELLOW",
      "prefix": "0856,0857,0858,0815,0816,0855,0814",
      "pembeliankategori_id": "2",
      "status": "1"
    },
    {
      "id": 23,
      "product_id": "ITN",
      "product_name": "iTunes Gift Card",
      "prefix": null,
      "pembeliankategori_id": "7",
      "status": "1"
    },
    {
      "id": 24,
      "product_id": "OV",
      "product_name": "ORANGE TV",
      "prefix": null,
      "pembeliankategori_id": "8",
      "status": "1"
    },
    {
      "id": 25,
      "product_id": "VO",
      "product_name": "OVO",
      "prefix": null,
      "pembeliankategori_id": "9",
      "status": "1"
    },
    {
      "id": 26,
      "product_id": "SM",
      "product_name": "SMARTFREN",
      "prefix": "0881,0882,0883,0884,0885,0886,0887,0888,0889",
      "pembeliankategori_id": "1",
      "status": "1"
    },
    {
      "id": 27,
      "product_id": "SMV",
      "product_name": "SMARTFREN DATA VOLUME",
      "prefix": "0881,0882,0883,0884,0885,0886,0887,0888,0889",
      "pembeliankategori_id": "2",
      "status": "1"
    },
    {
      "id": 28,
      "product_id": "SMD",
      "product_name": "SMARTFREN INTERNET",
      "prefix": "0881,0882,0883,0884,0885,0886,0887,0888,0889",
      "pembeliankategori_id": "2",
      "status": "1"
    },
    {
      "id": 29,
      "product_id": "S",
      "product_name": "TELKOMSEL",
      "prefix": "0811,0812,0813,0821,0822,0823,0852,0853,0851",
      "pembeliankategori_id": "1",
      "status": "1"
    },
    {
      "id": 30,
      "product_id": "STG",
      "product_name": "TELKOMSEL DATA",
      "prefix": "0811,0812,0813,0821,0822,0823,0852,0853,0851",
      "pembeliankategori_id": "2",
      "status": "1"
    },
    {
      "id": 31,
      "product_id": "SDA",
      "product_name": "TELKOMSEL DATA AS",
      "prefix": "0811,0812,0813,0821,0822,0823,0852,0853,0851",
      "pembeliankategori_id": "2",
      "status": "1"
    },
    {
      "id": 32,
      "product_id": "SDB",
      "product_name": "TELKOMSEL DATA BULK",
      "prefix": "0811,0812,0813,0821,0822,0823,0852,0853,0851",
      "pembeliankategori_id": "2",
      "status": "1"
    },
    {
      "id": 33,
      "product_id": "SS",
      "product_name": "TELKOMSEL SMS",
      "prefix": "0811,0812,0813,0821,0822,0823,0852,0853,0851",
      "pembeliankategori_id": "5",
      "status": "1"
    },
    {
      "id": 34,
      "product_id": "ST",
      "product_name": "TELKOMSEL TELEPON",
      "prefix": "0811,0812,0813,0821,0822,0823,0852,0853,0851",
      "pembeliankategori_id": "5",
      "status": "1"
    },
    {
      "id": 35,
      "product_id": "STR",
      "product_name": "TELKOMSEL TRANSFER PULSA",
      "prefix": "0811,0812,0813,0821,0822,0823,0852,0853,0851",
      "pembeliankategori_id": "6",
      "status": "1"
    },
    {
      "id": 36,
      "product_id": "T",
      "product_name": "TRI",
      "prefix": "0896,0897,0898,0899,0895",
      "pembeliankategori_id": "1",
      "status": "1"
    },
    {
      "id": 37,
      "product_id": "TD",
      "product_name": "TRI DATA",
      "prefix": "0896,0897,0898,0899,0895",
      "pembeliankategori_id": "2",
      "status": "1"
    },
    {
      "id": 38,
      "product_id": "TBM",
      "product_name": "TRI DATA BM",
      "prefix": "0896,0897,0898,0899,0895",
      "pembeliankategori_id": "2",
      "status": "1"
    },
    {
      "id": 39,
      "product_id": "TDC",
      "product_name": "TRI DATA CINTA",
      "prefix": "0896,0897,0898,0899,0895",
      "pembeliankategori_id": "2",
      "status": "1"
    },
    {
      "id": 40,
      "product_id": "TGM",
      "product_name": "TRI DATA GETMORE",
      "prefix": "0896,0897,0898,0899,0895",
      "pembeliankategori_id": "2",
      "status": "1"
    },
    {
      "id": 41,
      "product_id": "TDR",
      "product_name": "TRI DATA REGULER",
      "prefix": "0896,0897,0898,0899,0895",
      "pembeliankategori_id": "2",
      "status": "1"
    },
    {
      "id": 42,
      "product_id": "TT",
      "product_name": "TRI TELEPON",
      "prefix": "0896,0897,0898,0899,0895",
      "pembeliankategori_id": "5",
      "status": "1"
    },
    {
      "id": 43,
      "product_id": "TTR",
      "product_name": "TRI TRANSFER PULSA",
      "prefix": "0896,0897,0898,0899,0895",
      "pembeliankategori_id": "6",
      "status": "1"
    },
    {
      "id": 44,
      "product_id": "X",
      "product_name": "XL",
      "prefix": "0817,0818,0819,0859,0877,0878",
      "pembeliankategori_id": "1",
      "status": "1"
    },
    {
      "id": 45,
      "product_id": "XCX",
      "product_name": "XL INTERNET COMBO XTRA",
      "prefix": "0817,0818,0819,0859,0877,0878",
      "pembeliankategori_id": "2",
      "status": "1"
    },
    {
      "id": 46,
      "product_id": "XH",
      "product_name": "XL INTERNET HOTROD",
      "prefix": "0817,0818,0819,0859,0877,0878",
      "pembeliankategori_id": "2",
      "status": "1"
    },
    {
      "id": 47,
      "product_id": "XHE",
      "product_name": "XL INTERNET HOTROD EXTRA",
      "prefix": "0817,0818,0819,0859,0877,0878",
      "pembeliankategori_id": "2",
      "status": "1"
    },
    {
      "id": 48,
      "product_id": "XT",
      "product_name": "XL TELEPON",
      "prefix": "0817,0818,0819,0859,0877,0878",
      "pembeliankategori_id": "5",
      "status": "1"
    },
    {
      "id": 49,
      "product_id": "XTL",
      "product_name": "XL TELEPON LUAR NEGERI",
      "prefix": "0817,0818,0819,0859,0877,0878",
      "pembeliankategori_id": "5",
      "status": "1"
    },
    {
      "id": 50,
      "product_id": "PLN",
      "product_name": "PLN",
      "prefix": null,
      "pembeliankategori_id": "10",
      "status": "1"
    },
    {
      "id": 51,
      "product_id": "BOX",
      "product_name": "Xbox Live Gift Card",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 52,
      "product_id": "BP",
      "product_name": "Game facebook - Boyaa Poker",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 53,
      "product_id": "BSF",
      "product_name": "BSF",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 54,
      "product_id": "CBL",
      "product_name": "Cabal Online",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 55,
      "product_id": "CRY",
      "product_name": "e-PINS",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 56,
      "product_id": "DGC",
      "product_name": "Digicash",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 57,
      "product_id": "FAV",
      "product_name": "Faveo",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 58,
      "product_id": "FBG",
      "product_name": "FBCARD",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 59,
      "product_id": "FSB",
      "product_name": "Fastblack",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 60,
      "product_id": "GA",
      "product_name": "ASIASOFT",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 61,
      "product_id": "GD",
      "product_name": "DASA GAME",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 62,
      "product_id": "GES",
      "product_name": "GOLONLINE",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 63,
      "product_id": "GGM",
      "product_name": "GOGAME",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 64,
      "product_id": "GIH",
      "product_name": "IAH Games",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 65,
      "product_id": "GIN",
      "product_name": "INGAME",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 66,
      "product_id": "GMM",
      "product_name": "MatchMove",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 67,
      "product_id": "GMS",
      "product_name": "Gemscool",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 68,
      "product_id": "GOG",
      "product_name": "OrangeGame",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 69,
      "product_id": "GPY",
      "product_name": "Playon",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 70,
      "product_id": "GQ",
      "product_name": "Qash",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 71,
      "product_id": "GST",
      "product_name": "ROSE ONLINE",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 72,
      "product_id": "GTA",
      "product_name": "TERACORD",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 73,
      "product_id": "GW",
      "product_name": "Gamewave",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 74,
      "product_id": "GWV",
      "product_name": "Gameweb",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 75,
      "product_id": "ID",
      "product_name": "Playstation Store Prepaid Card",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 76,
      "product_id": "JM",
      "product_name": "Game facebook - Joombi",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 77,
      "product_id": "KRM",
      "product_name": "Koram",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 78,
      "product_id": "KW",
      "product_name": "kiwi card",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 79,
      "product_id": "LYT",
      "product_name": "LYTO",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 80,
      "product_id": "MAIN",
      "product_name": "Mainkan.com",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 81,
      "product_id": "MB",
      "product_name": "Mobius",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 82,
      "product_id": "MGC",
      "product_name": "MOGCAZ",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 83,
      "product_id": "MGX",
      "product_name": "Megaxus",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 84,
      "product_id": "MOG",
      "product_name": "MOGPLAY",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 85,
      "product_id": "MOL",
      "product_name": "MOLPoints",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 86,
      "product_id": "MTN",
      "product_name": "Metin 2",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 87,
      "product_id": "MYC",
      "product_name": "MyCard",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 88,
      "product_id": "PLC",
      "product_name": "Playcircle",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 89,
      "product_id": "PLF",
      "product_name": "Playfish",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 90,
      "product_id": "PLP",
      "product_name": "Playpoint",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 91,
      "product_id": "PLT",
      "product_name": "Game facebook - Pool Live Tour",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 92,
      "product_id": "PLT",
      "product_name": "Game facebook - Pico World",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 93,
      "product_id": "PLT",
      "product_name": "Game facebook - Joombi",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 94,
      "product_id": "PLT",
      "product_name": "Game facebook - Boyaa Poker",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 95,
      "product_id": "PUB",
      "product_name": "PUBG",
      "prefix": null,
      "pembeliankategori_id": "12",
      "status": "1"
    },
    {
      "id": 96,
      "product_id": "PW",
      "product_name": "Game facebook - Pico World",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 97,
      "product_id": "PYN",
      "product_name": "Playnexia",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 98,
      "product_id": "SOF",
      "product_name": "Softnyx",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 99,
      "product_id": "SPN",
      "product_name": "Spin",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 100,
      "product_id": "SRT",
      "product_name": "Serenity",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 101,
      "product_id": "STE",
      "product_name": "STEAM",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 102,
      "product_id": "TRV",
      "product_name": "Travian",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 103,
      "product_id": "UGC",
      "product_name": "PLAYSPAN",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 104,
      "product_id": "UNI",
      "product_name": "UNIPIN",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 105,
      "product_id": "VTC",
      "product_name": "VTC Online",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 106,
      "product_id": "VW",
      "product_name": "Viwawa",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 107,
      "product_id": "WIN",
      "product_name": "Winner Card",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 108,
      "product_id": "WVP",
      "product_name": "Wavegame",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
    },
    {
      "id": 109,
      "product_id": "ZNG",
      "product_name": "ZYNGA",
      "prefix": null,
      "pembeliankategori_id": "11",
      "status": "1"
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
	$pembeliankategori_id = $row["pembeliankategori_id"];
	$status = $row["status"];

	$arrresorder[]=array("id"=>$id,"product_id"=>$product_id,"product_name"=>$product_name,"prefix"=>$prefix,"pembeliankategori_id"=>$pembeliankategori_id,"status"=>$status);
	
  }
print_r($arrresorder);


if (!$dbh) {
			$arr=array("kode"=>$kode,"nama"=>$nama);
		}else{
			$resultord = pdoMultiInsert('x_ppob_operator', $arrresorder, $dbh);
		}





?>