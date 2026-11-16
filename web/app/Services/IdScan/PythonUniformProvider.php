<?php

namespace App\Services\IdScan;

use App\Enums\Gate\Sex;
use App\Enums\Gate\UniformStatus;
use App\Models\Student;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class PythonUniformProvider implements UniformProvider
{
    public function current(?Student $student = null): UniformResult
    {
        // Support demo/stub mode without external service
        if (config('verifigate.uniform_mode') === 'stub_compliant') {
            return new UniformResult(UniformStatus::Compliant, 99.0);
        }

        # get token
        $token = env("VITE_GATE_TOKEN") ?: env("GATE_TOKEN");

        try {
            $sexValue = null;
            if ($student?->sex instanceof Sex) {
                $sexValue = $student->sex->value;
            } elseif (is_string($student?->sex)) {
                $sexValue = $student->sex;
            }

            $query = array_filter([
                'token' => $token,
                'student_number' => $student?->student_number,
                'sex' => $sexValue,
            ]);

            # call python endpoint
            $response = Http::timeout(5)->get("http://127.0.0.1:8002/id_scanned", $query);

            if ($response->successful()) {
                $data = $response->json();
                $unifStatus = strtolower(str_replace('-', '_', (string) ($data["status"] ?? "unknown")));

                # get returned status and map it to uniform statuses (supporting both Python & Laravel conventions)
                $mappedStatus = match ($unifStatus) {
                    "compliant", "approved" => UniformStatus::Compliant,
                    "non_compliant", "non-compliant", "denied" => UniformStatus::NonCompliant,
                    "low_confidence" => UniformStatus::LowConfidence,
                    default => UniformStatus::Unavailable,
                };

                return new UniformResult($mappedStatus, isset($data["confidence"]) ? (float) $data["confidence"] : null);
            }
        } catch (\Exception $e) {
            Log::error("Uniform API Failed: " . $e->getMessage());
        }

        return new UniformResult(UniformStatus::Unavailable);
    }
}

