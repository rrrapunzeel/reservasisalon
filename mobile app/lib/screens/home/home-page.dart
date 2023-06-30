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

  @override
  void initState() {
    super.initState();
    categoriesController.fetchCategories();
    perawatanController.fetchPerawatan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorConstant.pink300,
        centerTitle: true,
        title: const Text("Homepage"),
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
                    "Hello, ${userController.getUser!.nama.toString().split(' ')[0]}👋",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppStyle.txtPoppinsMedium22.copyWith(
                      letterSpacing: getHorizontalSize(1.0),
                    ),
                  )),
            const SizedBox(height: 8.0),
            Text(
              "Mau perawatan apa hari ini?".tr,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: AppStyle.txtRobotoRegular16.copyWith(
                letterSpacing: getHorizontalSize(1.0),
              ),
            ),
            const Divider(),
            SizedBox(
              height: 40,
              child: Obx(
                () => categoriesController.isLoading.value
                    ? const Text("loading")
                    : ListView.separated(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 10);
                        },
                        itemCount: categoriesController.kategori.length,
                        itemBuilder: (context, index) {
                          Category model = categoriesController.kategori[index];
                          bool isSelected = model ==
                              categoriesController.selectedCategory.value;

                          return GestureDetector(
                            onTap: () {
                              categoriesController
                                  .fetchDataByCategory(model.namaKategori);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? ColorConstant.pink300
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: ColorConstant.pink300,
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                model.namaKategori.toString(),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          );
                        },
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
                                      "Rp${perawatan.hargaPerawatan!.toStringAsFixed(0)}",
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    onPrimary: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                      side: BorderSide(
                                        color: ColorConstant.pink300,
                                        width: 2,
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(10),
                                  ),
                                  onPressed: () async {
                                    await perawatanController
                                        .addCartItem(perawatan);
                                  },
                                  child: const Text(
                                    '+',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          perawatanController.calculateTotal(); // Calculate the total
          Navigator.pushNamed(context, '/checkout');
        },
        backgroundColor: ColorConstant.pink300,
        label: Obx(() {
          final isLoading = perawatanController.isLoading.value;
          final cartCount = perawatanController.cartCount.value;
          final total = perawatanController.total.value;

          return isLoading
              ? const Text("loading")
              : Text('Keranjang : $cartCount, Total : Rp$total');
        }),
      ),
    );
  }
}
