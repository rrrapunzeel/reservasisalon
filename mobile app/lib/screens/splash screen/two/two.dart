import 'package:supabase_auth/screens/splash screen/two/controller/two_controller.dart';
import 'package:flutter/material.dart';
import 'package:supabase_auth/core/app_export.dart';
import 'package:supabase_auth/widgets/custom_button.dart';
import '../../../controllers/images.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_style.dart';

class SplashScreenTwoScreen extends GetWidget<SplashScreenTwoController> {
  const SplashScreenTwoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ImagesController imagesController = Get.put(ImagesController());
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Container(
              width: size.width,
              height: size.height,
              decoration: BoxDecoration(
                border: Border.all(
                  color: ColorConstant.black900,
                  width: getHorizontalSize(1),
                ),
                gradient: LinearGradient(
                  begin: const Alignment(0.5, 0),
                  end: const Alignment(0.5, 1),
                  colors: [
                    ColorConstant.whiteA700,
                    ColorConstant.whiteA700,
                    ColorConstant.whiteA700,
                  ],
                ),
              ),
              child: InkWell(
                onTap: onTapLanjut, // Navigate to the next page
                child: Container(
                  width: double.maxFinite,
                  padding: getPadding(
                    left: 20,
                    top: 40,
                    right: 20,
                    bottom: 20,
                  ), // Added bottom padding
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Row(children: [
                          Container(
                            height: getVerticalSize(10),
                            width: getHorizontalSize(105),
                            decoration: BoxDecoration(
                              color: ColorConstant.pink300,
                              borderRadius:
                                  BorderRadius.circular(getHorizontalSize(5)),
                            ),
                          ),
                          Container(
                            height: getVerticalSize(10),
                            width: getHorizontalSize(48),
                            margin: getMargin(left: 9),
                            decoration: BoxDecoration(
                              color: ColorConstant.gray300,
                              borderRadius:
                                  BorderRadius.circular(getHorizontalSize(5)),
                            ),
                          ),
                          Container(
                            height: getVerticalSize(10),
                            width: getHorizontalSize(29),
                            margin: getMargin(left: 9),
                            decoration: BoxDecoration(
                              color: ColorConstant.gray300,
                              borderRadius:
                                  BorderRadius.circular(getHorizontalSize(5)),
                            ),
                          ),
                        ]),
                      ),
                      Padding(
                        padding: getPadding(top: 40),
                        child: Text(
                          "Pilih Perawatan".tr,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtPoppinsMedium22.copyWith(
                            letterSpacing: getHorizontalSize(1.0),
                          ),
                        ),
                      ),
                      Container(
                        width: getHorizontalSize(259),
                        margin: getMargin(left: 40, top: 4, right: 34),
                        child: Text(
                          "Pilih perawatan dengan satu Klik!".tr,
                          maxLines: null,
                          textAlign: TextAlign.center,
                          style: AppStyle.txtPoppinsRegular14.copyWith(
                            letterSpacing: getHorizontalSize(1.0),
                          ),
                        ),
                      ),
                      Obx(
                        () {
                          if (imagesController.isLoading.value) {
                            return const CircularProgressIndicator();
                          } else {
                            if (imagesController.gambar.isNotEmpty) {
                              final imageUrl = imagesController.gambar[1].image;

                              return Align(
                                alignment: Alignment.center,
                                child: Image.network(
                                  imageUrl ?? '',
                                  height: 300,
                                  width: 300,
                                ),
                              );
                            } else {
                              return const Text('No images found.');
                            }
                          }
                        },
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: CustomButton(
                            height: getVerticalSize(48),
                            text: "Lanjut".tr,
                            margin: getMargin(top: 10, bottom: 5),
                            onTap: onTapLanjut,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: onTapSkip,
                child: Container(
                  margin: getMargin(top: 16, right: 16),
                  padding: getPadding(top: 20, bottom: 12),
                  child: Text(
                    "Lewati",
                    style: AppStyle.txtPoppinsRegular14.copyWith(
                      color: Colors.black,
                      letterSpacing: getHorizontalSize(1.0),
                      decoration:
                          TextDecoration.underline, // Add the underline here
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  onTapLanjut() {
    Get.toNamed(AppRoutes.splashScreenThreeScreen);
  }

  onTapSkip() {
    Get.toNamed(AppRoutes.loginScreen);
  }
}
