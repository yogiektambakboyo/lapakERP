<?php
 
namespace App\Http\Controllers;
 
use Illuminate\Http\Request;
use App\Mail\NotifEmail;
use Illuminate\Support\Facades\Mail;
 
class NotifEmailController extends Controller
{
	public function send_mail(){
        $name = "Julian";
        $content = "https://lapakkraetif.com/hello";

		Mail::to("yogiektambakboyo@gmail.com")->send(new NotifEmail($name,$content));
		return "Email telah dikirim";
	}
 
}