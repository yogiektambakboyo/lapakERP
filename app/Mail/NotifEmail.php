<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;

class NotifEmail extends Mailable
{
    use Queueable, SerializesModels;
 
 
    /**
     * Create a new message instance.
     *
     * @return void
     */
    public $content;
    public $name;


    public function __construct($name, $content)
    {
        $this->name = $name;
        $this->content = $content;  
    }
 
    /**
     * Build the message.
     *
     * @return $this
     */
    public function build()
    {
       return $this->from('lapakkreatiflamongan@gmail.com')
                   ->view('email_register')
                   ->subject("Verifikasi Akun Lapak Kreatif Lamongan")
                   ->with(
                    [
                        'nama' => $this->name,
                        'website' => $this->content,
                    ]);
    }
}