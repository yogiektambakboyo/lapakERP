<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;

class CompanyTableSeeder extends Seeder
{

    /**
     * Auto generated seed file
     *
     * @return void
     */
    public function run()
    {
        

        \DB::table('company')->delete();
        
        \DB::table('company')->insert(array (
            0 => 
            array (
                'id' => 1,
                'remark' => 'Kakiku',
                'address' => 'Gading Serpong I',
                'city' => 'Tangerang',
                'email' => 'admin@kakiku.com',
                'phone_no' => '031-3322224',
                'icon_file' => '6d4c83f6b695389b860d79e975e13751.png',
                'updated_at' => '2022-09-03 00:59:33',
                'created_at' => '2022-08-30 22:06:56.025994',
            ),
        ));
        
        
    }
}