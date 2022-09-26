<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateProductCommisionsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('product_commisions', function (Blueprint $table) {
            $table->integer('product_id');
            $table->integer('branch_id');
            $table->integer('created_by_fee')->nullable();
            $table->integer('assigned_to_fee')->nullable();
            $table->integer('referral_fee')->nullable();
            $table->timestamp('created_at');
            $table->integer('created_by');
            $table->string('remark')->nullable();
            $table->timestamp('updated_at')->nullable();

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
        Schema::dropIfExists('product_commisions');
    }
}
