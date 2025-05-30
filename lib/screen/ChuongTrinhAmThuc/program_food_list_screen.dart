import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hue_passport_app/controller/nav_controller.dart';
import 'package:hue_passport_app/controller/program_food_controller.dart';
import 'package:hue_passport_app/screen/setting/profile_screen.dart';
import 'package:hue_passport_app/services/program_food_api_service.dart';
import 'package:hue_passport_app/widgets/program_card_widget.dart';
import 'package:hue_passport_app/screen/ChuongTrinhAmThuc/dish_list_screen.dart';
import 'package:hue_passport_app/widgets/ranking_item_widget.dart'; // Add this import

class ProgramListScreen extends StatelessWidget {
  final controller = Get.put(ProgramFoodController());
  final navController = Get.find<NavController>();
  final PageController _pageController = PageController();

  final ProgramFoodApiService apiService = ProgramFoodApiService();

  ProgramListScreen({super.key});

  // Hàm hiển thị dialog chọn chương trình
  void _showProgramSelectionDialog(BuildContext context,
      RxInt selectedChuongTrinhID, RxString selectedProgramName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Chọn chương trình',
            style: TextStyle(
              fontFamily: 'Mulish',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.programs.isEmpty) {
              return const Text('Không có chương trình nào.');
            }

            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: controller.programs.map((program) {
                  return ListTile(
                    title: Text(
                      program.tenChuongTrinh,
                      style: const TextStyle(fontFamily: 'Mulish'),
                    ),
                    onTap: () {
                      selectedChuongTrinhID.value = program.chuongTrinhID;
                      selectedProgramName.value = program.tenChuongTrinh;
                      controller.updateSelectedProgram(program.chuongTrinhID);
                      Get.back();
                    },
                  );
                }).toList(),
              ),
            );
          }),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text(
                'Hủy',
                style: TextStyle(fontFamily: 'Mulish', color: Colors.grey),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedChuongTrinhID =
        0.obs; // Start with 0, will be updated dynamically
    final selectedProgramName = ''.obs;

    // Sync with controller's selectedChuongTrinhID
    ever(controller.selectedChuongTrinhID, (id) {
      selectedChuongTrinhID.value = id;
      final program =
          controller.programs.firstWhere((p) => p.chuongTrinhID == id);
      final initialProgram = controller.programs.firstWhere(
        (program) => program.chuongTrinhID == selectedChuongTrinhID.value,
      );
      selectedProgramName.value = program.tenChuongTrinh;
    });

    // Initial sync
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.programs.isNotEmpty &&
          controller.selectedChuongTrinhID.value == 0) {
        controller
            .updateSelectedProgram(controller.programs.first.chuongTrinhID);
      }
    });

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Ảnh nền phía sau (border2)
            Container(
              height: 100,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/border2.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Nội dung chính
            Column(
              children: [
                const SizedBox(height: 90),
                Container(
                  padding: const EdgeInsets.only(top: 12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFDF6FC),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Column(
                    children: [
                      // Phần PageView.builder (Chương trình chính)
                      Obx(() {
                        if (controller.isLoading.value) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (controller.programs.isEmpty) {
                          return const Center(
                              child: Text('Không có chương trình nào.'));
                        }

                        return SizedBox(
                          height: 500,
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: controller.programs.length,
                            onPageChanged: (index) {
                              final id =
                                  controller.programs[index].chuongTrinhID;
                              navController.updateChuongTrinhID(id);
                              controller.updateSelectedProgram(id);
                            },
                            itemBuilder: (context, index) {
                              final program = controller.programs[index];
                              return ProgramCardWidget(
                                program: program,
                                currentPage: index,
                                totalPages: controller.programs.length,
                              );
                            },
                          ),
                        );
                      }),

                      // Phần hiển thị bảng xếp hạng
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(() => Flexible(
                                      child: Text(
                                        selectedProgramName.value,
                                        style: const TextStyle(
                                          fontFamily: 'Mulish',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )),
                                TextButton(
                                  onPressed: () => _showProgramSelectionDialog(
                                      context,
                                      selectedChuongTrinhID,
                                      selectedProgramName),
                                  child: const Icon(
                                    Icons.more_vert,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Obx(() {
                              if (controller.isLoadingRankings.value) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              if (controller.rankings.isEmpty) {
                                return const Center(
                                    child: Text('Không có dữ liệu xếp hạng.'));
                              }

                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller.rankings.length > 10
                                    ? 10
                                    : controller
                                        .rankings.length, // Limit to top 10
                                itemBuilder: (context, index) {
                                  final user = controller.rankings[index];
                                  return RankingItemWidget(
                                    user: user,
                                    index: index,
                                  );
                                },
                              );
                            }),
                          ],
                        ),
                      ),

                      const SizedBox(height: 60), // Khoảng cách dưới cùng
                    ],
                  ),
                ),
              ],
            ),

            // Nút "Xem chi tiết"
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final currentIndex = _pageController.page?.round() ?? 0;
                    if (controller.programs.isNotEmpty) {
                      final chuongTrinhID =
                          controller.programs[currentIndex].chuongTrinhID;
                      try {
                        // Gọi API fetchProgramTime từ ProgramFoodApiService
                        final programTime =
                            await apiService.fetchProgramTime(chuongTrinhID);
                        // Điều hướng đến DishListScreen với chuongTrinhID và time
                        Get.to(() => DishListScreen(
                              chuongTrinhID: chuongTrinhID,
                              time: programTime,
                            ));
                      } catch (e) {
                        // Xử lý lỗi khi gọi API thất bại
                        Get.snackbar(
                            'Lỗi', 'Không thể lấy dữ liệu thời gian: $e');
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C853),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Xem chi tiết',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            // Header với avatar và tiêu đề
            Positioned(
              top: 30,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(
                          () => ProfileScreen()); // Navigate to ProfileScreen
                    },
                    child: const CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          AssetImage('assets/images/useravatar.png'),
                    ),
                  ),
                  const Text(
                    'Ẩm thực',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
