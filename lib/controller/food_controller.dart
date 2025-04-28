import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/food_model.dart';

class FoodController extends GetxController {
  var isLoading = false.obs;
  var foodList = <FoodModel>[].obs;
  var expandList = <RxBool>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchFoods(); // 👈 Tự động gọi khi controller khởi tạo
  }

  // Gọi API để lấy danh sách món ăn
  Future<void> fetchFoods() async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse(
          'https://run.mocky.io/v3/a3c1dbc7-546e-47a6-a3fa-d33f30dafe7e'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        foodList.value = jsonData.map((e) => FoodModel.fromJson(e)).toList();

        // Cập nhật danh sách trạng thái mở rộng mô tả
        expandList.value = List.generate(foodList.length, (_) => false.obs);
      } else {
        Get.snackbar('Lỗi', 'Không lấy được dữ liệu món ăn');
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Kết nối thất bại: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Lấy chi tiết món ăn theo ID
  Future<FoodModel?> getFoodDetail(int id) async {
    try {
      final response =
          await http.get(Uri.parse('https://yourdomain.com/api/foods/$id'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return FoodModel.fromJson(data);
      } else {
        Get.snackbar('Lỗi', 'Không tìm thấy chi tiết món ăn');
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Lỗi lấy chi tiết món ăn: $e');
    }
    return null;
  }

  // Mở/thu gọn mô tả
  void toggleExpand(int index) {
    if (index >= 0 && index < expandList.length) {
      expandList[index].toggle();
    }
  }
}
