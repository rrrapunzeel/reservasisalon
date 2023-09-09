<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Http\Requests;
use App\Http\Controllers\Controller;
use GuzzleHttp\Client;
use Carbon\Carbon;
class JadwalController extends Controller {

    public function selectPegawai()
    {
        // Retrieve and process data
        $pegawai = []; // Assume this is the data you want to pass

        return $pegawai;
    }
    
    public function insertJadwal (Request $request, $pegawai) {
        $client = new Client();
        $headers = [
            'apikey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
            'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
            'Content-Type' => 'application/json',
            'Prefer' => 'return=minimal'
        ];

        $jam_perawatan = $request->jam_perawatan;
        $idPegawai = $request->idPegawai;
        $available = $request->available;
        $tanggal = $request->tanggal;
    
    $response = $client->Request('POST', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/time_slots', [
        'headers' => $headers,
        'json' => [
            'jam_perawatan' => $jam_perawatan,
            'idPegawai' => $idPegawai,
            'available' => $available,
            'tanggal'=> $tanggal
        ]
    ]);

    $jadwals = json_decode($response->getBody());
    return view('jadwal.create')->with('jadwals', $jadwals);
    }

    public function selectJadwal(Request $request)
    {
        $client = new Client();
        $headers = [
            'apikey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
            'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
            'Content-Type' => 'application/json',
            'Prefer' => 'return=minimal'
        ];
    
        $currentDate = Carbon::now();
        $selectedDate = Carbon::parse($request->input('tanggal'));
    
        // Cek apakah tanggal di kalender berbeda dengan tanggal saat ini
        if (!$selectedDate->isSameDay($currentDate)) {
            // Mengubah semua jadwal menjadi "Aktif"
            $response = $client->request('GET', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/time_slots?select=*', [
                'headers' => $headers,
            ]);
    
            $jadwals = json_decode($response->getBody(), true);
    
            foreach ($jadwals as &$jadwal) {
                $jadwal['available'] = 'Aktif';
            }
        } else {
            // Jika tanggal di kalender sama dengan tanggal saat ini
            // Get the filter values from the request
            $pegawaiFilter = $request->input('pegawai');
            $availableFilter = $request->input('available');
            if ($availableFilter === 'Aktif') {
                $availableFilter = true;
            } elseif ($availableFilter === 'Tidak Aktif') {
                $availableFilter = false;
            }
            

    
            // Build the API query based on the filter values
            $query = 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/time_slots?select=*';
            if ($pegawaiFilter) {
                $query .= '&idPegawai=eq.' . $pegawaiFilter;
            }
            if ($availableFilter !== null) {
                $query .= '&available=eq.' . ($availableFilter ? 'true' : 'false');
            }

    
            $response = $client->request('GET', $query, [
                'headers' => $headers,
            ]);
    
            $jadwals = json_decode($response->getBody(), true);
        }
    
        $responsePegawai = $client->request('GET', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/user', [
            'headers' => $headers
        ]);
    
        $pegawais = json_decode($responsePegawai->getBody(), true);
    
        return view('jadwal.index', compact('jadwals', 'pegawais'));
    }

    public function updateJadwal(Request $request, $id)
    {
        $client = new Client();
        $headers = [
            'apikey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
            'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
            'Content-Type' => 'application/json',
            'Prefer' => 'return=minimal'
        ];
        $jam_perawatan = $request->jam_perawatan;
        $idPegawai = $request->idPegawai;
        $available = $request->available;
     
        $response = $client->request('GET', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/time_slots?id=eq.' . $id, [
            'headers' => $headers,
        ]);

        $jadwals = json_decode($response->getBody(), true);

        if (!empty($jadwals) && count($jadwals) > 0) {
            $jadwal = $jadwals[0];
            // Mengupdate data jika ditemukan
            $response = $client->request('PATCH', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/time_slots?id=eq.' . $id, [
                'headers' => $headers,
                'json' => [
                    'jam_perawatan' => $jam_perawatan,
                    'idPegawai' => $idPegawai,
                    'available' => $available
                ]
            ]);
            return view('jadwal.update', compact('jadwal'))->with('success', 'Jadwal berhasil diperbarui');
        }
    
        return redirect()->back()->with('error', 'Gagal memperbarui kategori');
    }

    public function deleteJadwal(Request $request, $id)
    {
        $client = new Client();
        $headers = [
          'apikey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
          'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
          'Content-Type' => 'application/json',
          'Prefer' => 'return=minimal'
        ];

        $id = $request->id;

        $response = $client->Request('DELETE', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/time_slots?id=eq.' . $id, [
            'headers' => $headers,
            'json' => [
                'id' => $id,
                ]
            ]);
        //return $response->getBody();
        return back()->with('success', 'Data Berhasil Dihapus');
    }
}