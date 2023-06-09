import 'dart:async';
import 'package:get/get.dart';
import 'package:supabase_auth/models/notifikasi.dart';
import 'package:supabase_auth/repository/notifikasi.dart';

class NotifikasiController extends GetxController {
  final NotifikasiRepository notifikasiRepository = NotifikasiRepository();
  final notifikasi = <Notifikasi>[].obs;
  var isLoading = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    fetchNotifikasi();
  }

  void fetchNotifikasi() async {
    isLoading(true);
    try {
      final result = await notifikasiRepository.getNotifikasi();
      notifikasi.assignAll(result);
    } catch (e) {
      print("error");
    }
    isLoading(false);
  }
}
