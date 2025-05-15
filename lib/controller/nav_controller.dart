import 'package:get/get.dart';

class NavController extends GetxController {
  var selectedIndex = 0.obs; // Chỉ số tab hiện tại
  final List<int> tabHistory = [0]; // Lưu lịch sử các tab, bắt đầu từ tab 0

  var currentChuongTrinhID = 1.obs;

  // Hàm cập nhật chuongTrinhID

  void changeTabIndex(int index) {
    if (selectedIndex.value != index) {
      // Nếu chuyển sang tab mới, thêm chỉ số tab vào lịch sử
      tabHistory.add(index);
      selectedIndex.value = index;
    }
  }

  void goBackToPreviousTab() {
    if (tabHistory.length > 1) {
      // Xóa tab hiện tại khỏi lịch sử
      tabHistory.removeLast();
      // Chuyển về tab trước đó
      selectedIndex.value = tabHistory.last;
    } else {
      // Nếu không có tab trước đó, có thể quay về màn hình mặc định (ví dụ: LoginScreen)
      Get.offAllNamed('/login'); // Hoặc thay bằng route cụ thể
    }
  }

  void updateChuongTrinhID(int id) {
    currentChuongTrinhID.value = id;
  }
}
