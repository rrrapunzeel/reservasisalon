import 'package:get/get.dart';
import 'package:supabase_auth/models/time_slot.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../SupabaseClient.dart';
import '../models/pembayaran.dart';

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

  Future<void> updateAvailability(String idPegawai, String jamPerawatan,
      String selectedTimeSlotId, bool availability, DateTime? newDate) async {
    final response = await supabase
        .from('time_slots')
        .update(
            {'available': availability, 'tanggal': newDate?.toIso8601String()})
        .eq('idPegawai', idPegawai)
        .eq('jam_perawatan', jamPerawatan)
        .execute();

    if (response.error != null) {
      throw response.error!.message ?? 'Unknown error occurred';
    }

    print('Availability updated successfully');
  }

  Future<void> updatePembayaran(String id, Pembayaran pembayaran) async {
    final response = await supabase
        .from('pembayaran')
        .update(pembayaran.toJson())
        .eq('id', id)
        .execute();

    if (response.error != null) {
      throw response.error!.message ?? 'Unknown error occurred';
    }
  }

  Future<void> insertPembayaran(String id, Pembayaran pembayaran) async {
    // Cek apakah data dengan ID tersebut sudah ada
    final existingData = await getPembayaranById(id);
    if (existingData != null) {
      // Lakukan update jika data sudah ada
      await updatePembayaran(id, pembayaran);
    } else {
      // Lakukan insert jika data belum ada
      final response = await supabase
          .from('pembayaran')
          .insert(pembayaran.toJson())
          .execute();

      if (response.error != null) {
        throw response.error!.message ?? 'Unknown error occurred';
      }
    }
  }

  Future<Pembayaran?> getPembayaranById(String id) async {
    final response = await supabase
        .from('pembayaran')
        .select()
        .eq('id', id)
        .single()
        .execute();

    if (response.error != null) {
      throw response.error!.message ?? 'Unknown error occurred';
    }

    final data = response.data;
    if (data != null) {
      return Pembayaran.fromJson(data);
    }

    return null;
  }
}
