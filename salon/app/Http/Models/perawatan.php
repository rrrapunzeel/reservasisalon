<?
namespace App\Http\Models;

use Illuminate\Database\Eloquent\Model;

class Perawatan extends Model
{
    protected $table = 'perawatan'; // Nama tabel perawatan di database

    // Daftar kolom yang dapat diisi
    protected $fillable = [
        'id_kategori',
        'nama_perawatan',
        'harga_perawatan',
    ];

    // Relasi dengan model Kategori
    public function kategori()
    {
        return $this->belongsTo(Kategori::class, 'id_kategori');
    }
}
