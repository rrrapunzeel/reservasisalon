<?
namespace App\Models;

use Illuminate\Database\Eloquent\Model;


use Illuminate\Database\Eloquent\Factories\HasFactory;

class Perawatan extends Model
{
    use HasFactory;

    protected $table = 'perawatan';

    protected $fillable = ['id_perawatan', 'id_kategori', 'nama_perawatan', 'harga_perawatan'];

   
    public function kategori()
    {
        return $this->belongsTo(Kategori::class, 'id_kategori');
    }
    
}
