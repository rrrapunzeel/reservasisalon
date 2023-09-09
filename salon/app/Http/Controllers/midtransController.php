<?php

namespace App\Http\Controllers;

use App\Mail\InvoiceEmail; 

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;
use Illuminate\Support\Facades\Mail;
use SendGrid\Mail\Mail as SendGridMail;
use SendGrid\Mail\From as SendGridFrom;
use SendGrid\Mail\To as SendGridTo;
use SendGrid\Mail\Content as SendGridContent;
use SendGrid\Mail\Subject as SendGridSubject;
use SendGrid\Mail\PlainTextContent as SendGridPlainTextContent;
use SendGrid\Mail\HtmlContent as SendGridHtmlContent;
use SendGrid\Mail\Attachment as SendGridAttachment;
use SendGrid\Mail\Personalization as SendGridPersonalization;
use SendGrid\Mail\Email as SendGridEmail;
use SendGrid;
use DateInterval;
use SendGrid\Mail\To;
use Carbon\Carbon;
use DateTime;
use DateTimeZone;
use Google_Client;
use Illuminate\Http\Request;
use App\Http\Controllers\GoogleCalendarController;
use Illuminate\Http\Client\RequestException;
use GuzzleHttp\Client;
use App\Http\Controllers\calendarController;
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
use Spatie\GoogleCalendar\Event;
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
            "tanggal" => $tanggal,
            "pegawai" => $pegawai,
        ];
    
        $snapToken = Veritrans_Snap::getSnapToken($payload);

        $client = new Client();
        $headers = [
            'apikey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
            'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
            'Content-Type' => 'application/json',
            'Prefer' => 'return=representation'
        ];


        $response = $client->request('post', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/pembayaran', [
            'headers' => $headers,
            'json' => [
            'nama' => $nama,
            'email' => $email,
            'total' => $total,
            'items' => $items,
            'snap_token'=>$snapToken,
            'transaction_id' => $transactionId,
            'transaction_status' => 'Menunggu Pembayaran',
            'pegawai'=>$pegawai,
            'jam'=>$jam,
            'tanggal'=>$tanggal,
            ]
        ]);

        return response()->json(['snap_token' => $snapToken]);
    }

    public function notificationHandler(Request $request)
    {
        $orderId = $request->input('order_id');
        $transaction = $request->input('transaction_status');
        $email = $request->input('email');
        $selectedDateTime = $request->input('selectedDateTime');
        $nama = $request->input('nama');
        $items = $request->input('items');
        $pegawai = $request->input('pegawai');
        $total = $request->input('total');
    
        $client = new Client();
        $endpoint = 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/pembayaran';
        $headers = [
            'apikey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
            'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
            'Content-Type' => 'application/json',
            'Prefer' => 'return=minimal'
        ];
    
        $queryParams = [
            'select' => '*',
            'transaction_id' => 'eq.' . $orderId
        ];
    
        $response = $client->request('GET', $endpoint, [
            'headers' => $headers,
            'query' => $queryParams
        ]);
    
        $statusCode = $response->getStatusCode();
        $responseData = json_decode($response->getBody(), true);
    
            try {
                if ($transaction === 'pending') {
                    $response = $client->request('PATCH', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/pembayaran?transaction_id=eq.' . $orderId, [
                        'headers' => $headers,
                        'json' => [
                            'transaction_status' => 'Tertunda'
                        ]
                    ]);
                    return "Transaction status updated successfully: pending. Transaction ID : $orderId";
    
                } elseif ($transaction === 'settlement') {
                    $response = $client->request('PATCH', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/pembayaran?transaction_id=eq.' . $orderId, [
                        'headers' => $headers,
                        'json' => [
                            'transaction_status' => 'Berhasil'
                        ]
                    ]);
    
                    $queryParams = [
                        'select' => 'tanggal,jam,email,nama,pegawai,items,total',
                        'transaction_id' => 'eq.' . $orderId
                    ];
                    
                    $response = $client->request('GET', $endpoint, [
                        'headers' => $headers,
                        'query' => $queryParams
                    ]);
                    
                    $responseData = json_decode($response->getBody(), true);

                    if (!empty($responseData)) {
                        $selectedDateTime = $responseData[0]['tanggal'] . 'T' . $responseData[0]['jam'] . '-05:00';
                        $email = $responseData[0]['email'];
                        $nama = $responseData[0]['nama'];
                        $pegawai = $responseData[0]['pegawai'];
                        $total = $responseData[0]['total'];
                    
                        // Check if 'items' key exists in the data and it is an array
                        if (isset($responseData[0]['items']) && is_array($responseData[0]['items'])) {
                            $items = $responseData[0]['items'];
                        } else {
                            // Handle the case when 'items' data is not available or not in the expected format
                            $items = [];
                        }
                        } else {
                            // Handle case when no data is returned
                            $selectedDateTime = null; // or set a default value
                            $email = null; 
                            $nama = null; 
                            $items = [];
                            $pegawai = null;
                            $total = null; // or set a default value
                        }

                        $this->sendEmail($email, $orderId, $selectedDateTime, $items, $pegawai, $total, $nama);
                        $this->addGoogleCalendar($orderId, $email, $selectedDateTime);
                        
                        // Render the view and pass the data to it
                        return view('emails.email_template', [
                            'nama' => $nama,
                            'orderId' => $orderId,
                            'items' => $items,
                            'pegawai' => $pegawai,
                            'selectedDateTime' => $selectedDateTime,
                            'total' => $total,
                            'email' => $email,
                        ]);
                        
                    return "Transaction status updated successfully: settlement. Transaction ID : $orderId | Selected Date $selectedDateTime | Email : $email" ;
                } elseif ($transaction === 'expire') {
                    $response = $client->request('PATCH', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/pembayaran?transaction_id=eq.' . $orderId, [
                        'headers' => $headers,
                        'json' => [
                            'transaction_status' => 'Gagal'
                        ]
                ]);
        
                    return "Transaction status updated successfully : expire. Transaction ID : $orderId";
                } else {
                    return "Failed to update transaction status. Response code: ";
                }
            } catch (RequestException $e) {
                return "Error: " . $e->getMessage();
            }
        }
        
        public function addGoogleCalendar($orderId, $email, $selectedDateTimeString)
        {
                 $email = $this->getEmailFromDatabase($orderId);
        
                 if (!$email) {
                     return response()->json(['message' => 'Email not found in the database'], 404);
                 }
            $selectedDateTime = DateTime::createFromFormat('Y-m-d\TH:i:sP', $selectedDateTimeString);
            
            if ($selectedDateTime instanceof DateTime) {
                $formattedDateTime = $selectedDateTime->format('Y-m-d\TH:i:s');
                $endDateTime = clone $selectedDateTime;
                $endDateTime->add(new DateInterval('PT1H'));
            
                $client = new Google_Client();
                $client->setAuthConfig('C:/xampp/htdocs/salon/salon/salon/assets/challista-beauty-salon-calendar.json');
                $client->addScope(Google_Service_Calendar::CALENDAR_EVENTS);
        
                $service = new Google_Service_Calendar($client);
            
                $event = new Google_Service_Calendar_Event([
                    'summary' => 'Challista Beauty Salon',
                    'description' => 'Jangan lupa untuk treatment di Challista Beauty Salon ya!',
                    'start' => [
                        'dateTime' => $formattedDateTime,
                        'timeZone' => 'Asia/Bangkok',
                    ],
                    'end' => [
                        'dateTime' => $endDateTime->format('Y-m-d\TH:i:s'),
                        'timeZone' => 'Asia/Bangkok',
                    ],
                ]);
            
                // Get the calendar ID associated with the user's email
                $matchingCalendarId = $this->getCalendarIdByEmail($email);
            
                // Check if a matching calendar ID is found
                if (!$matchingCalendarId) {
                    return response()->json(['message' => 'Calendar ID not found for the given email'], 404);
                }
            
                // Insert event to Google Calendar
                $calendarId = $matchingCalendarId; // Ganti dengan ID Kalender yang sesuai
                $event = $service->events->insert($calendarId, $event);
     // Return response
                return response()->json([
                    'message' => 'Event added to Google Calendar',
                    'eventId' => $event->id,
                ]);
            } else {
                return response()->json(['message' => 'Invalid DateTime'], 400);
            }
        }
    
    // public function addGoogleCalendar($orderId, $email, $selectedDateTimeString)
    // {
    //          // Get the email from the database based on the orderId
    //          $email = $this->getEmailFromDatabase($orderId);
    
    //          // Check if email is found
    //          if (!$email) {
    //              return response()->json(['message' => 'Email not found in the database'], 404);
    //          }
    //     // Ubah string menjadi objek DateTime
    //     $selectedDateTime = DateTime::createFromFormat('Y-m-d\TH:i:sP', $selectedDateTimeString);
        
    //     if ($selectedDateTime instanceof DateTime) {
    //         $formattedDateTime = $selectedDateTime->format('Y-m-d\TH:i:s');
    //         $endDateTime = clone $selectedDateTime;
    //         $endDateTime->add(new DateInterval('PT1H'));
        
    //         $client = new Google_Client();
    //         $client->setAuthConfig('C:/xampp/htdocs/salon/salon/salon/assets/challista-beauty-salon-calendar.json');
    //         $client->addScope(Google_Service_Calendar::CALENDAR_EVENTS);
    
    //         $service = new Google_Service_Calendar($client);

    //         // Get the access token from your database based on the user's email
    //         $accessTokenJson = $this->getAccessTokenFromDatabase($email);
    //         $accessToken = json_decode($accessTokenJson, true);

    //         if (!$accessToken) {
    //             // Redirect the user to grant access again if the access token is not found
    //             $authUrl = $client->createAuthUrl();
    //             return redirect()->away($authUrl);
    //         }

    //         // Set the access token for the client
    //         $client->setAccessToken($accessToken);
        
    //         $event = new Google_Service_Calendar_Event([
    //             'summary' => 'Challista Beauty Salon',
    //             'description' => 'Jangan lupa untuk treatment di Challista Beauty Salon ya!',
    //             'start' => [
    //                 'dateTime' => $formattedDateTime,
    //                 'timeZone' => 'Asia/Bangkok',
    //             ],
    //             'end' => [
    //                 'dateTime' => $endDateTime->format('Y-m-d\TH:i:s'),
    //                 'timeZone' => 'Asia/Bangkok',
    //             ],
    //         ]);
        
    //         // Get the calendar ID associated with the user's email
    //         $matchingCalendarId = $this->getCalendarIdByEmail($email);
        
    //         // Check if a matching calendar ID is found
    //         if (!$matchingCalendarId) {
    //             return response()->json(['message' => 'Calendar ID not found for the given email'], 404);
    //         }
        
    //         // Insert event to Google Calendar
    //         $calendarId = $matchingCalendarId; // Ganti dengan ID Kalender yang sesuai
    //         $event = $service->events->insert($calendarId, $event);
        
    //         // Return response
    //         return response()->json([
    //             'message' => 'Event added to Google Calendar',
    //             'eventId' => $event->id,
    //         ]);
    //     } else {
    //         return response()->json(['message' => 'Invalid DateTime'], 400);
    //     }
    // }
    
    public function getCalendarIdByEmail($email)
    {
        return $email;
    }


