<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class AddForeignKeysToProductUomTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('product_uom', function (Blueprint $table) {
            $table->foreign(['product_id'], 'product_uom_fk')->references(['id'])->on('product_sku');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('product_uom', function (Blueprint $table) {
            $table->dropForeign('product_uom_fk');
        });
    }
}
