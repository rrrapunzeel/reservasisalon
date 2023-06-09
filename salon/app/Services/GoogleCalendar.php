<?php

namespace App\Services;

use Google\Client\ServiceProvider as GoogleClient;

class GoogleCalendar
{
    protected $client;
    protected $calendar;

    public function __construct()
    {
        $this->client = new GoogleClient();
        $this->client->setAuthConfig(config('google-calendar.credentials_json'));
        $this->client->addScope(\Google_Service_Calendar::CALENDAR);
        $this->calendar = new \Google_Service_Calendar($this->client);
    }

    // Tambahkan method-method sesuai kebutuhan Anda, misalnya:

    public function createEvent($eventData)
    {
        // Logika untuk membuat event di Google Calendar
    }
}
