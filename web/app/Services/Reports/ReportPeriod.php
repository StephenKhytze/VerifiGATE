<?php

namespace App\Services\Reports;

use App\Enums\Reports\Period;
use App\Support\SchoolClock;
use Carbon\CarbonInterface;

/** One selected period: its Manila date range, labels and chart buckets. */
final class ReportPeriod
{
    /** @param CarbonInterface $start inclusive, school time; $end exclusive, school time */
    private function __construct(
        public readonly Period $period,
        public readonly CarbonInterface $start,
        public readonly CarbonInterface $end,
    ) {
    }

    public static function for(Period $period, ?CarbonInterface $at = null): self
    {
        $day = SchoolClock::startOfDay($at);

        return match ($period) {
            Period::Daily => new self($period, $day, $day->copy()->addDay()),
            Period::Weekly => self::weekly($day),
            Period::Monthly => self::monthly($day),
        };
    }

    private static function weekly(CarbonInterface $day): self
    {
        $start = $day->copy()->startOfWeek(CarbonInterface::MONDAY);

        return new self(Period::Weekly, $start, $start->copy()->addWeek());
    }

    private static function monthly(CarbonInterface $day): self
    {
        $start = $day->copy()->startOfMonth();

        return new self(Period::Monthly, $start, $start->copy()->addMonth());
    }

    public function queryStart(): CarbonInterface
    {
        return SchoolClock::forQuery($this->start);
    }

    public function queryEnd(): CarbonInterface
    {
        return SchoolClock::forQuery($this->end);
    }

    public function title(): string
    {
        return $this->period->label() . ' Report';
    }

    public function subtitle(): string
    {
        return match ($this->period) {
            Period::Daily => 'today',
            Period::Weekly => 'this week',
            Period::Monthly => 'this month',
        };
    }

    public function rangeLabel(): string
    {
        $last = $this->end->copy()->subDay();

        return match ($this->period) {
            Period::Daily => $this->start->format('l, F j, Y'),
            Period::Weekly => $this->start->format('M j') . ' – ' . $last->format('M j, Y'),
            Period::Monthly => $this->start->format('F Y'),
        };
    }

    /**
     * Chart x-axis: 24 hours for Daily, one bucket per day otherwise, skipping Sundays.
     *
     * @return list<array{key: string, label: string}>
     */
    public function buckets(): array
    {
        if ($this->period === Period::Daily) {
            return array_map(fn (int $hour) => [
                'key' => sprintf('%02d', $hour),
                'label' => $this->start->copy()->setTime($hour, 0)->format('ga'),
            ], range(0, 23));
        }

        $buckets = [];
        for ($day = $this->start->copy(); $day->lt($this->end); $day = $day->copy()->addDay()) {
            if ($day->dayOfWeekIso === 7) {
                continue;
            }
            $buckets[] = [
                'key' => $day->format('Y-m-d'),
                'label' => $this->period === Period::Weekly ? $day->format('D') : $day->format('j'),
            ];
        }

        return $buckets;
    }

    /** Which bucket an instant falls in, or null when it is outside the period or on a Sunday. */
    public function bucketKey(CarbonInterface $at): ?string
    {
        $local = SchoolClock::local($at);

        if ($local->lt($this->start) || $local->gte($this->end)) {
            return null;
        }
        if ($this->period === Period::Daily) {
            return $local->format('H');
        }

        return $local->dayOfWeekIso === 7 ? null : $local->format('Y-m-d');
    }

    /** What the page receives. */
    public function toArray(): array
    {
        return [
            'key' => $this->period->value,
            'label' => $this->period->label(),
            'title' => $this->title(),
            'subtitle' => $this->subtitle(),
            'range' => $this->rangeLabel(),
        ];
    }
}
