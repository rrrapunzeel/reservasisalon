import 'dart:convert';
import 'package:supabase_auth/controllers/user.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;

class CheckoutController extends GetxController {
  final supabase = SupabaseClient(
    'https://fuzdyyktvczvrbwrjkhe.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzI0MTA4ODcsImV4cCI6MTk4Nzk4Njg4N30.kMVUSwTCDMLEM-8ePXPXniT62zkB75Q3gvyvuAbkibU',
  );

  Future<String> sendPaymentRequest({
    required String idPerawatan,
    // required String perawatan,
    required String hargaPerawatan,
    required String total,
    required List perawatanList,
  }) async {
    final url =
        'https://c11e-202-80-216-225.ngrok-free.app/pay'; // Ganti dengan URL yang sesuai
    final headers = {
      'Content-Type': 'application/json',
    };

    // ambil user
    UserController userController = Get.put(UserController());

    List<Map<String, dynamic>> perawatanJsonList =
        List<Map<String, dynamic>>.from(
            perawatanList.map((perawatan) => perawatan.toJson()));

    final body = jsonEncode({
      // Menggunakan data yang diambil dari tabel Supabase
      'nama': userController.getCurrentUser().nama,
      'email': userController.getCurrentUser().email,
      'perawatan': perawatanJsonList,
      'total': total
    });

    final paymentResponse =
        await http.post(Uri.parse(url), headers: headers, body: body);

    if (paymentResponse.statusCode == 200) {
      // Permintaan berhasil, lakukan tindakan yang sesuai di sini
      print('Permintaan pembayaran berhasil');

      final responseData = jsonDecode(paymentResponse.body);
      print(responseData['snapToken']);
      final snapToken = responseData['snap_token'];

      // Meluncurkan halaman pembayaran menggunakan snapToken
      final paymentUrl =
          'https://c11e-202-80-216-225.ngrok-free.app/snap?token=$snapToken'; // Ganti dengan URL yang sesuai

      return paymentUrl;
    } else {
      // Permintaan gagal, lakukan tindakan yang sesuai di sini
      print('Gagal mengirim permintaan pembayaran');
      print(paymentResponse.statusCode);
      print(paymentResponse.body);
      return 'error';
    }
  }
}
