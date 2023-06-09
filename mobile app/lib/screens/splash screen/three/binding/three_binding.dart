import 'package:supabase_auth/screens/splash screen/three/controller/three_controller.dart';

import 'package:get/get.dart';

class SplashScreenThreeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashScreenThreeController());
  }
}
