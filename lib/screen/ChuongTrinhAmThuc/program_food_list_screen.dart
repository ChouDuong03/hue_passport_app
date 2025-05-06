import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hue_passport_app/controller/program_food_controller.dart';
import 'package:hue_passport_app/screen/ChuongTrinhAmThuc/program_food_detail_screen.dart';

class ProgramListScreen extends StatelessWidget {
  final controller = Get.put(ProgramFoodController());
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.programs.isEmpty) {
          return const Center(child: Text('Không có chương trình nào.'));
        }

        return PageView.builder(
          controller: _pageController,
          onPageChanged: (index) async {
            final id = controller.programs[index].chuongTrinhID;
            if (!controller.programDetailsCache.containsKey(id)) {
              await controller.fetchProgramDetail(id);
            }

            // Preload chương trình tiếp theo
            if (index + 1 < controller.programs.length) {
              final nextId = controller.programs[index + 1].chuongTrinhID;
              if (!controller.programDetailsCache.containsKey(nextId)) {
                controller.fetchProgramDetail(nextId);
              }
            }
          },
          itemCount: controller.programs.length,
          itemBuilder: (context, index) {
            final program = controller.programs[index];

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCustomHeader(program.anhDaiDien),

                    const SizedBox(height: 24),

                    // Thông tin ngắn
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            color: Colors.red, size: 18),
                        Text('${program.soLuongMonAn} Món ăn  ',
                            style: const TextStyle(color: Colors.red)),
                        const Icon(Icons.group, color: Colors.green, size: 18),
                        Text(
                          '  ${program.soNguoiThamGia.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} Tham gia',
                          style: const TextStyle(color: Colors.green),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Tên & mô tả
                    Text(
                      program.tenChuongTrinh,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),

                    Obx(() {
                      final isExpanded = controller.expandedProgramIds
                          .contains(program.chuongTrinhID);
                      final detail =
                          controller.programDetailsCache[program.chuongTrinhID];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isExpanded && detail != null
                                ? detail.details.first.gioiThieu
                                : detail?.details.first.gioiThieu
                                        .substring(0, 100) ??
                                    '...',
                            maxLines: isExpanded ? null : 3,
                            overflow: isExpanded
                                ? TextOverflow.visible
                                : TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          GestureDetector(
                            onTap: () async {
                              if (!isExpanded && detail == null) {
                                await controller
                                    .fetchProgramDetail(program.chuongTrinhID);
                              }

                              controller.toggleExpanded(program.chuongTrinhID);
                            },
                            child: Text(
                              isExpanded ? 'Thu gọn' : 'Xem thêm',
                              style: const TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 16),

                    const Text(
                      'Món ăn trong chương trình',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),

                    // Danh sách món ăn ngang
                    SizedBox(
                      height: 80,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: 4,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'assets/images/monan${index + 1}.png',
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Nút Xem chi tiết
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.to(() => ProgramDetailScreen(
                              programId: program.chuongTrinhID));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text('Xem chi tiết'),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildCustomHeader(String imageAsset) {
    return SizedBox(
      height: 260,
      child: Stack(
        children: [
          // Ảnh nền (sát với ảnh chương trình, không padding)
          Positioned.fill(
            child: Image.asset(
              'assets/images/border2.png',
              fit: BoxFit.cover,
            ),
          ),

          // Header thông tin (logo + chữ Ẩm thực)
          const Positioned(
            top: 10,
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
                    fontSize: 20,
                    fontFamily: 'Mulish',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 40),
              ],
            ),
          ),

          // Ảnh chương trình (nằm sát ảnh nền)
          Positioned(
            top: 60,
            left: 16,
            right: 16,
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage('assets/images/$imageAsset'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Nút "Tham gia trò chơi"
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text('Tham gia trò chơi'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
