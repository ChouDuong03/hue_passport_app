import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hue_passport_app/controller/program_food_controller.dart';
import 'package:hue_passport_app/widgets/program_card_widget.dart';
import 'package:hue_passport_app/screen/ChuongTrinhAmThuc/dish_list_screen.dart';

class ProgramListScreen extends StatelessWidget {
  final controller = Get.put(ProgramFoodController());
  final PageController _pageController = PageController();
  final baseUrl = "https://localhost:51512";
  ProgramListScreen({super.key});

  // Dữ liệu giả cho danh sách chương trình ẩm thực
  final List<Map<String, dynamic>> foodTours = [
    {
      'rank': 1,
      'name': 'Lê Phước Lương',
      'location': 'Huế Food Tour',
      'checkIns': 20,
    },
    {
      'rank': 2,
      'name': 'Nguyễn Ngọc Đông',
      'location': 'Huế Food Tour',
      'checkIns': 19,
    },
    {
      'rank': 3,
      'name': 'Jack Jinson',
      'location': 'Huế Food Tour',
      'checkIns': 19,
    },
    {
      'rank': 4,
      'name': 'Kofi Davila',
      'location': 'Huế Food Tour',
      'checkIns': 18,
    },
    {
      'rank': 5,
      'name': 'Nakita Michiko',
      'location': 'Huế Food Tour',
      'checkIns': 17,
    },
  ];

  @override
  Widget build(BuildContext context) {
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

                      // Phần "Top người dùng check-in được đặt ở đây" (hàng dọc)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Top người dùng check-in được đặt ở đây',
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
                                          backgroundImage: NetworkImage(
                                              "$baseUrl/${user.anhDaiDien}"),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                user.hoTen, // Hiển thị tên quán
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Text(
                                                user.tenQuan, // Giả định địa điểm
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

                      // Phần "Huế Food Tour: Trải nghiệm Ẩm thực Huế 1 ngày"
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Huế Food Tour: Trải nghiệm Ẩm thực Huế 1 ngày',
                              style: TextStyle(
                                fontFamily: 'Mulish',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: foodTours.length,
                              itemBuilder: (context, index) {
                                final tour = foodTours[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    children: [
                                      Text(
                                        '${tour['rank']}.',
                                        style: const TextStyle(
                                          fontFamily: 'Mulish',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              tour['name'],
                                              style: const TextStyle(
                                                fontFamily: 'Mulish',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              '${tour['location']} • kinh nghiệm: ${tour['checkIns']}',
                                              style: const TextStyle(
                                                fontFamily: 'Mulish',
                                                color: Colors.grey,
                                                fontSize: 12,
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
                            ),
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
                    // Thêm hành động khi nhấn nút (ví dụ: điều hướng đến màn hình chi tiết)
                    final currentIndex = _pageController.page?.round() ?? 0;
                    if (controller.programs.isNotEmpty) {
                      final chuongTrinhID =
                          controller.programs[currentIndex].chuongTrinhID;
                      Get.to(
                          () => DishListScreen(chuongTrinhID: chuongTrinhID));
                    } // Ví dụ: điều hướng đến màn hình chi tiết
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C853), // Màu xanh lục
                    foregroundColor: Colors.white, // Màu chữ trắng
                    minimumSize: const Size(double.infinity,
                        50), // Chiều rộng toàn màn hình, chiều cao 50
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25), // Bo góc
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
            // Avatar + tiêu đề nằm trên ảnh nền
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
                  SizedBox(width: 40), // Để cân layout
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
