<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateProductCommisionByYearTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('product_commision_by_year', function (Blueprint $table) {
            $table->integer('product_id');
            $table->integer('branch_id');
            $table->integer('jobs_id');
            $table->integer('years')->default(1);
            $table->integer('values');
            $table->integer('created_by');
            $table->timestamps();

            $table->primary(['product_id', 'branch_id', 'jobs_id', 'years']);
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('product_commision_by_year');
    }
}
