import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_auth/controllers/user.dart';
import 'package:supabase_auth/core/utils/color_constant.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_auth/controllers/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../models/userModel.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserController userController = Get.put(UserController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstant.pink300,
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Obx(() => userController.isLoading.value
                ? const Text("loading")
                : CircleAvatar(
                    radius: 30.0,
                    backgroundImage:
                        NetworkImage("${userController.getUser!.avatar}"),
                    backgroundColor: Colors.transparent,
                  )),
            Form(
              child: SizedBox(
                width: double.maxFinite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Text(
                        "Email".tr,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: TextFormField(
                        controller: userController.emailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Text(
                        "Nama".tr,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: TextField(
                        controller: userController.namaController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Text(
                        "Nomor Telepon".tr,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: TextField(
                        controller: userController.nomorTeleponController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: ColorConstant.pink300, // background
                            onPrimary: Colors.white, // foreground
                          ),
                          onPressed: () async {
                            final idUser =
                                userController.getCurrentUser().id.toString();
                            userController.fetchUpdateProfile(idUser);
                          },
                          child: const Text('Simpan'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: ColorConstant.pink300, // background
                            onPrimary: Colors.white, // foreground
                          ),
                          onPressed: () async {
                            await Supabase.instance.client.auth.signOut();
                          },
                          child: const Text('Keluar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final _connect = GetConnect();
}
