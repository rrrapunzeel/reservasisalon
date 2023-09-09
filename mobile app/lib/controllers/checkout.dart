import 'dart:convert';
import 'package:supabase_auth/controllers/reservasi.dart';
import 'package:supabase_auth/controllers/user.dart';
import 'package:get/get.dart';
import 'package:supabase_auth/repository/reservasi.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_auth/models/pembayaran.dart';
import 'package:supabase_auth/controllers/perawatan.dart';
import 'package:supabase_auth/controllers/time_slot.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/time_slot.dart';

class CheckoutController extends GetxController {
  Pembayaran? getBookingById(String? idTransaksi) {
    return bookings
        .firstWhereOrNull((booking) => booking.idTransaksi == idTransaksi);
  }

  final ReservasiRepository reservasiRepository = ReservasiRepository();
  final PerawatanController perawatanController = PerawatanController();
  final TimeSlotController timeSlotController = TimeSlotController();
  final ReservasiController reservasiController = ReservasiController();
  final bookings = <Pembayaran>[].obs;
  Rx<TimeSlot?> selectedTime = Rx<TimeSlot?>(null);
  var isLoading = false.obs;
  Timer? paymentStatusTimer;

  final supabase = SupabaseClient(
    'https://fuzdyyktvczvrbwrjkhe.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzI0MTA4ODcsImV4cCI6MTk4Nzk4Njg4N30.kMVUSwTCDMLEM-8ePXPXniT62zkB75Q3gvyvuAbkibU',
  );

  @override
  void onInit() {
    super.onInit();
  }

  Future<String> sendPaymentRequest({
    required String idPerawatan,
    required String hargaPerawatan,
    required String total,
    required String pegawai,
    required String tanggal,
    required String jam,
    required List perawatanList,
  }) async {
    final url = 'https://ffff-202-80-216-225.ngrok-free.app/pay';
    final headers = {
      'Content-Type': 'application/json',
    };

    // ambil user
    UserController userController = Get.put(UserController());
    final DateFormat timeFormat = DateFormat('HH:mm:ss');
    final DateFormat inputFormat = DateFormat('yyyy-MM-dd');

    final DateFormat outputFormat = DateFormat('yyyy-MM-dd');

    final DateTime dateTime = inputFormat.parse(tanggal);
    final String formattedDate = outputFormat.format(dateTime);

    final String jam = timeSlotController.selectedTime.value != null
        ? timeFormat.format(timeSlotController.selectedTime.value!.jamPerawatan)
        : '15:00:00';

    List<Map<String, dynamic>> perawatanJsonList =
        List<Map<String, dynamic>>.from(
            perawatanList.map((perawatan) => perawatan.toJson()));

    final body = jsonEncode({
      'nama': userController.getCurrentUser().nama,
      'email': userController.getCurrentUser().email,
      'total': total,
      'jam': jam,
      'tanggal': formattedDate,
      'pegawai': pegawai,
      'perawatan': perawatanJsonList,
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
          'https://ffff-202-80-216-225.ngrok-free.app/snap?token=$snapToken'; // Ganti dengan URL yang sesuai
      await savePaymentRequest(paymentUrl); // Menyimpan paymentUrl ke sesi

      return paymentUrl;
    } else {
      // Permintaan gagal, lakukan tindakan yang sesuai di sini
      print('Gagal mengirim permintaan pembayaran');
      print(paymentResponse.statusCode);
      print(paymentResponse.body);
      return 'error';
    }
  }

  Future<void> savePaymentRequest(String paymentUrl) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('snapToken', paymentUrl);
  }

  void launchPaymentUrl() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? paymentUrl = prefs.getString('snapToken');

    if (paymentUrl != null) {
      if (await canLaunch(paymentUrl)) {
        await launch(paymentUrl);
      } else {
        throw 'Tidak dapat meluncurkan URL';
      }
    }
  }

  Future<String?> fetchTransactionStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? snapToken = prefs.getString('snapToken');
    final url = Uri.parse(
        'https://ffff-202-80-216-225.ngrok-free.app/snap?token=$snapToken');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final transactionStatus = jsonResponse['status'];

      return transactionStatus;
    } else {
      throw Exception('Gagal memperoleh status transaksi');
    }
  }

  Future<String> sendJadwal({
    required List<DateTime> selectedDates,
    required String selectedTime,
  }) async {
    final url = 'https://fuzdyyktvczvrbwrjkhe.supabase.co/rest/v1/pembayaran';
    final headers = {
      'Content-Type': 'application/json',
      'apikey':
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzI0MTA4ODcsImV4cCI6MTk4Nzk4Njg4N30.kMVUSwTCDMLEM-8ePXPXniT62zkB75Q3gvyvuAbkibU',
    };
    final formatter = DateFormat('yyyy-MM-dd');
    final formattedDates =
        selectedDates.map((date) => formatter.format(date)).toList();

    final body = jsonEncode({
      'tanggal': formattedDates,
      'jam': selectedTime,
    });

    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 201) {
      // Data berhasil disimpan ke database Supabase
      print('Data berhasil disimpan');
      return 'Data berhasil disimpan';
    } else {
      // Gagal menyimpan data ke database Supabase
      print('Gagal menyimpan data');
      print(response.statusCode);
      print(response.body);
      return 'Gagal menyimpan data';
    }
  }

  Color _getStatusColor(StatusTransaksi status) {
    switch (status) {
      case StatusTransaksi.success:
        return Colors.green;
      case StatusTransaksi.pending:
        return Colors.yellow;
      case StatusTransaksi.failed:
        return Colors.red;
      case StatusTransaksi.cancel:
        return const Color.fromARGB(255, 165, 13, 2);
      case StatusTransaksi.done:
        return const Color.fromARGB(255, 2, 100, 165);
      default:
        return Colors.grey;
    }
  }
}
