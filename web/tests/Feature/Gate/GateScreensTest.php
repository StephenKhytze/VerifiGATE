<?php

use App\Models\Student;
use App\Models\User;
use Database\Seeders\GateDemoSeeder;
use Illuminate\Support\Facades\Http;

beforeEach(function () {
    config([
        'verifigate.station_token' => 't',
        'verifigate.ocr.url' => 'http://127.0.0.1:8001',
        'verifigate.ocr.token' => 'x',
        'verifigate.crop_url' => 'http://127.0.0.1:8003',
        'verifigate.uniform_mode' => 'unavailable',
    ]);
    $this->seed(GateDemoSeeder::class);
    $this->guardUser = User::factory()->create();
});

function fakeLcCardRead(int $cropStatus = 200): void
{
    $box = [[0, 0], [9, 0], [9, 9], [0, 9]];
    Http::fake([
        '*/ocr' => Http::response([
            'lines' => [
                ['text' => 'LAGUNA COLLEGE', 'confidence' => 0.99, 'box' => $box],
                ['text' => 'JUAN MIGUEL C. DE GUZMAN', 'confidence' => 0.97, 'box' => $box],
                ['text' => 'Student No.: H24-9001', 'confidence' => 0.96, 'box' => $box],
            ],
            'mean_confidence' => 0.97,
            'type_hint' => 'lc_card',
        ]),
        '*/crops/*' => Http::response($cropStatus === 200 ? 'JPEGBYTES' : '', $cropStatus),
    ]);
}

function scanAsStation($test)
{
    return $test->call('POST', '/api/station/scans', [], [], [],
        ['HTTP_X_STATION_TOKEN' => 't', 'CONTENT_TYPE' => 'image/jpeg'], 'jpeg-bytes');
}

it('requires a login for the guard endpoints', function () {
    $this->getJson('/gate/state')->assertUnauthorized();
    $this->getJson('/gate/screen-state')->assertUnauthorized();
});

it('shows idle on both screens when nothing is happening', function () {
    $this->actingAs($this->guardUser)->getJson('/gate/state')
        ->assertOk()->assertJsonPath('mode', 'idle')->assertJsonPath('current', null);

    $this->actingAs($this->guardUser)->getJson('/gate/screen-state')
        ->assertOk()->assertExactJson(['screen' => 'idle', 'given_names' => null, 'time' => null]);
});

it('shows a pending scan to the guard and only "scanning" to the student', function () {
    fakeLcCardRead();
    scanAsStation($this)->assertJsonPath('result', 'pending');

    $this->actingAs($this->guardUser)->getJson('/gate/state')
        ->assertOk()
        ->assertJsonPath('mode', 'review')
        ->assertJsonPath('current.name', 'DE GUZMAN, JUAN MIGUEL C.')
        ->assertJsonPath('current.identifier', 'H24-9001')
        ->assertJsonPath('current.needs_decision', true)
        ->assertJsonFragment(['code' => 'uniform_unavailable']);

    // The student screen must never include flag reasons
    $this->actingAs($this->guardUser)->getJson('/gate/screen-state')
        ->assertExactJson(['screen' => 'scanning', 'given_names' => null, 'time' => null]);
});

it('approves with a flagged uniform and welcomes the student by given names', function () {
    fakeLcCardRead();
    $id = scanAsStation($this)->json('event_id');

    $this->actingAs($this->guardUser)
        ->postJson("/gate/events/{$id}/decision", ['decision' => 'approve'])
        ->assertOk()->assertJsonPath('status', 'approved_flagged_uniform');

    $this->actingAs($this->guardUser)->getJson('/gate/screen-state')
        ->assertJsonPath('screen', 'welcome')
        ->assertJsonPath('given_names', 'JUAN MIGUEL');

    $this->assertDatabaseHas('gate_events', [
        'id' => $id, 'decided_by' => 'guard', 'guard_user_id' => $this->guardUser->id,
    ]);
});

it('flags the student on deny and refuses a second decision', function () {
    fakeLcCardRead();
    $id = scanAsStation($this)->json('event_id');

    $this->actingAs($this->guardUser)
        ->postJson("/gate/events/{$id}/decision", ['decision' => 'deny'])
        ->assertOk()->assertJsonPath('status', 'flagged');

    $this->actingAs($this->guardUser)->getJson('/gate/screen-state')
        ->assertExactJson(['screen' => 'flagged', 'given_names' => null, 'time' => null]);

    $this->actingAs($this->guardUser)
        ->postJson("/gate/events/{$id}/decision", ['decision' => 'approve'])
        ->assertStatus(409);
});

it('shows scanning while the worker reports a steady card', function () {
    $this->postJson('/api/station/signal', ['state' => 'card'], ['X-Station-Token' => 't'])->assertOk();

    $this->actingAs($this->guardUser)->getJson('/gate/screen-state')
        ->assertJsonPath('screen', 'scanning');
});

it('rejects the worker signal without the station token', function () {
    $this->postJson('/api/station/signal', ['state' => 'card'])->assertUnauthorized();
});

it('finds people by name or number', function () {
    $this->actingAs($this->guardUser)->getJson('/gate/people/search?q=guzman')
        ->assertOk()->assertJsonFragment(['identifier' => 'H24-9001']);

    $this->actingAs($this->guardUser)->getJson('/gate/people/search?q=H24-9002')
        ->assertOk()->assertJsonFragment(['name' => 'DE LOS SANTOS, MARIA ALBA A.']);
});

it('lets the guard start a manual entry and identify the student', function () {
    $eventId = $this->actingAs($this->guardUser)->postJson('/gate/events/manual')
        ->assertOk()->json('event_id');
    $studentId = Student::where('student_number', 'H24-9001')->value('id');

    $this->actingAs($this->guardUser)
        ->postJson("/gate/events/{$eventId}/identify", ['person_type' => 'student', 'person_id' => $studentId])
        ->assertOk()->assertJsonPath('event.name', 'DE GUZMAN, JUAN MIGUEL C.');

    $this->assertDatabaseHas('gate_events', [
        'id' => $eventId, 'person_type' => 'student', 'student_id' => $studentId,
        'verification_method' => 'registration_card',
    ]);
    $this->assertDatabaseHas('gate_event_flags', ['gate_event_id' => $eventId, 'reason' => 'uniform_unavailable']);
});

it('streams the ID image from the worker', function () {
    fakeLcCardRead();
    $id = scanAsStation($this)->json('event_id');

    $this->actingAs($this->guardUser)->get("/gate/events/{$id}/id-image")
        ->assertOk()->assertHeader('Content-Type', 'image/jpeg');
});

it('returns 404 for the ID image when the worker no longer has it', function () {
    fakeLcCardRead(404);
    $id = scanAsStation($this)->json('event_id');

    $this->actingAs($this->guardUser)->get("/gate/events/{$id}/id-image")->assertNotFound();
});
