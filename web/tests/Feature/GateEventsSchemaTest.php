<?php

use Illuminate\Database\QueryException;
use Illuminate\Support\Facades\DB;

test('stores a visitor gate event with no person foreign keys', function () {
    $schoolYearId = insertSchoolYear();

    DB::table('gate_events')->insert([
        'school_year_id' => $schoolYearId,
        'direction' => 'in',
        'person_type' => 'visitor',
        'visitor_name' => 'Jane Doe',
        'scanned_at' => now(),
        'created_at' => now(),
        'updated_at' => now(),
    ]);

    $this->assertDatabaseHas('gate_events', [
        'person_type' => 'visitor',
        'visitor_name' => 'Jane Doe',
        'student_id' => null,
        'faculty_id' => null,
        'employee_id' => null,
        'guardian_id' => null,
    ]);
});

test('rejects a gate event that points at two people', function () {
    $schoolYearId = insertSchoolYear();
    $studentId = insertStudent($schoolYearId);
    $facultyId = insertFaculty();

    expect(fn () => DB::table('gate_events')->insert([
        'school_year_id' => $schoolYearId,
        'direction' => 'in',
        'person_type' => 'student',
        'student_id' => $studentId,
        'faculty_id' => $facultyId,
        'scanned_at' => now(),
        'created_at' => now(),
        'updated_at' => now(),
    ]))->toThrow(QueryException::class);
});

function insertSchoolYear(): int
{
    return DB::table('school_years')->insertGetId([
        'label' => '2026-2027',
        'starts_on' => '2026-08-01',
        'ends_on' => '2027-05-31',
        'is_current' => true,
        'created_at' => now(),
        'updated_at' => now(),
    ]);
}

function insertStudent(int $schoolYearId): int
{
    $departmentId = DB::table('departments')->insertGetId([
        'name' => 'Computing',
        'created_at' => now(),
        'updated_at' => now(),
    ]);

    $programId = DB::table('programs')->insertGetId([
        'department_id' => $departmentId,
        'code' => 'BSIT',
        'name' => 'Information Technology',
        'created_at' => now(),
        'updated_at' => now(),
    ]);

    $sectionId = DB::table('sections')->insertGetId([
        'school_year_id' => $schoolYearId,
        'level' => 'college',
        'program_id' => $programId,
        'year_or_grade' => 1,
        'name' => '1A',
        'created_at' => now(),
        'updated_at' => now(),
    ]);

    return DB::table('students')->insertGetId([
        'student_number' => '2026-0001',
        'last_name' => 'Santos',
        'first_name' => 'Ana',
        'section_id' => $sectionId,
        'enrollment_status' => 'active',
        'created_at' => now(),
        'updated_at' => now(),
    ]);
}

function insertFaculty(): int
{
    return DB::table('faculties')->insertGetId([
        'employee_no' => 'F-0001',
        'last_name' => 'Reyes',
        'first_name' => 'Luis',
        'status' => 'active',
        'created_at' => now(),
        'updated_at' => now(),
    ]);
}
