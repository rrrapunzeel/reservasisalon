import 'package:supabase_auth/screens/splash screen/two/controller/two_controller.dart';
import 'package:get/get.dart';

class SplashScreenTwoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashScreenTwoController());
  }
}
