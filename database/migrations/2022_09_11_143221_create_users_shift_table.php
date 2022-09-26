<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateUsersShiftTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('users_shift', function (Blueprint $table) {
            $table->integer('branch_id');
            $table->integer('users_id');
            $table->date('dated');
            $table->integer('shift_id');
            $table->string('shift_remark');
            $table->time('shift_time_start')->nullable();
            $table->time('shift_time_end')->nullable();
            $table->string('remark')->nullable();
            $table->timestamp('updated_at')->nullable();
            $table->timestamp('created_at')->useCurrent();

            $table->primary(['branch_id', 'users_id', 'dated', 'shift_id']);
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('users_shift');
    }
}
