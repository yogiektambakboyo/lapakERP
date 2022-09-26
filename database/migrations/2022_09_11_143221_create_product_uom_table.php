<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateProductUomTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('product_uom', function (Blueprint $table) {
            $table->integer('product_id');
            $table->integer('uom_id');
            $table->timestamp('created_at')->useCurrent();
            $table->integer('create_by')->nullable();

            $table->primary(['product_id', 'uom_id']);
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('product_uom');
    }
}
