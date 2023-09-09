// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:supabase_auth/controllers/reservasi.dart';
// import 'package:supabase_auth/models/pembayaran.dart';
// import 'package:supabase_auth/repository/pembayaran.dart';
// import 'package:supabase_auth/controllers/checkout.dart';
// import 'package:supabase_auth/core/utils/color_constant.dart';
// import 'package:supabase_auth/controllers/time_slot.dart';
// import 'package:intl/intl.dart';
// import 'package:supabase_auth/screens/reservasi/detail-page.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// import '../../SupabaseClient.dart';

// class ReservasiPage extends StatefulWidget {
//   const ReservasiPage({Key? key}) : super(key: key);

//   @override
//   _ReservasiPageState createState() => _ReservasiPageState();
// }

// class _ReservasiPageState extends State<ReservasiPage>
//     with SingleTickerProviderStateMixin {
//   final checkoutController = Get.put(CheckoutController());
//   final timeSlotController = Get.put(TimeSlotController());
//   final reservasiController = Get.put(ReservasiController());

//   final DateFormat timeFormat = DateFormat('HH:mm:ss');
//   final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     checkoutController.fetchHalamanReservasi();
//     getTransactionIdFromSupabase();
//     // transactionId.getTransactionIdFromSupabase();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: ColorConstant.pink300,
//         centerTitle: true,
//         title: const Text("Pesanan"),
//         bottom: TabBar(
//           controller: _tabController,
//           tabs: const [
//             Tab(text: 'Proses'),
//             Tab(text: 'Riwayat'),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           _buildOngoingBookings(),
//           _buildHistoryBookings(),
//         ],
//       ),
//     );
//   }

//   Widget _buildOngoingBookings() {
//     return Obx(
//       () => checkoutController.isLoading.value
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               padding: const EdgeInsets.all(8),
//               itemCount: checkoutController.booking.length,
//               itemBuilder: (BuildContext context, int index) {
//                 final bookingItem = checkoutController.booking[index];
//                 print(checkoutController.booking.length);

//                 List<dynamic> itemJson = bookingItem.items != null
//                     ? jsonDecode(bookingItem.items!)
//                     : [];
//                 List items =
//                     itemJson.map((item) => item['name'].toString()).toList();

//                 final selectedDates = reservasiController.selectedDates;
//                 if (selectedDates.isEmpty) {
//                   return const SizedBox(); // Jika selectedDates kosong, tampilkan SizedBox
//                 }

//                 Color statusColor =
//                     _getStatusColor(bookingItem.statusTransaksi);

//                 // Check the status of the booking
//                 if (bookingItem.statusTransaksi == "Berhasil" &&
//                     bookingItem.statusTransaksi == "Pembayaran Tertunda" &&
//                     bookingItem.statusTransaksi == "Menunggu Konfirmasi") {
//                   return BookingListItem(
//                     bookingItem: bookingItem,
//                     fetchHalamanReservasi: fetchHalamanReservasi,
//                     getStatusColor: _getStatusColor,
//                     cancelReservation: cancelReservation,
//                     selectedDates: selectedDates,
//                     items: items,
//                     statusColor: statusColor,
//                     navigateToDetailPage: navigateToDetailPage,
//                   );
//                 } else {
//                   return const SizedBox(); // Jika status bukan "confirmed", tampilkan SizedBox
//                 }
//               },
//             ),
//     );
//   }

//   Widget _buildHistoryBookings() {
//     return Obx(
//       () => checkoutController.isLoading.value
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               padding: const EdgeInsets.all(8),
//               itemCount: checkoutController.booking.length,
//               itemBuilder: (BuildContext context, int index) {
//                 final bookingItem = checkoutController.booking[index];
//                 print(checkoutController.booking.length);

//                 List<dynamic> itemJson = bookingItem.items != null
//                     ? jsonDecode(bookingItem.items!)
//                     : [];
//                 List items =
//                     itemJson.map((item) => item['name'].toString()).toList();

//                 final selectedDates = reservasiController.selectedDates;
//                 if (selectedDates.isEmpty) {
//                   return const SizedBox(); // Jika selectedDates kosong, tampilkan SizedBox
//                 }

//                 // Check the status of the booking
//                 Color statusColor =
//                     _getStatusColor(bookingItem.statusTransaksi);

//                 if (bookingItem.statusTransaksi == "Pembayaran Gagal" &&
//                     bookingItem.statusTransaksi == "Treatment Selesai") {
//                   return BookingListItem(
//                     bookingItem: bookingItem,
//                     fetchHalamanReservasi: fetchHalamanReservasi,
//                     getStatusColor: _getStatusColor,
//                     cancelReservation: cancelReservation,
//                     selectedDates: selectedDates,
//                     items: items,
//                     navigateToDetailPage: navigateToDetailPage,
//                     statusColor: statusColor, // Tambahkan statusColor di sini
//                   );
//                 } else {
//                   return const SizedBox(); // Jika status "confirmed", tampilkan SizedBox
//                 }
//               },
//             ),
//     );
//   }

//   Future<String?> getTransactionIdFromSupabase() async {
//     final supabase = SupabaseClient(
//       'https://fuzdyyktvczvrbwrjkhe.supabase.co',
//       'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzI0MTA4ODcsImV4cCI6MTk4Nzk4Njg4N30.kMVUSwTCDMLEM-8ePXPXniT62zkB75Q3gvyvuAbkibU',
//     );
//     final response = await supabase
//         .from('pembayaran')
//         .select('id')
//         .order('id', ascending: false)
//         .limit(2)
//         .execute();

