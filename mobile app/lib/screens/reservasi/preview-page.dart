import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_auth/controllers/perawatan.dart';
import 'package:supabase_auth/controllers/checkout.dart';
import 'package:supabase_auth/controllers/user.dart';
import 'package:supabase_auth/repository/reservasi.dart';
import 'package:supabase_auth/core/utils/color_constant.dart';
import 'package:supabase_auth/screens/reservasi/checkout-page.dart';
import 'package:supabase_auth/screens/reservasi/reservasi-page.dart';
import 'package:supabase_auth/screens/reservasi/payment-success.dart';
import 'package:supabase_auth/screens/reservasi/payment-failed.dart';
import 'package:supabase_auth/screens/reservasi/payment-screen.dart';
import 'package:supabase_auth/controllers/time_slot.dart';
import 'package:supabase_auth/controllers/reservasi.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:time/time.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../core/utils/image_constant.dart';
import '../../core/utils/size_utils.dart';
import '../../widgets/custom_image_view.dart';

class PreviewPage extends StatefulWidget {
  const PreviewPage({Key? key}) : super(key: key);

  @override
  _PreviewPageState createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  final PerawatanController perawatanController =
      Get.put(PerawatanController());
  final UserController userController = Get.put(UserController());
  final TimeSlotController timeSlotController = Get.put(TimeSlotController());
  final CheckoutController checkoutController = Get.put(CheckoutController());
  final ReservasiController reservasiController =
      Get.put(ReservasiController());
  final ReservasiRepository reservasiRepository =
      Get.put(ReservasiRepository());
  final DateFormat timeFormat = DateFormat('HH:mm:ss');
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  late DateTime _endTime;
  late Duration _remainingTime;
  final List<Widget> pages = const [
    CheckoutPage(),
    ReservasiPage(),
  ];

  final List<String> tabTitles = const [
    'Checkout',
    'Confirmation',
    'Payment',
    'Detail Reservasi'
  ];
  final RxInt currentPageIndex = 1.obs;

