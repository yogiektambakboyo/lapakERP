<?php 
class connect{    
    public function __construct() {     
     
    }
    public function connectDB() {
        try {
		   $dbh = new PDO("pgsql:dbname=didi;host=10.17.206.43", 'postgres', 'postgres'); 
		}
		catch(PDOException $e)
		{
			echo $e->getMessage();
		}
        return $dbh;
    }
 }
?>