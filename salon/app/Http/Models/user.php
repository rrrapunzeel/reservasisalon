<?php


namespace App\Http\Models;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class User extends Model
{
    use HasFactory;

    protected $table = 'user'; // Name of the table

    protected $fillable = [
        'id',
        'updated_at',
        'email',
        'nama',
        'avatar_url',
        'nomor_telepon',
        'role',
        'status',
    ];

    // Optional: If your primary key is not "id" column, specify it here
    // protected $primaryKey = 'custom_id';

    // Optional: If you don't have timestamps columns in the table, set this to false
    // public $timestamps = false;
}
