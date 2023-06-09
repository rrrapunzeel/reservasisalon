import 'package:supabase_auth/models/time_slot.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TimeSlotRepository {
  final supabase = SupabaseClient(
    'https://fuzdyyktvczvrbwrjkhe.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzI0MTA4ODcsImV4cCI6MTk4Nzk4Njg4N30.kMVUSwTCDMLEM-8ePXPXniT62zkB75Q3gvyvuAbkibU',
  );

  Future<List<TimeSlot>> getTimeSlots(String idPegawai) async {
    final response = await supabase
        .from('time_slots')
        .select('*')
        .filter('idPegawai', 'eq', idPegawai)
        .execute();

    if (response.error != null) {
      throw response.error!.message ?? 'Unknown error occurred';
    }

    final data = response.data as List<dynamic>;
    final timeslots = data.map((json) => TimeSlot.fromJson(json)).toList();

    return timeslots;
  }
}
