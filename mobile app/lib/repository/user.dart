import 'dart:convert';

import 'package:supabase_auth/models/userModel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRepository {
  final supabase = SupabaseClient(
    'https://fuzdyyktvczvrbwrjkhe.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzI0MTA4ODcsImV4cCI6MTk4Nzk4Njg4N30.kMVUSwTCDMLEM-8ePXPXniT62zkB75Q3gvyvuAbkibU',
  );

  get pegawai => null;

  Future<List<UserModel>> getUser() async {
    final response = await supabase.from('user').select().execute();

    if (response.error != null) {
      throw response.error?.message ?? "Unknown error occurred";
    }

    final data = response.data as List<dynamic>;
    final user = data.map((json) => UserModel.fromJson(json)).toList();

    return user;
  }

  Future<UserModel> updateProfile(
      String nama, String nomorTelepon, String id) async {
    final response = await supabase
        .from('user')
        .update({'nama': nama, 'nomor_telepon': nomorTelepon})
        .eq('id', id)
        .execute();

    if (response.error != null) {
      throw response.error?.message ?? "Unknown error occurred";
    }

    final data = response.data as List<dynamic>;
    final updateprofile = UserModel.fromJson(data.first);

    return updateprofile;
  }

  Future<List<UserModel>> getProfile(String id) async {
    final response = await supabase
        .from('user')
        .select('email, nama, nomor_telepon')
        .eq('id', id)
        .execute();

    if (response.error != null) {
      throw response.error?.message ?? "Unknown error occurred";
    }

    final data = response.data as List<dynamic>;
    final profile = data.map((json) => UserModel.fromJson(json)).toList();

    return profile;
  }

  Future<List<UserModel>> getPegawai() async {
    final response =
        await supabase.from('user').select('*').eq('role', 'Pegawai').execute();

    if (response.error != null) {
      throw response.error?.message ?? "Unknown error occurred";
    }

    final data = response.data as List<dynamic>;
    final pegawai = data.map((json) => UserModel.fromJson(json)).toList();

    return pegawai;
  }
}
