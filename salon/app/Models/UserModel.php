<?php
namespace App;

use Illuminate\Database\Eloquent\Model;

class UserModel extends Model
{
    protected $table = 'users'; // Nama tabel di database
    protected $primaryKey = 'id'; // Nama kolom kunci utama

    protected $fillable = [
        'name', 'email', 'password', // Daftar atribut yang dapat diisi secara massal (mass assignment)
    ];

    protected $hidden = [
        'password', 'remember_token', // Daftar atribut yang akan disembunyikan saat di-serialize
    ];

    public function getFullNameAttribute()
{
    return $this->first_name . ' ' . $this->last_name;
}
}