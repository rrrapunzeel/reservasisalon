<?php

namespace App\Http\Controllers;

use Illuminate\Routing\Controller as BaseController;
use Illuminate\Http\Request;
use Illumiinate\GuzzleHttp;

class reservasiController extends BaseController
{

    public function insertReservasi(Request $request) {
        $client = new \GuzzleHttp\Client();
        $headers = [
            'apikey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
            'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
            'Content-Type' => 'application/json',
            'Prefer' => 'return=minimal'
        ];

          // Mendapatkan data kategori dari Supabase
          $response = $client->request('get', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/pegawai', [
            'headers' => $headers,
        ]);
        $pegawais = json_decode($response->getBody());
        
          // Mendapatkan data kategori dari Supabase
          $response = $client->request('get', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/perawatan', [
            'headers' => $headers,
        ]);
        $perawatans = json_decode($response->getBody());

        $response = $client->request('get', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/time_slots', [
            'headers' => $headers,
        ]);
        $jams = json_decode($response->getBody());

    $uniqueJamPerawatan = [];
    foreach ($jams as $jam) {
        $jamPerawatan = $jam->jam_perawatan;
        if (!in_array($jamPerawatan, $uniqueJamPerawatan)) {
            $uniqueJamPerawatan[] = $jamPerawatan;
        }
    }

    return view('reservasi.create', compact('pegawais', 'perawatans', 'uniqueJamPerawatan'));
}


public function storeReservasi(Request $request) {
    $client = new \GuzzleHttp\Client();
    $headers = [
        'apikey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
        'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
        'Content-Type' => 'application/json',
        'Prefer' => 'return=minimal'
    ];

    $nama = $request->nama;
    $items = $request->items;
    $jam = $request->jam;
    $tanggal = $request->tanggal;
    $pegawai = $request->pegawai;
    $total = $request->total;
    $transaction_status = $request->transaction_status;

      // Mendapatkan data kategori dari Supabase
      $response = $client->request('post', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/pembayaran', [
        'headers' => $headers,
        'json' => [
            'nama' => $nama,
            'items' => $items,
            'tanggal' => $tanggal,
            'jam' => $jam,
            'pegawai' => $pegawai,
            'transaction_status' => 'Menunggu Konfirmasi',
            'total' => $total

        ]
    ]);
    
$statusCode = $response->getStatusCode();
    
if ($statusCode === 200 || $statusCode === 201) {
    // Add a flash message to the session to display the success message
    $request->session()->flash('success', 'Data berhasil disimpan');
    return redirect()->route('reservasi.index');
}

return redirect()->back()->with('error', 'Gagal memperbarui kategori');
}
    // read
    public function selectReservasi(Request $request)
    {
        $client = new \GuzzleHttp\Client();
        $headers = [
            'apikey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
            'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
            'Content-Type' => 'application/json',
            'Prefer' => 'return=minimal'
        ];
    
        $response = $client->request('GET', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/pembayaran?select=id,nama,items,jam,tanggal,pegawai,transaction_status&order=id.desc', [
            'headers' => $headers
        ]);
    
        $reservasis = json_decode($response->getBody(), true);
    
        $totalPemasukkan = 0;
        
        foreach ($reservasis as $reservasi) {
            if (is_array($reservasi) && isset($reservasi['total'])) {
                $totalPemasukkan += $reservasi['total'];
            }
        }
        
        return view('reservasi.index', compact('reservasis', 'totalPemasukkan'));
    }
    
    // update
    public function updateReservasi(Request $request, $id)
    {
        return view('reservasi.update');
    }
    // delete

    public function storeUpdate(Request $request, $id)
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
        return redirect()->route('reservasi.index')->with('success', 'Data berhasil diperbarui');
    }
    public function deleteReservasi(Request $request, $id)
    {
        $client = new \GuzzleHttp\Client();
        $headers = [
            'apikey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
            'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow'
        ];

        $id = $request->id;

        $response = $client->Request('DELETE', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/pembayaran?id=eq.' . $id, [
            'headers' => $headers,
            'json' => [
                'id' => $id
                ]
            ]);
        //return $response->getBody();
        return back()->with('success', 'Data Berhasil Dihapus');
    }
}
