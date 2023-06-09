<?php
namespace App\Services;

use Google\Client\ServiceProvider;

class GoogleClientService
{
    public function setupClient()
    {
        $client = new ServiceProvider();
        // ...
    }
}
