import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hue_passport_app/controller/program_food_controller.dart';
import 'package:hue_passport_app/models/program_food_model.dart';

class ProgramCardWidget extends StatelessWidget {
  final ProgramFoodModel program;
  final controller = Get.find<ProgramFoodController>();

  ProgramCardWidget({super.key, required this.program});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header image section with "Tham gia trò chơi" button
            _buildImageSection(program.anhDaiDien),

            const SizedBox(height: 12),

            // Quick info: number of dishes and participants
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.red, size: 18),
                Text(
                  '${program.soLuongMonAn} Món ăn',
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.group, color: Colors.green, size: 18),
                Text(
                  '  ${program.soNguoiThamGia.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} Tham gia',
                  style: const TextStyle(color: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Program title
            Text(
              program.tenChuongTrinh,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),

            // Description with "Xem thêm" toggle
            Obx(() {
              final isExpanded =
                  controller.expandedProgramIds.contains(program.chuongTrinhID);
              final detail =
                  controller.programDetailsCache[program.chuongTrinhID];
              final description = detail?.details.first.gioiThieu ?? '';

              // Ensure description is fetched if not expanded and detail is null
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
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
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

            // Section: Dishes in the program
            const Text(
              'Món ăn trong chương trình',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),

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
            child: Image.asset(
              'assets/images/$imageAsset',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 10,
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
                child: const Text(
                  'Tham gia trò chơi',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
