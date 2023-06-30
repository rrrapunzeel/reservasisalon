import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_auth/core/utils/color_constant.dart';
import 'package:supabase_auth/screens/home/home-page.dart';
import 'package:supabase_auth/screens/notifikasi/notifikasi-page.dart';
import 'package:supabase_auth/screens/profile/profile-section.dart';
import 'package:supabase_auth/screens/reservasi/reservasi-page.dart';
import 'package:supabase_auth/screens/reservasi/payment-screen.dart';
import 'package:supabase_auth/supabase_state/auth_require_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_auth/repository/user.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends AuthRequiredState<DashboardScreen> {
  int _selectedIndex = 0;
  User? user;

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    ReservasiPage(),
    NotifikasiPage(),
    PaymentScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void onAuthenticated(Session session) async {
    //SECTION - mengambil data user login google dan nanti disimpen di SharedPreferences.

    final _user = session.user;
    user = _user;
    final prefs = await SharedPreferences.getInstance();
    final UserRepository userRepository = UserRepository();
    final result = await userRepository.getProfile(user?.id ?? '');

    final profile = result.first;

    print('prefs ${user?.userMetadata["full_name"]}');
    print('prefs ${user?.userMetadata["avatar_url"]}');
    print('prefs ${user?.userMetadata["phone"]}');

    // simpen di SharedPreferences
    await prefs.setString('userId', user!.id);
    await prefs.setString('userEmail', user!.email.toString());
    await prefs.setString('userAvatar', user!.userMetadata["avatar_url"]);
    await prefs.setString('userName', profile.nama ?? '');
    await prefs.setString('nomorTelepon', profile.nomorTelepon ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today), label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications_none), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: ColorConstant.pink300,
          type: BottomNavigationBarType.fixed,
          enableFeedback: false,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
          elevation: 2),
    );
  }

  void onTapSignOut() async {
    await Supabase.instance.client.auth.signOut();
  }
}
