// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:googleapis_auth/auth_io.dart';
// import 'package:googleapis/calendar/v3.dart' as calendar;
// import 'package:supabase/supabase.dart';

// class ReminderController extends GetxController {
//   final SupabaseClient _supabaseClient = SupabaseClient(
//     'https://fuzdyyktvczvrbwrjkhe.supabase.co',
//     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzI0MTA4ODcsImV4cCI6MTk4Nzk4Njg4N30.kMVUSwTCDMLEM-8ePXPXniT62zkB75Q3gvyvuAbkibU',
//   );

//   final _authScopes = [calendar.CalendarApi.calendarScope];
//   late AutoRefreshingAuthClient _client;

//   Future<void> addReminder({
//     required String title,
//     required DateTime startTime,
//     required DateTime endTime,
//   }) async {
//     // Set up the authentication credentials
//     final credentials = await obtainAccessCredentialsViaUserConsent(
//         _authScopes, _supabaseClient.auth.session.token.toString(),
//         (uri) async {
//       final response = await http.get(Uri.parse(uri.toString()));
//       return response.body;
//     });
//     _client = authenticatedClient(credentials);

//     // Create a new event on the user's Google Calendar
//     final calendarApi = calendar.CalendarApi(_client);
//     final event = calendar.Event()
//       ..summary = title
//       ..start = calendar.EventDateTime()
//       ..dateTime = startTime.toUtc().toIso8601String()
//       ..timeZone = 'UTC'
//       ..end = calendar.EventDateTime()
//       ..dateTime = endTime.toUtc().toIso8601String()
//       ..timeZone = 'UTC';

//     final calendarId = 'primary'; // Use the primary calendar
//     final createdEvent =
//         await calendarApi.events.insert(event, calendarId).execute();

//     // Store information about the event in Supabase
//     final response = await _supabaseClient.from('reminder').insert({
//       'title': title,
//       'start_time': startTime.toIso8601String(),
//       'end_time': endTime.toIso8601String(),
//       'event_id': createdEvent.id,
//     }).execute();
//     if (response.error != null) {
//       // Handle error
//       print(response.error!.message);
//     }
//   }
// }
