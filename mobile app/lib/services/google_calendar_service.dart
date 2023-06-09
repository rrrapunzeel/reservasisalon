import 'package:googleapis/calendar/v3.dart' as google_calendar;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

class GoogleCalendarService {
  late google_calendar.CalendarApi _calendar;

  // Method to initialize OAuth authentication
  Future<void> initializeOAuth() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: ['https://www.googleapis.com/auth/calendar.events'],
    );

    try {
      await _googleSignIn.signIn();
      final headers = await _googleSignIn.currentUser!.authHeaders;
      final accessToken = headers['Authorization']!.split(' ')[1];

      final httpClient = http.Client();
      final credentials = auth.AccessCredentials(
        auth.AccessToken('Bearer', accessToken, DateTime.now()),
        null,
        ['https://www.googleapis.com/auth/calendar.events'],
      );
      final client = auth.authenticatedClient(httpClient, credentials);

      _calendar = google_calendar.CalendarApi(client);
    } catch (error) {
      // Error during authentication
      print('Error initializing OAuth: $error');
    }
  }

  // Method to add an event to Google Calendar
  Future<bool> addEventToCalendar(
      DateTime eventStartTime, String summary) async {
    try {
      await this.initializeOAuth();

      final event = google_calendar.Event()
        ..summary = summary
        ..start = google_calendar.EventDateTime()
        ..start!.dateTime = eventStartTime.toUtc()
        ..end = google_calendar.EventDateTime()
        ..end!.dateTime = eventStartTime.add(const Duration(hours: 1)).toUtc();

      await _calendar.events.insert(event, 'primary');
      return true;
    } catch (error) {
      print('Error adding event to Google Calendar: $error');
      return false;
    }
  }

  void dispose() {}
}
