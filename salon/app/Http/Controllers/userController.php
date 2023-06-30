<?php

namespace App\Http\Controllers;

use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use Illuminate\Foundation\Bus\DispatchesJobs;
use Illuminate\Foundation\Validation\ValidatesRequests;
use Illuminate\Routing\Controller as BaseController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Http\Controllers\JadwalController;

class userController extends BaseController
{
    public function storePegawai()
    {
        // Retrieve and process data
        $pegawai = []; // Assume this is the data you want to store

        session()->put('pegawai', $pegawai);
    }

    // create
    public function insertUser(Request $request)
    {
        $client = new \GuzzleHttp\Client();
        $headers = [
            'apikey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
            'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
            'Content-Type' => 'application/json',
            'Prefer' => 'return=minimal'
        ];
        $id = $request->id;
        $udpated_at = $request->updated_at;
        $email = $request->email;
        $nama = $request->nama;
        $avatar_url = $request->avatar_url;
        $nomor_telepon = $request->nomor_telepon;
        $role = $request->role;
        $status = $request->status;

        $response = $client->Request('POST', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/user', [
            'headers' => $headers,
            'json' => [
                'id' => $id,
                'updated_at' => $udpated_at,
                'email' => $email,
                'nama' => $nama,
                'avatar_url' => $avatar_url,
                'nomor_telepon' => $nomor_telepon,
                'role' => $role,
                'status' => $status
            ]
        ]);
            return $response->getBody();
    }

    public function insertPegawai(Request $request)
{
    if (Auth::check()) {
    $client = new \GuzzleHttp\Client();
    $headers = [
        'apikey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
        'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
        'Content-Type' => 'application/json',
        'Prefer' => 'return=minimal'
    ];
    $userId = Auth::user()->id;

    // Assign the user ID to the 'id' column
    $id = $userId;

    // Set other column values from the request
    $updated_at = $request->updated_at;
    $email = $request->email;
    $nama = $request->nama;
    $avatar_url = null; // Set avatar_url to null
    $role = 'pegawai';

    $response = $client->request('POST', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/user', [
        'headers' => $headers,
        'json' => [
            'id' => $id,
            'updated_at' => $updated_at,
            'email' => $email,
            'nama' => $nama,
            'avatar_url' => $avatar_url,
            'role'=>$role
        ]
    ]);

    return $response->getBody();
}
return 'User is not authenticated';
}
    public function selectPelanggan(Request $request)
    {
        $client = new \GuzzleHttp\Client();
        $headers = [
            'apikey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
            'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow'
        ];
        $response = $client->Request('GET', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/user?select=id,nama,email,nomor_telepon,role', [
            'headers' => $headers
        ]);
        $users = json_decode($response->getBody());
    
        $pelanggan = [];
        foreach ($users as $user) {
            if ($user->role === 'Pelanggan') {
                $pelanggan[] = $user;
            }
        }
        $pelangganCount = count($pelanggan);
        return view('pelanggan.index')->with('pelanggan', $pelanggan);

    }

    public function selectPegawai(Request $request)
    {
        $client = new \GuzzleHttp\Client();
        $headers = [
            'apikey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
            'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow'
        ];
        $response = $client->Request('GET', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/user?select=id,nama,email,nomor_telepon,role,status', [
            'headers' => $headers
        ]);
        $users = json_decode($response->getBody());
    
        $pegawai = [];
        foreach ($users as $user) {
            if ($user->role === 'Pegawai') {
                $pegawai[] = $user;
            }
        }
        return view('pegawai.index')->with('pegawai', $pegawai);

    }
    // update
    public function updateUser(Request $request, $id)
    {
        $client = new \GuzzleHttp\Client();
        $headers = [
          'apikey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
          'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
          'Content-Type' => 'application/json',
          'Prefer' => 'return=minimal'
        ];
        $id = $request->id;
        $email = $request->email;
        $nama = $request->nama;
        $nomor_telepon = $request->nomor_telepon;


        $response = $client->Request('PATCH', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/user?id=eq.'.$id, [
            'headers' => $headers,
            'json' => [
                'id' => $id,
                'email' => $email,
                'nama' => $nama,
                'nomor_telepon' => $nomor_telepon
            ]
        ]);
        return $response->getBody();
    }

    public function updatePegawai(Request $request, $id)
    {
        $client = new \GuzzleHttp\Client();
        $headers = [
            'apikey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
          'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
          'Content-Type' => 'application/json',
          'Prefer' => 'return=minimal'
        ];

        $nama = $request->nama;
        $email = $request->email;
        $nomor_telepon = $request->nomor_telepon;
        $status = $request->status;

        $response = $client->Request('GET', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/user?id=eq.'.$id, [
            'headers' => $headers,
        ]);
        $datapegawai = json_decode($response->getBody(), true);

        if (!empty($datapegawai) && count($datapegawai) > 0) {
            $pegawai = $datapegawai[0];
    
        $response = $client->request('PATCH', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/user?id=eq.'.$id, [
            'headers' => $headers,
            'json' => [
                'nama' => $nama,
                'email' => $email,
                'nomor_telepon' => $nomor_telepon,
                'status' => $status
            ]
        ]);

            return view('pegawai.update', compact('pegawai'))->with('success', 'Pegawai berhasil diperbarui');
        
    }
}

public function updatePelanggan(Request $request, $id)
{
    $client = new \GuzzleHttp\Client();
    $headers = [
        'apikey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
      'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
      'Content-Type' => 'application/json',
      'Prefer' => 'return=minimal'
    ];

    $nama = $request->nama;
    $email = $request->email;
    $nomor_telepon = $request->nomor_telepon;

    $response = $client->Request('GET', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/user?id=eq.'.$id, [
        'headers' => $headers,
    ]);
    $datapelanggan = json_decode($response->getBody(), true);

    if (!empty($datapelanggan) && count($datapelanggan) > 0) {
        $pelanggan = $datapelanggan[0];

    $response = $client->request('PATCH', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/user?id=eq.'.$id, [
        'headers' => $headers,
        'json' => [
            'nama' => $nama,
            'email' => $email,
            'nomor_telepon' => $nomor_telepon,
        ]
    ]);

        return view('pelanggan.update', compact('pelanggan'))->with('success', 'Pegawai berhasil diperbarui');
    
}
}

public function insertPelanggan(Request $request)
{
    $client = new \GuzzleHttp\Client();
    $headers = [
        'apikey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
      'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
      'Content-Type' => 'application/json',
      'Prefer' => 'return=minimal'
    ];

    $nama = $request->nama;
    $email = $request->email;
    $nomor_telepon = $request->nomor_telepon;

    $response = $client->request('POST', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/user', [
        'headers' => $headers,
        'json' => [
            'nama' => $nama,
            'email' => $email,
            'nomor_telepon' => $nomor_telepon,
        ]
    ]);

    $datapelanggan = json_decode($response->getBody());
        return view('pelanggan.create')->with('datapelanggan', $datapelanggan);
    
}
    
    // delete
    public function deleteUser(Request $request, $id)
    {
        $client = new \GuzzleHttp\Client();
        $headers = [
        'apikey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
        'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow'
        ];

        $id = $request->id;

        $response = $client->Request('DELETE', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/user?id=eq.'.$id, [
            'headers' => $headers,
            'json' => [
                'id' => $id
                ]
            ]);
        // return $response->getBody();
        return back()->with('success', 'Data Berhasil Dihapus');
    }

}
