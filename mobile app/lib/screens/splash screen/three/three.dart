import 'package:supabase_auth/screens/splash screen/three/controller/three_controller.dart';
import 'package:flutter/material.dart';
import 'package:supabase_auth/core/app_export.dart';
import 'package:supabase_auth/widgets/custom_button.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_style.dart';

class SplashScreenThreeScreen extends GetWidget<SplashScreenThreeController> {
  @override
  Widget build(BuildContext context) {
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
                        width: getHorizontalSize(1)),
                    gradient: LinearGradient(
                        begin: const Alignment(0.5, 0),
                        end: const Alignment(0.5, 1),
                        colors: [
                          ColorConstant.whiteA700,
                          ColorConstant.whiteA700,
                          ColorConstant.whiteA700
                        ])),
                child: Container(
                    width: double.maxFinite,
                    padding: getPadding(left: 20, top: 40, right: 20),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(children: [
                            Container(
                                height: getVerticalSize(10),
                                width: getHorizontalSize(48),
                                decoration: BoxDecoration(
                                    color: ColorConstant.gray300,
                                    borderRadius: BorderRadius.circular(
                                        getHorizontalSize(5)))),
                            Container(
                                height: getVerticalSize(10),
                                width: getHorizontalSize(105),
                                margin: getMargin(left: 9),
                                decoration: BoxDecoration(
                                    color: ColorConstant.pink300,
                                    borderRadius: BorderRadius.circular(
                                        getHorizontalSize(5)))),
                            Container(
                                height: getVerticalSize(10),
                                width: getHorizontalSize(29),
                                margin: getMargin(left: 9),
                                decoration: BoxDecoration(
                                    color: ColorConstant.gray300,
                                    borderRadius: BorderRadius.circular(
                                        getHorizontalSize(5))))
                          ]),
                          Padding(
                              padding: getPadding(left: 40, top: 40),
                              child: Text("Bayar dengan Mudah".tr,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppStyle.txtPoppinsMedium22.copyWith(
                                      letterSpacing: getHorizontalSize(1.0)))),
                          Align(
                              alignment: Alignment.center,
                              child: Container(
                                  width: getHorizontalSize(259),
                                  margin:
                                      getMargin(left: 40, top: 4, right: 34),
                                  child: Text(
                                      "Tersedia berbagai metode pembayaran".tr,
                                      maxLines: null,
                                      textAlign: TextAlign.center,
                                      style: AppStyle.txtPoppinsRegular14
                                          .copyWith(
                                              letterSpacing:
                                                  getHorizontalSize(1.0))))),
                          CustomImageView(
                              imagePath: ImageConstant.imgSplashscreenTwo,
                              height: getVerticalSize(214),
                              width: getHorizontalSize(335),
                              margin: getMargin(top: 15)),
                          CustomButton(
                              height: getVerticalSize(48),
                              text: "Lanjut".tr,
                              margin: getMargin(top: 71, bottom: 5),
                              onTap: onTapLanjut)
                        ])))));
  }

  onTapLanjut() {
    Get.toNamed(AppRoutes.loginScreen);
  }
}
