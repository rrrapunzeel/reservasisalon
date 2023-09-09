import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_auth/screens/reservasi/detail-view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supabase_auth/screens/reservasi/reservasi-view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_auth/controllers/perawatan.dart';
import 'package:supabase_auth/controllers/checkout.dart';
import 'package:supabase_auth/controllers/user.dart';
import 'package:supabase_auth/repository/reservasi.dart';
import 'package:supabase_auth/core/utils/color_constant.dart';
import 'package:supabase_auth/screens/reservasi/checkout-page.dart';
import 'package:supabase_auth/screens/reservasi/reservasi-page.dart';
import 'package:supabase_auth/controllers/time_slot.dart';
import 'package:supabase_auth/controllers/reservasi.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:time/time.dart';
import '../../core/utils/image_constant.dart';
import '../../core/utils/size_utils.dart';
import '../../models/pembayaran.dart';
import '../../widgets/custom_image_view.dart';

class PreviewPage extends StatefulWidget {
  const PreviewPage({super.key});

  @override
  _PreviewPageState createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  final DateFormat timeFormat = DateFormat('HH:mm:ss');
  final DateFormat inputFormat = DateFormat('yyyy-MM-dd');
  final DateFormat outputFormat = DateFormat('yyyy-MM-dd');
  final PerawatanController perawatanController =
      Get.put(PerawatanController());
  final UserController userController = Get.put(UserController());
  final TimeSlotController timeSlotController = Get.put(TimeSlotController());
  final CheckoutController checkoutController = Get.put(CheckoutController());
  final ReservasiController reservasiController =
      Get.put(ReservasiController());
  final ReservasiRepository reservasiRepository =
      Get.put(ReservasiRepository());
  late DateTime _endTime;
  late Duration _remainingTime;
  late final Pembayaran booking;
  late final List<Pembayaran> bookings;

  final List<Widget> pages = const [
    CheckoutPage(),
  ];

  final List<String> tabTitles = const ['Reservasi', 'Konfirmasi', 'Pesanan'];
  final RxInt currentPageIndex = 1.obs;

  Timer? paymentStatusTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchData();
    });
    _endTime = DateTime.now() + 30.minutes;
    _remainingTime = _endTime.difference(DateTime.now());

    paymentStatusTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _remainingTime = _endTime.difference(DateTime.now());
        });
      }

      if (_remainingTime.isNegative) {
        paymentStatusTimer?.cancel();
        Navigator.pushNamed(context, '/payment-failed');
      }
    });
  }

  @override
  void dispose() {
    paymentStatusTimer?.cancel();
    super.dispose();
  }

  Future<void> fetchData() async {
    await UserController.to.getUserInfo();
    await PerawatanController.to.loadCartItems();
  }

  Widget buildProgressTab() {
    return Container(
      height: 70,
      color: Colors.white,
      alignment: Alignment.center,
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceEvenly, // Center the tab titles horizontally
            children: List.generate(
              tabTitles.length,
              (index) {
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
                          builder: (context) => const ReservasiView(
                            bookings: [],
                          ),
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
                        const SizedBox(height: 4),
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
      ),
    );
  }

  Future<void> sendTanggalJam() async {
    final DateFormat inputFormat = DateFormat('yyyy-MM-dd');
    final DateFormat outputFormat = DateFormat('yyyy-MM-dd');

    final DateTime dateTime =
        inputFormat.parse(perawatanController.tanggal.value);
    final String formattedDate = outputFormat.format(dateTime);

    tz.initializeTimeZones();

    final String jam =
        timeFormat.format(timeSlotController.selectedTime.value!.jamPerawatan);

    final String email = userController.getUser!.email.toString();

    print('Email: $email');
    print('jam: $jam');
    print('formattedDate: $formattedDate');

    final url =
        'https://ffff-202-80-216-225.ngrok-free.app/pay/notificationhandler/$email/${formattedDate}T$jam-05:00';

    print('Url Laravel: $url');

    try {
      final response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'email': email,
            'selectedDateTime': formattedDate,
          }));

      if (response.statusCode == 200) {
        print('Success: ${response.body}');
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void showBookingConfirmationDialog() {
    final DateTime dateTime =
        inputFormat.parse(perawatanController.tanggal.value);
    final String formattedDate = outputFormat.format(dateTime);
    final String jam =
        timeFormat.format(timeSlotController.selectedTime.value!.jamPerawatan);
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
                  tanggal: formattedDate,
                  jam: jam,
                  pegawai: perawatanController.pegawaiNama.value,
                  total: perawatanController.total.value,
                );
                print(payment);

                if (payment != 'error') {
                  if (await canLaunch(payment)) {
                    await launch(payment);
                    Navigator.of(context).pop();
                    Fluttertoast.showToast(
                      msg: "Anda akan dialihkan ke halaman pembayaran...",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb:
                          10, // Time to show the toast (in seconds)
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                    );
                    paymentStatusTimer?.cancel();
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
    final DateFormat inputFormat = DateFormat('yyyy-MM-dd');
    final DateFormat outputFormat = DateFormat('yyyy-MM-dd');

    final DateTime dateTime =
        inputFormat.parse(perawatanController.tanggal.value);
    final String formattedDate = outputFormat.format(dateTime);

    final String jam =
        timeFormat.format(timeSlotController.selectedTime.value!.jamPerawatan);

    // Return the widget tree
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorConstant.pink300,
        centerTitle: true,
        title: const Text("Konfirmasi Pemesanan"),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: buildProgressTab(),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              "Selesaikan pesanan dalam ${_remainingTime.inMinutes}:${(_remainingTime.inSeconds % 60).toString().padLeft(2, '0')}",
              style: const TextStyle(
                color: Colors.pink,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(height: 3),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgDetail,
                  height: getSize(150),
                  width: getSize(200),
                  margin: const EdgeInsets.only(top: 1),
                ),
                const SizedBox(height: 5),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Nama",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${userController.getUser!.nama}",
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Jadwal",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${formattedDate} | ${jam}",
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Detail",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Pegawai",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            perawatanController.pegawaiNama.value,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 3),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Treatment",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 3),
                        ...perawatanController.cartItems.map((item) {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "• ${item.namaPerawatan}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                // if (item.hargaDP != null)
                                // Text(
                                //   "Harga DP : Rp${item.hargaDP} | Harga Full : Rp${item.hargaPerawatan}",
                                //   style: const TextStyle(
                                //     fontSize: 14,
                                //   ),
                                // ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Total",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Obx(
                            () => Text(
                              'Rp${perawatanController.total.value}',
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: ColorConstant.pink300, // background
                        onPrimary: Colors.white, // foreground
                      ),
                      onPressed: () {
                        showBookingConfirmationDialog();
                      },
                      child: const Text("Pesan"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