public function googleCalendarCallback(Request $request)
{
    $client = new GoogleClient();
    $client->setAuthConfig('C:\xampp\htdocs\salon\salon\salon\assets\google-calendar-credentials.json');
    $client->setAccessType('offline');

    $redirectUri = 'https://ffff-202-80-216-225.ngrok-free.app/google-calendar-callback';
    $client->setRedirectUri($redirectUri);

    $authCode = $request->input('code');

    // Exchange authorization code for access token
    $accessToken = $client->fetchAccessTokenWithAuthCode($authCode);

    // Get the user's email from the database based on the orderId
    $orderId = $request->input('state'); // Assuming 'state' parameter contains the orderId
    $email = $this->getEmailFromDatabase($orderId);

    if ($email) {
        $accessTokenJson = json_encode($accessToken);

        // Save $accessTokenJson to your database associated with the user's email for future use
        $this->saveAccessTokenToDatabase($email, $accessTokenJson);

    // Continue with event creation
    $selectedDateTimeString = $request->session()->get('selectedDateTimeString'); // Assuming you stored selectedDateTimeString in the session
    $this->addGoogleCalendar($orderId, $email, $selectedDateTimeString);

    return redirect()->route('success')->with('message', 'Authorization successful. You can now create the event.');
    } else {
        return response()->json(['message' => 'Email not found in the database'], 404);
    }
}


    public function getEmailFromDatabase($orderId)
{
    $response = \Illuminate\Support\Facades\Http::withHeaders([
        'apikey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
        'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
    ])->get('https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/pembayaran', [
        'select' => 'email',
        'transaction_id' => 'eq.' . $orderId
    ]);

    if ($response->status() === 200) {
        $data = $response->json();

        if (!empty($data) && count($data) > 0) {
            return $data[0]['email'];
        }
    }

    return null;
}
public function sendEmail($email, $orderId, $selectedDateTime, $items, $pegawai, $total, $nama)
{
    // Customize the email content
    $message = "Invoice for Reservation\n\n";
    $message .= "Order ID: $orderId\n";
    $message .= "Selected Date: $selectedDateTime\n";
    $message .= "Items:\n";

    // Format the items using the updated method that handles null gracefully
    $formattedItems = $this->formatItems($items);

    // Use the Mailable class to send the email and pass data to the view
    Mail::to($email)->send(new InvoiceEmail($orderId, $selectedDateTime, $items, $email, $pegawai, $total, $nama));
    
    // The email is sent automatically by Laravel's Mail facade using SendGrid as the driver.
    // You don't need to manually call the SendGrid API.

    // Return a success message
    return "Invoice email sent successfully to: $email";
}

