<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;

class JobTitleTableSeeder extends Seeder
{

    /**
     * Auto generated seed file
     *
     * @return void
     */
    public function run()
    {
        

        \DB::table('job_title')->delete();
        
        \DB::table('job_title')->insert(array (
            0 => 
            array (
                'id' => 1,
                'remark' => 'Kasir',
                'created_at' => '2022-06-01 19:52:32.509771',
                'active' => 1,
            ),
            1 => 
            array (
                'id' => 2,
                'remark' => 'Terapist',
                'created_at' => '2022-06-01 19:52:32.509771',
                'active' => 1,
            ),
            2 => 
            array (
                'id' => 3,
                'remark' => 'Owner',
                'created_at' => '2022-06-01 19:52:32.509771',
                'active' => 1,
            ),
            3 => 
            array (
                'id' => 6,
                'remark' => 'Administrator',
                'created_at' => '2022-06-01 19:52:32.509771',
                'active' => 1,
            ),
            4 => 
            array (
                'id' => 4,
                'remark' => 'Staff Finance & Accounting',
                'created_at' => '2022-06-01 19:52:32.509771',
                'active' => 1,
            ),
            5 => 
            array (
                'id' => 5,
                'remark' => 'Staff Human Resource',
                'created_at' => '2022-06-01 19:52:32.509771',
                'active' => 1,
            ),
            6 => 
            array (
                'id' => 7,
                'remark' => 'Trainer',
                'created_at' => '2022-06-01 19:52:32.509771',
                'active' => 1,
            ),
        ));
        
        
    }
}