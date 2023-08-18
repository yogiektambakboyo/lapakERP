<?php 
class SendNotification {    
    private static $API_SERVER_KEY = 'AAAAwg1wzJI:APA91bGZEyKf_H4uh7L9-b3BkPu9lnh-6R6cP4YmlIEeQnDbtR36VBTklS70_lZ5upLcjFuEyQ2OfEp3xe7NOeomjjT1tq3RTOK9HJsuPMyyAD6IsKzkA7px6WEMe8d7Kvpt3kM0nSKI';
    private static $is_background = "TRUE";
    public function __construct() {     
     
    }
    public function sendPushNotificationToFCMSever($token, $message, $notifyID) {
        $path_to_firebase_cm = 'https://fcm.googleapis.com/fcm/send';
 
        $fields = array(
            'registration_id' => $token,
            'priority' => 10,
            'notification' => array('title' => 'DIDI', 'body' =>  $message ,'sound'=>'Default','image'=>'Notification Image' ),
			'to'=> $token
        );
        $headers = array(
            'Authorization:key=' . self::$API_SERVER_KEY,
            'Content-Type:application/json'
        );  
         
        // Open connection  
        $ch = curl_init(); 
        // Set the url, number of POST vars, POST data
        curl_setopt($ch, CURLOPT_URL, $path_to_firebase_cm); 
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_IPRESOLVE, CURL_IPRESOLVE_V4 );
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($fields));
        // Execute post   
        $result = curl_exec($ch); 
		 if ($result === FALSE) {
			die('Oops! FCM Send Error: ' . curl_error($ch));
		   }
        // Close connection      
        curl_close($ch);
        return $result;
    }
 }
?>