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

    'crop_url' => env('CROP_URL', 'http://127.0.0.1:8003'),
];
