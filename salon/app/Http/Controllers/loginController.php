<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Redirect;
use Laravel\Socialite\Facades\Socialite;
use Illuminate\Support\Facades\Session;
use Supabase\Client;
use Illuminate\Support\Str;

class LoginController extends Controller
{

    public function login()
    {
        return view('auth.login');
    }

    public function redirectToGoogle(Request $request)
    {
        // Generate a random state value
        $state = Str::random(40);

        // Store the state value in the session
        $request->session()->put('oauth_state', $state);
    
        // Redirect the user to the Google authentication page with the state parameter
        return redirect()->to(
            Socialite::driver('google')
                ->stateless()
                ->with(['state' => $state])
                ->redirect()
                ->getTargetUrl()
        );
    }
    
    public function handleGoogleCallback(Request $request)
    {
    
       // Get the expected state value from session
       $expectedState = $request->session()->pull('oauth_state');

    // Get the received state value from the request
    $receivedState = $request->query('state');

    // Check if both states are not null
    if ($receivedState !== null && $expectedState !== null) {
        // Check if the received state value is valid
        if (!hash_equals($receivedState, $expectedState)) {
            return 'Invalid state value';
        }
    
        // Check if the user is authenticated
        if (Auth::check()) {
            // Create a GuzzleHttp client instance
            $client = new \GuzzleHttp\Client();
    
            // Set the Supabase API headers
            $headers = [
                'apikey' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
            'Authorization' => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
            'Content-Type' => 'application/json',
            'Prefer' => 'return=minimal'
            ];
            // Get the authenticated user
            $user = $request->user();

            // Get the user ID
            $userId = $user->id;
    
            // Get the user data from Google
            $googleUser = Socialite::driver('google')->stateless()->user();
    
            // Fill the user data from Google into corresponding variables
            $id = $userId;
            $updated_at = now()->toDateTimeString();
            $email = $googleUser->getEmail();
            $nama = $googleUser->getName();
            $avatar_url = null; // Set avatar_url to null
            $role = 'pegawai';

            $accessToken = $googleUser->token;
            $headers['Authorization'] = 'Bearer ' . $accessToken;
    
            // Send a POST request to the Supabase API to save the user data to the "pegawai" table
            $response = $client->request('POST', 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/user', [
                'headers' => $headers,
                'json' => [
                    'id' => $id,
                    'updated_at' => $updated_at,
                    'email' => $email,
                    'nama' => $nama,
                    'avatar_url' => $avatar_url,
                    'role' => $role
                ]
            ]);
    
            if ($response->getStatusCode() === 200) {
                return redirect()->route('dashboard.view');
            }
            return 'Failed to save user data';
        }
    
        // If the user is not authenticated, display an error message or perform the appropriate action
        return 'User is not authenticated';
    }  
    return 'Invalid state value';
}
}
    