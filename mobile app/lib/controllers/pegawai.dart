// import 'package:awesome_select/awesome_select.dart';
// import 'package:get/get.dart';

// import '../repository/pegawai.dart';

// class PegawaiController extends GetxController {
//   final PegawaiRepository pegawaiRepository = PegawaiRepository();

//   List<String?> pegawai = <String?>[].obs;
//   List<S2Choice<String>>? _pegawai;
//   var isLoading = false.obs;

//   void getListPegawai() async {
//     isLoading(true);
//     try {
//       final result = await pegawaiRepository.getPegawai();
//       pegawai.assignAll(result);
//       _pegawai = pegawai.map((nama) {
//         return S2Choice<String>(value: nama!, title: nama!);
//       }).toList();
//     } catch (e) {
//       print(e);
//     }
//     isLoading(false);
//   }

//   List<S2Choice<String>>? get getPegawai => _pegawai;
// }
