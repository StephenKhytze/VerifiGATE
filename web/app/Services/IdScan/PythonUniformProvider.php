<?php

namespace App\Services\IdScan;

use App\Enums\Gate\UniformStatus;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

use function Pest\Laravel\json;

class PythonUniformProvider implements UniformProvider
{
  public function current(): UniformResult
  {
    # get token
    $token = env("VITE_GATE_TOKEN");
    try {
      # call python endpoint
      $response = Http::timeout(5)->get("http://127.0.0.1:8002/id_scanned?token={$token}");

      if ($response->successful()) {
        $data = $response->json();
        $unifStatus = $data["status"] ?? "unknown";

        # get returned status and map it to uniform statuses
        $mappedStatus = match($unifStatus) {
          "compliant" => UniformStatus::Compliant,
          "non_compliant" => UniformStatus::NonCompliant,
          "low_confidence" => UniformStatus::LowConfidence,
          default => UniformStatus::Unavailable
        };

        return new UniformResult($mappedStatus, $data["confidence"] ?? null);
      }
    } catch (\Exception $e) {
      Log::error("Uniform API Failed: " . $e->getMessage());
    }

    return new UniformResult(UniformStatus::Unavailable);
  }
}
