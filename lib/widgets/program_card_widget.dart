import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hue_passport_app/controller/program_food_controller.dart';
import 'package:hue_passport_app/models/program_food_model.dart';
import 'package:hue_passport_app/screen/ChuongTrinhAmThuc/dish_list_screen.dart';
import 'package:hue_passport_app/services/program_food_api_service.dart';

class ProgramCardWidget extends StatelessWidget {
  final ProgramFoodModel program;
  final int currentPage;
  final int totalPages;
  final controller = Get.find<ProgramFoodController>();

  final ProgramFoodApiService apiService = ProgramFoodApiService();

  ProgramCardWidget({
    super.key,
    required this.program,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    // Gọi API để lấy danh sách món ăn khi widget được xây dựng
    controller.fetchDishesByProgram(program.chuongTrinhID);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection('https://localhost:53963${program.anhDaiDien}'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.red, size: 18),
                    Text(
                      '${program.soLuongMonAn} Món ăn',
                      style: const TextStyle(
                        color: Colors.red,
                        fontFamily: 'Mulish',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.group, color: Colors.green, size: 18),
                    Text(
                      '  ${program.soNguoiThamGia.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} Tham gia',
                      style: const TextStyle(
                        color: Colors.green,
                        fontFamily: 'Mulish',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              program.tenChuongTrinh,
              style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'Mulish',
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Obx(() {
              final isExpanded =
                  controller.expandedProgramIds.contains(program.chuongTrinhID);
              final detail =
                  controller.programDetailsCache[program.chuongTrinhID];
              final description = detail?.details.first.gioiThieu ?? '';

              if (!isExpanded && detail == null && description.isEmpty) {
                controller.fetchProgramDetail(program.chuongTrinhID);
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isExpanded || description.length <= 120
                        ? description
                        : '${description.substring(0, 120)}...',
                    style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Mulish',
                        color: Colors.black87),
                  ),
                  if (description.length > 120) ...[
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () {
                        controller.toggleExpanded(program.chuongTrinhID);
                      },
                      child: Text(
                        isExpanded ? 'Thu gọn' : 'Xem thêm',
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ],
              );
            }),
            const SizedBox(height: 16),
            const Text(
              'Món ăn trong chương trình',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Mulish',
                  fontSize: 16),
            ),
            const SizedBox(height: 8),
            Obx(() {
              final dishes =
                  controller.dishesCache[program.chuongTrinhID] ?? [];
              if (controller.isLoadingDishes.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (dishes.isEmpty) {
                return const Center(child: Text('Không có món ăn nào.'));
              }

              return SizedBox(
                height: 80,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: dishes.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final dish = dishes[index];
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        'https://localhost:53963${dish.anhDaiDien}',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey,
                            child: const Center(
                              child: Text(
                                'Error',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(String imageAsset) {
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageAsset,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(totalPages, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == currentPage ? Colors.blue : Colors.grey,
                    ),
                  );
                }),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () async {
                  // Thêm hành động khi nhấn nút (ví dụ: điều hướng đến màn hình chi tiết)

                  if (controller.programs.isNotEmpty) {
                    final chuongTrinhID =
                        controller.programs[currentPage].chuongTrinhID;
                    final programTime =
                        await apiService.fetchProgramTime(chuongTrinhID);
                    Get.to(() => DishListScreen(
                          chuongTrinhID: chuongTrinhID,
                          time: programTime,
                        ));
                  } // Ví dụ: điều hướng đến màn hình chi tiết
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'Tham gia trò chơi',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Mulish',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
