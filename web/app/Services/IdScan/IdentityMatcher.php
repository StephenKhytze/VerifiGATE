<?php

namespace App\Services\IdScan;

use App\Enums\Gate\FlagReason;
use App\Enums\Gate\PersonType;
use App\Models\Employee;
use App\Models\Faculty;
use App\Models\Guardian;
use App\Models\Student;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

final class IdentityMatcher
{
    public function __construct(private IdTextParser $parser)
    {
    }

    public function identify(OcrResult $ocr): Identity
    {
        $t = config('verifigate.thresholds');

        if ($ocr->typeHint === 'national_id') {
            return $this->visitor($ocr, 'National ID');
        }

        $numbers = $this->parser->numbers($ocr->lines);
        $tries = [
            [PersonType::Student, 'student', fn ($v) => Student::where('student_number', $v)->first()],
            [PersonType::Faculty, 'faculty', fn ($v) => Faculty::where('employee_no', $v)->first()],
            [PersonType::Employee, 'employee', fn ($v) => Employee::where('employee_no', $v)->first()],
        ];

        $numberRead = false;
        foreach ($tries as [$type, $key, $find]) {
            if (!$numberRead && $numbers[$key]) {
                // fall through to the next type only if this number matches nobody
            }
            if (!$numbers[$key]) {
                continue;
            }
            $numberRead = true;
            if ($model = $find($numbers[$key]['value'])) {
                return $this->lcPerson($type, $model, $numbers[$key], $ocr);
            }
        }

        if ($numberRead) {
            // A number was read but nobody has it: never guess from the name
            return Identity::unknown([FlagReason::NoMatch], ($numbers['student']['conf'] ?? 0) * 100);
        }

        if ($ocr->typeHint === 'lc_card') {
            return $this->byNameOnly($ocr);
        }

        $readable = count($ocr->lines) >= $t['visitor_min_lines'] && $ocr->meanConfidence >= $t['visitor_min_mean'];
        if ($ocr->typeHint === 'unknown' && $readable) {
            return $this->visitor($ocr, 'Other ID');
        }

        // Blank frames, registration cards (no sample yet), faculty/employee cards without a readable number
        return Identity::unknown([]);
    }

    private function lcPerson(PersonType $type, Model $person, array $number, OcrResult $ocr): Identity
    {
        [$score, $nameConf] = $this->nameScore($person, $ocr->lines);
        $status = $person->enrollment_status ?? $person->status;
        $active = $status === 'active';

        return new Identity(
            type: $type,
            model: $person,
            active: $active,
            nameScore: $score,
            ocrConfidence: min($number['conf'], $nameConf) * 100,
            flags: $active ? [] : [FlagReason::InactiveStudent],
        );
    }

    /**
     * Best similarity between the record's name and any OCR line (or two adjacent lines).
     *
     * @return array{0: float, 1: float}  [similarity 0-100, confidence of that line 0-1]
     */
    private function nameScore(Model $p, array $lines): array
    {
        $mi = $p->middle_name ? ' ' . Str::substr($p->middle_name, 0, 1) : '';
        $expected = [
            "{$p->first_name}{$mi} {$p->last_name}",
            "{$p->first_name} {$p->last_name}",
            "{$p->last_name} {$p->first_name}{$mi}",
        ];

        $candidates = [];
        foreach ($lines as $i => $l) {
            $candidates[] = [$l['text'], $l['confidence']];
            if (isset($lines[$i + 1])) {
                $candidates[] = [
                    $l['text'] . ' ' . $lines[$i + 1]['text'],
                    min($l['confidence'], $lines[$i + 1]['confidence']),
                ];
            }
        }

        $best = [0.0, 0.0];
        foreach ($candidates as [$text, $conf]) {
            foreach ($expected as $name) {
                $ratio = Names::ratio($text, $name);
                if ($ratio > $best[0]) {
                    $best = [$ratio, (float) $conf];
                }
            }
        }

        return $best;
    }

    /** LC card with no readable number: identify by name, but only if the match is clear. */
    private function byNameOnly(OcrResult $ocr): Identity
    {
        $t = config('verifigate.thresholds');

        $scored = Student::where('enrollment_status', 'active')->get()
            ->map(fn ($s) => [$s, ...$this->nameScore($s, $ocr->lines)])
            ->sortByDesc(fn ($x) => $x[1])
            ->values();

        if ($scored->isEmpty() || $scored[0][1] < $t['name_only_min']) {
            return Identity::unknown([FlagReason::NoMatch]);
        }
        if (isset($scored[1]) && ($scored[0][1] - $scored[1][1]) < $t['name_only_margin']) {
            return Identity::unknown([FlagReason::AmbiguousMatch]);
        }

        return new Identity(
            type: PersonType::Student,
            model: $scored[0][0],
            nameScore: $scored[0][1],
            ocrConfidence: $scored[0][2] * 100,
            flags: [FlagReason::MatchedByNameOnly],
        );
    }

    private function visitor(OcrResult $ocr, string $idType): Identity
    {
        $visitor = new Identity(
            type: PersonType::Visitor,
            ocrConfidence: $ocr->meanConfidence * 100,
            idType: $idType,
        );

        $name = $idType === 'National ID' ? $this->parser->nationalId($ocr->lines) : null;
        if (!$name) {
            return $visitor;   // guard reads the ID image
        }

        $mi = isset($name['middle']) ? ' ' . Str::substr($name['middle']['value'], 0, 1) . '.' : '';
        $visitor->visitorName = "{$name['last']['value']}, {$name['given']['value']}{$mi}";
        $visitor->ocrConfidence = min($name['last']['conf'], $name['given']['conf']) * 100;

        $needle = $name['given']['value'] . ' ' . $name['last']['value'];
        $hits = Guardian::all()
            ->map(fn ($g) => [$g, Names::ratio($needle, "{$g->first_name} {$g->last_name}")])
            ->filter(fn ($x) => $x[1] >= config('verifigate.thresholds.guardian_min'))
            ->sortByDesc(fn ($x) => $x[1])
            ->values();

        if ($hits->count() === 1) {
            $visitor->model = $hits[0][0];
            $visitor->nameScore = $hits[0][1];
        } elseif ($hits->count() > 1) {
            $visitor->flags[] = FlagReason::AmbiguousMatch;   // never guess between two guardians
        }

        return $visitor;
    }
}
