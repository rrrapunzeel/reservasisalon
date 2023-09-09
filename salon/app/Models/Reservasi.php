<?php

namespace App\Http\Models;

use Illuminate\Database\Eloquent\Model;

class Reservasi extends Model
{
    protected $table = 'reservasi';

    protected $fillable = [
        'id',
        'id_reservasi',
        'id_pegawai',
        'item_perawatan',
        'date',
        'time_slot',
        // other columns in the "reservasi" table
    ];

    // Relationships
    public function pembayaran()
    {
        return $this->belongsTo(Pembayaran::class);
    }

    // Additional methods or attributes specific to the Reservasi entity
}
