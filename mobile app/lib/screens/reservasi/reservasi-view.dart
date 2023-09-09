import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_auth/repository/reservasi.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:supabase_auth/screens/reservasi/detail-view.dart';

import '../../controllers/reservasi.dart';
import '../../controllers/time_slot.dart';
import '../../core/utils/color_constant.dart';
import '../../models/pembayaran.dart';

class ReservasiView extends StatefulWidget {
  final List<Pembayaran> bookings;
  const ReservasiView({Key? key, required this.bookings}) : super(key: key);

  @override
  _ReservasiViewState createState() => _ReservasiViewState();
}

class _ReservasiViewState extends State<ReservasiView>
    with SingleTickerProviderStateMixin {
  List<Pembayaran> bookings = [];
  ReservasiRepository reservasiRepository = Get.put(ReservasiRepository());
  ReservasiController reservasiController = Get.put(ReservasiController());
  TimeSlotController timeSlotController = Get.put(TimeSlotController());

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchHalamanReservasi();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void fetchHalamanReservasi() async {
    try {
      final result = await reservasiRepository.getHalamanReservasi();
      setState(() {
        bookings = result;
      });
      print(bookings);
    } catch (e) {
      print("Error fetching reservasi: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstant.pink300,
        centerTitle: true,
        title: const Text("Pesanan"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Proses'),
            Tab(text: 'Riwayat'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          proses(),
          riwayat(),
        ],
      ),
    );
  }

  // Callback for back button press
  Future<bool> _onWillPop() async {
    // Check if there's a previous route in the stack
    if (_tabController.index > 0) {
      // If there is, switch to the previous tab
      _tabController.animateTo(_tabController.index - 1);
      return false;
    } else {
      // If there's no previous route in the stack, allow the app to exit
      return true;
    }
  }

  Widget proses() {
    final timeFormat = DateFormat('HH:mm');
    final prosesBookings = bookings.where((booking) {
      final status = booking.statusTransaksi;
      return status == 'Berhasil' ||
          status == 'Tertunda' ||
          status == 'Menunggu Konfirmasi';
    }).toList();

    return ListView.builder(
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        final dateFormat = DateFormat('dd-MM-yyyy');

        final formattedTime = timeFormat.format(booking.jam);
// Format the booking time

        return InkWell(
          onTap: () {
            Get.to(() => DetailView(
                booking: booking,
                bookings: bookings)); // Pass the bookings list
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 50,
                          decoration: BoxDecoration(
                            color: ColorConstant.pink300,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                DateFormat('dd').format(booking.tanggal),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                DateFormat('MMM').format(booking.tanggal),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                "${booking.pegawai ?? ""} | ${formattedTime}",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                '${booking.items != null ? jsonDecode(booking.items)[0]['name'] as String : ""}',
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total: ${booking.total?.toStringAsFixed(0) ?? ""}',
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 4.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(
                                          booking.statusTransaksi),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: Text(
                                      '${booking.statusTransaksi ?? ""}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
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

  Widget riwayat() {
    final timeFormat = DateFormat('HH:mm');
    final riwayatBookings = bookings.where((booking) {
      final status = booking.statusTransaksi;
      return status == 'Gagal' || status == 'Batal' || status == 'Lunas';
    }).toList();
    return ListView.builder(
      itemCount: riwayatBookings.length,
      itemBuilder: (context, index) {
        final booking = riwayatBookings[index];
        final dateFormat = DateFormat('dd-MM-yyyy');

        final formattedTime =
            timeFormat.format(booking.jam); // Format the booking time

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 50,
                        decoration: BoxDecoration(
                          color: ColorConstant.pink300,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              DateFormat('dd').format(booking.tanggal),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              DateFormat('MMM').format(booking.tanggal),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              "${booking.pegawai ?? ""} | ${formattedTime}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              '${booking.items != null ? jsonDecode(booking.items)[0]['name'] as String : ""}',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total: ${booking.total?.toStringAsFixed(0) ?? ""}',
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 4.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(
                                        booking.statusTransaksi),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Text(
                                    '${booking.statusTransaksi ?? ""}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
