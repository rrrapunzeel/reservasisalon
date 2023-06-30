import 'package:supabase_auth/screens/profile/profile-page.dart';
import 'package:get/get.dart';
import 'package:supabase_auth/controllers/user.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/utils/color_constant.dart';
import '../../core/utils/size_utils.dart';
import '../../theme/app_style.dart';

class ProfileSection extends StatefulWidget {
  const ProfileSection({Key? key}) : super(key: key);

  @override
  _ProfileSectionState createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  UserController userController = Get.put(UserController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorConstant.pink300,
        centerTitle: true,
        title: const Text("Homepage"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Obx(() => userController.isLoading.value
              ? const Text("loading")
              : CircleAvatar(
                  radius: 30.0,
                  backgroundImage:
                      NetworkImage("${userController.getUser!.avatar}"),
                  backgroundColor: Colors.transparent,
                )),
          Text(
            "${userController.getUser!.nama}",
            style: AppStyle.txtRobotoRegular16.copyWith(
              letterSpacing: getHorizontalSize(1.0),
            ),
          ),
          Text(
            "${userController.getUser!.email}",
            style: AppStyle.txtPoppinsRegular14.copyWith(
              letterSpacing: getHorizontalSize(1.0),
            ),
          ),
          Divider(),
          SizedBox(height: 20),
          ListView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(vertical: 16),
            children: [
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                },
                leading: Icon(
                  Icons.account_circle_outlined,
                  color: Color.fromARGB(255, 226, 97, 140),
                ),
                title: Text('Edit Profile'),
                trailing: Icon(Icons.arrow_right_sharp),
              ),
              Divider(), // Divider pertama
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                },
                leading: Icon(
                  Icons.history,
                  color: Color.fromARGB(255, 226, 97, 140),
                ),
                title: Text('Booking History'),
                trailing: Icon(Icons.arrow_right_sharp),
              ),
              Divider(),
              ListTile(
                onTap: () async {
                  await Supabase.instance.client.auth.signOut();
                },
                leading: Icon(
                  Icons.logout_outlined,
                  color: Color.fromARGB(255, 226, 97, 140),
                ),
                title: Text('Logout'),
                trailing: Icon(Icons.arrow_right_sharp),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
