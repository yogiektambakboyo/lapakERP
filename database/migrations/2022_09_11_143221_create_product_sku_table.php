<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateProductSkuTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('product_sku', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('remark');
            $table->string('abbr')->unique('product_sku_un');
            $table->string('alias_code')->nullable();
            $table->string('barcode')->nullable();
            $table->integer('category_id');
            $table->integer('type_id')->comment('\'Product/Service\'');
            $table->integer('brand_id');
            $table->timestamp('updated_at')->nullable();
            $table->integer('updated_by')->nullable();
            $table->timestamp('created_at')->useCurrent();
            $table->integer('created_by');
            $table->decimal('vat', 10, 0)->default(0);
            $table->smallInteger('active')->default(1);
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('product_sku');
    }
}
