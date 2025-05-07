import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hue_passport_app/controller/program_food_controller.dart';
import 'package:hue_passport_app/models/dish_detail_model.dart';
import 'package:hue_passport_app/models/dish_model.dart';

class DishDetailScreen extends StatefulWidget {
  final DishModel dish;
  final ProgramFoodController controller = Get.find<ProgramFoodController>();

  DishDetailScreen({super.key, required this.dish}) {
    // Chuyển đổi dish.id từ String? sang int
    final int id = dish.id ?? 1; // Ép kiểu int rõ ràng
    controller.fetchDishDetail(id); // Gọi API với id hợp lệ
  }

  @override
  State<DishDetailScreen> createState() => _DishDetailScreenState();
}

class _DishDetailScreenState extends State<DishDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // Phần tiêu đề với ảnh nền
                Container(
                  height: 60, // Tăng chiều cao để bao phủ tiêu đề và mũi tên
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/border2.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.white),
                            onPressed: () => Get.back(),
                          ),
                          const Text(
                            'Món ăn trong chương trình',
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 48),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFDF6FC),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Obx(() {
                    if (widget.controller.isLoadingDishDetail.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final detail =
                        widget.controller.dishDetailCache[widget.dish.id ?? 1];
                    if (detail == null || detail.childMonAnChiTiets.isEmpty) {
                      return const Center(
                          child: Text('Không thể tải chi tiết món ăn.'));
                    }

                    final childDetail = detail.childMonAnChiTiets.first;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hình ảnh món ăn
                        Center(
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              // Ảnh món ăn
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 1,
                                height: MediaQuery.of(context).size.width * 0.5,
                                child: Image.asset(
                                  'assets/images/${widget.dish.anhDaiDien}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // Gradient bóng mờ phía dưới ảnh
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 1,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black.withOpacity(0.5),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // Chữ tenMon đè lên ảnh
                              Positioned(
                                bottom: 16,
                                left: 8,
                                child: Text(
                                  detail.tenMon,
                                  style: const TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black87,
                                        offset: Offset(2, 2),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Tiêu đề và thông tin cơ bản
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Giới thiệu | Danh sách quán ăn',
                              style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 16,
                                color: Colors.blue[700],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${detail.tenMon} Huế',
                          style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Loại món ăn: ${childDetail.tenLoai}',
                          style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Mô tả (Phần ăn)
                        const Text(
                          'Mô tả',
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          childDetail.moTa.trim(),
                          style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Thành phần
                        const Text(
                          'Thành phần',
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ..._parseIngredients(childDetail.thanhPhan)
                            .map((ingredient) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        '• ',
                                        style: TextStyle(
                                          fontFamily: 'Mulish',
                                          fontSize: 14,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          ingredient.trim(),
                                          style: const TextStyle(
                                            fontFamily: 'Mulish',
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                        const SizedBox(height: 16),

                        // Cách làm (Món)
                        const Text(
                          'Cách làm',
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ..._parseSteps(childDetail.cachLam)
                            .map((step) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        '• ',
                                        style: TextStyle(
                                          fontFamily: 'Mulish',
                                          fontSize: 14,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          step,
                                          style: const TextStyle(
                                            fontFamily: 'Mulish',
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                        const SizedBox(height: 16),

                        // Khuyến nghị khi dùng
                        if (childDetail.khuyenNghiKhiDung.isNotEmpty) ...[
                          const Text(
                            'Khuyến nghị khi dùng',
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            childDetail.khuyenNghiKhiDung.trim(),
                            style: const TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        const SizedBox(height: 80), // Khoảng cách cho nút
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
          // Nút Check-in cố định ở cuối màn hình
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: ElevatedButton(
              onPressed: () {
                Get.to(() => CheckInPlaceholderScreen(dish: widget.dish));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C853),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Đã check in',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Tiêu đề và nút quay lại
        ],
      ),
    );
  }

  // Hàm phân tích cách làm thành các bước
  List<String> _parseSteps(String text) {
    final steps = text.split('\r\nBước ').where((s) => s.isNotEmpty).toList();
    if (steps.isNotEmpty) {
      // Loại bỏ ký tự thừa ở bước đầu nếu có
      steps[0] = steps[0].replaceFirst('\r\n', '');
      // Thêm "Bước " vào đầu mỗi bước
      for (int i = 0; i < steps.length; i++) {
        if (!steps[i].trim().startsWith('Bước ')) {
          steps[i] = 'Bước ${steps[i].trim()}';
        }
      }
    }
    return steps.map((s) => s.trim()).toList();
  }

  // Hàm phân tích thành phần thành danh sách
  List<String> _parseIngredients(String text) {
    return text.split(';').map((s) => s.trim()).toList();
  }
}

// Placeholder cho trang Check-in
class CheckInPlaceholderScreen extends StatelessWidget {
  final DishModel dish;

  const CheckInPlaceholderScreen({super.key, required this.dish});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-in'),
        backgroundColor: const Color(0xFF00C853),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Trang Check-in cho món: ${dish.tenMon}',
              style: const TextStyle(
                fontFamily: 'Mulish',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Đây là placeholder. Bạn có thể phát triển chức năng check-in tại đây.',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C853),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'Quay lại',
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
