<?php

namespace App\Http\Controllers;

use Google\Client\ServiceProvider as GoogleCalendar;

use Google_Client;
use Google_Service_Calendar;
use Google_Service_Calendar_Event;
use Illuminate\Http\Request;

class CalendarController extends Controller
{

    protected $googleCalendar;
    public function __construct(GoogleCalendar $googleCalendar)
    {
        $this->googleCalendar = $googleCalendar;
    }
    public function createEvent(Request $request)
    {
        // Ambil data waktu yang dipilih dari permintaan Flutter
        $selectedTime = $request->input('selectedTime');

        // Inisialisasi Google Client
        $client = new Google_Client();
        $client->setApplicationName('Challista Beauty Salon');
        $client->setScopes(Google_Service_Calendar::CALENDAR_EVENTS);
        $client->setAuthConfig('app\config\google-calendar-credentials.json'); // Ganti dengan path file JSON Anda

        // Buat instance Google Calendar
        $service = new Google_Service_Calendar($client);

        // Buat objek acara baru
        $event = new Google_Service_Calendar_Event([
            'summary' => 'Reminder',
            'start' => [
                'dateTime' => $selectedTime, // Gunakan waktu yang dipilih dari permintaan Flutter
            ],
            'end' => [
                'dateTime' => $selectedTime, // Gunakan waktu yang dipilih dari permintaan Flutter
            ],
        ]);

        // Kirim permintaan pembuatan acara ke Google Calendar
        $calendarId = 'primary'; // Ganti dengan ID kalendar Anda
        $event = $service->events->insert($calendarId, $event);

        // Berikan respons sukses ke Flutter
        return response()->json([
            'message' => 'Event created successfully.',
        ]);
    }
}
