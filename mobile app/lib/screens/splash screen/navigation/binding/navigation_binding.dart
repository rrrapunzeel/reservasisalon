import 'package:supabase_auth/screens/splash screen/navigation/controller/navigation_controller.dart';
import 'package:get/get.dart';

class AppNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AppNavigationController());
  }
}
