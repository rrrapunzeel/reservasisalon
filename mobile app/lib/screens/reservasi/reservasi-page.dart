import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_auth/controllers/reservasi.dart';
import 'package:supabase_auth/models/pembayaran.dart';
import 'package:supabase_auth/controllers/checkout.dart';
import 'package:supabase_auth/core/utils/color_constant.dart';
import 'package:supabase_auth/controllers/time_slot.dart';
import 'package:supabase_auth/models/time_slot.dart';
import 'package:intl/intl.dart';

class ReservasiPage extends StatefulWidget {
  const ReservasiPage({Key? key}) : super(key: key);

  @override
  _ReservasiPageState createState() => _ReservasiPageState();
}

class _ReservasiPageState extends State<ReservasiPage> {
  final checkoutController = Get.put(CheckoutController());
  final timeSlotController = Get.put(TimeSlotController());
  final reservasiController = Get.put(ReservasiController());

  final DateFormat timeFormat = DateFormat('HH:mm:ss');
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    checkoutController.fetchHalamanReservasi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstant.pink300,
        centerTitle: true,
        title: const Text("My Bookings"),
      ),
      body: Obx(
        () => checkoutController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: checkoutController.booking.length,
                itemBuilder: (BuildContext context, int index) {
                  final booking = checkoutController.booking[index];
                  print(checkoutController.booking.length);

                  return BookingListItem(
                    booking: booking,
                    getStatusColor: _getStatusColor,
                    fetchHalamanReservasi: fetchHalamanReservasi,
                  );
                },
              ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Confirmed':
        return Colors.green;
      case 'Canceled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void fetchHalamanReservasi(Pembayaran booking) {
    final timeSlotController = Get.find<TimeSlotController>();
    final reservasiController = Get.find<ReservasiController>();
    final selectedTime = timeSlotController.selectedTime.value;
    final jam = selectedTime?.jamPerawatan != null
        ? timeFormat.format(selectedTime!.jamPerawatan!)
        : '';
    final selectedDates = reservasiController.selectedDates;
    final tanggal =
        selectedDates.isNotEmpty ? dateFormat.format(selectedDates.first) : '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Detail Reservasi"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("ID Transaksi: ${booking.idTransaksi}"),
              Text("Nama : ${booking.nama}"),
              Text("Perawatan : ${booking.items}"),
              Text("Pegawai: ${booking.pegawai}"),
              Text("Tanggal: $tanggal"),
              Text("Jam: $jam"),
              Text("Total : ${booking.total}"),
              Text("Status Reservasi: ${booking.statusTransaksi}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}

class BookingListItem extends StatelessWidget {
  final Pembayaran booking;
  final Color Function(String?) getStatusColor;
  final void Function(Pembayaran) fetchHalamanReservasi;

  const BookingListItem({
    required this.booking,
    required this.getStatusColor,
    required this.fetchHalamanReservasi,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reservasiController = Get.find<ReservasiController>();
    final timeSlotController = Get.find<TimeSlotController>();
    final dateFormat = DateFormat('yyyy-MM-dd');
    final timeFormat = DateFormat('HH:mm:ss');
    final TimeSlot? selectedTime = timeSlotController.selectedTime.value;
    final jam = selectedTime?.jamPerawatan != null
        ? timeFormat.format(selectedTime!.jamPerawatan)
        : '';
    final selectedDates = reservasiController.selectedDates;
    final tanggal =
        selectedDates.isNotEmpty ? dateFormat.format(selectedDates.first) : '';

    return GestureDetector(
      onTap: () {
        fetchHalamanReservasi(booking);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    color: Color.fromARGB(255, 226, 97, 140),
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    '$tanggal | $jam',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 226, 97, 140),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text("${booking.nama}"),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text("${booking.items}"),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: getStatusColor(booking.statusTransaksi),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    '${booking.statusTransaksi}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
