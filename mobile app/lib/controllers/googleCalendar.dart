import 'package:get/get.dart';
import 'package:supabase_auth/controllers/reservasi.dart';
import 'package:supabase_auth/controllers/time_slot.dart';
import 'package:supabase_auth/services/google_calendar_service.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;

class GoogleCalendarController extends GetxController {
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

  Future<bool> addEventToCalendar(
      DateTime eventStartTime, String summary) async {
    try {
      await _calendarService.initializeOAuth();
      final event = calendar.Event()
        ..summary = summary
        ..start = calendar.EventDateTime()
        ..start!.dateTime = eventStartTime.toUtc()
        ..start!.timeZone = 'GMT'
        ..end = calendar.EventDateTime()
        ..end!.dateTime = eventStartTime.add(const Duration(hours: 1)).toUtc()
        ..end!.timeZone = 'GMT';

      await calendarApi?.events.insert(event, 'primary');
      print(eventStartTime);
      return true;
    } catch (error) {
      print('Error adding event to Google Calendar: $error');
      return false;
    }
  }

  Future<String> createEventInCalendar(
      DateTime startDate, DateTime endDate) async {
    calendar.Event event = calendar.Event()
      ..summary = 'My Event'
      ..start = calendar.EventDateTime()
      ..end = calendar.EventDateTime();

    event.start!.dateTime = startDate.toUtc();
    event.start!.timeZone = 'GMT';
    event.end!.dateTime = endDate.toUtc();
    event.end!.timeZone = 'GMT';

    try {
      calendar.Event createdEvent =
          await calendarApi!.events.insert(event, 'primary');
      return createdEvent.id!;
    } catch (e) {
      print('Error creating event: $e');
      return '';
    }
  }

  void updateCalendarEvents() {
    calendarApi!.events.list('primary').then((events) {
      final selectedDates = reservasiController.selectedDates;

      for (var event in events.items!) {
        DateTime eventDate = event.start!.dateTime!.toLocal();
        if (!selectedDates.contains(eventDate)) {
          calendarApi!.events.delete('primary', event.id!);
        }
      }

      for (var selectedDate in selectedDates) {
        bool eventExists = events.items!.any((event) {
          DateTime eventDate = event.start!.dateTime!.toLocal();
          return selectedDate.year == eventDate.year &&
              selectedDate.month == eventDate.month &&
              selectedDate.day == eventDate.day;
        });

        if (!eventExists) {
          createEventInCalendar(
            selectedDate,
            selectedDate.add(const Duration(hours: 1)),
          );
        }
      }
    });
  }

  Future<void> addReminderToEvent(DateTime eventDateTime) async {
    try {
      // Buat objek EventReminder
      calendar.EventReminder reminder = calendar.EventReminder();
      reminder.minutes = 30; // Mengatur pengingat 30 menit sebelum acara

      // Dapatkan daftar acara di Google Calendar
      calendar.Events events = await calendarApi!.events.list('primary');

      // Loop melalui setiap acara
      for (var event in events.items!) {
        // Periksa apakah acara cocok dengan tanggal dan jam yang dipilih
        DateTime eventDate = event.start!.dateTime!.toLocal();
        if (eventDate == eventDateTime) {
          // Tambahkan pengingat ke acara yang cocok
          event.reminders!.useDefault = false;
          event.reminders!.overrides = [reminder];
          await calendarApi!.events.update(event, 'primary', event.id!);
          break;
        }
      }
    } catch (e) {
      print('Terjadi kesalahan saat menambahkan pengingat: $e');
    }
  }
}
