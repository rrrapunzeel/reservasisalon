import 'dart:convert';
import 'dart:ui' as ui;
import 'package:awesome_select/awesome_select.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_auth/controllers/perawatan.dart';
import 'package:supabase_auth/controllers/notifikasi.dart';
import 'package:supabase_auth/controllers/checkout.dart';
import 'package:supabase_auth/controllers/user.dart';
import 'package:supabase_auth/repository/reservasi.dart';
import 'package:supabase_auth/models/reservasi.dart';
import 'package:supabase_auth/controllers/googleCalendar.dart';
import 'package:supabase_auth/core/utils/color_constant.dart';
import 'package:supabase_auth/screens/reservasi/preview-page.dart';
import 'package:supabase_auth/screens/reservasi/reservasi-page.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:supabase_auth/models/perawatan.dart';
import 'package:supabase_auth/models/time_slot.dart';
import 'package:supabase_auth/controllers/time_slot.dart';
import 'package:supabase_auth/controllers/reservasi.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final supabase = SupabaseClient(
    'https://fuzdyyktvczvrbwrjkhe.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzI0MTA4ODcsImV4cCI6MTk4Nzk4Njg4N30.kMVUSwTCDMLEM-8ePXPXniT62zkB75Q3gvyvuAbkibU',
  );
  final List<Widget> pages = [
    const PreviewPage(),
    const ReservasiPage(),
  ];

  final List<String> tabTitles = [
    'Checkout',
    'Confirmation',
    'Payment',
    'Detail Reservasi'
  ];

  final RxInt currentPageIndex = 0.obs;
  bool isBackdropFilterVisible = false;
  late List<DateTime> selectedDates;
  late List<DateTime> enabledDates;
  DateTime? selectedDate;
  PerawatanController perawatanController = Get.put(PerawatanController());
  UserController userController = Get.put(UserController());
  final TimeSlotController timeSlotController = Get.put(TimeSlotController());
  CheckoutController checkoutController = Get.put(CheckoutController());
  ReservasiController reservasiController = Get.put(ReservasiController());
  NotifikasiController notifikasiController = Get.put(NotifikasiController());
  ReservasiRepository reservasiRepository = Get.put(ReservasiRepository());
  GoogleCalendarController googleCalendarController =
      Get.put(GoogleCalendarController());

  @override
  void initState() {
    super.initState();
    selectedDates = [];
    enabledDates = [];
    reservasiController.fetchReservasi();
    reservasiController.fetchAvailableDates();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime minDate = DateTime(now.year, now.month, now.day);
    DateTime lastDayOfMonth =
        DateTime(now.year, now.month + 1, 1).subtract(const Duration(days: 1));

    bool isSameDay(DateTime date1, DateTime date2) {
      final dateFormat = DateFormat('yyyy-MM-dd');
      final formattedDate1 = dateFormat.format(date1);
      final formattedDate2 = dateFormat.format(date2);
      return formattedDate1 == formattedDate2;
    }

    Widget buildProgressTab() {
      return Container(
        height: 70,
        color: Colors.white,
        alignment: Alignment.center,
        child: SizedBox(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: tabTitles.length,
            itemBuilder: (context, index) {
              final isCurrentPage = index == currentPageIndex.value;
              return InkWell(
                onTap: () {
                  // Aksi ketika lingkaran diklik
                  if (index == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CheckoutPage()),
                    );
                  } else if (index == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PreviewPage()),
                    );
                  } else if (index == 2) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ReservasiPage()),
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
                      const SizedBox(height: 8),
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
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorConstant.pink300,
        centerTitle: true,
        title: const Text("Checkout"),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: buildProgressTab(),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 20),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
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
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Keranjang",
                            style: TextStyle(
                              color: ColorConstant.pink300,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Obx(
                            () => perawatanController.isLoading.value
                                ? const Text("loading")
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount:
                                        perawatanController.cartItems.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final itemData = jsonDecode(jsonEncode(
                                          perawatanController.cartItems[index]
                                              .toJson()));
                                      final item = Perawatan.fromJson(itemData);
                                      // Check if the item already exists before the current index
                                      if (index > 0 &&
                                          perawatanController.cartItems
                                              .sublist(0, index)
                                              .contains(item)) {
                                        // Item already exists before the current index, do not show it again
                                        return Container();
                                      }
                                      // Find the first index of the current item in the cartItems list
                                      final firstIndex = perawatanController
                                          .cartItems
                                          .indexOf(item);
                                      return Column(
                                        children: [
                                          if (index == firstIndex)
                                            Column(
                                              children: [
                                                const Divider(),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      item.namaPerawatan ?? '',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: ColorConstant
                                                            .gray400,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const Divider(),
                                              ],
                                            ),
                                          ListTile(
                                            title:
                                                Text(item.namaPerawatan ?? ''),
                                            subtitle: Text(
                                                "Rp ${item.hargaPerawatan}"),
                                            trailing: IconButton(
                                              icon: const Icon(Icons.delete),
                                              onPressed: () {
                                                perawatanController
                                                    .removeCartItem(item);
                                                perawatanController
                                                    .calculateTotal();
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                "Total :",
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Obx(
                                () => Column(
                                  children: [
                                    Text(
                                      "Rp${perawatanController.total.value}",
                                      style: const TextStyle(
                                        fontSize: 16.0,
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 20),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
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
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Pilih Tanggal",
                            style: TextStyle(
                              color: ColorConstant.pink300,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Obx(
                            () => reservasiController.isLoading.value
                                ? const Text("loading")
                                : SfDateRangePicker(
                                    allowViewNavigation: false,
                                    minDate: minDate,
                                    maxDate: lastDayOfMonth,
                                    selectionColor: ColorConstant.pink300,
                                    todayHighlightColor: ColorConstant.pink300,
                                    startRangeSelectionColor:
                                        ColorConstant.pink300,
                                    endRangeSelectionColor:
                                        ColorConstant.pink300,
                                    rangeTextStyle: TextStyle(
                                      color: ColorConstant.pink300,
                                    ),
                                    onSelectionChanged:
                                        (DateRangePickerSelectionChangedArgs
                                            args) {
                                      if (args.value is DateTime) {
                                        final selectedDate =
                                            args.value as DateTime;
                                        final formattedDate = DateTime(
                                          selectedDate.year,
                                          selectedDate.month,
                                          selectedDate.day,
                                        );
                                        final formattedIsoDate =
                                            formattedDate.toIso8601String();

                                        timeSlotController.timeSlots
                                            .forEach((timeSlot) {
                                          timeSlot.available = true;
                                        });

                                        perawatanController.tanggal.value =
                                            formattedIsoDate;

                                        if (selectedDates
                                            .contains(formattedDate)) {
                                          // Tanggal telah dipilih sebelumnya, hapus dari daftar tanggal yang dipilih
                                          setState(() {
                                            selectedDates.remove(formattedDate);
                                          });
                                        } else if (selectedDates.length < 6) {
                                          // Tambahkan tanggal ke daftar tanggal yang dipilih jika jumlah tanggal yang dipilih kurang dari 6
                                          setState(() {
                                            selectedDates.add(formattedDate);
                                          });
                                          print(
                                              'Tanggal dipilih: $formattedIsoDate');
                                        } else {
                                          // Jika sudah ada 2 tanggal yang dipilih, abaikan pemilihan tambahan
                                          return;
                                        }

                                        // Membuat daftar tanggal yang dapat dipilih berdasarkan batasan jumlah tanggal yang dipilih
                                        enabledDates = reservasiController
                                            .availableDates
                                            .where((date) {
                                          final matchingDates = selectedDates
                                              .where((selectedDate) {
                                            return date.year ==
                                                    selectedDate.year &&
                                                date.month ==
                                                    selectedDate.month &&
                                                date.day == selectedDate.day;
                                          }).toList();
                                          return matchingDates.length < 6;
                                        }).toList();

                                        perawatanController.tanggal.value =
                                            formattedIsoDate;

                                        if (selectedDates.length == 1) {
                                          print('Reserved');
                                        }
                                      }
                                    },
                                    monthCellStyle:
                                        DateRangePickerMonthCellStyle(
                                      disabledDatesTextStyle:
                                          const TextStyle(color: Colors.grey),
                                      specialDatesTextStyle:
                                          const TextStyle(color: Colors.white),
                                      specialDatesDecoration: BoxDecoration(
                                        color: ColorConstant.pink300,
                                        shape: BoxShape.circle,
                                      ),
                                      todayTextStyle:
                                          const TextStyle(color: Colors.black),
                                      leadingDatesTextStyle:
                                          const TextStyle(color: Colors.grey),
                                      trailingDatesTextStyle:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                    monthViewSettings:
                                        const DateRangePickerMonthViewSettings(
                                      showTrailingAndLeadingDates: true,
                                    ),
                                    selectionMode:
                                        DateRangePickerSelectionMode.single,
                                    selectableDayPredicate: (DateTime date) {
                                      final matchingDates = reservasiController
                                          .selectedDates
                                          .where((availableDate) =>
                                              isSameDay(availableDate, date))
                                          .toList();
                                      return matchingDates.length < 6;
                                    },
                                    initialSelectedDate:
                                        selectedDates.isNotEmpty
                                            ? selectedDates.first
                                            : null,
                                  ),
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      children: [
                        Visibility(
                          visible: isBackdropFilterVisible,
                          child: BackdropFilter(
                            filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Container(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            isBackdropFilterVisible = true;
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 20),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
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
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Obx(() {
                                  return userController.isLoading.value
                                      ? const Text("loading")
                                      : GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isBackdropFilterVisible = true;
                                            });
                                          },
                                          child: SmartSelect<String?>.single(
                                            title: 'Pilih Pegawai',
                                            selectedValue: perawatanController
                                                .pegawai.value,
                                            onChange: (selected) {
                                              perawatanController
                                                      .pegawai.value =
                                                  selected.value.toString();
                                              perawatanController
                                                      .pegawaiNama.value =
                                                  selected.title.toString();
                                              print(selected.value);
                                              timeSlotController
                                                  .fetchTimeSlots();
                                            },
                                            choiceType: S2ChoiceType.radios,
                                            choiceItems:
                                                userController.getPegawai!,
                                            modalType: S2ModalType.popupDialog,
                                            modalHeader: false,
                                            modalConfig: const S2ModalConfig(
                                              style: S2ModalStyle(
                                                elevation: 3,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              20.0)),
                                                ),
                                              ),
                                            ),
                                            tileBuilder: (context, state) {
                                              return S2Tile.fromState(
                                                state,
                                                isTwoLine: true,
                                                leading: CircleAvatar(
                                                  backgroundColor:
                                                      ColorConstant.pink300,
                                                  child: Text(
                                                    '${state.selected.toString()[0]}',
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                }),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 20),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "Pilih Jam",
                            style: TextStyle(
                              color: Colors.pink,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Obx(
                            () => timeSlotController.isLoading.value
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: const EdgeInsets.all(16.0),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 16.0,
                                      crossAxisSpacing: 16.0,
                                      childAspectRatio: 2.5,
                                    ),
                                    itemCount:
                                        timeSlotController.timeSlots.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      TimeSlot timeSlot =
                                          timeSlotController.timeSlots[index];
                                      bool isSelected = timeSlot ==
                                          timeSlotController.selectedTime.value;
                                      bool isAvailable = timeSlot.available!;
                                      Color cardColor = isSelected
                                          ? const Color.fromARGB(
                                              255, 150, 187, 218)
                                          : ColorConstant.pink300;
                                      Color textColor = isSelected
                                          ? Colors.white
                                          : Colors.white;

                                      return GestureDetector(
                                        onTap: () async {
                                          if (isAvailable) {
                                            // Only update selected time if it's available
                                            setState(() {
                                              timeSlotController.selectedTime
                                                  .value = timeSlot;

                                              for (int i = 0;
                                                  i <
                                                      timeSlotController
                                                          .timeSlots.length;
                                                  i++) {
                                                TimeSlot currentSlot =
                                                    timeSlotController
                                                        .timeSlots[i];
                                                currentSlot.isSelected =
                                                    (currentSlot == timeSlot);
                                              }
                                            });

                                            int? selectedTimeSlotId =
                                                timeSlot.idTimeSlots;

                                            // Buat objek Reservasi baru dengan nilai yang sesuai
                                            Reservasi newReservasi = Reservasi(
                                              date: DateTime(
                                                selectedDates[0].year,
                                                selectedDates[0].month,
                                                selectedDates[0].day,
                                              ),
                                              idTimeSlots: selectedTimeSlotId,
                                            );

                                            // Panggil metode createReservasi dari ReservasiRepository untuk membuat reservasi baru
                                            await reservasiRepository
                                                .createReservasi(newReservasi);
                                            // if (created) {
                                            //   // Reservasi berhasil dibuat
                                            //   ScaffoldMessenger.of(context)
                                            //       .showSnackBar(
                                            //     const SnackBar(
                                            //       content:
                                            //           Text('Reservasi berhasil dibuat'),
                                            //     ),
                                            //   );
                                            // } else {
                                            //   // Gagal membuat reservasi
                                            //   ScaffoldMessenger.of(context)
                                            //       .showSnackBar(
                                            //     const SnackBar(
                                            //       content:
                                            //           Text('Gagal membuat reservasi'),
                                            //     ),
                                            //   );
                                            // }
                                          }
                                        },
                                        child: Card(
                                          color: isAvailable
                                              ? cardColor
                                              : Colors
                                                  .grey, // Disable color if not available
                                          child: Center(
                                            child: Text(
                                              DateFormat.Hm().format(
                                                  timeSlot.jamPerawatan!),
                                              style: TextStyle(
                                                color: isAvailable
                                                    ? textColor
                                                    : Colors
                                                        .white, // Disable text color if not available
                                                fontSize: 18.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                    //!SECTION

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: ColorConstant.pink300, // background
                        onPrimary: Colors.white, // foreground
                      ),
                      onPressed: () async {
                        List<DateTime> selectedDates =
                            reservasiController.selectedDates;
                        String selectedTime = timeSlotController
                            .selectedTime.value!.jamPerawatan
                            .toString();

                        // Memanggil fungsi sendJadwal dengan data yang diperoleh
                        String result = await checkoutController.sendJadwal(
                          selectedDates: selectedDates,
                          selectedTime: selectedTime,
                        );
                        print(result);
                        print("Jam : ${timeSlotController.selectedTime.value}");
                        print(
                            "Pegawai : ${perawatanController.pegawaiNama.value}");
                        print(
                            "Perawatan : ${perawatanController.cartItems[0].namaPerawatan.toString()}");
                        print(
                            "Harga Perawatan : ${perawatanController.cartItems[0].hargaPerawatan.toString()}");
                        print("Total : ${perawatanController.total.value}");
                        print(
                            "Nama :${userController.getUser!.nama.toString()}");
                        print(
                            "Email :${userController.getUser!.email.toString()}");

                        // Pindah ke halaman CheckoutPage
                        Get.to(const PreviewPage());
                      },
                      child: const Text('Lanjut'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
