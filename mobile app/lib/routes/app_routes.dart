import 'package:supabase_auth/screens/splash%20screen/one/one.dart';
import 'package:supabase_auth/screens/splash%20screen/one/binding/one_binding.dart';
import 'package:supabase_auth/screens/splash%20screen/two/two.dart';
import 'package:supabase_auth/screens/splash%20screen/two/binding/two_binding.dart';
import 'package:supabase_auth/screens/splash%20screen/three/three.dart';
import 'package:supabase_auth/screens/splash%20screen/three/binding/three_binding.dart';
import 'package:supabase_auth/screens/splash%20screen/four/four.dart';
import 'package:supabase_auth/screens/splash%20screen/four/binding/four_binding.dart';
import 'package:supabase_auth/screens/splash%20screen/navigation/navigation.dart';
import 'package:supabase_auth/screens/splash%20screen/navigation/binding/navigation_binding.dart';
import 'package:get/get.dart';

import '../screens/auth/sign_in_screen.dart';

class AppRoutes {
  static const String splashScreenOneScreen = '/one';

  static const String splashScreenTwoScreen = '/two';

  static const String splashScreenThreeScreen = '/three';

  static const String splashScreenFourScreen = '/four';

  static const String loginScreen = '/login';

  static const String appNavigationScreen = '/navigation';

  static String initialRoute = '/initialRoute';

  static List<GetPage> pages = [
    GetPage(
      name: splashScreenOneScreen,
      page: () => SplashScreenOneScreen(),
      bindings: [
        SplashScreenOneBinding(),
      ],
    ),
    GetPage(
      name: splashScreenTwoScreen,
      page: () => SplashScreenTwoScreen(),
      bindings: [
        SplashScreenTwoBinding(),
      ],
    ),
    GetPage(
      name: splashScreenThreeScreen,
      page: () => SplashScreenThreeScreen(),
      bindings: [
        SplashScreenThreeBinding(),
      ],
    ),
    GetPage(
      name: splashScreenFourScreen,
      page: () => SplashScreenFourScreen(),
      bindings: [
        SplashScreenFourBinding(),
      ],
    ),
    GetPage(
      name: loginScreen,
      page: () => const SignInScreen(),
    ),
    GetPage(
      name: appNavigationScreen,
      page: () => AppNavigationScreen(),
      bindings: [
        AppNavigationBinding(),
      ],
    ),
    GetPage(
      name: initialRoute,
      page: () => SplashScreenOneScreen(),
      bindings: [
        SplashScreenOneBinding(),
      ],
    )
  ];
}
