<?php

use Database\Seeders\GateDemoSeeder;
use Illuminate\Http\Client\ConnectionException;
use Illuminate\Support\Facades\Http;

beforeEach(function () {
    config([
        'verifigate.station_token' => 't',
        'verifigate.ocr.url' => 'http://127.0.0.1:8001',
        'verifigate.ocr.token' => 'x',
    ]);
    $this->seed(GateDemoSeeder::class);
});

function postScan($test)
{
    return $test->call('POST', '/api/station/scans', [], [], [],
        ['HTTP_X_STATION_TOKEN' => 't', 'CONTENT_TYPE' => 'image/jpeg'], 'jpeg-bytes');
}

it('auto-approves a matched, high-confidence, compliant student', function () {
    config(['verifigate.uniform_mode' => 'stub_compliant']);
    $box = [[0, 0], [9, 0], [9, 9], [0, 9]];
    Http::fake(['*/ocr' => Http::response([
        'lines' => [
            ['text' => 'LAGUNA COLLEGE', 'confidence' => 0.99, 'box' => $box],
            ['text' => 'JUAN MIGUEL C. DE GUZMAN', 'confidence' => 0.97, 'box' => $box],
            ['text' => 'Student No.: H24-9001', 'confidence' => 0.96, 'box' => $box],
        ],
        'mean_confidence' => 0.97,
        'type_hint' => 'lc_card',
    ])]);

    postScan($this)->assertOk()->assertJsonPath('result', 'approved');
    $this->assertDatabaseHas('gate_events', ['status' => 'approved', 'decided_by' => 'system']);
});

it('sends the scan to the guard when OCR is down', function () {
    Http::fake(['*/ocr' => fn () => throw new ConnectionException('down')]);

    postScan($this)->assertOk()->assertJsonPath('result', 'pending');
    $this->assertDatabaseHas('gate_event_flags', ['reason' => 'ocr_unavailable']);
});

it('rejects requests without the station token', function () {
    $this->call('POST', '/api/station/scans', [], [], [], ['CONTENT_TYPE' => 'image/jpeg'], 'x')
        ->assertUnauthorized();
});
