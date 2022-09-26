<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class AddForeignKeysToProductCommisionByYearTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('product_commision_by_year', function (Blueprint $table) {
            $table->foreign(['product_id'], 'product_commision_by_year_fk')->references(['id'])->on('product_sku');
            $table->foreign(['branch_id'], 'product_commision_by_year_fk_1')->references(['id'])->on('branch');
            $table->foreign(['created_by'], 'product_commision_by_year_fk_2')->references(['id'])->on('users');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('product_commision_by_year', function (Blueprint $table) {
            $table->dropForeign('product_commision_by_year_fk');
            $table->dropForeign('product_commision_by_year_fk_1');
            $table->dropForeign('product_commision_by_year_fk_2');
        });
    }
}
