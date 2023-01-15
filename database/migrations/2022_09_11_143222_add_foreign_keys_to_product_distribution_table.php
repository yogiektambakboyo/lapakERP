<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class AddForeignKeysToProductDistributionTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('product_distribution', function (Blueprint $table) {
            $table->foreign(['branch_id'], 'product_distribution_fk')->references(['id'])->on('branch');
            $table->foreign(['product_id'], 'product_distribution_fk_1')->references(['id'])->on('product_sku');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('product_distribution', function (Blueprint $table) {
            $table->dropForeign('product_distribution_fk');
            $table->dropForeign('product_distribution_fk_1');
        });
    }
}
