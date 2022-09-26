<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateUsersSkillsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('users_skills', function (Blueprint $table) {
            $table->integer('users_id');
            $table->integer('modul');
            $table->integer('trainer');
            $table->string('status');
            $table->date('dated')->useCurrent();
            $table->timestamp('updated_at')->nullable();
            $table->integer('created_by')->nullable();
            $table->timestamp('created_at')->useCurrent();

            $table->primary(['users_id', 'modul', 'dated', 'status']);
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('users_skills');
    }
}
