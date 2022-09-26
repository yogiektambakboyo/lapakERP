<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class AddForeignKeysToReceiveDetailTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('receive_detail', function (Blueprint $table) {
            $table->foreign(['receive_no'], 'receive_detail_fk')->references(['receive_no'])->on('receive_master');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('receive_detail', function (Blueprint $table) {
            $table->dropForeign('receive_detail_fk');
        });
    }
}
