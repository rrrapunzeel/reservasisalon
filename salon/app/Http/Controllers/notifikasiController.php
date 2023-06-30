<?php

namespace App\Http\Controllers;

use GuzzleHttp\Client;
use Illuminate\Routing\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\DB;


class NotifikasiController extends Controller
{
    private $supabase;
    public function __construct()
    {
        $supabaseUrl = 'https://fuzdyyktvczvrbwrjkhe.supabase.co';
        $supabaseKey =  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzI0MTA4ODcsImV4cCI6MTk4Nzk4Njg4N30.kMVUSwTCDMLEM-8ePXPXniT62zkB75Q3gvyvuAbkibU';
        $supabaseOptions = [
            'apiUrl' => $supabaseUrl,
            'apiKey' => $supabaseKey,
        ];
        $this->supabase = new Client($supabaseOptions);
    }

    public function sendNotification(Request $request)
    {
        $data = $request->all();
        $playerIds = $data['player_ids'];
        $title = $data['title'];
        $body = $data['body'];

        $notification = [
            'app_id' => '98ce4c83-acb4-4667-ad2f-f628488fb3f2',
            'include_player_ids' => $playerIds,
            'headings' => [
                'en' => $title,
            ],
            'contents' => [
                'en' => $body,
            ],
        ];

        $response = Http::withHeaders([
            'Authorization' => 'Basic YzY0OWNlYzctNzYyNy00Y2Q1LWEyMjMtMDZiM2IxZjE1ODhh',
            'Content-Type' => 'application/json',
        ])->post('https://onesignal.com/api/v1/notifications', $notification);

        if ($response->successful()) {
            // Notifikasi berhasil dikirim, update status notifikasi di Supabase
            $updateResponse = $this->supabase->post('/rest/v1/pembayaran', [
                'json' => [
                    'notification' => true,
                ],
            ]);

            if ($updateResponse->getStatusCode() === 200) {
                return response()->json(['message' => 'Notification sent successfully']);
            } else {
                return response()->json(['message' => 'Failed to update notification status'], 500);
            }
        } else {
            // Gagal mengirim notifikasi
            return response()->json(['message' => 'Failed to send notification'], 500);
        }
    }
}