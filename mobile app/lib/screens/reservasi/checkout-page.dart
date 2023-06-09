import 'dart:convert';
import 'dart:ui' as ui;
import 'package:awesome_select/awesome_select.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_auth/controllers/perawatan.dart';
import 'package:supabase_auth/controllers/checkout.dart';
import 'package:supabase_auth/controllers/user.dart';
import 'package:supabase_auth/controllers/googleCalendar.dart';
import 'package:supabase_auth/core/utils/color_constant.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:supabase_auth/models/perawatan.dart';
import 'package:supabase_auth/models/time_slot.dart';
import 'package:supabase_auth/controllers/time_slot.dart';
import 'package:supabase_auth/controllers/reservasi.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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
  bool isBackdropFilterVisible = false;
  late List<DateTime> selectedDates;
  late List<DateTime> enabledDates;
  PerawatanController perawatanController = Get.put(PerawatanController());
  UserController userController = Get.put(UserController());
  final TimeSlotController timeSlotController = Get.put(TimeSlotController());
  CheckoutController checkoutController = Get.put(CheckoutController());
  ReservasiController reservasiController = Get.put(ReservasiController());
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstant.pink300,
        title: const Text("Checkout"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // changes position of shadow
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
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: perawatanController.cartItems.length,
                            itemBuilder: (BuildContext context, int index) {
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
                              final firstIndex =
                                  perawatanController.cartItems.indexOf(item);
                              return Column(
                                children: [
                                  if (index == firstIndex)
                                    Column(
                                      children: [
                                        const Divider(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              item.namaPerawatan ?? '',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: ColorConstant.gray400),
                                            ),
                                          ],
                                        ),
                                        const Divider(),
                                      ],
                                    ),
                                  ListTile(
                                    title: Text(item.namaPerawatan ?? ''),
                                    subtitle: Text("Rp ${item.hargaPerawatan}"),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        perawatanController
                                            .removeCartItem(item);
                                        perawatanController.calculateTotal();
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
                    setState(() {
                      isBackdropFilterVisible = true;
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                                    selectedValue:
                                        perawatanController.pegawai.value,
                                    onChange: (selected) {
                                      perawatanController.pegawai.value =
                                          selected.value.toString();
                                      perawatanController.pegawaiNama.value =
                                          selected.title.toString();
                                      print(selected.value);
                                      timeSlotController.fetchTimeSlots();
                                    },
                                    choiceType: S2ChoiceType.radios,
                                    choiceItems: userController.getPegawai!,
                                    modalType: S2ModalType.popupDialog,
                                    modalHeader: false,
                                    modalConfig: const S2ModalConfig(
                                      style: S2ModalStyle(
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0)),
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
            //!SECTION

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
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
                            startRangeSelectionColor: ColorConstant.pink300,
                            endRangeSelectionColor: ColorConstant.pink300,
                            rangeTextStyle: TextStyle(
                              color: ColorConstant.pink300,
                            ),
                            onSelectionChanged:
                                (DateRangePickerSelectionChangedArgs args) {
                              if (args.value is DateTime) {
                                final selectedDate = args.value as DateTime;
                                final formattedDate = DateTime(
                                  selectedDate.year,
                                  selectedDate.month,
                                  selectedDate.day,
                                );
                                final formattedIsoDate =
                                    formattedDate.toIso8601String();

                                if (selectedDates.contains(formattedDate)) {
                                  // Tanggal telah dipilih sebelumnya, hapus dari daftar tanggal yang dipilih
                                  setState(() {
                                    selectedDates.remove(formattedDate);
                                  });
                                } else if (selectedDates.length < 6) {
                                  // Tambahkan tanggal ke daftar tanggal yang dipilih jika jumlah tanggal yang dipilih kurang dari 6
                                  setState(() {
                                    selectedDates.add(formattedDate);
                                  });
                                  // Simpan ke Google Calendar
                                  googleCalendarController
                                      .createEventInCalendar(
                                          selectedDate,
                                          selectedDate
                                              .add(const Duration(hours: 1)))
                                      .then((eventId) {
                                    if (eventId.isNotEmpty) {
                                      print('Event created with ID: $eventId');
                                    } else {
                                      print('Failed to create event');
                                    }
                                  });
                                } else {
                                  // Jika sudah ada 2 tanggal yang dipilih, abaikan pemilihan tambahan
                                  return;
                                }

                                // Membuat daftar tanggal yang dapat dipilih berdasarkan batasan jumlah tanggal yang dipilih
                                enabledDates = reservasiController
                                    .availableDates
                                    .where((date) {
                                  final matchingDates =
                                      selectedDates.where((selectedDate) {
                                    return date.year == selectedDate.year &&
                                        date.month == selectedDate.month &&
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
                            monthCellStyle: DateRangePickerMonthCellStyle(
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
                            selectionMode: DateRangePickerSelectionMode.single,
                            selectableDayPredicate: (DateTime date) {
                              final matchingDates = reservasiController
                                  .selectedDates
                                  .where((availableDate) =>
                                      isSameDay(availableDate, date))
                                  .toList();
                              return matchingDates.length < 6;
                            },
                            initialSelectedDate: selectedDates.isNotEmpty
                                ? selectedDates.first
                                : null,
                          ),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // changes position of shadow
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
                        ? const Center(child: CircularProgressIndicator())
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(16.0),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 16.0,
                              crossAxisSpacing: 16.0,
                              childAspectRatio: 2.5,
                            ),
                            itemCount: timeSlotController.timeSlots.length,
                            itemBuilder: (BuildContext context, int index) {
                              TimeSlot timeSlot =
                                  timeSlotController.timeSlots[index];
                              bool isSelected = timeSlot ==
                                  timeSlotController.selectedTime.value;
                              bool isAvailable = timeSlot.available!;
                              Color cardColor = isSelected
                                  ? const Color.fromARGB(255, 150, 187, 218)
                                  : ColorConstant.pink300;
                              Color textColor =
                                  isSelected ? Colors.white : Colors.white;

                              return GestureDetector(
                                onTap: () {
                                  if (isAvailable) {
                                    // Only update selected time if it's available
                                    setState(() {
                                      timeSlotController.selectedTime.value =
                                          timeSlot;

                                      for (int i = 0;
                                          i <
                                              timeSlotController
                                                  .timeSlots.length;
                                          i++) {
                                        TimeSlot currentSlot =
                                            timeSlotController.timeSlots[i];
                                        currentSlot.isSelected =
                                            (currentSlot == timeSlot);
                                      }
                                    });

                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                              'Tambahkan ke Google Calendar'),
                                          content: const Text(
                                              'Apakah Anda ingin menambahkan jadwal ini ke Google Calendar?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(
                                                    context); // Tutup pop-up
                                              },
                                              child: const Text('Batal'),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                // Tambahkan ke Google Calendar
                                                String summary =
                                                    "Event Summary";
                                                bool success =
                                                    await googleCalendarController
                                                        .addEventToCalendar(
                                                            timeSlot
                                                                .jamPerawatan,
                                                            summary);

                                                if (success) {
                                                  // Berhasil ditambahkan ke Google Calendar
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          'Jadwal berhasil ditambahkan ke Google Calendar'),
                                                    ),
                                                  );
                                                } else {
                                                  // Gagal menambahkan ke Google Calendar
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          'Gagal menambahkan jadwal ke Google Calendar'),
                                                    ),
                                                  );
                                                }
                                                Navigator.pop(
                                                    context); // Tutup pop-up
                                              },
                                              child: const Text('Tambahkan'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                child: Card(
                                  color: isAvailable
                                      ? cardColor
                                      : Colors
                                          .grey, // Disable color if not available
                                  child: Center(
                                    child: Text(
                                      DateFormat.Hm()
                                          .format(timeSlot.jamPerawatan),
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

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: ColorConstant.pink300, // background
                onPrimary: Colors.white, // foreground
              ),
              onPressed: () async {
                print("Tanggal : ${reservasiController.selectedDates.value}");
                print("Jam : ${timeSlotController.selectedTime.value}");
                print("Pegawai : ${perawatanController.pegawaiNama.value}");
                print(
                    "Perawatan : ${perawatanController.cartItems[0].namaPerawatan.toString()}");
                print(
                    "Harga Perawatan : ${perawatanController.cartItems[0].hargaPerawatan.toString()}");
                print("Total : ${perawatanController.total.value}");
                print("Nama :${userController.getUser!.nama.toString()}");
                print("Email :${userController.getUser!.email.toString()}");
                print(
                    "ID Reservasi : ${reservasiController.selectedDates.value}");

                var payment = await checkoutController.sendPaymentRequest(
                    idPerawatan:
                        perawatanController.cartItems[0].idPerawatan.toString(),
                    hargaPerawatan: perawatanController
                        .cartItems[0].hargaPerawatan
                        .toString(),
                    perawatanList: perawatanController.cartItems,
                    total: perawatanController.total.value);
                print(payment);

                if (payment != 'error') {
                  if (!await launchUrl(Uri.parse('$payment'))) {
                    throw Exception('Could not launch ');
                  }
                }
              },
              child: Text('bayar'),
            ),
          ],
        ),
      ),
    );
  }
}
