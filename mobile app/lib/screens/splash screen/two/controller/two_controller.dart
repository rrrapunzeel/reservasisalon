import 'package:supabase_auth/core/app_export.dart';
import 'package:supabase_auth/screens/splash screen/two/model/two_model.dart';

import '../../../../models/images.dart';
import '../../../../repository/images.dart';

class SplashScreenTwoController extends GetxController {
  final ImagesRepository imagesRepository = ImagesRepository();
  Rx<SplashScreenTwoModel> splashScreenTwoModelObj = SplashScreenTwoModel().obs;

  final gambar = <Images>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Move the fetchGambar call to onInit
    fetchGambar();
  }

  void fetchGambar() async {
    isLoading(true);
    try {
      final result = await imagesRepository.getImages();
      print("Fetched Images: $result");
      gambar.assignAll(result);
    } catch (e) {
      print("Error fetching images: $e");
    }
    isLoading(false);
  }
}
