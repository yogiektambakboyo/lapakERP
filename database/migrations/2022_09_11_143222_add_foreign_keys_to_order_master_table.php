<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class AddForeignKeysToOrderMasterTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('order_master', function (Blueprint $table) {
            $table->foreign(['created_by'], 'order_master_fk')->references(['id'])->on('users');
            $table->foreign(['customers_id'], 'order_master_fk_1')->references(['id'])->on('customers');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('order_master', function (Blueprint $table) {
            $table->dropForeign('order_master_fk');
            $table->dropForeign('order_master_fk_1');
        });
    }
}
