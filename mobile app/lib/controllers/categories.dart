import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_auth/controllers/perawatan.dart';
import 'package:supabase_auth/models/categories.dart';
import 'package:supabase_auth/repository/categories.dart';
import 'package:supabase_auth/repository/perawatan.dart';
import '../models/perawatan.dart';

class CategoriesController extends GetxController {
  final CategoriesRepository categoriesRepository = CategoriesRepository();
  final PerawatanRepository perawatanRepository = PerawatanRepository();
  RxList<Perawatan> perawatanByCategory = RxList<Perawatan>([]);
  final kategori = <Category>[].obs;
  final selectedCategory = Rx<Category?>(null);
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  void fetchCategories() async {
    isLoading(true);
    try {
      final result = await categoriesRepository.getCategory();
      kategori.assignAll(result);
    } catch (e) {
      print("error");
    }
    isLoading(false);
  }

  void fetchDataByCategory(String namaPerawatan) async {
    isLoading(true);
    try {
      // Find the category object by name
      final category = kategori.firstWhere(
        (category) => category.namaKategori == namaPerawatan,
        orElse: () =>
            throw Exception('Kategori dengan $namaPerawatan tidak ditemukan'),
      );

      // Set the selected category
      selectedCategory(category);

      // Get perawatan by category ID
      final perawatanResult =
          await perawatanRepository.getPerawatanByCategory(category.idKategori);

      perawatanByCategory.assignAll(perawatanResult);
      Get.find<PerawatanController>().perawatan.assignAll(perawatanResult);

      print(perawatanByCategory);
    } catch (e) {
      print("Error occurred while fetching data: $e");
      Get.snackbar(
        "Error",
        "An error occurred while fetching data. Please try again later.",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }
}
