<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Str;
use Supabase\SupabaseClient;


class AuthController extends Controller
{

    public function linkGoogleProvider(Request $request)
    {
        $accessToken = $request->input('access_token');
        $userId = $request->input('user_id');

        // Initialize the Supabase client
        $supabaseUrl = 'https://fuzdyyktvczvrbwrjkhe.supabase.co'; // Replace with your Supabase URL
        $supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzI0MTA4ODcsImV4cCI6MTk4Nzk4Njg4N30.kMVUSwTCDMLEM-8ePXPXniT62zkB75Q3gvyvuAbkibU'; // Replace with your Supabase key
        $supabase = new Supabase($supabaseUrl, $supabaseKey);

        // Save the access token to the 'users' table in Supabase
        $response = $supabase->from('users')->update([
            'google_access_token' => $accessToken,
        ])->eq('id', $userId)->execute();

        if ($response->error) {
            // Error occurred while saving
            return response()->json(['message' => 'Failed to link Google provider'], 500);
        }

        return response()->json(['message' => 'Google provider linked successfully'], 200);
    }


    public function login(Request $request)
{
    return view('auth.login');    
}

public function logout()
{
    Auth::logout();
    return redirect()->route('login.view');
}
public function storeLogin (Request $request) {
    $client = new \GuzzleHttp\Client();
        $headers = [
            'apikey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
            'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
            'Content-Type' => 'application/json',
            'Prefer' => 'return=minimal'
        ];

        $email = $request->email;

        $response = $client->request('GET', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/user', [
            'headers' => $headers,
            'query' => [
                'email' => 'eq.' . $email
                
            ]
        ]);
        
    $data = json_decode($response->getBody(), true);

    if (!empty($data) && count($data) > 0) {
        // Email ditemukan, lanjutkan proses login
        return redirect()->route('dashboard.view')->with('success', 'Data berhasil disimpan');
    }

    // Email tidak ditemukan, tampilkan pesan error

    return redirect()->back()->with('error', 'Email tidak tersedia');
}


public function getUser($request)
{
    $client = new \GuzzleHttp\Client();
    $url = 'https://fuzdyyktvczvrbwrjkhe.supabase.co/auth/v1/signin';
    $apiKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow';

    $response = $client->post($url, [
        'headers' => [
            'apikey' => $apiKey,
            'Content-Type' => 'application/json',
        ],
        'json' => [
            'email' => $request->email,
            'password' => $request->password,
        ],
    ]);

    $data = json_decode($response->getBody(), true);

    // Cek apakah login berhasil
    if (isset($data['access_token'])) {
        // Sign-in successful, do something like storing the token in session
        // or redirect the user to the dashboard page
        return redirect()->route('dashboard')->with('success', 'Sign-in successful');
    } else {
        // Sign-in failed, display an error message
        return redirect()->back()->with('error', 'Email or password is incorrect');
    }
}

public function register(Request $request)
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
    $password = $request->password;
    $userId = Str::uuid();
   
    $response = $client->request('post', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/auth/v1/signup', [
        'headers' => $headers,
        'json' => [
            'id' => $userId,
            'name' => $nama,
            'email' => $email,
            'password' => $password
        ]
    ]);

    $statusCode = $response->getStatusCode();

    if ($statusCode === 200) {
        return redirect()->route('login.view')->with('success', 'Data berhasil disimpan');
    } else {
        return redirect()->back()->with('error', 'Gagal melakukan registrasi');
    }
}
public function showRegistrationForm(Request $request)
{ 

    return view('auth.signup');
}

public function getProfile()
{
    // Ambil token akses dari sesi
    $accessToken = session('access_token');

    // Buat header dengan menambahkan token akses ke header yang sudah ada
    $headers = [
        'Authorization' => 'Bearer ' . $accessToken,
    ];

    // Lakukan permintaan ke endpoint Supabase dengan header yang berisi token akses
    $client = new \GuzzleHttp\Client();
    $response = $client->get('https://fuzdyyktvczvrbwrjkhe.supabase.co/auth/v1/user', [
        'headers' => $headers,
    ]);

    // Periksa kode status respons
    if ($response->getStatusCode() === 200) {
        $userData = json_decode($response->getBody(), true);

        // Ambil nama pengguna dari data pengguna
        $nama = $userData[0]['nama'];

       // Tampilkan nama pengguna di halaman profil
       return view('profile', ['nama' => $nama]);
    }


    // Jika permintaan gagal, tampilkan pesan kesalahan
    return redirect()->back()->with('error', 'Failed to fetch user data');
}
}