  Timer? paymentStatusTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      fetchData();
    });
    _endTime = DateTime.now() +
        30.minutes; // Set the end time as current time + 30 minutes
    _remainingTime = _endTime
        .difference(DateTime.now()); // Calculate the initial remaining time

    // Start a timer to update the remaining time every second
    Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _remainingTime = _endTime.difference(DateTime.now());
      });

      if (_remainingTime.isNegative) {
        // If the remaining time is negative, navigate to the payment failed screen
        Navigator.pushNamed(context, '/payment-failed');
      }
    });
  }

  Future<void> fetchData() async {
    await UserController.to.getUserInfo();
    await PerawatanController.to.loadCartItems();
  }

  Future<String> checkPaymentStatus(String paymentUrl) async {
    final response = await http.get(Uri.parse(paymentUrl));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final paymentStatus = responseData['status'];

      if (paymentStatus == 'settlement') {
        return 'settlement';
      } else if (paymentStatus == 'pending') {
        return 'pending';
      } else {
        return 'unknown';
      }
    } else {
      return 'error';
    }
  }

  void redirectToApp() async {
    if (await canLaunch('io.supabase.flutterdemo://payment-success')) {
      await launch('io.supabase.flutterdemo://payment-success');
    } else {
      throw Exception('Could not launch the app');
    }
  }

  void startPaymentStatusTimer(BuildContext context, String paymentUrl) {
    paymentStatusTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      checkPaymentStatus(paymentUrl).then((status) {
        if (status == 'settlement') {
          Navigator.pushNamed(context, '/payment-success');
          paymentStatusTimer?.cancel(); // Stop the timer
          redirectToApp(); // Redirect back to your Flutter app
        } else if (status == 'pending') {
          // Handle pending status if needed
        } else {
          Navigator.pushNamed(context, '/payment-failed');
          paymentStatusTimer?.cancel(); // Stop the timer
          redirectToApp(); // Redirect back to your Flutter app
        }
      }).catchError((error) {
        print('Error checking payment status: $error');
        // Handle error when checking payment status
        paymentStatusTimer?.cancel(); // Stop the timer
        redirectToApp(); // Redirect back to your Flutter app
      });
    });
  }

  Widget buildProgressTab() {
    return Container(
      height: 70,
      color: Colors.white,
      alignment: Alignment.center,
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: tabTitles.length,
            itemBuilder: (context, index) {
              final isCurrentPage = index == currentPageIndex.value;
              return InkWell(
                onTap: () {
                  if (index == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CheckoutPage(),
                      ),
                    );
                  } else if (index == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PreviewPage(),
                      ),
                    );
                  } else if (index == 2) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReservasiPage(),
                      ),
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCurrentPage
                              ? ColorConstant.pink300
                              : Colors.grey,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        tabTitles[index],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isCurrentPage
                              ? ColorConstant.pink300
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void showBookingConfirmationDialog() {
    final List<DateTime> selectedDates = reservasiController.selectedDates;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi Booking"),
          content: const Text(
              "Apakah Anda yakin ingin melakukan booking? Pembatalan reservasi dapat dilakukan selama belum melakukan pembayaran."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () async {
                var payment = await checkoutController.sendPaymentRequest(
                  idPerawatan:
                      perawatanController.cartItems[0].idPerawatan.toString(),
                  hargaPerawatan: perawatanController
                      .cartItems[0].hargaPerawatan
                      .toString(),
                  perawatanList: perawatanController.cartItems,
                  tanggal: selectedDates.isNotEmpty
                      ? dateFormat.format(selectedDates.first)
                      : '',
                  pegawai: perawatanController.pegawaiNama.value,
                  total: perawatanController.total.value,
                );
                print(payment);

                if (payment != 'error') {
                  if (await canLaunch(payment)) {
                    await launch(payment);
                    Navigator.of(context).pop();
                    startPaymentStatusTimer(context, payment);
                  } else {
                    throw Exception('Could not launch $payment');
                  }
                } else {
                  throw Exception('Failed to send payment request');
                }
              },
              child: const Text("Booking"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat timeFormat = DateFormat('HH:mm:ss');
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    final String jam =
        timeFormat.format(timeSlotController.selectedTime.value!.jamPerawatan);

    final List<DateTime> selectedDates = reservasiController.selectedDates;
    final String tanggal =
        selectedDates.isNotEmpty ? dateFormat.format(selectedDates.first) : '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorConstant.pink300,
        centerTitle: true,
        title: const Text("Payment Confirmation"),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: buildProgressTab(),
          ),
          Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Finish your booking in ${_remainingTime.inMinutes}:${(_remainingTime.inSeconds % 60).toString().padLeft(2, '0')}",
                    style: const TextStyle(
                      color: Colors.pink,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Customer Details",
                      style: TextStyle(
                        color: Colors.pink,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "${userController.getUser!.nama}",
                    ),
                    Text(
                      "${userController.getUser!.email}",
                    ),
                    const Divider(),
                    const SizedBox(height: 5),
                    Text(
                      "Date & Time",
                      style: TextStyle(
                        color: ColorConstant.pink300,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "$tanggal at $jam",
                    ),
                    const Divider(),
                    Column(
                      children: [
                        Text(
                          "Treatment Booked",
                          style: TextStyle(
                            color: ColorConstant.pink300,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Column(
                          children: [
                            const Text(
                              "Pegawai",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              perawatanController.pegawaiNama.value,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              "Treatment",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 5),
                            ...perawatanController.cartItems.map((item) {
                              return Text(
                                "• ${item.namaPerawatan} : Rp${item.hargaPerawatan}",
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                        const Divider(),
                        Column(
                          children: [
                            Text(
                              "Total",
                              style: TextStyle(
                                color: ColorConstant.pink300,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Obx(
                                () => Text(
                                  'Rp${perawatanController.total.value}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            showBookingConfirmationDialog();
                          },
                          child: const Text("Booking"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
