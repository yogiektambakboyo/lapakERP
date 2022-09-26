<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateProductPointTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('product_point', function (Blueprint $table) {
            $table->integer('product_id');
            $table->integer('branch_id');
            $table->integer('point')->default(0);
            $table->integer('created_by')->nullable();
            $table->timestamps();

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
        Schema::dropIfExists('product_point');
    }
}
