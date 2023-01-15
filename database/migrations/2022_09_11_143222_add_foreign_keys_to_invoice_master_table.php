<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class AddForeignKeysToInvoiceMasterTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('invoice_master', function (Blueprint $table) {
            $table->foreign(['created_by'], 'invoice_master_fk')->references(['id'])->on('users');
            $table->foreign(['customers_id'], 'invoice_master_fk_1')->references(['id'])->on('customers');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('invoice_master', function (Blueprint $table) {
            $table->dropForeign('invoice_master_fk');
            $table->dropForeign('invoice_master_fk_1');
        });
    }
}
