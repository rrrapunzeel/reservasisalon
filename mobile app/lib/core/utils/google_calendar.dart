import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:googleapis_auth/auth_io.dart' as auth;

class GoogleCalendar extends GetxController {
  void addToGoogleCalendar(DateTime selectedDateTime) async {
    // Load credentials from JSON file
    final credentials = auth.ServiceAccountCredentials.fromJson(
      await rootBundle.loadString('assets/credentials.json'),
      ['https://www.googleapis.com/auth/calendar.events'],
    );

    // Authenticate with Google Calendar API
    final client = await auth.clientViaServiceAccount(credentials);

    // Create event resource
    final event = calendar.Event()
      ..summary = 'Payment Success Reminder'
      ..description = 'Reminder for successful payment'
      ..start = calendar.EventDateTime()
      ..dateTime = selectedDateTime
      ..timeZone = 'YOUR_TIMEZONE' // Set your timezone here
      ..end = calendar.EventDateTime()
      ..dateTime = selectedDateTime.add(const Duration(hours: 1))
      ..timeZone = 'YOUR_TIMEZONE'; // Set your timezone here

    // Insert event to Google Calendar
    final calendarApi = calendar.CalendarApi(client);
    await calendarApi.events.insert(event, 'primary');

    // Close the client
    client.close();
  }
}
