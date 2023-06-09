import 'package:supabase_auth/models/perawatan.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PerawatanRepository {
  final supabase = SupabaseClient(
    'https://fuzdyyktvczvrbwrjkhe.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzI0MTA4ODcsImV4cCI6MTk4Nzk4Njg4N30.kMVUSwTCDMLEM-8ePXPXniT62zkB75Q3gvyvuAbkibU',
  );

  Future<List<Perawatan>> getPerawatan() async {
    final response = await supabase
        .from('perawatan')
        .select()
        .order('id_perawatan', ascending: true)
        .execute();

    if (response.error != null) {
      throw response.error?.message ?? "Unknown error occurred";
    }

    final data = response.data as List<dynamic>;
    final perawatan = data.map((json) => Perawatan.fromJson(json)).toList();

    return perawatan;
  }

  Future<Perawatan> getPerawatanById(int idPerawatan) async {
    final response = await supabase
        .from('perawatan')
        .select('*')
        .eq('id_perawatan', idPerawatan)
        .single()
        .execute();
    if (response.error != null) {
      throw response.error!;
    }
    return Perawatan.fromJson(response.data);
  }

  Future<List<Perawatan>> getPerawatanByCategory(int idKategori) async {
    final categoryId = int.tryParse(idKategori.toString());

    if (categoryId == null) {
      throw ArgumentError('Invalid idKategori: $idKategori');
    }

    final response = await supabase
        .from('perawatan')
        .select()
        .eq('id_kategori', idKategori)
        .execute();

    final List<Perawatan> perawatans = [];
    for (final row in response.data!) {
      final perawatan = Perawatan.fromJson(row);
      perawatans.add(perawatan);
    }
    return perawatans;
  }
}
