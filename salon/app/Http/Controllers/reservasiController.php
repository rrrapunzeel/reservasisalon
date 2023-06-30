<?php

namespace App\Http\Controllers;

use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use Illuminate\Foundation\Bus\DispatchesJobs;
use Illuminate\Foundation\Validation\ValidatesRequests;
use Illuminate\Routing\Controller as BaseController;
use Illuminate\Http\Request;
use Illumiinate\GuzzleHttp;

class reservasiController extends BaseController
{

    // create
    public function insertReservasi(Request $request)
    {
        $client = new \GuzzleHttp\Client();
        $headers = [
            'apikey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
            'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
            'Content-Type' => 'application/json',
            'Prefer' => 'return=minimal'
        ];

        $id_reservasi = $request->id_reservasi;
        $id_pegawai = $request->id_pegawai;
        $id_perawatan = $request->id_perawatan;
        $date = $request->date;
        $time_slot_id = $request->time_slot_id;
        $status_reservasi = $request->status_reservasi;

        $response = $client->Request('POST', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/reservasi', [
            'headers' => $headers,
            'json' => [
                'id_reservasi' => $id_reservasi,
                'id_pegawai' => $id_pegawai,
                'id_perawatan' => $id_perawatan,
                'time_slot_id' => $time_slot_id,
                'date'=> $date,
                'status_reservasi' => $status_reservasi
            ]
        ]);
        return $response->getBody();
    }

    // read
    public function selectReservasi(Request $request)
    {
        $client = new \GuzzleHttp\Client();
        $headers = [
            'apikey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
            'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow'
        ];
    
        $response1 = $client->request('GET', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/pembayaran?select=id_reservasi,nama,items', [
            'headers' => $headers
        ]);
        $response2 = $client->request('GET', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/time_slots?select=idPegawai,jam_perawatan', [
            'headers' => $headers
        ]);
        $response3 = $client->request('GET', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/reservasi?select=id,date', [
            'headers' => $headers
        ]);
    
        $pembayaran = json_decode($response1->getBody(), true);
        $time_slots = json_decode($response2->getBody(), true);
        $reservasi = json_decode($response3->getBody(), true);
    
        // Menggabungkan data dari tabel pembayaran, time_slots, dan reservasi
        $result = array();
        foreach ($pembayaran as $row) {
            $id_reservasi = $row['id_reservasi'];
            $nama = $row['nama'];
            $items = $row['items'];
    
            // Cari data time_slots yang sesuai
            $time_slot = array_filter($time_slots, function ($item) use ($id_reservasi) {
                return $item['idPegawai'] === $id_reservasi;
            });
    
            // Menggabungkan data dari tabel menjadi satu array
            foreach ($time_slot as $slot) {
                $result[] = array(
                    'id_reservasi' => $id_reservasi,
                    'nama' => $nama,
                    'items' => $items,
                    'jam_perawatan' => $slot['jam_perawatan'],
                    'date' => ''
                );
            }
        }
    
        // Mengirimkan data hasil ke view
        return view('reservasi.index')->with('reservasi', $result);
    }
    

    // update
    public function updateReservasi(Request $request, $id)
    {
        $client = new \GuzzleHttp\Client();
        $headers = [
            'apikey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
            'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
            'Content-Type' => 'application/json',
            'Prefer' => 'return=minimal'
        ];

        $id_reservasi = $request->id_reservasi;
        $id_pegawai = $request->id_pegawai;
        $id_perawatan = $request->id_perawatan;
        $time_slot_id = $request->time_slot_id;
        $date = $request->date;
        $status_reservasi = $request->status_reservasi;

        $response = $client->Request('PATCH', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/reservasi?id_reservasi=eq.' . $id, [
            'headers' => $headers,
            'json' => [
                'id_reservasi' => $id_reservasi,
                'id_pegawai' => $id_pegawai,
                'id_perawatan' => $id_perawatan,
                'time_slot_id' => $time_slot_id,
                'date'=>$date,
                'status_reservasi' => $status_reservasi
            ]
        ]);
        return $response->getBody();
    }
    // delete
    public function deleteReservasi(Request $request, $id)
    {
        $client = new \GuzzleHttp\Client();
        $headers = [
            'apikey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
            'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow'
        ];

        $id_reservasi = $request->id_reservasi;

        $response = $client->Request('DELETE', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/reservasi?id_reservasi=eq.' . $id, [
            'headers' => $headers,
            'json' => [
                'id_reservasi' => $id_reservasi
                ]
            ]);
        //return $response->getBody();
        return back()->with('success', 'Data Berhasil Dihapus');
    }
}
