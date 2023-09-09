import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:googleapis_auth/auth_io.dart' as auth;

import '../../controllers/reservasi.dart';
import '../../controllers/time_slot.dart';
import '../../services/google_calendar_service.dart';

class GoogleCalendar extends GetxController {
  final TimeSlotController timeSlotController = Get.find();
  final ReservasiController reservasiController = Get.find();
  late GoogleCalendarService _calendarService;
  calendar.CalendarApi? calendarApi;

  @override
  void onInit() {
    super.onInit();
    _calendarService = GoogleCalendarService();
  }

  @override
  void onClose() {
    _calendarService.dispose();
    super.onClose();
  }

  void addToGoogleCalendar(DateTime selectedDateTime) async {
    // Load credentials from JSON file
    final credentials = auth.ServiceAccountCredentials.fromJson(
      await rootBundle
          .loadString('credentials/challista-beauty-salon-calendar.json'),
    );

    // Authenticate with Google Calendar API
    final client = await auth.clientViaServiceAccount(
      credentials,
      ['https://www.googleapis.com/auth/calendar.events'],
    );

    // Create event resource
    final event = calendar.Event()
      ..summary = 'Payment Success Reminder'
      ..description = 'Reminder for successful payment'
      ..start = calendar.EventDateTime.fromJson({
        'dateTime': selectedDateTime.toUtc().toIso8601String(),
        'timeZone': 'Asia/Bangkok',
      })
      ..end = calendar.EventDateTime.fromJson({
        'dateTime': selectedDateTime
            .toUtc()
            .add(const Duration(hours: 1))
            .toIso8601String(),
        'timeZone': 'Asia/Bangkok',
      });

    // Insert event to Google Calendar
    final calendarApi = calendar.CalendarApi(client);
    await calendarApi.events.insert(event, 'primary');

    // Close the client
    client.close();
  }
}