//     if (response.error != null) {
//       throw response.error!.message ?? 'Unknown error occurred';
//     }

//     final data = response.data as List<dynamic>;
//     final transactionIds =
//         data.map((json) => json['transaction_id'].toString()).toList();

//     if (transactionIds.isEmpty) {
//       return null; // Handle the case when no rows are returned
//     }

//     final transactionId =
//         transactionIds[0]; // Ambil transaction_id dari row terakhir

//     return transactionId;
//   }

//   void fetchHalamanReservasi(Pembayaran booking) {
//     final timeSlotController = Get.find<TimeSlotController>();
//     final reservasiController = Get.find<ReservasiController>();
//     final selectedTime = timeSlotController.selectedTime.value;
//     final jam = selectedTime?.jamPerawatan != null
//         ? timeFormat.format(selectedTime!.jamPerawatan!)
//         : '';
//     final selectedDates = reservasiController.selectedDates;
//     final tanggal =
//         selectedDates.isNotEmpty ? dateFormat.format(selectedDates.first) : '';
//   }

//   Color _getStatusColor(String? status) {
//     switch (status) {
//       case 'Pembayaran Tertunda':
//         return Colors.orange;
//       case 'Berhasil':
//         return Colors.green;
//       case 'Pembayaran Gagal':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }

//   void navigateToDetailPage(Pembayaran booking) {
//     Get.to(DetailPage(booking: booking));
//   }

//   Future<void> cancelReservation(String? idTransaksi) async {
//     final pembayaranRepo = PembayaranRepository();
//     final pembayaran = checkoutController.getBookingById(idTransaksi);

//     if (pembayaran?.statusTransaksi == 'Pembayaran Tertunda') {
//       await pembayaranRepo.cancelReservation(idTransaksi.toString());
//       Get.back();
//       Get.snackbar("Success", "Reservation canceled");
//       checkoutController.fetchHalamanReservasi();
//     } else {
//       Get.snackbar(
//           "Error", "Cannot cancel reservation. Status is not Pending.");
//     }
//   }
// }

// class BookingListItem extends StatelessWidget {
//   final Pembayaran bookingItem;
//   final Function(Pembayaran) fetchHalamanReservasi;
//   final Color Function(String?) getStatusColor;
//   final Function(String?) cancelReservation;
//   final List<DateTime> selectedDates;
//   final Function(Pembayaran) navigateToDetailPage;
//   final Color statusColor;

//   const BookingListItem({
//     required this.fetchHalamanReservasi,
//     required this.bookingItem,
//     required this.getStatusColor,
//     required this.navigateToDetailPage,
//     required this.cancelReservation,
//     required this.selectedDates,
//     required this.statusColor,
//     Key? key,
//     required List<dynamic> items,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     List<dynamic> itemJson = jsonDecode(bookingItem.items ?? '[]');
//     List items = itemJson.map((item) => item['name']).toList();
//     final reservasiController = Get.find<ReservasiController>();
//     final timeSlotController = Get.find<TimeSlotController>();
//     final dateFormat = DateFormat('yyyy-MM-dd');
//     final timeFormat = DateFormat('HH:mm:ss');

//     final selectedDates = reservasiController.selectedDates;
//     List<DateTime> selectedDatess = reservasiController.selectedDates;
//     final tanggal = selectedDatess.isNotEmpty
//         ? dateFormat.format(selectedDatess.first)
//         : '';

//     String jam = '';
//     final selectedTime = timeSlotController.selectedTime.value;
//     if (selectedTime != null) {
//       jam = timeFormat.format(selectedTime.jamPerawatan);
//     }

//     return GestureDetector(
//       onTap: () {
//         navigateToDetailPage(
//             bookingItem); // Navigasi ke halaman detail dengan parameter booking
//       },
//       child: Card(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Align(
//                 alignment: Alignment.center,
//                 child: Container(
//                   width: 50, // Lebar kotak tanggal dan bulan
//                   decoration: BoxDecoration(
//                     color: ColorConstant.pink300, // Warna latar belakang kotak
//                     borderRadius: BorderRadius.circular(4.0),
//                   ),
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     children: [
//                       Text(
//                         DateFormat('dd')
//                             .format(selectedDatess.first), // Tampilkan tanggal
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white, // Warna font
//                         ),
//                       ),
//                       Text(
//                         DateFormat('MMM')
//                             .format(selectedDatess.first), // Tampilkan bulan
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white, // Warna font
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 10.0),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 8.0),
//                     child: Text("${bookingItem.jam}"),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 8.0),
//                     child: Text(items.join(", ")),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 8.0),
//                     child: Text("${bookingItem.pegawai}"),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 8.0),
//                     child: Text(
//                         "Rp${bookingItem.total?.toStringAsFixed(0) ?? ''}"),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 8.0),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 8.0,
//                         vertical: 4.0,
//                       ),
//                       decoration: BoxDecoration(
//                         color: getStatusColor(bookingItem.statusTransaksi),
//                         borderRadius: BorderRadius.circular(4.0),
//                       ),
//                       child: Text(
//                         '${bookingItem.statusTransaksi}',
//               d          style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
