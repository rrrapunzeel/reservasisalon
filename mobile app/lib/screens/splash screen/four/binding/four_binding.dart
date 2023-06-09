import 'package:supabase_auth/screens/splash screen/four/controller/four_controller.dart';
import 'package:get/get.dart';

class SplashScreenFourBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashScreenFourController());
  }
}
