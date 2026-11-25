<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('gate_events', function (Blueprint $table) {
            $table->string('attendance_status', 10)->nullable()->after('verification_method');
        });
    }

    public function down(): void
    {
        Schema::table('gate_events', function (Blueprint $table) {
            $table->dropColumn('attendance_status');
        });
    }
};
