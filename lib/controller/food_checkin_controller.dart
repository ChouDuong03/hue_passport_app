import 'package:get/get.dart';
import '../services/api_checkin_food_service.dart';

class CheckinController extends GetxController {
  var isLoading = false.obs;
  var isSuccess = false.obs;

  Future<void> checkIn({
    required int monAnId,
    required int chuongTrinhId,
    required double viDo,
    required double kinhDo,
  }) async {
    try {
      isLoading.value = true;

      final result = await ApiCheckinFoodService.postCheckinMultipart(
        monAnId: monAnId,
        chuongTrinhId: chuongTrinhId,
        viDo: viDo,
        kinhDo: kinhDo,
      );

      isSuccess.value = result.success;

      if (result.success) {
        Get.snackbar("Thành công", "Check-in thành công!");
      } else {
        Get.snackbar("Thất bại", "Check-in không thành công!");
      }
    } catch (e) {
      Get.snackbar("Lỗi", "Đã xảy ra lỗi khi check-in: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
