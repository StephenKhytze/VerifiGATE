<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('gate_events', function (Blueprint $table) {
            $table->id();
            $table->foreignId('school_year_id')->constrained();
            $table->string('direction', 3)->default('in');
            $table->string('person_type', 10);
            $table->foreignId('student_id')->nullable()->constrained();
            $table->foreignId('faculty_id')->nullable()->constrained('faculties');
            $table->foreignId('employee_id')->nullable()->constrained();
            $table->foreignId('guardian_id')->nullable()->constrained();
            $table->string('visitor_name')->nullable();
            $table->string('id_type', 50)->nullable();
            $table->string('status', 30)->default('pending');
            $table->string('decided_by', 10)->nullable();
            $table->foreignId('guard_user_id')->nullable()->constrained('users');
            $table->string('verification_method', 20)->default('ocr_auto');
            $table->unsignedTinyInteger('scan_attempts')->default(1);
            $table->decimal('ocr_confidence', 5, 2)->nullable();
            $table->decimal('match_score', 5, 2)->nullable();
            $table->string('uniform_status', 20)->nullable();
            $table->decimal('uniform_confidence', 5, 2)->nullable();
            $table->foreignId('exemption_id')->nullable()->constrained();
            $table->foreignId('paired_entry_id')->nullable()->unique()->constrained('gate_events');
            $table->dateTime('scanned_at', 3);
            $table->dateTime('decided_at', 3)->nullable();
            $table->unsignedInteger('verify_ms')->nullable();
            $table->timestamps();
            $table->index(['student_id', 'scanned_at']);
            $table->index(['person_type', 'status']);
            $table->index('scanned_at');
        });

        $this->constrainOnePerson();
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('gate_events');
    }

    /**
     * At most one of student, faculty, employee, or guardian may be set.
     * Visitors keep all four foreign keys null.
     *
     * MySQL 8 enforces this CHECK. SQLite (phpunit) cannot ADD CONSTRAINT,
     * so tests use equivalent INSERT/UPDATE triggers.
     */
    private function constrainOnePerson(): void
    {
        if (Schema::getConnection()->getDriverName() === 'sqlite') {
            DB::statement(<<<'SQL'
CREATE TRIGGER chk_one_person_insert BEFORE INSERT ON gate_events
FOR EACH ROW
WHEN ((NEW.student_id IS NOT NULL) + (NEW.faculty_id IS NOT NULL) + (NEW.employee_id IS NOT NULL) + (NEW.guardian_id IS NOT NULL) > 1)
BEGIN
    SELECT RAISE(ABORT, 'chk_one_person');
END
SQL);
            DB::statement(<<<'SQL'
CREATE TRIGGER chk_one_person_update BEFORE UPDATE ON gate_events
FOR EACH ROW
WHEN ((NEW.student_id IS NOT NULL) + (NEW.faculty_id IS NOT NULL) + (NEW.employee_id IS NOT NULL) + (NEW.guardian_id IS NOT NULL) > 1)
BEGIN
    SELECT RAISE(ABORT, 'chk_one_person');
END
SQL);

            return;
        }

        DB::statement('ALTER TABLE gate_events ADD CONSTRAINT chk_one_person CHECK (
  (student_id IS NOT NULL) + (faculty_id IS NOT NULL)
  + (employee_id IS NOT NULL) + (guardian_id IS NOT NULL) <= 1)');
    }
};
