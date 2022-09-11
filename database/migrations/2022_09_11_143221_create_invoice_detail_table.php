<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateInvoiceDetailTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('invoice_detail', function (Blueprint $table) {
            $table->string('invoice_no');
            $table->integer('product_id');
            $table->integer('qty')->default(0);
            $table->decimal('price', 18, 0)->default(0);
            $table->decimal('total', 18, 0)->default(0);
            $table->decimal('discount', 18, 0)->default(0);
            $table->smallInteger('seq')->default(0);
            $table->integer('assigned_to')->nullable();
            $table->integer('referral_by')->nullable();
            $table->timestamp('updated_at')->nullable();
            $table->timestamp('created_at')->useCurrent();

            $table->primary(['invoice_no', 'product_id']);
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('invoice_detail');
    }
}
