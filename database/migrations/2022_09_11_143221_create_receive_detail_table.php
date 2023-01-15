<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateReceiveDetailTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('receive_detail', function (Blueprint $table) {
            $table->string('receive_no');
            $table->integer('product_id');
            $table->integer('qty')->default(0);
            $table->decimal('price', 18, 0)->default(0);
            $table->decimal('total', 18, 0)->default(0);
            $table->decimal('discount', 18, 0)->default(0);
            $table->smallInteger('seq')->default(0);
            $table->date('expired_at')->default('now() + \'1 year');
            $table->string('batch_no')->nullable();
            $table->timestamp('updated_at')->nullable();
            $table->timestamp('created_at')->useCurrent();

            $table->primary(['receive_no', 'product_id', 'expired_at']);
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('receive_detail');
    }
}
