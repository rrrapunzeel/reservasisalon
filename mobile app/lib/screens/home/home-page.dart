import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_auth/controllers/categories.dart';
import 'package:supabase_auth/controllers/perawatan.dart';
import 'package:supabase_auth/controllers/user.dart';
import 'package:supabase_auth/core/utils/color_constant.dart';
import 'package:supabase_auth/models/categories.dart';
import 'package:supabase_auth/models/perawatan.dart';

import '../../core/utils/size_utils.dart';
import '../../theme/app_style.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CategoriesController categoriesController = Get.put(CategoriesController());
  PerawatanController perawatanController = Get.put(PerawatanController());
  UserController userController = Get.put(UserController());

  bool _isTooltipVisible = false;
  GlobalKey _listViewKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    categoriesController.fetchCategories();
    perawatanController.fetchPerawatan();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _showTooltip();
    });
  }

  Widget _buildCategoryContainer(bool isSelected, String categoryName) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isSelected ? ColorConstant.pink300 : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: ColorConstant.pink300,
          width: 2,
        ),
      ),
      child: Text(
        categoryName,
        textAlign: TextAlign.left,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  void _showTooltip([TapDownDetails? details]) {
    final tooltipOverlayEntry = OverlayEntry(
      builder: (context) {
        if (details == null) {
          return Container(); // If there are no categories, hide the tooltip
        }

        final bubbleTop = details.globalPosition.dy + 10;
        final bubbleLeft = details.globalPosition.dx - 30;

        return Positioned(
          top: bubbleTop,
          left: bubbleLeft,
          child: _CustomTooltip(
            message: "Sort by kategori",
          ),
        );
      },
    );

    Overlay.of(context)?.insert(tooltipOverlayEntry);

    // Hide the tooltip after a short delay
    Future.delayed(Duration(seconds: 3), () {
      tooltipOverlayEntry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorConstant.pink300,
        centerTitle: true,
        title: const Text("Beranda"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Obx(() => userController.isLoading.value
                ? const Text("loading")
                : Text(
                    "Halo, ${userController.getUser!.nama.toString().split(' ')[0]}👋",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppStyle.txtPoppinsMedium22.copyWith(
                      letterSpacing: getHorizontalSize(1.0),
                    ),
                  )),
            const SizedBox(height: 8.0),
            SizedBox(
              height: 40,
              child: Obx(
                () => categoriesController.isLoading.value
                    ? const Text("loading")
                    : Container(
                        height: 40,
                        child: ListView.builder(
                          key: _listViewKey,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: categoriesController.kategori.length,
                          itemBuilder: (context, index) {
                            Category model =
                                categoriesController.kategori[index];
                            bool isSelected = model ==
                                categoriesController.selectedCategory.value;

                            return GestureDetector(
                              onTap: () {
                                categoriesController
                                    .fetchDataByCategory(model.namaKategori);
                              },
                              onTapDown: (details) {
                                _showTooltip(details);
                              },
                              child: Container(
                                child: Row(
                                  children: [
                                    _buildCategoryContainer(
                                        isSelected, model.namaKategori),
                                    const SizedBox(
                                      width: 10,
                                    ), // Separator between items
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: Obx(
                () => categoriesController.isLoading.value
                    ? const Text("loading")
                    : ListView.builder(
                        itemCount: perawatanController.filteredPerawatan.length,
                        itemBuilder: (context, index) {
                          Perawatan perawatan =
                              perawatanController.filteredPerawatan[index];

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      perawatan.namaPerawatan.toString(),
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "Harga DP : Rp${perawatan.hargaPerawatan!.toStringAsFixed(0)} | Durasi : ${perawatan.estimasi.toString()} menit",
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: ColorConstant.pink300,
                                  ),
                                  child: InkWell(
                                    onTap: () async {
                                      await perawatanController
                                          .addCartItem(perawatan);
                                    },
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Obx(() {
        final cartCount = perawatanController.cartCount.value;
        final total = perawatanController.total.value;

        return Visibility(
          visible: cartCount > 0,
          child: FloatingActionButton.extended(
            onPressed: () {
              perawatanController.calculateTotal(); // Calculate the total
              Navigator.pushNamed(context, '/checkout');
            },
            backgroundColor: ColorConstant.pink300,
            label: Text('Keranjang : $cartCount | Total : Rp$total'),
          ),
        );
      }),
    );
  }
}

class _CustomTooltip extends StatelessWidget {
  final String message;

  const _CustomTooltip({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        message,
        style: TextStyle(fontSize: 14, color: Colors.black),
      ),
    );
  }
}
