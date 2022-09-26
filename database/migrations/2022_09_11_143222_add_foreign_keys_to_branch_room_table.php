<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class AddForeignKeysToBranchRoomTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('branch_room', function (Blueprint $table) {
            $table->foreign(['branch_id'], 'branch_room_fk_1')->references(['id'])->on('branch');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('branch_room', function (Blueprint $table) {
            $table->dropForeign('branch_room_fk_1');
        });
    }
}
