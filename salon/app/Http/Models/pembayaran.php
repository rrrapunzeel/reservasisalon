<?php
namespace App\Http\Models;

use Illuminate\Database\Eloquent\Model;

class Pembayaran extends Model
{
    protected $table = 'pembayaran';

    protected $fillable = [
        'nama',
        'email',
        'total',
        'snap_token',
        'transaction_status',
        'items',
    ];
    public function reservasi()
    {
        return $this->hasOne(Reservasi::class);
    }
}
