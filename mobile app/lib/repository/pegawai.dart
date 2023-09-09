// import 'dart:convert';

// import 'package:supabase_auth/models/pegawai.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class PegawaiRepository {
//   final supabase = SupabaseClient(
//     'https://fuzdyyktvczvrbwrjkhe.supabase.co',
//     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzI0MTA4ODcsImV4cCI6MTk4Nzk4Njg4N30.kMVUSwTCDMLEM-8ePXPXniT62zkB75Q3gvyvuAbkibU',
//   );

//   Future<List<String?>> getPegawai() async {
//     final response = await supabase.from('pegawai').select('nama').execute();

//     if (response.error != null) {
//       throw response.error?.message ?? "Unknown error occurred";
//     }

//     final data = response.data as List<dynamic>;
//     final pegawai = data.map((json) => json['nama'] as String?).toList();

//     return pegawai;
//   }
// }
