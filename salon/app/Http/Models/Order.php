<?php
namespace App\Http\Models;

use Illuminate\Database\Eloquent\Model;
use App\Mail\OrderConfirmationMail;
use App\Mail\PaymentReceiptMail;
use Illuminate\Support\Facades\Mail;

class Order extends Model
{
    protected $table = 'orders';

    protected $fillable = [
        'order_number',
        'customer_id',
        'status',
        // Kolom-kolom lain yang ada dalam tabel orders
    ];

    // Relasi dengan model Customer
    public function customer()
    {
        return $this->belongsTo(Customer::class);
    }
    
    // Relasi dengan model OrderItem
    public function orderItems()
    {
        return $this->hasMany(OrderItem::class);
    }

    // Metode atau fungsi lain yang berhubungan dengan model Order

    public static function createOrder($request, $snapToken, $transaction)
    {
        $order = new Order();
        $order->order_number = uniqid();
        $order->customer_id = $request->customer_id;
        $order->status = 'pending';
        $order->save();

        $perawatan = $request->input('perawatan');

        foreach ($perawatan as $item) {
            $orderItem = new OrderItem();
            $orderItem->order_id = $order->id;
            $orderItem->perawatan_id = $item['id_perawatan'];
            $orderItem->harga_perawatan = $item['harga_perawatan'];
            $orderItem->nama_perawatan = $item['nama_perawatan'];
            $orderItem->save();
        }

        // Kirim email konfirmasi
        Mail::to($order->customer->email)->send(new OrderConfirmationMail($order));

        // Simpan pembayaran
        $pembayaran = new Pembayaran();
        $pembayaran->order_id = $order->id;
        $pembayaran->snap_token = $snapToken;
        $pembayaran->transaction_status = $transaction;
        $pembayaran->save();

        return $order;
    }

    public static function updateOrderStatus($orderId, $status)
    {
        $order = self::findOrFail($orderId); // Menggunakan self:: untuk merujuk ke class saat ini
        $order->status = $status;
        $order->save();
    }
}
