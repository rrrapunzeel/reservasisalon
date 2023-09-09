import 'package:awesome_select/awesome_select.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_auth/models/userModel.dart';
import 'package:supabase_auth/repository/user.dart';
import 'package:flutter/material.dart';

class UserController extends GetxController {
  static UserController get to => Get.find<UserController>();
  final UserRepository userRepository = UserRepository();
  final pegawai = <UserModel>[].obs;
  final profile = <UserModel>[].obs;
  late SharedPreferences prefs;
  var isLoading = false.obs;
  List<S2Choice<String>>? _pegawai;
  UserModel? _user;
  TextEditingController? emailController;
  TextEditingController? namaController;
  TextEditingController? nomorTeleponController;

  @override
  Future<void> onInit() async {
    super.onInit();
    getListPegawai();
    prefs = await SharedPreferences.getInstance();
    getUserInfo();
    emailController = TextEditingController(
      text: prefs.getString('userEmail'),
    );
    namaController = TextEditingController(text: prefs.getString('userName'));
    nomorTeleponController =
        TextEditingController(text: prefs.getString('nomorTelepon'));
    // print(namaController?.text);
    // print(emailController?.text);
    // print(nomorTeleponController?.text);
  }

  getUserInfo() {
    isLoading(true);
    final String? id = prefs.getString('userId');
    final String? email = prefs.getString('userEmail');
    final String? nama = prefs.getString('userName');
    final String? avatar = prefs.getString('userAvatar');
    final String? nomorTelepon = prefs.getString('nomorTelepon');

    _user = UserModel(
        id: id,
        email: email,
        nama: nama,
        avatar: avatar,
        nomorTelepon: nomorTelepon);
    isLoading(false);
  }

  UserModel getCurrentUser() {
    final String? userId = prefs.getString('userId');
    final String? email = prefs.getString('userEmail');
    final String? name = prefs.getString('userName');
    final String? avatar = prefs.getString('userAvatar');
    final String? nomorTelepon = prefs.getString('nomorTelepon');

    if (userId != null && email != 'null' && name != null && avatar != null) {
      return UserModel(
          id: userId,
          email: email,
          nama: name,
          avatar: avatar,
          nomorTelepon: nomorTelepon);
    } else {
      throw Exception('Gagal mendapatkan pengguna saat ini');
    }
  }

  void getListPegawai() async {
    isLoading(true);
    try {
      final result = await userRepository.getPegawai();
      pegawai.assignAll(result);
    } catch (e) {
      print(e);
    }
    isLoading(false);

    List<S2Choice<String>> select = pegawai.map((item) {
      String value = item.id ?? '';
      String label = item.nama ?? '';
      return S2Choice<String>(value: value, title: label);
    }).toList();
    _pegawai = select;
    isLoading(false);
  }

  Future<void> fetchProfile() async {
    try {
      final result =
          await userRepository.getProfile(prefs.getString('userId') ?? '');
      if (result.isNotEmpty) {
        final profile = result[0];
        emailController?.text = profile.email ?? '';
        namaController?.text = profile.nama ?? '';
        nomorTeleponController?.text = profile.nomorTelepon ?? '';
        await prefs.setString('userAvatar', profile.avatar ?? '');
        await prefs.setString('userName', profile.nama ?? '');
        await prefs.setString('nomorTelepon', profile.nomorTelepon ?? '');
      }
      print(profile);
    } catch (e) {
      print("Error fetching profile: $e");
    }
  }

  void fetchUpdateProfile(String id) async {
    try {
      final result = await userRepository.updateProfile(
          namaController!.text, nomorTeleponController!.text, id);
      if (result != null) {
        namaController?.text = result.nama ?? '';
        nomorTeleponController?.text = result.nomorTelepon ?? '';
      }
      print(result);
    } catch (e) {
      print("Error fetching profile: $e");
    }
  }

  UserModel? get getUser => _user;
  List<S2Choice<String>>? get getPegawai => _pegawai;
}
