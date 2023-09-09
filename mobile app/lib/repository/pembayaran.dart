import 'package:supabase_auth/models/pembayaran.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PembayaranRepository {
  final supabase = SupabaseClient(
    'https://fuzdyyktvczvrbwrjkhe.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzI0MTA4ODcsImV4cCI6MTk4Nzk4Njg4N30.kMVUSwTCDMLEM-8ePXPXniT62zkB75Q3gvyvuAbkibU',
  );

  Future<List<Pembayaran>> cancelReservasi() async {
    final response = await supabase
        .from('pembayaran')
        .update(
            {'transaction_status': 'Batal'}) // Update the transaction status
        .in_('transaction_status', ['Tertunda', 'Menunggu Konfirmasi'])
        .order('transaction_status', ascending: true)
        .execute();

    if (response.error != null) {
      throw response.error?.message ?? "Unknown error occurred";
    }

    final data = response.data as List<dynamic>;
    final pembayaran = data.map((json) => Pembayaran.fromJson(json)).toList();

    return pembayaran;
  }

  Future<void> cancelReservation(String transactionId) async {
    final response = await supabase
        .from('pembayaran')
        .update({'transaction_status': 'Batal'})
        .eq('transaction_id', transactionId)
        .execute();

    if (response.error != null) {
      throw response.error?.message ?? "Unknown error occurred";
    }
  }
}
