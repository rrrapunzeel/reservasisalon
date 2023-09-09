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
    
        // Mendapatkan data perawatan dari Supabase
        $response = $client->request('get', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/perawatan', [
            'headers' => $headers,
        ]);
        $perawatans = json_decode($response->getBody(), true);
    
        // Membuat array berisi ID perawatan yang telah digunakan
        $usedIds = [];
        foreach ($perawatans as $perawatan) {
            $usedIds[] = $perawatan['id_perawatan'];
        }
    
        // Mencari ID perawatan yang belum pernah digunakan
        $defaultIdPerawatan = 1;
        while (in_array($defaultIdPerawatan, $usedIds)) {
            $defaultIdPerawatan++;
        }
    
        // Mendapatkan data kategori dari Supabase
        $response = $client->request('get', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/kategori', [
            'headers' => $headers,
        ]);
        $kategoris = json_decode($response->getBody());
    
        return view('perawatan.create', compact('kategoris', 'defaultIdPerawatan'));
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
    $estimasi = $request->estimasi;

    $response = $client->request('post', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/perawatan', [
        'headers' => $headers,
        'json' => [
            'id_perawatan' => $id_perawatan,
            'id_kategori' => $id_kategori,
            'nama_perawatan' => $nama_perawatan,
            'harga_perawatan' => $harga_perawatan,
            'estimasi' => $estimasi
        ]
    ]);
    $statusCode = $response->getStatusCode();
    
    if ($statusCode === 200 || $statusCode === 201) {
        // Add a flash message to the session to display the success message
        $request->session()->flash('success', 'Data berhasil disimpan');
        return redirect()->route('perawatan.index');
    }

    return redirect()->back()->with('error', 'Gagal memperbarui kategori');
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

   // Sort perawatan data by 'id_perawatan' in descending order
    usort($perawatans, function ($a, $b) {
        return $b['id_perawatan'] - $a['id_perawatan'];
    });

    
        $responseKategori = $client->Request('GET', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/kategori', [
            'headers' => $headers
        ]);
    
        $kategoris = json_decode($responseKategori->getBody(), true);
        
    
         return view('perawatan.index', compact('kategoris', 'perawatans'));
    }

    public function storeUpdate(Request $request, $id) {
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
        $estimasi = $request->estimasi;

            $response = $client->request('GET', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/perawatan?id_perawatan=eq.' . $id, [
                'headers' => $headers,
                'json' => [
                    'id_perawatan' => $id_perawatan,
                    'id_kategori' => $id_kategori,
                    'nama_perawatan' => $nama_perawatan,
                    'harga_perawatan' => $harga_perawatan,
                    'estimasi' => $estimasi
                ]
            ]);

        $perawatanData = json_decode($response->getBody(), true);

            if (!empty($perawatanData) && count($perawatanData) > 0) {
                $kategoriItem = (object)$perawatanData[0];
    
        $response = $client->request('PATCH', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/perawatan?id_perawatan=eq.' . $id, [
            'headers' => $headers,
            'json' => [
                'id_perawatan' => $id_perawatan,
                'id_kategori' => $id_kategori,
                'nama_perawatan' => $nama_perawatan,
                'harga_perawatan' => $harga_perawatan,
                'estimasi' => $estimasi
            ]
        ]);
    
            return redirect()->route('perawatan.index')->with('success', 'Data berhasil disimpan');
        }
    
        return redirect()->back()->with('error', 'Gagal memperbarui perawatan');
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

        $id_perawatan = $request->id_perawatan;
        $id_kategori = $request->id_kategori;
        $nama_perawatan = $request->nama_perawatan;
        $harga_perawatan = $request->harga_perawatan;
        $estimasi = $request->estimasi;

            $response = $client->request('GET', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/perawatan?id_perawatan=eq.' . $id, [
                'headers' => $headers,
                'json' => [
                    'id_perawatan' => $id_perawatan,
                    'id_kategori' => $id_kategori,
                    'nama_perawatan' => $nama_perawatan,
                    'harga_perawatan' => $harga_perawatan,
                    'estimasi' => $estimasi
                ]
            ]);
            $perawatanData = json_decode($response->getBody(), true);

            if (!empty($perawatanData) && count($perawatanData) > 0) {
                $kategoriItem = (object)$perawatanData[0];
                // Mengupdate data jika ditemukan
                $response = $client->request('GET', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/perawatan?id_perawatan=eq.' . $id, [
                    'headers' => $headers,
                    'json' => [
                        'id_perawatan' => $id_perawatan,
                        'id_kategori' => $id_kategori,
                        'nama_perawatan' => $nama_perawatan,
                        'harga_perawatan' => $harga_perawatan,
                        'estimasi' => $estimasi
                    ]
                ]);

                $response = $client->request('get', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/kategori', [
                    'headers' => $headers,
                ]);
                $kategoris = json_decode($response->getBody());
        
                return view('perawatan.update', compact('kategoriItem', 'kategoris','id_perawatan'));
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


    public function selectDashboard(Request $request) {
    
            $client = new \GuzzleHttp\Client();
            $headers = [
                'apikey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
                'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow'
            ];
    
            $response = $client->request('GET', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/pembayaran?select=id,nama,items,jam,tanggal,pegawai,transaction_status&order=id.desc', [
                'headers' => $headers
            ]);
    
            $reservasi = json_decode($response->getBody(), true);

            $response = $client->request('GET', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/pembayaran?total', [
                'headers' => $headers
            ]);

            $pembayarans = json_decode($response->getBody(), true);
            // Mengirimkan data hasil ke view
            return view('dashboard.index', compact('reservasi', 'pembayarans'));
        
    }
}
