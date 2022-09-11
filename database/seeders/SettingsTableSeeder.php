<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;

class SettingsTableSeeder extends Seeder
{

    /**
     * Auto generated seed file
     *
     * @return void
     */
    public function run()
    {
        

        \DB::table('settings')->delete();
        
        \DB::table('settings')->insert(array (
            0 => 
            array (
                'transaction_date' => '2022-07-16',
                'period_no' => 202207,
                'company_name' => 'Kakiku',
                'app_name' => 'Lapak ERP',
                'version' => 'v0.0.1',
                'icon_file' => 'Logo_512.png',
            ),
        ));
        
        
    }
}