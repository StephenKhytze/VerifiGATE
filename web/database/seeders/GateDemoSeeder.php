<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\SchoolYear;
use App\Models\Department;
use App\Models\Program;
use App\Models\Section;
use App\Models\Student;
use App\Models\Faculty;
use App\Models\Employee;
use App\Models\Guardian;
use App\Models\PickupAuthorization;
use App\Models\ExemptionType;

class GateDemoSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        abort_if(app()->environment('production'), 403, 'Demo data is for dev only');

        $sy = SchoolYear::create(['label' => '2026-2027 (DEMO)',
            'starts_on' => '2026-06-01', 'ends_on' => '2027-03-31', 'is_current' => true]);
        $dept = Department::create(['name' => 'DEMO Information Technology']);
        $bsit = Program::create(['department_id' => $dept->id, 'code' => 'BSIT']);

        $g10 = Section::create(['school_year_id' => $sy->id, 'level' => 'junior_high',
            'year_or_grade' => 10, 'name' => 'Mercury']);
        $g11 = Section::create(['school_year_id' => $sy->id, 'level' => 'senior_high',
            'year_or_grade' => 11, 'name' => 'Sun']);
        $c1 = Section::create(['school_year_id' => $sy->id, 'level' => 'college',
            'program_id' => $bsit->id, 'year_or_grade' => 1, 'name' => '1A']);
        $c4 = Section::create(['school_year_id' => $sy->id, 'level' => 'college',
            'program_id' => $bsit->id, 'year_or_grade' => 4, 'name' => '1']);

        // [number, last, first, middle, suffix, section]   ALL FAKE
        $students = [
            ['H24-0137', 'DE GUZMAN',     'JUAN MIGUEL', 'C', null,  $g10],
            ['H24-9002', 'DE LOS SANTOS', 'MARIA ALBA',  'A', null,  $g10],
            ['H24-9003', 'NUÑEZ',         'JOSE RAFAEL', 'P', 'JR.', $g10],
            ['H24-9004', 'PEÑA',          'ANA LUISA',   'B', null,  $g11],
            ['C24-9001', 'CRUZ',          'DANIEL ANDREW','L', null, $c1],
            ['C24-9002', 'DELA CRUZ',     'SOFIA MAE',   'T', null,  $c1],
            ['C23-0270', 'GARROVILLO',     'STEPHEN KHYTZE',   'M', null,  $c4],
        ];
        foreach ($students as [$no, $last, $first, $mid, $suf, $sec]) {
            Student::create(['student_number' => $no, 'last_name' => $last,
                'first_name' => $first, 'middle_name' => $mid, 'suffix' => $suf,
                'section_id' => $sec->id]);
        }

        // PLACEHOLDER formats, not real LC ID numbers
        Faculty::create(['employee_no' => 'FAC-9001', 'last_name' => 'REYES',
            'first_name' => 'CARLA', 'middle_name' => 'M', 'department_id' => $dept->id]);
        Employee::create(['employee_no' => 'EMP-9001', 'last_name' => 'BAUTISTA',
            'first_name' => 'RICARDO', 'middle_name' => 'S', 'office' => 'Registrar (DEMO)']);

        $g = Guardian::create(['last_name' => 'DE GUZMAN', 'first_name' => 'ELENA', 'middle_name' => 'R']);
        PickupAuthorization::create(['guardian_id' => $g->id,
            'student_id' => Student::where('student_number', 'H24-0137')->value('id'),
            'relationship' => 'Mother']);

        foreach (['Civilian', 'P.E. Uniform', 'Department Shirt'] as $n) {
            ExemptionType::create(['name' => $n]);
        }
    }
}
