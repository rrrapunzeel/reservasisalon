import 'package:flutter/material.dart';
import 'package:supabase_auth/core/app_export.dart';

class SplashScreenOneScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 9000), () {
      Get.toNamed('/two');
    });

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
                    padding: getPadding(left: 34, right: 34),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomImageView(
                              imagePath: ImageConstant.imgLogochallista1,
                              height: getSize(307),
                              width: getSize(307),
                              margin: getMargin(bottom: 5))
                        ])))));
  }
}
