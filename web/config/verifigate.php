<?php

return [
    'ocr' => [
        'url' => env('OCR_URL'),
        'token' => env('OCR_TOKEN'),
        'timeout' => (float) env('OCR_TIMEOUT', 3),
    ],

    'station_token' => env('STATION_TOKEN'),

    // unavailable = every student scan goes to the guard
    // stub_compliant = fake "compliant" result, for demos only
    'uniform_mode' => env('UNIFORM_MODE', 'unavailable'),

    'duplicate_window_seconds' => 30,

    // Exemption types that allow any clothes (normalized names, see Names::norm)
    'any_clothes_exemptions' => ['CIVILIAN'],

    // PLACEHOLDERS: calibrate with real scan data
    'thresholds' => [
        'ocr_high' => 90.0,          // weakest of number/name line confidence, 0-100
        'name_min' => 85.0,          // name similarity vs the matched record, 0-100
        'name_only_min' => 92.0,     // name-only matching
        'name_only_margin' => 8.0,   // best match must beat the runner-up by this much
        'guardian_min' => 92.0,      // visitor name vs guardian name
        'visitor_min_lines' => 4,    // "readable ID of some kind"
        'visitor_min_mean' => 0.6,
    ],

    'notifications' => [
        // mock | semaphore | off   (off = no notification rows are created or sent)
        'driver' => env('NOTIFY_DRIVER', 'mock'),

        // Mock outcome: delivered | sent | fail
        'mock_result' => env('NOTIFY_MOCK_RESULT', 'delivered'),

        // app.timezone is UTC, so message times and the Important panel use this zone
        'timezone' => 'Asia/Manila',

        // Seconds to wait before retry 1 and retry 2 (so 3 attempts in total)
        'backoff' => [10, 60],

        // Important panel: age before a stuck message becomes an alert, and the card cap
        'unsent_after_minutes' => 2,
        'unconfirmed_after_minutes' => 5,
        'important_limit' => 20,
    ],

    'reports' => [
        // School days are Manila days; queries convert to app.timezone
        'timezone' => 'Asia/Manila',

        // TEMPORARY test control until class schedules exist:
        // on_time = every entry counts as Present, late = every entry counts as Late
        'attendance_mode' => env('ATTENDANCE_MODE', 'on_time'),

        // ISO weekdays that are school days per level (1 = Monday ... 7 = Sunday)
        'school_days' => [
            'junior_high' => [1, 2, 3, 4, 5],
            'senior_high' => [1, 2, 3, 4, 5],
            'college' => [1, 2, 3, 4, 5, 6],
        ],

        // Flag reasons that count as incidents (chart and Uniform Violations card)
        'incident_flags' => ['uniform_non_compliant'],

        // Stand-ins until the accounts module defines roles and class assignments
        'mock' => [
            'role' => env('REPORTS_MOCK_ROLE', 'faculty'),
            'faculty' => ['name' => 'Sir Kyle', 'title' => 'Faculty', 'program' => 'BSIT', 'year' => 1],
            'admin' => ['name' => 'Ms. Schuyler', 'title' => 'Admin'],
        ],
    ],
    
    'crop_url' => env('CROP_URL', 'http://127.0.0.1:8003'),
];
