import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_auth/models/reservasi.dart';

class ReservasiRepository {
  final supabase = SupabaseClient(
    'https://fuzdyyktvczvrbwrjkhe.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzI0MTA4ODcsImV4cCI6MTk4Nzk4Njg4N30.kMVUSwTCDMLEM-8ePXPXniT62zkB75Q3gvyvuAbkibU',
  );

  Future<List<Reservasi>> getReservasi() async {
    final response = await supabase.from('reservasi').select().execute();

    if (response.error != null) {
      throw response.error?.message ?? "Unknown error occurred";
    }

    final data = response.data as List<dynamic>;
    final reservasi = data.map((json) => Reservasi.fromJson(json)).toList();

    return reservasi;
  }

  Future<List<Reservasi>> getTimeSlotId(int timeSlotId_) async {
    final response = await supabase
        .from('reservasi')
        .select('*')
        .filter('time_slots_id', 'eq', timeSlotId_)
        .execute();

    if (response.error != null) {
      throw response.error?.message ?? "Unknown error occurred";
    }

    final data = response.data as List<dynamic>;
    final timeSlotId = data.map((json) => Reservasi.fromJson(json)).toList();

    return timeSlotId;
  }

  Future<List<DateTime>> getAvailableDates() async {
    try {
      final reservations = await getReservasi();

      final reservedDates =
          reservations.map((reservasi) => reservasi.date).toList();

      final startDate = DateTime.now();
      final endDate = startDate.add(const Duration(days: 30));
      final allDates = List<DateTime>.generate(
        endDate.difference(startDate).inDays + 1,
        (index) => startDate.add(Duration(days: index)),
      );

      final availableDates = <DateTime>[];
      final reservedCountByDate = <DateTime, int>{};

      for (var date in allDates) {
        if (!reservedDates.contains(date)) {
          availableDates.add(date);
        } else {
          final reservationsForDate = reservations
              .where((reservasi) => reservasi.date == date)
              .toList();
          if (reservationsForDate.length < 6) {
            availableDates.add(date);
          } else {
            reservedCountByDate[date] = reservationsForDate.length;
          }
        }
      }

      if (reservedCountByDate.isNotEmpty) {
        // Perform any action for reserved dates, such as storing them or displaying a message
        reservedCountByDate.forEach((date, count) {
          ('$date: $count reservations');
        });
      }

      return availableDates;
    } catch (e) {
      print('Error fetching available dates: $e');
      throw Exception('Failed to fetch available dates');
    }
  }

  Future<bool> isDateAvailable(
      int selectedUserId, DateTime selectedDate) async {
    try {
      final response = await supabase
          .from('time_slots')
          .select('available')
          .eq('id_pegawai', selectedUserId)
          .eq('date', selectedDate)
          .single()
          .execute();

      if (response.error != null) {
        throw response.error!.message;
      }

      final available =
          response.data != null ? response.data['available'] as bool : false;
      return available;
    } catch (e) {
      print('Error checking availability: $e');
      throw Exception('Failed to check availability');
    }
  }
}
