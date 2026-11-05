<?php

use Tests\TestCase;

uses(TestCase::class);

it('is connected to the test database, not the real one', function () {
    expect(\Illuminate\Support\Facades\DB::connection()->getDatabaseName())->toBe('verifigate_test');
});
