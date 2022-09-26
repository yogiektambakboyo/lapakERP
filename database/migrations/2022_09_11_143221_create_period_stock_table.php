<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreatePeriodStockTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('period_stock', function (Blueprint $table) {
            $table->integer('periode');
            $table->integer('branch_id');
            $table->integer('product_id')->default(0);
            $table->integer('balance_begin')->default(0);
            $table->integer('balance_end')->default(0);
            $table->integer('qty_in')->default(0);
            $table->integer('qty_out')->default(0);
            $table->timestamp('updated_at')->nullable();
            $table->integer('created_by')->default(1);
            $table->timestamp('created_at')->useCurrent();

            $table->primary(['periode', 'branch_id', 'product_id']);
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('period_stock');
    }
}
