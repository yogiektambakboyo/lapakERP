<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;

class PeriodTableSeeder extends Seeder
{

    /**
     * Auto generated seed file
     *
     * @return void
     */
    public function run()
    {
        

        \DB::table('period')->delete();
        
        \DB::table('period')->insert(array (
            0 => 
            array (
                'period_no' => 202201,
                'remark' => 'January -2022',
                'start_date' => '2022-01-01',
                'end_date' => '2022-01-31',
            ),
            1 => 
            array (
                'period_no' => 202202,
                'remark' => 'February-2022',
                'start_date' => '2022-02-01',
                'end_date' => '2022-02-28',
            ),
            2 => 
            array (
                'period_no' => 202203,
                'remark' => 'March -2022',
                'start_date' => '2022-03-01',
                'end_date' => '2022-03-31',
            ),
            3 => 
            array (
                'period_no' => 202204,
                'remark' => 'April -2022',
                'start_date' => '2022-04-01',
                'end_date' => '2022-04-30',
            ),
            4 => 
            array (
                'period_no' => 202205,
                'remark' => 'May -2022',
                'start_date' => '2022-05-01',
                'end_date' => '2022-05-31',
            ),
            5 => 
            array (
                'period_no' => 202206,
                'remark' => 'June-2022',
                'start_date' => '2022-06-01',
                'end_date' => '2022-06-30',
            ),
            6 => 
            array (
                'period_no' => 202207,
                'remark' => 'July-2022',
                'start_date' => '2022-07-01',
                'end_date' => '2022-07-31',
            ),
            7 => 
            array (
                'period_no' => 202208,
                'remark' => 'August-2022',
                'start_date' => '2022-08-01',
                'end_date' => '2022-08-31',
            ),
            8 => 
            array (
                'period_no' => 202209,
                'remark' => 'September -2022',
                'start_date' => '2022-09-01',
                'end_date' => '2022-09-30',
            ),
            9 => 
            array (
                'period_no' => 202210,
                'remark' => 'October -2022',
                'start_date' => '2022-10-01',
                'end_date' => '2022-10-31',
            ),
            10 => 
            array (
                'period_no' => 202211,
                'remark' => 'November-2022',
                'start_date' => '2022-11-01',
                'end_date' => '2022-11-30',
            ),
            11 => 
            array (
                'period_no' => 202212,
                'remark' => 'December-2022',
                'start_date' => '2022-12-01',
                'end_date' => '2022-12-31',
            ),
            12 => 
            array (
                'period_no' => 202301,
                'remark' => 'January -2023',
                'start_date' => '2023-01-01',
                'end_date' => '2023-01-31',
            ),
            13 => 
            array (
                'period_no' => 202302,
                'remark' => 'February-2023',
                'start_date' => '2023-02-01',
                'end_date' => '2023-02-28',
            ),
            14 => 
            array (
                'period_no' => 202303,
                'remark' => 'March -2023',
                'start_date' => '2023-03-01',
                'end_date' => '2023-03-31',
            ),
            15 => 
            array (
                'period_no' => 202304,
                'remark' => 'April -2023',
                'start_date' => '2023-04-01',
                'end_date' => '2023-04-30',
            ),
            16 => 
            array (
                'period_no' => 202305,
                'remark' => 'May -2023',
                'start_date' => '2023-05-01',
                'end_date' => '2023-05-31',
            ),
            17 => 
            array (
                'period_no' => 202306,
                'remark' => 'June-2023',
                'start_date' => '2023-06-01',
                'end_date' => '2023-06-30',
            ),
            18 => 
            array (
                'period_no' => 202307,
                'remark' => 'July-2023',
                'start_date' => '2023-07-01',
                'end_date' => '2023-07-31',
            ),
            19 => 
            array (
                'period_no' => 202308,
                'remark' => 'August-2023',
                'start_date' => '2023-08-01',
                'end_date' => '2023-08-31',
            ),
            20 => 
            array (
                'period_no' => 202309,
                'remark' => 'September -2023',
                'start_date' => '2023-09-01',
                'end_date' => '2023-09-30',
            ),
            21 => 
            array (
                'period_no' => 202310,
                'remark' => 'October -2023',
                'start_date' => '2023-10-01',
                'end_date' => '2023-10-31',
            ),
            22 => 
            array (
                'period_no' => 202311,
                'remark' => 'November-2023',
                'start_date' => '2023-11-01',
                'end_date' => '2023-11-30',
            ),
            23 => 
            array (
                'period_no' => 202312,
                'remark' => 'December-2023',
                'start_date' => '2023-12-01',
                'end_date' => '2023-12-01',
            ),
        ));
        
        
    }
}