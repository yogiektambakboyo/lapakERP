<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateSettingsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('settings', function (Blueprint $table) {
            $table->date('transaction_date')->useCurrent();
            $table->integer('period_no');
            $table->string('company_name');
            $table->string('app_name');
            $table->string('version')->nullable();
            $table->string('icon_file')->nullable();

            $table->primary(['company_name', 'app_name']);
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('settings');
    }
}
