<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreatePurchaseDetailTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('purchase_detail', function (Blueprint $table) {
            $table->string('purchase_no');
            $table->integer('product_id');
            $table->string('product_remark')->nullable();
            $table->string('uom')->nullable();
            $table->smallInteger('seq')->default(0);
            $table->integer('qty')->default(0);
            $table->decimal('price', 18, 0)->default(0);
            $table->decimal('discount', 18, 0)->default(0);
            $table->decimal('vat', 10)->default(0);
            $table->decimal('vat_total', 18)->default(0);
            $table->decimal('subtotal', 18, 0)->default(0);
            $table->decimal('subtotal_vat', 18)->nullable()->default(0);
            $table->timestamp('updated_at')->nullable();
            $table->timestamp('created_at')->useCurrent();

            $table->primary(['purchase_no', 'product_id']);
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('purchase_detail');
    }
}
