import 'package:flutter/material.dart';
import 'package:supabase_auth/core/app_export.dart';
import 'package:get/get.dart';
import '../../../controllers/images.dart';

class SplashScreenOneScreen extends StatelessWidget {
  const SplashScreenOneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 6000), () {
      Get.toNamed('/two');
    });
    // Fetch images before navigating to the next screen
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
          child: Container(
            width: double.maxFinite,
            padding: getPadding(left: 34, right: 34),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () {
                    if (imagesController.isLoading.value) {
                      // Use imagesController.isLoading.value
                      return const CircularProgressIndicator();
                    } else {
                      // Check if there's at least one image in the list
                      if (imagesController.gambar.isNotEmpty) {
                        // Use imagesController.gambar
                        // Use the first image URL from the list
                        final imageUrl = imagesController
                            .gambar[0].image; // Use imagesController.gambar

                        // Display the image using CustomImageView
                        return Image.network(
                          imageUrl ?? '',
                          height: 307,
                          width: 307,
                        );
                      } else {
                        // Return a fallback widget or message if there are no images
                        return const Text('No images found.');
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
