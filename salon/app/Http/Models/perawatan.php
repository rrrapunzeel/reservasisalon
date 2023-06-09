<?php

namespace App\Http\Models;

use Illuminate\Database\Eloquent\Model;

class Perawatan extends Model
{
    protected $table = 'perawatan';

    protected $fillable = [
        'id_kategori',
        'nama_perawatan',
        'harga_perawatan',
    ];

    // Define a relationship with the Kategori model if it exists
    public function kategori()
    {
        return $this->belongsTo(Kategori::class, 'id_kategori');
    }

    // Add other methods or custom logic as needed
}
