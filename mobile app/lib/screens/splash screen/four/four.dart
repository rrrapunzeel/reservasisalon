import 'package:supabase_auth/screens/splash screen/four/controller/four_controller.dart';
import 'package:flutter/material.dart';
import 'package:supabase_auth/core/app_export.dart';
import 'package:supabase_auth/widgets/custom_button.dart';

import '../../../controllers/images.dart';
import '../../../theme/app_style.dart';

class SplashScreenFourScreen extends GetWidget<SplashScreenFourController> {
  const SplashScreenFourScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ImagesController imagesController = Get.put(ImagesController());
    imagesController.fetchGambar();
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            border: Border.all(
              color: ColorConstant.black900,
              width: getHorizontalSize(
                1,
              ),
            ),
            gradient: LinearGradient(
              begin: const Alignment(
                0.5,
                0,
              ),
              end: const Alignment(
                0.5,
                1,
              ),
              colors: [
                ColorConstant.whiteA700,
                ColorConstant.whiteA700,
                ColorConstant.whiteA700,
              ],
            ),
          ),
          child: Container(
            width: double.maxFinite,
            padding: getPadding(
              left: 20,
              top: 63,
              right: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Container(
                        height: getVerticalSize(
                          10,
                        ),
                        width: getHorizontalSize(
                          29,
                        ),
                        decoration: BoxDecoration(
                          color: ColorConstant.gray300,
                          borderRadius: BorderRadius.circular(
                            getHorizontalSize(
                              5,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: getVerticalSize(
                          10,
                        ),
                        width: getHorizontalSize(
                          48,
                        ),
                        margin: getMargin(
                          left: 9,
                        ),
                        decoration: BoxDecoration(
                          color: ColorConstant.gray300,
                          borderRadius: BorderRadius.circular(
                            getHorizontalSize(
                              5,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: getVerticalSize(
                          10,
                        ),
                        width: getHorizontalSize(
                          106,
                        ),
                        margin: getMargin(
                          left: 9,
                        ),
                        decoration: BoxDecoration(
                          color: ColorConstant.pink300,
                          borderRadius: BorderRadius.circular(
                            getHorizontalSize(
                              5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: getPadding(
                    top: 46,
                  ),
                  child: Text(
                    "lbl_datang_ke_salon".tr,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppStyle.txtPoppinsMedium22.copyWith(
                      letterSpacing: getHorizontalSize(
                        1.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: getHorizontalSize(
                    242,
                  ),
                  margin: getMargin(
                    left: 49,
                    right: 43,
                  ),
                  child: Text(
                    "msg_kamu_siap_untuk".tr,
                    maxLines: null,
                    textAlign: TextAlign.center,
                    style: AppStyle.txtPoppinsRegular14.copyWith(
                      letterSpacing: getHorizontalSize(
                        1.0,
                      ),
                    ),
                  ),
                ),
                Obx(
                  () {
                    if (imagesController.isLoading.value) {
                      return const CircularProgressIndicator();
                    } else {
                      if (imagesController.gambar.isNotEmpty) {
                        final imageUrl = imagesController
                            .gambar[3].image; // Use imagesController.gambar[0]

                        return Align(
                          alignment: Alignment.center,
                          child: Image.network(
                            imageUrl ?? '',
                            height: 100,
                            width: 100,
                          ),
                        );
                      } else {
                        return const Text('No images found.');
                      }
                    }
                  },
                ),
                // SizedBox(
                //   height: getVerticalSize(
                //     20,
                //   ),
                CustomButton(
                  text: "msg_masuk_dengan_google".tr,
                  margin: getMargin(
                    left: 2,
                    right: 1,
                    bottom: 5,
                  ),
                  variant: ButtonVariant.outlinePink300,
                  padding: ButtonPadding.paddingT13,
                  fontStyle: ButtonFontStyle.poppinsBold12Gray80001,
                  prefixWidget: Container(
                    margin: getMargin(
                      right: 10,
                    ),
                    child: CustomImageView(
                      svgPath: ImageConstant.imgGoogle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
