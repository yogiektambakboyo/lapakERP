<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateUsersTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('users', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('name')->nullable();
            $table->string('email')->unique();
            $table->string('username')->unique();
            $table->timestamp('email_verified_at')->nullable();
            $table->string('password');
            $table->rememberToken();
            $table->timestamps();
            $table->string('phone_no', 50)->nullable();
            $table->string('address')->nullable();
            $table->date('join_date')->nullable();
            $table->smallInteger('join_years')->default(0);
            $table->string('gender')->nullable();
            $table->string('netizen_id')->nullable();
            $table->string('city')->nullable();
            $table->string('employee_id')->nullable();
            $table->string('photo')->nullable();
            $table->string('photo_netizen_id')->nullable();
            $table->integer('job_id')->nullable();
            $table->integer('branch_id')->nullable();
            $table->integer('department_id')->nullable();
            $table->integer('referral_id')->nullable();
            $table->string('birth_place')->nullable();
            $table->date('birth_date')->nullable();
            $table->string('employee_status')->nullable();
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
        Schema::dropIfExists('users');
    }
}
