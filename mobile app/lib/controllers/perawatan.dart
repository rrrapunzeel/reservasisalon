import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_auth/models/categories.dart';
import 'package:supabase_auth/repository/perawatan.dart';
import 'package:supabase_auth/models/perawatan.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PerawatanController extends GetxController {
  static PerawatanController get to => Get.find<PerawatanController>();
  final supabase = SupabaseClient(
    'https://fuzdyyktvczvrbwrjkhe.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzI0MTA4ODcsImV4cCI6MTk4Nzk4Njg4N30.kMVUSwTCDMLEM-8ePXPXniT62zkB75Q3gvyvuAbkibU',
  );
  final PerawatanRepository perawatanRepository = PerawatanRepository();

  RxList<Perawatan> perawatan = <Perawatan>[].obs;
  var isLoading = false.obs;
  final cartItems = <Perawatan>[].obs;
  RxInt cartCount = 0.obs;
  var selectedIndex = -1.obs;
  RxList<Perawatan> perawatanByCategory = RxList<Perawatan>([]);
  RxList<Perawatan> selectedPerawatan = RxList<Perawatan>([]);
  final kategori = <Category>[].obs;
  final estimasi = <Perawatan>[].obs;
  final selectedCategory = Rx<Category?>(null);
  RxBool isLoadingg = false.obs;
  //SECTION - data untuk checkout
  List<Perawatan>? _cartperawatan;
  RxString total = ''.obs;
  RxString tanggal = "".obs;
  RxString jam = "".obs;
  RxString pegawai = "".obs;
  RxString pegawaiNama = "".obs;
  //!SECTION

  @override
  Future<void> onInit() async {
    super.onInit();
    fetchPerawatan();
    loadCartItems();
    calculateTotal();
    updateFilteredPerawatan();
  }

  List<Perawatan> get filteredPerawatan {
    if (selectedCategory.value == null) {
      // No category selected, return all perawatan
      return perawatan;
    } else {
      // Filter perawatan based on selected category
      return perawatan
          .where((perawatan) =>
              perawatan.idKategori == selectedCategory.value?.idKategori)
          .toList();
    }
  }

  void fetchDataByCategory(int idKategori) async {
    // Get perawatan data from the specified category
    List<Perawatan> perawatanByCategory =
        await perawatanRepository.getPerawatanByCategory(idKategori);

    // Set the filtered perawatan to the obtained perawatanByCategory
    setPerawatan(perawatanByCategory);

    // Update the filtered perawatan based on the selected category
    updateFilteredPerawatan();
  }

  void updateFilteredPerawatan() {
    if (selectedCategory.value == null) {
      // No category selected, assign all perawatan to filteredPerawatan
      filteredPerawatan.assignAll(perawatanByCategory);
    } else {
      // Filter perawatanByCategory based on the selected category
      filteredPerawatan.assignAll(perawatanByCategory
          .where((perawatan) =>
              perawatan.idKategori == selectedCategory.value!.idKategori)
          .toList());
    }
  }

  void setPerawatan(List<Perawatan> data) {
    perawatanByCategory.value = data;
    selectedPerawatan.value = [];
  }

  void setSelectedPerawatan(Category selectedCategory) {
    selectedPerawatan.value = perawatan
        .where(
            (perawatan) => perawatan.idKategori == selectedCategory.idKategori)
        .toList();
  }

  loadCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartStringList = prefs.getStringList('cart') ?? [];

    // Convert List<String> to List<Perawatan>
    final cartList = cartStringList.map((item) {
      final decodedItem = jsonDecode(item);
      print(decodedItem);
      return Perawatan.fromJson(decodedItem);
    }).toList();

    // Update cartItems and cartCount
    cartItems.value = cartList;
    cartCount.value = cartList.length;
  }

  removeCartItem(Perawatan item) async {
    final prefs = await SharedPreferences.getInstance();

    cartItems
        .removeWhere((cartItem) => cartItem.idPerawatan == item.idPerawatan);

    // Convert List<Perawatan> to List<String>
    final cartStringList =
        cartItems.map((item) => jsonEncode(item.toJson())).toList();

    // Update cart in SharedPreferences
    await prefs.setStringList('cart', cartStringList);

    // Update cartCount
    cartCount.value = cartItems.length;

    // Recalculate the total
    calculateTotal();
  }

  Future<void> addCartItem(Perawatan item, {double? hargaDP}) async {
    final prefs = await SharedPreferences.getInstance();

    // Hitung estimasi total dari semua item dalam keranjang
    int estimasiTotalSaatIni = 0;
    for (final cartItem in cartItems) {
      estimasiTotalSaatIni += cartItem.estimasi!;
    }

    // Hitung estimasi total setelah menambahkan item baru
    int estimasiTotalBaru = estimasiTotalSaatIni + item.estimasi!;

    // Periksa apakah estimasi total baru melebihi batas maksimal yang diizinkan (60 menit)
    if (estimasiTotalBaru <= 60) {
      // Tambahkan item baru ke daftar cartItems dengan opsi harga yang dipilih (harga DP atau harga penuh)
      if (cartItems.contains(item)) {
        // Item sudah ada, jadi tidak perlu menambahkannya lagi
        return;
      }

      if (hargaDP == null) {
        hargaDP = item.hargaDP ?? item.hargaPerawatan!;
      }

      cartItems.add(item.copyWith(hargaDP: hargaDP!));

      // Ubah List<Perawatan> menjadi List<String>
      final cartStringList =
          cartItems.map((item) => jsonEncode(item.toJson())).toList();

      // Perbarui cart di SharedPreferences
      await prefs.setStringList('cart', cartStringList);

      // Perbarui daftar selectedPerawatan
      selectedPerawatan.add(item);

      cartCount.value++;
      item.isAddedToCart = true;

      calculateTotal();
    } else {
      // Tampilkan pesan kesalahan jika estimasi total melebihi batas maksimal
      Get.snackbar(
        'Error',
        'Estimasi total dari layanan yang dipilih melebihi batas maksimal (60 menit).',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  loadPerawatanCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cart = prefs.getStringList('cart') ?? [];
    cartCount.value = cartItems.length;
  }

  void fetchPerawatan() async {
    try {
      final result = await perawatanRepository.getPerawatan();
      perawatan.assignAll(result);
      print(perawatan);
    } catch (e) {
      print("Error fetching perawatan: $e");
    }
  }

  void fetchEstimasi() async {
    try {
      final result = await perawatanRepository.getEstimasi();
      estimasi.assignAll(result);
      print(estimasi);
    } catch (e) {
      print("Error fetching estimasi: $e");
    }
  }

  void calculateTotal() {
    if (cartItems.isEmpty) {
      total.value = '0'; // Set the total to 0 when the cart is empty
      return;
    }

    double totalSum = 0;

    for (Perawatan item in cartItems) {
      double harga =
          item.hargaDP != null ? item.hargaDP! : item.hargaPerawatan!;
      totalSum += harga;
    }

    total.value = totalSum.toStringAsFixed(0);
  }

  List<Perawatan>? get getCartPerawatan => _cartperawatan;
}
