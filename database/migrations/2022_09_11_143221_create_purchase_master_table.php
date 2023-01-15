<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreatePurchaseMasterTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('purchase_master', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('purchase_no')->unique('purchase_master_un');
            $table->date('dated')->useCurrent();
            $table->integer('supplier_id');
            $table->string('supplier_name')->nullable();
            $table->integer('branch_id');
            $table->string('branch_name')->nullable();
            $table->decimal('total', 18, 0)->default(0);
            $table->decimal('total_vat', 18, 0)->default(0);
            $table->decimal('total_payment', 18, 0)->default(0);
            $table->decimal('total_discount', 18, 0)->default(0);
            $table->string('remark')->nullable();
            $table->string('payment_type')->nullable();
            $table->decimal('payment_nominal', 18, 0)->default(0);
            $table->timestamp('scheduled_at')->useCurrent();
            $table->string('ref_no')->nullable();
            $table->timestamp('printed_at')->nullable();
            $table->integer('updated_by')->nullable();
            $table->timestamp('updated_at')->nullable();
            $table->integer('created_by');
            $table->timestamp('created_at')->useCurrent();
            $table->smallInteger('is_receive')->default(0);
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
        Schema::dropIfExists('purchase_master');
    }
}
