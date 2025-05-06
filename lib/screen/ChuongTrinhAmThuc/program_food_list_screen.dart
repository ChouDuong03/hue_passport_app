import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hue_passport_app/controller/program_food_controller.dart';
import 'package:hue_passport_app/widgets/program_card_widget.dart';

class ProgramListScreen extends StatelessWidget {
  final controller = Get.put(ProgramFoodController());
  final PageController _pageController = PageController();

  ProgramListScreen({super.key});

  // Dữ liệu giả cho danh sách người dùng check-in
  final List<Map<String, dynamic>> topCheckInUsers = [
    {
      'rank': 1,
      'name': 'Robert Downey Jr.',
      'location': 'Huế Food Tour',
      'avatar': 'assets/images/user1.png',
    },
    {
      'rank': 2,
      'name': 'Elliott McCoy',
      'location': 'Huế Food Tour',
      'avatar': 'assets/images/user2.png',
    },
    {
      'rank': 3,
      'name': 'Nathalie Laing',
      'location': 'Huế Food Tour',
      'avatar': 'assets/images/user3.png',
    },
    {
      'rank': 4,
      'name': 'Kofi Davila',
      'location': 'Huế Food Tour',
      'avatar': 'assets/images/user4.png',
    },
    {
      'rank': 5,
      'name': 'Manikandan Jonoka',
      'location': 'Huế Food Tour',
      'avatar': 'assets/images/user5.png',
    },
  ];

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
              height: 250,
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
                          height:
                              500, // Chiều cao tối thiểu để chứa ProgramCardWidget
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: controller.programs.length,
                            itemBuilder: (context, index) {
                              final program = controller.programs[index];
                              return ProgramCardWidget(program: program);
                            },
                          ),
                        );
                      }),

                      // Phần "Top người dùng check-in được đặt ở đây"
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Top người dùng check-in được đặt ở đây',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 80,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: topCheckInUsers.length,
                                itemBuilder: (context, index) {
                                  final user = topCheckInUsers[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: Row(
                                      children: [
                                        Text(
                                          '${user['rank']}.',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundImage:
                                              AssetImage(user['avatar']),
                                        ),
                                        const SizedBox(width: 8),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              user['name'],
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              user['location'],
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
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
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ListView.builder(
                              shrinkWrap:
                                  true, // Để ListView không chiếm toàn bộ không gian
                              physics:
                                  const NeverScrollableScrollPhysics(), // Tắt cuộn trong ListView
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
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              '${tour['location']} • kinh nghiệm: ${tour['checkIns']}',
                                              style: const TextStyle(
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

                      const SizedBox(height: 20), // Khoảng cách dưới cùng
                    ],
                  ),
                ),
              ],
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
