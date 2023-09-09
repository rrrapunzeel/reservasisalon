import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_auth/controllers/user.dart';
import 'package:supabase_auth/core/utils/color_constant.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var authRedirectUri = 'io.supabase.flutterdemo://login-callback';
  final _formKey = GlobalKey<FormState>();
  UserController userController = Get.put(UserController());
  final FocusNode _namaFocus = FocusNode();
  final FocusNode _nomorTeleponFocus = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstant.pink300,
        centerTitle: true,
        title: const Text("Profil"),
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
              key: _formKey,
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
                        enabled: false, // Disable editing
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
                      child: TextFormField(
                        controller: userController.namaController,
                        focusNode: _namaFocus,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Nama is required.';
                          }
                          // Additional validation logic if needed
                          return null;
                        },
                        onEditingComplete: () {
                          FocusScope.of(context)
                              .requestFocus(_nomorTeleponFocus);
                        },
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
                      child: TextFormField(
                        controller: userController.nomorTeleponController,
                        focusNode: _nomorTeleponFocus,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Nomor Telepon is required.';
                          }
                          // Additional validation logic if needed
                          return null;
                        },
                        onEditingComplete: () {
                          _namaFocus.unfocus();
                          _nomorTeleponFocus.unfocus();
                        },
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
                            if (_formKey.currentState!.validate()) {
                              final idUser =
                                  userController.getCurrentUser().id.toString();
                              userController.fetchUpdateProfile(idUser);
                              _showSuccessAlert();
                            }
                          },
                          child: const Text('Simpan'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: ColorConstant.pink300,
                            onPrimary: Colors.white,
                          ),
                          onPressed: () async {
                            final supabaseAuth = Supabase.instance.client.auth;
                            if (supabaseAuth.currentUser != null) {
                              // If the user is already signed in with Supabase,
                              // sign them out of both Supabase and Google.
                              await supabaseAuth.signOut();
                              GoogleSignIn _googleSignIn = GoogleSignIn();
                              await _googleSignIn.signOut();
                            }

                            // Close the current screen
                            Get.back();
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

  void _showSuccessAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: const Text('Profil berhasil disimpan'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
