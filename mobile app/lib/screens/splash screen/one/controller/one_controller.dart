import 'package:supabase_auth/core/app_export.dart';
import 'package:supabase_auth/screens/splash screen/one/model/one_model.dart';

import '../../../../routes/app_routes.dart';

class SplashScreenOneController extends GetxController {
  Rx<SplashScreenOneModel> splashScreenOneModelObj = SplashScreenOneModel().obs;

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(milliseconds: 3000), () {
      Get.offNamed(AppRoutes.splashScreenTwoScreen);
    });
  }

  @override
  void onClose() {
    super.onClose();
  }
}
