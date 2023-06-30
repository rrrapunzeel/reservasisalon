<?php

return [
    /*
    |--------------------------------------------------------------------------
    | OneSignal App ID
    |--------------------------------------------------------------------------
    |
    | The OneSignal App ID is used to identify your application in OneSignal.
    |
    */
    'app_id' => env('ONESIGNAL_APP_ID'),

    /*
    |--------------------------------------------------------------------------
    | Rest API Key
    |--------------------------------------------------------------------------
    |
    | The Rest API Key is used for server-to-server notifications.
    |
    */
    'rest_api_key' => env('ONESIGNAL_REST_API_KEY'),

    /*
    |--------------------------------------------------------------------------
    | User Auth Key
    |--------------------------------------------------------------------------
    |
    | The User Auth Key is used for user-specific notifications.
    |
    */
    'user_auth_key' => env('ONESIGNAL_USER_AUTH_KEY'),

    /*
    |--------------------------------------------------------------------------
    | User Auth Key Identifier
    |--------------------------------------------------------------------------
    |
    | The User Auth Key Identifier is used for user-specific notifications.
    |
    */
    'user_auth_key_identifier' => env('ONESIGNAL_USER_AUTH_KEY_IDENTIFIER'),

    /*
    |--------------------------------------------------------------------------
    | User Auth Key Length
    |--------------------------------------------------------------------------
    |
    | The User Auth Key Length is used for user-specific notifications.
    |
    */
    'user_auth_key_length' => env('ONESIGNAL_USER_AUTH_KEY_LENGTH'),

    /*
    |--------------------------------------------------------------------------
    | Log Level
    |--------------------------------------------------------------------------
    |
    | The log level determines the verbosity of the package's log output.
    |
    */
    'log_level' => env('ONESIGNAL_LOG_LEVEL', 'error'),
];
