<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('gate_events', function (Blueprint $table) {
            $table->index('decided_at');
            $table->index(['status', 'scanned_at']);
        });
    }

    public function down(): void
    {
        Schema::table('gate_events', function (Blueprint $table) {
            $table->dropIndex(['decided_at']);
            $table->dropIndex(['status', 'scanned_at']);
        });
    }
};
