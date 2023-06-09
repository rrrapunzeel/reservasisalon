<?php


namespace App\Http\Models;

use Illuminate\Database\Eloquent\Model;

class pegawai extends Model
{
    protected $table = 'address';
    public $primaryKey = 'address_id';
    public $timestamps = true;

    public function user()
    {
        return $this->belongsTo('App\User');
    }
}