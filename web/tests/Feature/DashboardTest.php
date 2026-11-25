<?php

use App\Models\User;

test('guests are redirected to the login page', function () {
    $response = $this->get(route('dashboard'));
    $response->assertRedirect(route('login'));
});

test('authenticated users are sent to their dashboard', function () {
    config(['verifigate.reports.mock.role' => 'faculty']);
    $this->actingAs(User::factory()->create());

    $this->get(route('dashboard'))->assertRedirect('/dashboard/faculty');
});
