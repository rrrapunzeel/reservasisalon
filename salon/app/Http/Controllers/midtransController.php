<?php

namespace App\Http\Controllers;

use Google\Task\Exception;
use Illuminate\Http\Client\RequestException;
use Illuminate\Http\Request;
use SendGrid\Mail\Mail;
use App\Http\Controllers\CalendarController;
use App\Http\Models\Pembayaran;
use App\Http\Models\reservasi;
use App\Http\Requests;
use App\Http\Controllers\Controller;
use App\Http\Models\Order;
use App\Mail\OrderConfirmationMail;
use App\Mail\PaymentReceiptMail;
use Illuminate\Contracts\Mail\Mailable;
use Veritrans_Config;
use Veritrans_Snap;
use Veritrans_Notification;
use GuzzleHttp\Client;
use Spatie\GoogleCalendar\Event;
use Carbon\Carbon;
use Google_Service_Calendar;
use Google_Service_Calendar_Event;
use Google\Client as GoogleClient;
use Google\Service\Calendar as GoogleCalendar;

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
        $jam = $request->input('jam');
        $pegawai = $request->input('pegawai');
        $tanggal = $request->input('tanggal');
    
        foreach ($perawatan as $item) {
            $items[] = [
                "id" => $item['id_perawatan'],
                "price" => $item['harga_perawatan'],
                "quantity" => 1,
                "name" => $item['nama_perawatan'], 
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
            "pegawai" => $pegawai,
            "tanggal" => $tanggal,
            "jam" => $jam
        ];
    
        $snapToken = Veritrans_Snap::getSnapToken($payload);

        return response()->json(['snap_token' => $snapToken]);
    }

    public function insertPembayaran(Request $request)
    {
        {
            $client = new Client();
            $headers = [
                'apikey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
                'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
                'Content-Type' => 'application/json',
                'Prefer' => 'return=representation'
            ];
            $pegawai = $request->pegawai;
            $jam = $request->jam;
            $tanggal = $request->tanggal;
            $nama = $request->nama;
            $email = $request->email;
            $total = $request->total;
            $items = $request->items;
            $transactionId = $request->transaction_id;
            $transaction = $request->transaction_status;


                // Check if the transaction ID is valid
                if (!is_numeric($transactionId)) {
                    return response()->json(['message' => 'Invalid transaction ID.'], 400);
                }
    
                $newPayment = [
                    'nama' => $nama,
                    'email' => $email,
                    'total' => $total,
                    'items' => $items,
            
                    'transaction_id' => $transactionId,
                    'transaction_status' => $transaction,
                    'pegawai'=>$pegawai,
                    'jam'=>$jam,
                    'tanggal'=>$tanggal,
                ];
                // Insert the data into Supabase
                $response = $client->from('pembayaran')->insert([$newPayment])->execute();

        if ($response['status'] === 'OK') {
            $transactionId = $response['data'][0]['id'];

            $this->sendEmail($email, $transactionId);

            return response()->json(['message' => 'Payment is successful. Order placed successfully.']);
        } else {
            return response()->json(['message' => 'Payment failed. Please try again.'], 500);
        }
    }
    }

     public function sendEmail($email, $transactionId)
    {

        $sendGridApiKey = 'SG.Tkt_nY4tTPK6G6d0M2EjEFA.C-73gAgRpdPKrnjxF_CTesWeA5Q4c5y1PgYZ2PMu9RM';
        $sendGrid = new \SendGrid($sendGridApiKey);
        $emailFrom = 'challistabeauty@salon.com';
        $emailTo = $email;
        $subject = 'Payment Confirmation';
        $message = "Thank you for your payment. Your payment ID is $transactionId.";
        
        $email = new Mail();
        $email->setFrom($emailFrom);
        $email->setSubject($subject);
        $email->addTo($emailTo);
        $email->addContent("text/plain", $message);

        try {
            $response = $sendGrid->send($email);
            echo "Email sent successfully. Status code: " . $response->statusCode();
        } catch (Exception $e) {
            echo "Error sending email: " . $e->getMessage();
        }
    }

    public function notificationHandler(Request $request)
    {
        $client = new Client();
        $headers = [
            'apikey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
            'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
            'Content-Type' => 'application/json',
            'Prefer' => 'return=minimal'
        ];
    
        $id = $request->id;
        $orderId = $request->transaction_id;
        $email = $request->email;
        $transaction = $request->transaction_status;
    
        try {
            $response = null;
    
            if ($transaction == 'capture' || $transaction == 'settlement') {
                $response = $client->request('PATCH', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/pembayaran?transaction_id=eq.' . $orderId, [
                    'headers' => $headers,
                    'json' => [
                        'transaction_status' => $transaction
                    ]
                ]);
                addToGoogleCalendar(selectedDateTime);
                $response = response()->json(['redirect_url' => 'io.supabase.flutterdemo://payment-success']);
            } elseif ($transaction == 'pending') {
                $response = $client->request('PATCH', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/pembayaran?transaction_id=eq.' . $orderId, [
                    'headers' => $headers,
                    'json' => [
                        'transaction_status' => $transaction
                    ]
                ]);
            }
    
            if ($response && $response->getStatusCode() === 200) {
                return $response;
            } else {
                return "Failed to update transaction status.";
            }
        } catch (RequestException $e) {
            return "Error: " . $e->getMessage();
        }
    }
    

    public function selectPembayaran(Request $request)
    {
        $client = new Client();
        $headers = [
        'apikey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
        'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
        'Content-Type' => 'application/json',
        'Prefer' => 'return=minimal'
        ];
        $response = $client->request('GET', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/pembayaran?select=transaction_id,nama,items,total,transaction_status', [
            'headers' => $headers
        ]);

       
        $pembayarans = json_decode($response->getBody(), true);
       
    
        return view('pembayaran.index')->with('pembayarans', $pembayarans);
    }

    public function updatePembayaran(Request $request, $id)
{
    $client = new Client();
    $headers = [
        'apikey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
        'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
        'Content-Type' => 'application/json',
        'Prefer' => 'return=minimal'
        ];

    $nama = $request->nama;
    $items = $request->items;
    $total = $request->total;
    $transaction_status = $request->transaction_status;

    $response = $client->request('GET', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/pembayaran?id=eq.' . $id, [
        'headers' => $headers,
    ]);
    $pembayarans = json_decode($response->getBody(), true);

    if (!empty($pembayarans) && count($pembayarans) > 0) {
        $pembayaran = $pembayarans[0];
        // Check if 'id' key exists in the $pembayaran array
        if (isset($pembayaran['id'])) {
            // Mengupdate data jika ditemukan
            $response = $client->request('PATCH', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/pembayaran?id=eq.' . $id, [
                'headers' => $headers,
                'json' => [
                    'nama' => $nama,
                    'items' => $items,
                    'total' => $total,
                    'transaction_status' => $transaction_status
                ]
            ]);
            return view('pembayaran.update', compact('pembayaran'))->with('success', 'Kategori berhasil diperbarui');
        }
    }
    return redirect()->back()->with('error', 'Gagal memperbarui kategori');
}

