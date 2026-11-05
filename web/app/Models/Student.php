<?php

namespace App\Models;

use App\Models\Concerns\HasPersonName;
use Illuminate\Database\Eloquent\Model;

class Student extends Model
{
    use HasPersonName;
    public function section() {
        return $this->belongsTo(Section::class);
    }
}
