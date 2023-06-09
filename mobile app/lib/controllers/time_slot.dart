import 'package:get/get.dart';
import 'package:supabase_auth/controllers/perawatan.dart';
import 'package:supabase_auth/models/time_slot.dart';
import 'package:supabase_auth/repository/time_slot.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TimeSlotController extends GetxController {
  final supabase = SupabaseClient(
    'https://fuzdyyktvczvrbwrjkhe.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzI0MTA4ODcsImV4cCI6MTk4Nzk4Njg4N30.kMVUSwTCDMLEM-8ePXPXniT62zkB75Q3gvyvuAbkibU',
  );
  final TimeSlotRepository timeSlotRepository = TimeSlotRepository();

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
        final result = await timeSlotRepository.getTimeSlots(id.value);
        timeSlots.assignAll(result);

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
}
