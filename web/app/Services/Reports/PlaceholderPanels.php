<?php

namespace App\Services\Reports;

/** Hard-coded until the Event and Uniform Exception modules exist. Replace this class, not its callers. */
final class PlaceholderPanels
{
    /** @return array{active: bool, name: ?string, date: ?string, attendees: ?int, capacity: ?int} */
    public function eventStatus(): array
    {
        return ['active' => false, 'name' => null, 'date' => null, 'attendees' => null, 'capacity' => null];
    }

    /** @return list<array{label: string, exceptions: list<array{name: string, info: bool}>}> */
    public function uniformExceptions(): array
    {
        return [
            ['label' => 'PE 114', 'exceptions' => [
                ['name' => 'P.E. Uniform', 'info' => true],
                ['name' => 'White t-shirt', 'info' => false],
            ]],
            ['label' => 'ITE Acquaintance Party', 'exceptions' => [
                ['name' => 'ITE Department Shirt', 'info' => true],
            ]],
            ['label' => 'CE 112', 'exceptions' => [
                ['name' => 'Civil Engineering Department Shirt', 'info' => true],
            ]],
        ];
    }
}
