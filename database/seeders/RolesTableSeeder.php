<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;

class RolesTableSeeder extends Seeder
{

    /**
     * Auto generated seed file
     *
     * @return void
     */
    public function run()
    {
        

        \DB::table('roles')->delete();
        
        \DB::table('roles')->insert(array (
            0 => 
            array (
                'id' => 1,
                'name' => 'admin',
                'guard_name' => 'web',
                'created_at' => '2022-05-28 12:40:11',
                'updated_at' => '2022-05-28 12:40:11',
            ),
            1 => 
            array (
                'id' => 2,
                'name' => 'owner',
                'guard_name' => 'web',
                'created_at' => '2022-05-28 12:40:11',
                'updated_at' => '2022-05-28 12:40:11',
            ),
            2 => 
            array (
                'id' => 3,
                'name' => 'cashier',
                'guard_name' => 'web',
                'created_at' => '2022-05-28 12:40:11',
                'updated_at' => '2022-05-28 12:40:11',
            ),
            3 => 
            array (
                'id' => 5,
                'name' => 'terapist',
                'guard_name' => 'web',
                'created_at' => '2022-05-28 12:40:11',
                'updated_at' => '2022-05-28 12:40:11',
            ),
            4 => 
            array (
                'id' => 4,
                'name' => 'admin_finance',
                'guard_name' => 'web',
                'created_at' => '2022-05-28 12:40:11',
                'updated_at' => '2022-05-28 12:40:11',
            ),
            5 => 
            array (
                'id' => 6,
                'name' => 'hr',
                'guard_name' => 'web',
                'created_at' => '2022-05-28 12:40:11',
                'updated_at' => '2022-05-28 12:40:11',
            ),
            6 => 
            array (
                'id' => 11,
                'name' => 'trainer',
                'guard_name' => 'web',
                'created_at' => '2022-08-06 23:01:46',
                'updated_at' => '2022-08-06 23:01:46',
            ),
        ));
        
        
    }
}