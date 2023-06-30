import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:supabase_auth/screens/reservasi/checkout-page.dart';
import 'package:supabase_auth/screens/reservasi/payment-failed.dart';
import 'package:supabase_auth/screens/reservasi/payment-screen.dart';
import 'package:supabase_auth/screens/reservasi/payment-success.dart';
import 'package:supabase_auth/screens/reservasi/preview-page.dart';
import 'package:supabase_auth/screens/reservasi/reservasi-page.dart';
import 'package:supabase_auth/screens/splash%20screen/one/one.dart';
import 'package:supabase_auth/screens/splash%20screen/three/three.dart';
import 'package:supabase_auth/screens/splash%20screen/two/two.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_auth/screens/navbar.dart';
import 'package:supabase_auth/screens/auth/sign_in_screen.dart';
import 'package:supabase_auth/screens/auth/sign_up_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
      url: 'https://fuzdyyktvczvrbwrjkhe.supabase.co/',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1emR5eWt0dmN6dnJid3Jqa2hlIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzI0MTA4ODcsImV4cCI6MTk4Nzk4Njg4N30.kMVUSwTCDMLEM-8ePXPXniT62zkB75Q3gvyvuAbkibU',
      authCallbackUrlHostname: 'login-callback', // optional
      debug: true // optional
      );

  // OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  // OneSignal.shared.setAppId("98ce4c83-acb4-4667-ad2f-f628488fb3f2");

  // OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
  //   print("Accepted permission: $accepted");
  // });
  // OneSignal.shared.setNotificationWillShowInForegroundHandler(
  //     (OSNotificationReceivedEvent event) {
  //   event.complete(event.notification);
  // });

  // OneSignal.shared
  //     .setNotificationOpenedHandler((OSNotificationOpenedResult result) {});

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Challista Beauty Salon',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      initialRoute: '/one',
      getPages: [
        GetPage(name: '/one', page: () => SplashScreenOneScreen()),
        GetPage(name: '/two', page: () => SplashScreenTwoScreen()),
        GetPage(name: '/three', page: () => SplashScreenThreeScreen()),
        GetPage(name: '/login', page: () => const SignInScreen()),
        GetPage(name: '/signup', page: () => const SignUpScreen()),
        GetPage(name: '/dashboard', page: () => const DashboardScreen()),
        GetPage(name: '/checkout', page: () => const CheckoutPage()),
        GetPage(name: '/reservasi', page: () => const ReservasiPage()),
        GetPage(name: '/preview', page: () => const PreviewPage()),
        GetPage(
            name: '/payment-success', page: () => const PaymentSuccessPage()),
        GetPage(
            name: '/payment-failed', page: () => const PaymentFailedScreen()),
        GetPage(name: '/payment', page: () => const PaymentScreen()),
      ],
    );
  }
}
