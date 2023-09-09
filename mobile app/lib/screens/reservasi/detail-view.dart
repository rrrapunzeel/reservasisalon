import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:intl/intl.dart';
import 'package:supabase_auth/screens/reservasi/reservasi-view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import '../../core/utils/color_constant.dart';
import '../../core/utils/image_constant.dart';
import '../../core/utils/size_utils.dart';
import '../../models/pembayaran.dart';
import '../../repository/pembayaran.dart';
import '../../widgets/custom_image_view.dart';

class DetailView extends StatelessWidget {
  final Pembayaran booking;
  final List<Pembayaran> bookings;

  const DetailView({Key? key, required this.booking, required this.bookings})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd-MM-yyyy');
    final timeFormat = DateFormat('HH:mm');
    final formattedTime = timeFormat.format(booking.jam);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorConstant.pink300,
        centerTitle: true,
        title: const Text("Detail Reservasi"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10.0),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CustomImageView(
                      imagePath: ImageConstant.imgPreview,
                      height: getSize(200),
                      width: getSize(200),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Jadwal',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${dateFormat.format(booking.tanggal)} | $formattedTime',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Status:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(booking.statusTransaksi),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                booking.statusTransaksi.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Detail Treatment",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      '${booking.items != null ? jsonDecode(booking.items)[0]['name'] as String : ""}',
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Pegawai",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('${booking.pegawai ?? ""}'),
                  const SizedBox(height: 16),
                  const Text(
                    "Total",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text("Rp${booking.total?.toStringAsFixed(0) ?? ''}"),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: (booking.statusTransaksi ==
                                      'Menunggu Pembayaran' ||
                                  booking.statusTransaksi == 'Tertunda')
                              ? () async {
                                  await cancelReservation();
                                }
                              : null, // Nonaktifkan tombol jika status bukan 'Menunggu Konfirmasi' atau 'Pembayaran Tertunda'
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                          ),
                          child: const Text(
                            "Batalkan Reservasi",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: (booking.statusTransaksi ==
                                      'Menunggu Pembayaran' ||
                                  booking.statusTransaksi == 'Tertunda')
                              ? () async {
                                  var payment = await getPaymentUrl();
                                  if (payment != null) {
                                    if (await canLaunch(payment)) {
                                      await launch(payment);
                                    } else {
                                      throw Exception(
                                          'Could not launch $payment');
                                    }
                                  } else {
                                    throw Exception(
                                        'Failed to send payment request');
                                  }
                                }
                              : null, // Nonaktifkan tombol jika status bukan 'Menunggu Konfirmasi' atau 'Pembayaran Tertunda'
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                          ),
                          child: const Text(
                            "Bayar",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> cancelReservation() async {
    final pembayaranRepo = PembayaranRepository();
    final idTransaksi = booking.idTransaksi;
    final pembayaran = getBookingById(idTransaksi);

    if (pembayaran?.statusTransaksi == 'Tertunda' ||
        pembayaran?.statusTransaksi == 'Menunggu Pembayaran') {
      // Show the confirmation dialog
      bool confirmed = await Get.defaultDialog(
        title: "Konfirmasi",
        middleText: "Apakah Anda yakin ingin membatalkan reservasi ini?",
        actions: [
          ElevatedButton(
            onPressed: () => Get.back(result: true), // Return true if confirmed
            child: Text("Ya"),
          ),
          ElevatedButton(
            onPressed: () =>
                Get.back(result: false), // Return false if canceled
            child: Text("Tidak"),
          ),
        ],
      );

      // Check the user's response from the dialog
      if (confirmed) {
        await pembayaranRepo.cancelReservation(idTransaksi.toString());
        Get.back();
        Get.snackbar(
          "Success",
          "Reservasi berhasil dibatalkan",
          snackStyle: SnackStyle.GROUNDED,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        // If not confirmed, do nothing or show a message if needed
        print("Reservation cancelation canceled by the user");
      }
    } else {
      Get.snackbar(
        "Error",
        "Mohon maaf, reservasi tidak dapat dibatalkan",
        snackStyle: SnackStyle.GROUNDED,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<String?> getPaymentUrl() async {
    try {
      final transactionId = await getTransactionIdFromSupabase();
      final snapToken = await getSnapTokenByTransactionId(transactionId!);

      final paymentUrl =
          'https://ffff-202-80-216-225.ngrok-free.app/snap?token=$snapToken'; // Ganti dengan URL yang sesuai

      return paymentUrl;
    } catch (error) {
      // Handle error
      print('Error occurred: $error');
      return null;
    }
  }

  Future<String?> getTransactionIdFromSupabase() async {
    try {
      final supabase = SupabaseClient(
        'https://fuzdyyktvczvrbwrjkhe.supabase.co',
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzI0MTA4ODcsImV4cCI6MTk4Nzk4Njg4N30.kMVUSwTCDMLEM-8ePXPXniT62zkB75Q3gvyvuAbkibU',
      );

      final response = await supabase
          .from('pembayaran')
          .select('transaction_id')
          .order('id', ascending: false)
          .limit(1) // Limit the result to 1 row
          .single()
          .execute();

      if (response.error != null) {
        throw response.error?.message ?? 'Unknown error occurred';
      }

      final data = response.data as Map<String, dynamic>?;
      final String? transactionId = data?['transaction_id'] as String?;

      if (transactionId == null) {
        throw Exception('Transaction ID not found or is null');
      }

      print("transaction id: ${transactionId}");
      return transactionId;
    } catch (error) {
      print('Error occurred: $error');
      return null;
    }
  }

  Future<String?> getSnapTokenByTransactionId(String transactionId) async {
    final supabase = SupabaseClient(
      'https://fuzdyyktvczvrbwrjkhe.supabase.co',
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzI0MTA4ODcsImV4cCI6MTk4Nzk4Njg4N30.kMVUSwTCDMLEM-8ePXPXniT62zkB75Q3gvyvuAbkibU',
    );
    final response = await supabase
        .from('pembayaran')
        .select('snap_token')
        .eq('transaction_id', transactionId)
        .single()
        .execute();

    if (response.error != null) {
      throw response.error?.message ?? 'Unknown error occurred';
    }

    final data = response.data as Map<String, dynamic>?;
    final snapToken = data?['snap_token'] as String?;

    print("snap token: ${snapToken}");
    return snapToken;
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Tertunda':
        return Colors.orange;
      case 'Lunas':
        return Colors.green;
      case 'Gagal':
        return Colors.red;
      case 'Batal':
        return const Color.fromARGB(255, 165, 13, 2);
      case 'Berhasil':
        return const Color.fromARGB(255, 2, 100, 165);
      default:
        return Colors.grey;
    }
  }

  Pembayaran? getBookingById(String? idTransaksi) {
    try {
      return bookings
          .firstWhere((booking) => booking.idTransaksi == idTransaksi);
    } catch (_) {
      return null;
    }
  }
}
