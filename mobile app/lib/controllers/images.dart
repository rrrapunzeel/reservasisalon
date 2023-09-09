import 'package:get/get.dart';
import '../models/images.dart';
import '../repository/images.dart';

class ImagesController extends GetxController {
  final ImagesRepository imagesRepository = ImagesRepository();
  final gambar = <Images>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void fetchGambar() async {
    isLoading(true);
    try {
      final result = await imagesRepository.getImages();
      print("Fetched Images: $result"); // Add this line to log the fetched data
      gambar.assignAll(result);
    } catch (e) {
      print("Error fetching images: $e"); // Add this line to log any errors
    }
    isLoading(false);
  }
}
