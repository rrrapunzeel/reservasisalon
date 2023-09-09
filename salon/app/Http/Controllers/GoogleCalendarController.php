<?php

namespace App\Http\Controllers;

use DateTime;
use DateInterval;
use Google_Client;
use Google_Service_Calendar;
use Google_Service_Calendar_Event;
use Google_Service_Calendar_EventDateTime;
use Illuminate\Http\Request;

class GoogleCalendarController extends Controller
{
    public function addToGoogleCalendar(Request $request)
    {
        $selectedDateTime = $request->input('selectedDateTime');

        // Load credentials from JSON file
        $client = new Google_Client();
        $client->setAuthConfig('C:\xampp\htdocs\salon\salon\salon\assets\google-calendar-credentials.json');
        $client->addScope(Google_Service_Calendar::CALENDAR_EVENTS);

        // Authenticate with Google Calendar API
        $service = new Google_Service_Calendar($client);

        // Create event
        $event = new Google_Service_Calendar_Event([
            'summary' => 'Payment Success Reminder',
            'description' => 'Reminder for successful payment',
            'start' => [
                'dateTime' => $selectedDateTime,
                'timeZone' => 'Asia/Bangkok',
            ],
            'end' => [
                'dateTime' => (new DateTime($selectedDateTime))->add(new DateInterval('PT1H')),
                'timeZone' => 'Asia/Bangkok',
            ],
        ]);

        // Insert event to Google Calendar
        $calendarId = 'primary';
        $event = $service->events->insert($calendarId, $event);

        // Return response
        return response()->json([
            'message' => 'Event added to Google Calendar',
            'eventId' => $event->id,
        ]);
    }
}
