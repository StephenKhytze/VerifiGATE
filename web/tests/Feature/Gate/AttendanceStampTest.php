<?php

use App\Enums\Gate\AttendanceStatus;
use App\Models\GateEvent;
use App\Models\User;
use Database\Seeders\GateDemoSeeder;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Http;
use App\Models\Student;

beforeEach(function () {
    config([
        'verifigate.station_token' => 't',
        'verifigate.ocr.url' => 'http://127.0.0.1:8001',
        'verifigate.ocr.token' => 'x',
        'verifigate.uniform_mode' => 'stub_compliant',
    ]);
    Cache::forget('gate.attendance_status');
    $this->seed(GateDemoSeeder::class);
});

function attScan($test)
{
    $number = Student::where('last_name', 'DE GUZMAN')->value('student_number');
    $box = [[0, 0], [9, 0], [9, 9], [0, 9]];
    Http::fake(['*/ocr' => Http::response([
        'lines' => [
            ['text' => 'LAGUNA COLLEGE', 'confidence' => 0.99, 'box' => $box],
            ['text' => 'JUAN MIGUEL C. DE GUZMAN', 'confidence' => 0.97, 'box' => $box],
            ['text' => "Student No.: {$number}", 'confidence' => 0.96, 'box' => $box],
        ],
        'mean_confidence' => 0.97,
        'type_hint' => 'lc_card',
    ])]);

    return $test->call('POST', '/api/station/scans', [], [], [],
        ['HTTP_X_STATION_TOKEN' => 't', 'CONTENT_TYPE' => 'image/jpeg'], 'jpeg-bytes');
}

function attSwitch($test, User $user, string $status)
{
    return $test->actingAs($user)->postJson('/gate/attendance-mode', ['status' => $status]);
}

it('stamps a scanned entry as on time by default', function () {
    attScan($this)->assertOk();

    expect(GateEvent::latest('id')->firstOrFail()->attendance_status)->toBe(AttendanceStatus::OnTime);
});

it('stamps entries as late after the guard screen switches the mode', function () {
    attSwitch($this, User::factory()->create(), 'late')
        ->assertOk()->assertJson(['attendance_mode' => 'late']);

    attScan($this)->assertOk();

    expect(GateEvent::latest('id')->firstOrFail()->attendance_status)->toBe(AttendanceStatus::Late);
});

it('keeps the status an entry was scanned with when the mode changes later', function () {
    attScan($this)->assertOk();
    $event = GateEvent::latest('id')->firstOrFail();

    attSwitch($this, User::factory()->create(), 'late')->assertOk();

    expect($event->fresh()->attendance_status)->toBe(AttendanceStatus::OnTime);
});

it('stamps manual entries with the current mode', function () {
    $user = User::factory()->create();
    attSwitch($this, $user, 'late')->assertOk();

    $id = $this->actingAs($user)->postJson('/gate/events/manual')->assertOk()->json('event_id');

    expect(GateEvent::findOrFail($id)->attendance_status)->toBe(AttendanceStatus::Late);
});

it('reports the mode and the toggle on the guard state', function () {
    $user = User::factory()->create();

    $this->actingAs($user)->getJson('/gate/state')->assertOk()
        ->assertJsonPath('attendance.mode', 'on_time')
        ->assertJsonPath('attendance.toggle', true);

    attSwitch($this, $user, 'late')->assertOk();

    $this->actingAs($user)->getJson('/gate/state')
        ->assertJsonPath('attendance.mode', 'late');
});

it('falls back to on time for a damaged stored value', function () {
    Cache::forever('gate.attendance_status', 'garbage');

    $this->actingAs(User::factory()->create())->getJson('/gate/state')
        ->assertJsonPath('attendance.mode', 'on_time');
});

it('rejects an unknown status and requires a login', function () {
    attSwitch($this, User::factory()->create(), 'nonsense')->assertUnprocessable();

    auth()->logout();
    $this->postJson('/gate/attendance-mode', ['status' => 'late'])->assertUnauthorized();
});

it('ignores the toggle in production', function () {
    $user = User::factory()->create();
    attSwitch($this, $user, 'late')->assertOk();

    app()->detectEnvironment(fn () => 'production');

    $this->actingAs($user)
        ->withSession(['_token' => 'test-token'])
        ->postJson('/gate/attendance-mode', ['status' => 'late'], ['X-CSRF-TOKEN' => 'test-token'])
        ->assertNotFound();
    $this->actingAs($user)->getJson('/gate/state')
        ->assertJsonPath('attendance.toggle', false)
        ->assertJsonPath('attendance.mode', 'on_time');

    attScan($this)->assertOk();

    expect(GateEvent::latest('id')->firstOrFail()->attendance_status)->toBe(AttendanceStatus::OnTime);
});