public function formatItems($items)
{
    if (is_array($items) || is_object($items)) {
        $formattedItems = "";
        foreach ($items as $item) {
            $formattedItems .= "<li>" . $item['name'] . "</li>";
        }
        return $formattedItems;
    } else {
        return "<li>No items to display</li>";
    }
}

    public function sendTransactionStatusToFlutter($orderId, $transactionStatus)
    {
        
        $client = new Client();
        
        try {
            $response = $client->post([
                'json' => [
                    'order_id' => $orderId,
                    'transaction_status' => $transactionStatus,
                ]
            ]);
        
            if ($response->getStatusCode() === 200) {
                return "Transaction status sent successfully to Flutter.";
            } else {
                return "Failed to send transaction status to Flutter. Response code: " . $response->getStatusCode();
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
        $response = $client->request('GET', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/pembayaran?select=id,transaction_id,nama,items,total,transaction_status,metode_pelunasan&order=updated_at.asc', [
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

    $transaction_status = $request->transaction_status;
    $metode_pelunasan = $request->metode_pelunasan;

    $response = $client->request('GET', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/pembayaran?id=eq.' . $id, [
        'headers' => $headers,
    ]);
    $pembayarans = json_decode($response->getBody(), true);

    if (!empty($pembayarans) && count($pembayarans) > 0) {
        $pembayaran = $pembayarans[0];
        // Mengupdate data jika ditemukan
        $response = $client->request('GET', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/pembayaran?id=eq.' . $pembayaran['id'], [
            'headers' => $headers,
            'json' => [
                'transaction_status' => $transaction_status,
                'metode_pelunasan' => $metode_pelunasan,
            ]
        ]);
            return view('pembayaran.update', compact('pembayaran', 'pembayarans'))->with('success', 'Pembayaran berhasil diperbarui');
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

        $transaction_status = $request->transaction_status;
        $metode_pelunasan = $request->metode_pelunasan;
        $total = $request->total;
    
        $response = $client->request('GET', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/pembayaran?id=eq.' . $id, [
            'headers' => $headers,
        ]);
        $pembayarans = json_decode($response->getBody(), true);
    
        if (!empty($pembayarans) && count($pembayarans) > 0) {
            $pembayaran = $pembayarans[0];
    
            // Check if the transaction_status is changed to "Lunas"
            if ($transaction_status === 'Lunas') {
                // Double the total value
                $total = $pembayaran['total'] * 2;
            } else {
                // Keep the original total value
                $total = $pembayaran['total'];
            }
    
            // Update the data
            $response = $client->request('PATCH', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/pembayaran?id=eq.' . $pembayaran['id'], [
                'headers' => $headers,
                'json' => [
                    'transaction_status' => $transaction_status,
                    'metode_pelunasan' => $metode_pelunasan,
                    'total' => $total,
                ],
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
