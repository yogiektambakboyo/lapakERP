<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateOrderMasterTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('order_master', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('order_no')->unique('order_master_un');
            $table->date('dated')->useCurrent();
            $table->integer('customers_id');
            $table->integer('created_by');
            $table->timestamp('created_at')->useCurrent();
            $table->decimal('total', 18, 0)->default(0);
            $table->decimal('tax', 18, 0)->default(0);
            $table->decimal('total_payment', 18, 0)->default(0);
            $table->decimal('total_discount', 18, 0)->default(0);
            $table->string('remark')->nullable();
            $table->string('payment_type');
            $table->decimal('payment_nominal', 18, 0)->default(0);
            $table->string('voucher_code')->nullable();
            $table->timestamp('printed_at')->nullable();
            $table->timestamp('updated_at')->nullable();
            $table->integer('updated_by')->nullable();
            $table->timestamp('scheduled_at')->useCurrent();
            $table->integer('branch_room_id');
            $table->smallInteger('is_checkout')->default(0);
            $table->smallInteger('is_canceled')->default(0);
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('order_master');
    }
}
