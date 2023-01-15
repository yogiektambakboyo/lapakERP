<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateProductPriceTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('product_price', function (Blueprint $table) {
            $table->integer('product_id');
            $table->decimal('price', 18, 0)->default(0);
            $table->integer('branch_id');
            $table->integer('updated_by')->nullable();
            $table->timestamp('updated_at')->nullable();
            $table->integer('created_by');
            $table->timestamp('created_at');

            $table->primary(['product_id', 'branch_id']);
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('product_price');
    }
}
