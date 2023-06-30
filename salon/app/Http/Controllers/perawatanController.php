<?php

namespace App\Http\Controllers;

use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use Illuminate\Foundation\Bus\DispatchesJobs;
use Illuminate\Foundation\Validation\ValidatesRequests;
use Illuminate\Routing\Controller as BaseController;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;
use App\Http\Models\Perawatan;
use Illuminate\Pagination\Paginator;
use Illuminate\Support\Facades\Http;

class PerawatanController extends BaseController {

    // create
    public function insertPerawatan(Request $request)
{
    $client = new \GuzzleHttp\Client();
    $headers = [
        'apikey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
        'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
        'Content-Type' => 'application/json',
        'Prefer' => 'return=minimal'
    ];

    $id_perawatan = $request->id_perawatan;
    $id_kategori = $request->id_kategori;
    $nama_perawatan = $request->nama_perawatan;
    $harga_perawatan = $request->harga_perawatan;


    $response = $client->request('get', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/perawatan', [
        'headers' => $headers,
        'json' => [
            'id_perawatan' => $id_perawatan,
            'id_kategori' => $id_kategori,
            'nama_perawatan' => $nama_perawatan,
            'harga_perawatan' => $harga_perawatan
        ]
    ]);

    // Mendapatkan data kategori setelah penambahan perawatan
    $response = $client->request('GET', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/kategori', [
        'headers' => $headers,
    ]);
    $kategoris = json_decode($response->getBody());

    return view('perawatan.create')->with('kategoris', $kategoris);
}



public function storePerawatan(Request $request)
{
    $client = new \GuzzleHttp\Client();
    $headers = [
        'apikey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
        'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
        'Content-Type' => 'application/json',
        'Prefer' => 'return=minimal'
    ];

    $id_perawatan = $request->id_perawatan;
    $id_kategori = $request->id_kategori;
    $nama_perawatan = $request->nama_perawatan;
    $harga_perawatan = $request->harga_perawatan;

    $response = $client->request('post', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/perawatan', [
        'headers' => $headers,
        'json' => [
            'id_perawatan' => $id_perawatan,
            'id_kategori' => $id_kategori,
            'nama_perawatan' => $nama_perawatan,
            'harga_perawatan' => $harga_perawatan
        ]
    ]);

    // Mendapatkan data kategori setelah penambahan perawatan
    $response = $client->request('get', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/kategori', [
        'headers' => $headers,
    ]);
    $kategoris = json_decode($response->getBody());  
    return redirect()->route('perawatan.index')->with('success', 'Perawatan berhasil ditambahkan');
}
    // read
    public function selectPerawatan(Request $request) {
        
        $client = new \GuzzleHttp\Client();
        $headers = [
            'apikey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
            'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow'
        ];
    
        $response = $client->Request('GET', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/perawatan?select=*', [
            'headers' => $headers
        ]);
    
        
        $perawatans = json_decode($response->getBody(), true);
    
        $responseKategori = $client->Request('GET', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/kategori', [
            'headers' => $headers
        ]);
    
        $kategoris = json_decode($responseKategori->getBody(), true);
        
    
         return view('perawatan.index', compact('kategoris', 'perawatans'));
    }

    // update
    public function updatePerawatan(Request $request, $id) {
        $client = new \GuzzleHttp\Client();
        $headers = [
            'apikey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
            'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
            'Content-Type' => 'application/json',
            'Prefer' => 'return=minimal'
        ];

        $id_kategori = $request->id_kategori;
        $nama_perawatan = $request->nama_perawatan;
        $harga_perawatan = $request->harga_perawatan;

        if (!empty($perawatans) && count($perawatans) > 0) {
            $perawatan = $perawatans[0];

        $response = $client->Request('PATCH', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/perawatan?id_perawatan=eq.'.$id, [
            'headers' => $headers,
            'json' => [
                'id_kategori' => $id_kategori,
                'nama_perawatan' => $nama_perawatan,
                'harga_perawatan' => $harga_perawatan
            ]
        ]);

        return view('perawatan.update', compact('perawatan'))->with('success', 'Kategori berhasil diperbarui');
    }
    return redirect()->back()->with('error', 'Gagal memperbarui kategori');
}

public function storeUpdate(Request $request, $id) {
    $client = new \GuzzleHttp\Client();
    $headers = [
        'apikey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
        'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
        'Content-Type' => 'application/json',
        'Prefer' => 'return=minimal'
    ];

    $id_kategori = $request->id_kategori;
    $nama_perawatan = $request->nama_perawatan;
    $harga_perawatan = $request->harga_perawatan;

    if (!empty($perawatans) && count($perawatans) > 0) {
        $perawatan = $perawatans[0];

    $response = $client->Request('PATCH', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/perawatan?id_perawatan=eq.'.$id, [
        'headers' => $headers,
        'json' => [
            'id_kategori' => $id_kategori,
            'nama_perawatan' => $nama_perawatan,
            'harga_perawatan' => $harga_perawatan
        ]
    ]);

    return redirect()->route('perawatan.index')->with('success', 'Data berhasil disimpan');
}

return redirect()->back()->with('error', 'Gagal memperbarui kategori');
}

    // delete
    public function deletePerawatan(Request $request, $id) {
        $client = new \GuzzleHttp\Client();
        $headers = [
            'apikey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
            'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow'
        ];
        $id_perawatan = $request->id_perawatan;

        $response = $client->Request('DELETE', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/perawatan?id_perawatan=eq.' . $id, [
            'headers' => $headers,
            'json' => [
                'id_perawatan' => $id_perawatan
            ]
        ]);
        //return $response->getBody();
        return back()->with('success', 'Data Berhasil Dihapus');
    }


    public function selectDashboard() {
     
         return view('dashboard.index');
    }
}