public function storeUpdate(Request $request, $id)
    {
        $client = new Client();
        $headers = [
        'apikey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
        'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
        'Content-Type' => 'application/json',
        'Prefer' => 'return=minimal'
        ];

        $nama = $request->nama;
        $items= $request->items;
        $total=$request->total;
        $transaction_status= $request->transaction_status;
    

        $response = $client->request('GET', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/pembayaran?id=eq.' .$id, [
            'headers' => $headers,
        ]);
        $pembayarans = json_decode($response->getBody(), true);

        if (!empty($pembayarans) && count($pembayarans) > 0) {
            $pembayaran = $pembayarans[0];
            // Mengupdate data jika ditemukan
            $response = $client->request('PATCH', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/pembayaran?id=eq.' . $id, [
                'headers' => $headers,
                'json' => [
                    'nama' => $nama,
                    'items' => $items,
                    'total' => $total,
                    'transaction_status' => $transaction_status
                ]
            ]);
            return redirect()->route('pembayaran.index')->with('success', 'Data berhasil disimpan');
    }
    return redirect()->back()->with('error', 'Gagal memperbarui kategori');
}

    public function deletePembayaran(Request $request, $id)
    {
        $client = new Client();
        $headers = [
        'apikey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
        'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
        'Content-Type' => 'application/json',
        'Prefer' => 'return=minimal'
        ];

        $id= $request->id;

        $response = $client->request('DELETE', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/pembayaran?id=eq.' .$id, [
            'headers' => $headers,
            'json' => [
                'id' => $id
            ]
        ]);
        return $response->getBody();
    }
}
