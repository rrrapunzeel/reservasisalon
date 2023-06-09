import 'package:supabase_auth/screens/splash screen/one/controller/one_controller.dart';
import 'package:get/get.dart';

class SplashScreenOneBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashScreenOneController());
  }
}
