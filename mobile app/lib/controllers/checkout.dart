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

import '../models/time_slot.dart';

class CheckoutController extends GetxController {
  final ReservasiRepository reservasiRepository = ReservasiRepository();
  final PerawatanController perawatanController = PerawatanController();
  final TimeSlotController timeSlotController = TimeSlotController();
  final ReservasiController reservasiController = ReservasiController();
  final booking = <Pembayaran>[].obs;
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
    required List perawatanList,
  }) async {
    final url = 'https://8f81-202-80-216-225.ngrok-free.app/pay';
    final headers = {
      'Content-Type': 'application/json',
    };

    // ambil user
    UserController userController = Get.put(UserController());

    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    final List<DateTime> selectedDates = reservasiController.selectedDates;
    final String formattedTanggal =
        selectedDates.isNotEmpty ? dateFormat.format(selectedDates.first) : '';

    List<Map<String, dynamic>> perawatanJsonList =
        List<Map<String, dynamic>>.from(
            perawatanList.map((perawatan) => perawatan.toJson()));

    final body = jsonEncode({
      'nama': userController.getCurrentUser().nama,
      'email': userController.getCurrentUser().email,
      'tanggal': formattedTanggal,
      'pegawai': pegawai,
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
          'https://8f81-202-80-216-225.ngrok-free.app/snap?token=$snapToken'; // Ganti dengan URL yang sesuai

      return paymentUrl;
    } else {
      // Permintaan gagal, lakukan tindakan yang sesuai di sini
      print('Gagal mengirim permintaan pembayaran');
      print(paymentResponse.statusCode);
      print(paymentResponse.body);
      return 'error';
    }
  }

  Future<void> insertPembayaran() async {
    final url = 'http://localhost:8000/pembayaran/create';
    final headers = {
      'Content-Type': 'application/json',
      'apikey':
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3MjQxMDg4NywiZXhwIjoxOTg3OTg2ODg3fQ.BOAcPoDA9lRPqeiwrhBwg0T5ODABcj2qHAglocH73ow',
      'Prefer': 'return=representation'
    };

    PerawatanController perawatanController = Get.put(PerawatanController());
    ReservasiController reservasiController = Get.put(ReservasiController());

    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    // Mengambil data pegawai dari perawatanController
    String pegawai = perawatanController.pegawaiNama.value;

    // Mengambil data jam dari timeSlotController
    // String jam =
    //     timeFormat.format(timeSlotController.selectedTime.value!.jamPerawatan);

    // Mengambil data tanggal dari selectedDates dalam reservasiController
    List<DateTime> selectedDates = reservasiController.selectedDates;
    String tanggal =
        selectedDates.isNotEmpty ? dateFormat.format(selectedDates.first) : '';

    // Membuat objek body untuk dikirim sebagai JSON
    final body = jsonEncode({
      'pegawai': pegawai,
      // 'jam': jam,
      'tanggal': tanggal,
    });
    // Lakukan log untuk memeriksa data yang diperoleh
    print("Pegawai: $pegawai");
    // print("Jam: $jam");
    print("Tanggal: $tanggal");

    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      // Berhasil memasukkan data
      print('Data berhasil dimasukkan');
    } else {
      // Gagal memasukkan data
      print('Gagal memasukkan data');
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
      case StatusTransaksi.cancel:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void fetchHalamanReservasi() async {
    try {
      final result = await reservasiRepository.getHalamanReservasi();
      List<Pembayaran> bookings = result;

      // Memperbarui variabel checkoutController.booking dengan daftar bookings
      booking.value = bookings;

      for (Pembayaran booking in bookings) {
        String? statusString = booking.statusTransaksi;
        StatusTransaksi status = getStatusFromString(statusString);
        Color statusColor = _getStatusColor(status);
        // Use the statusColor as needed
      }
    } catch (e) {
      print(e.toString()); // Print the error message
    }
    isLoading.value = false;
  }
}
