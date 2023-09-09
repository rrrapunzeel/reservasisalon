<?php

namespace App\Http\Controllers;
use Illuminate\Routing\Controller as BaseController;
use Illuminate\Http\Request;
use Illumiinate\GuzzleHttp;

class kategoriController extends BaseController
{
    // create
    public function insertKategori(Request $request)
    {
        $client = new \GuzzleHttp\Client();
        $headers = [
            'apikey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
            'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
            'Content-Type' => 'application/json',
            'Prefer' => 'return=minimal'
        ];
    
        $nama_kategori = $request->nama_kategori;
    
        $response = $client->request('post', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/kategori', [
            'headers' => $headers,
            'json' => [
                'nama_kategori' => $nama_kategori
            ]
        ]);
    
        $kategoris = json_decode($response->getBody());
    
        // Simpan nama kategori dalam session
        $request->session()->put('nama_kategori', $nama_kategori);
        return view('kategori.create')->with('kategoris', $kategoris);

    }
    

    public function storeKategori(Request $request)
{
    $client = new \GuzzleHttp\Client();
    $headers = [
        'apikey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
        'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
        'Content-Type' => 'application/json',
        'Prefer' => 'return=minimal'
    ];

    $nama_kategori = $request->nama_kategori;

    $response = $client->request('post', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/kategori', [
        'headers' => $headers,
        'json' => [
            'nama_kategori' => $nama_kategori
        ]
    ]);

    $kategoris = json_decode($response->getBody());

    // Simpan nama kategori dalam session
    $request->session()->put('nama_kategori', $nama_kategori);
    return redirect()->route('kategori.index')->with('success', 'Data berhasil disimpan');
    
}

    // read
    public function selectKategori(Request $request)
    {
        $client = new \GuzzleHttp\Client();
        $headers = [
            'apikey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
            'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow'
        ];

        $response = $client->Request('GET', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/kategori?select=*', [
            'headers' => $headers
        ]);
        $kategoris = json_decode($response->getBody());

        usort($kategoris, function ($a, $b) {
            return $b->id_kategori - $a->id_kategori;
        });

        return view('kategori.index')->with('kategoris', $kategoris);
    }

    // update
    public function storeUpdate(Request $request, $id)
    {
        $client = new \GuzzleHttp\Client();
        $headers = [
            'apikey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
            'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
            'Content-Type' => 'application/json',
            'Prefer' => 'return=minimal'
        ];
        $nama_kategori = $request->nama_kategori;
     
        $response = $client->request('GET', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/kategori?id_kategori=eq.' . $id, [
            'headers' => $headers,
        ]);

        $kategoris = json_decode($response->getBody(), true);

        if (!empty($kategoris) && count($kategoris) > 0) {
            $kategori = $kategoris[0];
            // Mengupdate data jika ditemukan
            $response = $client->request('PATCH', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/kategori?id_kategori=eq.' . $id, [
                'headers' => $headers,
                'json' => [
                    'nama_kategori' => $nama_kategori
                ]
            ]);
            return redirect()->route('kategori.index')->with('success', 'Data berhasil disimpan');
        }
    
        return redirect()->back()->with('error', 'Gagal memperbarui kategori');
    }

    public function updateKategori(Request $request, $id)
    {
        $client = new \GuzzleHttp\Client();
        $headers = [
            'apikey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
            'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
            'Content-Type' => 'application/json',
            'Prefer' => 'return=minimal'
        ];
        $nama_kategori = $request->nama_kategori;
     
        $response = $client->request('GET', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/kategori?id_kategori=eq.' . $id, [
            'headers' => $headers,
        ]);

        $kategoris = json_decode($response->getBody(), true);

        if (!empty($kategoris) && count($kategoris) > 0) {
            $kategori = $kategoris[0];
            // Mengupdate data jika ditemukan
            $response = $client->request('PATCH', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/kategori?id_kategori=eq.' . $id, [
                'headers' => $headers,
                'json' => [
                    'nama_kategori' => $nama_kategori
                ]
            ]);
            return view('kategori.update', compact('kategori'))->with('success', 'Kategori berhasil diperbarui');
        }
    
        return redirect()->back()->with('error', 'Gagal memperbarui kategori');
    }

    
    public function deleteKategori(Request $request, $id)
    {
        $client = new \GuzzleHttp\Client();
        $headers = [
          'apikey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
          'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
          'Content-Type' => 'application/json',
          'Prefer' => 'return=minimal'
        ];

        $id_kategori = $request->id_kategori;

        $response = $client->Request('DELETE', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/kategori?id_kategori=eq.' . $id, [
            'headers' => $headers,
            'json' => [
                'id_kategori' => $id_kategori,
                ]
            ]);
        //return $response->getBody();
        return back()->with('success', 'Data Berhasil Dihapus');
    }
}
