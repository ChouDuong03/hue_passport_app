import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hue_passport_app/controller/nav_controller.dart';
import 'package:hue_passport_app/controller/program_food_controller.dart';
import 'package:hue_passport_app/models/experiencestat_model.dart';
import 'package:hue_passport_app/services/program_food_api_service.dart';
import 'package:hue_passport_app/widgets/program_card_widget.dart';
import 'package:hue_passport_app/screen/ChuongTrinhAmThuc/dish_list_screen.dart';

class ProgramListScreen extends StatelessWidget {
  final controller = Get.put(ProgramFoodController());
  final navController = Get.find<NavController>();
  final PageController _pageController = PageController();

  ProgramListScreen({super.key});

  // Hàm hiển thị dialog chọn chương trình
  void _showProgramSelectionDialog(
      BuildContext context, RxInt selectedChuongTrinhID) {
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
                      Get.back(); // Đóng dialog
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
    // Biến để lưu chuongTrinhID được chọn, mặc định là chương trình đầu tiên
    final selectedChuongTrinhID = 1.obs; // Bắt đầu với ID 1

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
                const SizedBox(height: 90), // để tránh che mất avatar + tiêu đề
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
                              // Cập nhật chuongTrinhID hiện tại lên NavController
                              final id =
                                  controller.programs[index].chuongTrinhID;
                              navController.updateChuongTrinhID(id);
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

                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Top du khách check in gần đây',
                              style: TextStyle(
                                fontFamily: 'Mulish',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Obx(() {
                              if (controller.isLoadingTopUsers.value) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              if (controller.topCheckInUsers.isEmpty) {
                                return const Center(
                                    child:
                                        Text('Không có dữ liệu top check-in.'));
                              }

                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller.topCheckInUsers.length > 5
                                    ? 5
                                    : controller.topCheckInUsers.length,
                                itemBuilder: (context, index) {
                                  final user =
                                      controller.topCheckInUsers[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      children: [
                                        Text(
                                          '${index + 1}.',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        CircleAvatar(
                                          radius: 12,
                                          backgroundImage:
                                              NetworkImage(user.anhDaiDien),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                user.hoTen,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Text(
                                                user.tenQuan,
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }),
                          ],
                        ),
                      ),

                      // Phần hiển thị thống kê điểm kinh nghiệm
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Thống kê điểm kinh nghiệm',
                                  style: TextStyle(
                                    fontFamily: 'Mulish',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => _showProgramSelectionDialog(
                                      context, selectedChuongTrinhID),
                                  child: const Text(
                                    'Chọn chương trình',
                                    style: TextStyle(
                                      fontFamily: 'Mulish',
                                      color: Colors.blue,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Obx(() {
                              return FutureBuilder<List<ExperienceStatsModel>>(
                                future: ProgramFoodApiService()
                                    .fetchExperienceStats(
                                        selectedChuongTrinhID.value),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                  if (snapshot.hasError) {
                                    return const Text(
                                        'Không thể tải thống kê điểm kinh nghiệm.');
                                  }
                                  if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return const Text(
                                        'Không có dữ liệu điểm kinh nghiệm.');
                                  }

                                  final stats = snapshot.data!;
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: stats.length,
                                    itemBuilder: (context, index) {
                                      final stat = stats[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: Row(
                                          children: [
                                            Text(
                                              '${index + 1}.',
                                              style: const TextStyle(
                                                fontFamily: 'Mulish',
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            CircleAvatar(
                                              radius: 12,
                                              backgroundImage:
                                                  NetworkImage(stat.anhDaiDien),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    stat.hoTen,
                                                    style: const TextStyle(
                                                      fontFamily: 'Mulish',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Kinh nghiệm: ${stat.diemKinhNghiem}',
                                                    style: const TextStyle(
                                                      fontFamily: 'Mulish',
                                                      color: Colors.red,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Icon(Icons.arrow_forward_ios,
                                                size: 16, color: Colors.grey),
                                          ],
                                        ),
                                      );
                                    },
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
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final currentIndex = _pageController.page?.round() ?? 0;
                    if (controller.programs.isNotEmpty) {
                      final chuongTrinhID =
                          controller.programs[currentIndex].chuongTrinhID;
                      Get.to(
                          () => DishListScreen(chuongTrinhID: chuongTrinhID));
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
            const Positioned(
              top: 30,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/images/useravatar.png'),
                  ),
                  Text(
                    'Ẩm thực',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
