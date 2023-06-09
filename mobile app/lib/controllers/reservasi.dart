import 'dart:async';
import 'package:get/get.dart';
import 'package:supabase_auth/models/reservasi.dart';
import 'package:supabase_auth/repository/reservasi.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReservasiController extends GetxController {
  final supabase = SupabaseClient(
    'https://fuzdyyktvczvrbwrjkhe.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzI0MTA4ODcsImV4cCI6MTk4Nzk4Njg4N30.kMVUSwTCDMLEM-8ePXPXniT62zkB75Q3gvyvuAbkibU',
  );
  final ReservasiRepository reservasiRepository = ReservasiRepository();
  final reservasi = <Reservasi>[].obs;
  var isLoading = false.obs;
  late DateTime firstDayOfMonth;
  late DateTime lastDayOfMonth;
  final selectableDates = <DateTime>[].obs;
  final enabledDates = <DateTime>[].obs;
  final availableDates = <DateTime>[].obs;
  RxString selectedPegawaiId = RxString('');
  RxList<DateTime> selectedDates = RxList<DateTime>([]);

  @override
  Future<void> onInit() async {
    super.onInit();
    fetchReservasi();
    fetchAvailableDates();
  }

  void fetchReservasi() async {
    isLoading(true);
    try {
      final result = await reservasiRepository.getReservasi();
      reservasi.assignAll(result);

      final reservedDates = result.map((reservasi) => reservasi.date).toList();

      final startDate = DateTime.now();
      final endDate = startDate.add(const Duration(days: 30));
      final allDates = List<DateTime>.generate(
        endDate.difference(startDate).inDays + 1,
        (index) => startDate.add(Duration(days: index)),
      );

      enabledDates.clear();

      for (var date in allDates) {
        if (!reservedDates.contains(date)) {
          enabledDates.add(date);
        } else {
          final reservationsForDate =
              reservasi.where((reservasi) => reservasi.date == date).toList();
          if (reservationsForDate.length >= 5) {
            enabledDates.remove(date);
          }
        }
      }

      selectedDates.value = reservasi
          .map((reservasi) => DateTime(
                reservasi.date.year,
                reservasi.date.month,
                reservasi.date.day,
              ))
          .toList();
    } catch (e) {
      print('Error fetching reservasi: $e');
    }
    isLoading(false);
  }

  void fetchAvailableDates() async {
    isLoading(true);
    try {
      final result = await reservasiRepository.getAvailableDates();
      availableDates.clear();
      availableDates.addAll(result);
    } catch (e) {
      print("Error fetching available dates: $e");
    }
    isLoading(false);
  }
}
