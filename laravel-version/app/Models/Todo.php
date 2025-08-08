<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Todo extends Model
{
    protected $fillable = [
        'title',
        'description',
        'completed',
        'due_date',
        'completed_at'
    ];

    protected $casts = [
        'completed' => 'boolean',
        'due_date' => 'datetime',
        'completed_at' => 'datetime'
    ];
}
