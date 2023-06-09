<?php

namespace App\Http\Controllers;


use Illuminate\Http\Request;
use App\Http\Models\Pembayaran;
use App\Http\Models\reservasi;
use App\Http\Requests;
use App\Http\Controllers\Controller;
use App\Http\Models\Order;
use App\Mail\OrderConfirmationMail;
use App\Mail\PaymentReceiptMail;
use Illuminate\Contracts\Mail\Mailable;
use Illuminate\Support\Facades\Mail;
use Veritrans_Config;
use Veritrans_Snap;
use Veritrans_Notification;
use GuzzleHttp\Client;

class MidtransController extends Controller
{
    public function __construct()
    {
        Veritrans_Config::$serverKey = config('services.midtrans.serverKey');
        Veritrans_Config::$isProduction = config('services.midtrans.isProduction');
        Veritrans_Config::$isSanitized = config('services.midtrans.isSanitized');
        Veritrans_Config::$is3ds = config('services.midtrans.is3ds');
    }

    public function snap(Request $request)
    {
        return view('midtrans', ["token" => $request->token]);
    }

    public function midtranspayment(Request $request)
    {
        $items = [];
        $nama = $request->input('nama');
        $email = $request->input('email');
        $perawatan = $request->input('perawatan');
        $total = $request->input('total');

        foreach ($perawatan as $item) {
            $items[] = [
                "id" => $item['id_perawatan'],
                "price" => $item['harga_perawatan'],
                "quantity" => 1,
                "name" => $item['nama_perawatan']
            ];
        }

        $transactionId = uniqid();

        $payload = [
            'transaction_details' => [
                'order_id' => $transactionId,
                'gross_amount'  => intval($total),
            ],
            'customer_details' => [
                'first_name'    => $nama,
                'email'         => $email,
            ],
            "item_details" => $items,
        ];

        $snapToken = Veritrans_Snap::getSnapToken($payload);

        $this->insertPembayaran($request, $snapToken, '', $items);

        return response()->json(['snap_token' => $snapToken]);
    }

    public function notificationHandler(Request $request)
    {
        $data = $request->all();
        $transaction = $data['transaction_status'];
        $orderId = $data['order_id'];
    
        if ($transaction == 'capture' || $transaction == 'settlement') {
            // Update order status to 'paid'
            Order::updateOrderStatus($orderId, 'paid');
    
            // Send order confirmation and payment receipt emails
            $order = Order::findOrFail($orderId);
            Mail::to($order->customer->email)->send(new OrderConfirmationMail($order));
            Mail::to($order->customer->email)->send(new PaymentReceiptMail($order));
        } elseif ($transaction == 'pending') {
            // Update order status to 'pending'
            Order::updateOrderStatus($orderId, 'pending');
        }
    
        // Insert pembayaran into Supabase
        $this->insertPembayaran($request, '', $transaction, '');
    
        $response = $this->checkNotificationEndpoint($request->url());
    
        if ($response->getStatusCode() === 200) {
            return response()->json(['status' => 'success']);
        } else {
            return response()->json(['status' => 'error', 'message' => 'Notification endpoint unreachable']);
        }
    }
    
    private function checkNotificationEndpoint($endpoint)
{
    $client = new Client();

    try {
        $response = $client->get($endpoint);
        return $response;
    } catch (\Exception $e) {
        return $e->getResponse();
    }
}
    
    public function insertPembayaran($request, $snapToken, $transaction, $items)
    {
        $client = new Client();
        $headers = [
            'apikey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
            'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
            'Content-Type' => 'application/json',
            'Prefer' => 'return=minimal'
        ];

        $nama = $request->nama;
        $email = $request->email;
        $total = $request->total;

        $response = $client->request('POST', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/pembayaran', [
            'headers' => $headers,
            'json' => [
    
                'nama' => $nama,
                'email' => $email,
                'total'=>$total,
                'items' => $items,
                'snap_token' => $snapToken,
                'transaction_status' => $transaction,
                ]
            ]);
            return $response->getBody();
        }

        public function selectPembayaran(Request $request) {
             $client = new Client();
        $headers = [
            'apikey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
            'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
            'Content-Type' => 'application/json',
            'Prefer' => 'return=minimal'
        ];
    
            $response = $client->request('GET', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/pembayaran?select=*', [
                'headers' => $headers
            ]);
            return $response->getBody();
        }
    }
    