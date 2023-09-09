import 'dart:convert';

import 'package:http/http.dart' as http;

const supabaseUrl = 'https://fuzdyyktvczvrbwrjkhe.supabase.co';
const supabaseKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzI0MTA4ODcsImV4cCI6MTk4Nzk4Njg4N30.kMVUSwTCDMLEM-8ePXPXniT62zkB75Q3gvyvuAbkibU';

const providerName = 'google';
final providerSettings = {
  'access_type': 'offline',
  'scope': 'email https://www.googleapis.com/auth/calendar.events',
  'client_id':
      '362169221609-vqrqvin4kj1nu5df5phfva0v74mtn24q.apps.googleusercontent.com',
  'client_secret': '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',
  'redirect_uri': 'io.supabase.flutterdemo://login-callback',
};

final response = http.put(
  Uri.parse('$supabaseUrl/auth/v1/provider/$providerName'),
  headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $supabaseKey',
  },
  body: jsonEncode(providerSettings),
);
