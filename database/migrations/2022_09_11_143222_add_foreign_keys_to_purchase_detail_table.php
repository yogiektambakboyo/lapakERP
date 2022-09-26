<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class AddForeignKeysToPurchaseDetailTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('purchase_detail', function (Blueprint $table) {
            $table->foreign(['purchase_no'], 'purchase_detail_fk')->references(['purchase_no'])->on('purchase_master');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('purchase_detail', function (Blueprint $table) {
            $table->dropForeign('purchase_detail_fk');
        });
    }
}
