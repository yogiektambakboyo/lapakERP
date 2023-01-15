<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateProductIngredientsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('product_ingredients', function (Blueprint $table) {
            $table->integer('product_id');
            $table->integer('product_id_material');
            $table->integer('uom_id');
            $table->integer('qty')->default(1);
            $table->timestamp('updated_at')->nullable();
            $table->integer('created_by');
            $table->timestamp('created_at')->useCurrent();

            $table->primary(['product_id', 'product_id_material']);
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('product_ingredients');
    }
}
