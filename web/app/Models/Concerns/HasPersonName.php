<?php

namespace App\Models\Concerns;

use Illuminate\Support\Str;

trait HasPersonName
{
    /** "LAST, FIRST M." (+ suffix), the format used on the guard screen. */
    public function displayName(): string
    {
        $mi = $this->middle_name
            ? ' ' . Str::upper(Str::substr($this->middle_name, 0, 1)) . '.'
            : '';

        return "{$this->last_name}, {$this->first_name}{$mi}"
            . ($this->suffix ? " {$this->suffix}" : '');
    }
}
