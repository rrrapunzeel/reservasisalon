import 'dart:async';
import 'package:get/get.dart';
import 'package:supabase_auth/models/notifikasi.dart';
import 'package:supabase_auth/repository/notifikasi.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';

class NotifikasiController extends GetxController {
  final NotifikasiRepository notifikasiRepository = NotifikasiRepository();
  final notifikasi = <Notifikasi>[].obs;
  var isLoading = false.obs;
  OneSignal _oneSignal = OneSignal.shared;

  @override
  Future<void> onInit() async {
    super.onInit();
    _configureOneSignal();
  }

  void _configureOneSignal() {
    _oneSignal.setAppId("YOUR_ONESIGNAL_APP_ID");

    _oneSignal.setNotificationOpenedHandler((openedResult) {
      print("Opened app from notification: ${openedResult.notification.body}");
      // Tambahkan logika untuk menangani aksi ketika pengguna membuka aplikasi dari notifikasi
    });
  }

  Future<String> sendNotification() async {
    final response = await http.post(
      Uri.parse('http://localhost:8000/send-notification'),
      body: {'message': 'Pesan notifikasi'},
    );

    if (response.statusCode == 200) {
      // Permintaan berhasil
      return 'Notifikasi berhasil dikirim';
    } else {
      // Permintaan gagal
      return 'Gagal mengirim notifikasi';
    }
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
