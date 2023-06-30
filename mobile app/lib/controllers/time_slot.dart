import 'package:get/get.dart';
import 'package:supabase_auth/controllers/perawatan.dart';
import 'package:supabase_auth/models/time_slot.dart';
import 'package:supabase_auth/controllers/reservasi.dart';
import 'package:supabase_auth/repository/time_slot.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TimeSlotController extends GetxController {
  final supabase = SupabaseClient(
    'https://fuzdyyktvczvrbwrjkhe.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzI0MTA4ODcsImV4cCI6MTk4Nzk4Njg4N30.kMVUSwTCDMLEM-8ePXPXniT62zkB75Q3gvyvuAbkibU',
  );
  final TimeSlotRepository timeSlotRepository = TimeSlotRepository();
  // final ReservasiController reservasiController = ReservasiController();

  RxList<TimeSlot> timeSlots = <TimeSlot>[].obs;
  Rx<TimeSlot?> selectedTime = Rx<TimeSlot?>(null);
  RxBool isLoading = false.obs;
  RxInt selectedTimeSlotIndex = RxInt(-1);
  RxString selectedTimeSlot = RxString('');

  @override
  void onInit() {
    super.onInit();
  }

  void fetchTimeSlots() async {
    try {
      isLoading.value = true;

      final id = Get.find<PerawatanController>().pegawai;

      if (id.value != null) {
        // Get the time slots for the fetched pegawai ID
        final result = await timeSlotRepository.getTimeSlots(id.value!);
        timeSlots.assignAll(result);

        // Listen to changes in selectedTime and update availability accordingly
        ever(selectedTime, (_) async {
          // Mark the function as async
          // Check if a time slot is selected
          if (selectedTime.value != null) {
            // Update availability for the selected time slot
            await timeSlotRepository.updateAvailability(
                selectedTime.value!.idPegawai.toString(),
                selectedTime.value!.jamPerawatan.toString(),
                selectedTime.value!.id.toString(),
                false,
                null);

            // Update the timeSlots list with the updated time slot
            final index = timeSlots
                .indexWhere((slot) => slot.id == selectedTime.value!.id);
            if (index != -1) {
              timeSlots[index].available = false;
              timeSlots[index].tanggal = null;
            }
          }
        });

        for (var slot in timeSlots) {
          print('Time: ${slot.jamPerawatan}');
        }
      } else {
        print('No time slots found.');
      }
    } catch (e) {
      print("Error fetching time slots: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void updateAvailability() async {
    final ReservasiController reservasiController = ReservasiController();
    if (selectedTime.value != null) {
      final selectedTimeSlotId = selectedTime.value!.id.toString();

      // Get the selected dates from the reservasiController
      final selectedDates = reservasiController.selectedDates;

      try {
        isLoading.value = true;

        // Update the availability and date of the selected time slot
        await timeSlotRepository.updateAvailability(
          selectedTime.value!.idPegawai.toString(),
          selectedTime.value!.jamPerawatan.toString(),
          selectedTimeSlotId,
          false,
          selectedDates.isNotEmpty ? selectedDates.first! : null,
        );

        // Update the timeSlots list to reflect the updated availability
        final index =
            timeSlots.indexWhere((slot) => slot.id == selectedTimeSlotId);
        if (index != -1) {
          timeSlots[index].available = false;
          timeSlots[index].tanggal =
              selectedDates.isNotEmpty ? selectedDates.first! : null;
        }

        print('Availability updated successfully');
      } catch (e) {
        print('Error updating availability: $e');
      } finally {
        isLoading.value = false;
      }
    }
  }
}
