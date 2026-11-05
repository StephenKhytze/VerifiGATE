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
        Schema::create('gate_event_flags', function (Blueprint $table) {
            $table->id();
            $table->foreignId('gate_event_id')->constrained()->cascadeOnDelete();
            $table->string('reason', 40);
            $table->timestamp('created_at')->useCurrent();
            $table->index('reason');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('gate_event_flags');
    }
};
