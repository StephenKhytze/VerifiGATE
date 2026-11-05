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
        Schema::create('affiliations', function (Blueprint $table) {
            $table->id();
            $table->string('name')->unique();
            $table->timestamps();
        });

        Schema::create('student_affiliations', function (Blueprint $table) {
            $table->foreignId('student_id')->constrained();
            $table->foreignId('affiliation_id')->constrained();
            $table->primary(['student_id', 'affiliation_id']);
        });

        Schema::create('exemption_types', function (Blueprint $table) {
            $table->id();
            $table->string('name')->unique();
            $table->timestamps();
        });

        Schema::create('exemptions', function (Blueprint $table) {
            $table->id();
            $table->foreignId('student_id')->constrained();
            $table->foreignId('exemption_type_id')->constrained();
            $table->date('date');
            $table->foreignId('applied_by')->nullable()->constrained('users');
            $table->timestamps();
            $table->unique(['student_id', 'exemption_type_id', 'date']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('exemptions');
        Schema::dropIfExists('exemption_types');
        Schema::dropIfExists('student_affiliations');
        Schema::dropIfExists('affiliations');
    }
};
