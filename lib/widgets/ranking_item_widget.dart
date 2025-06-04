import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hue_passport_app/controller/program_food_controller.dart';
import 'package:hue_passport_app/models/ranking_model.dart';

class RankingItemWidget extends StatelessWidget {
  final RankingModel user;
  final int index;

  const RankingItemWidget({super.key, required this.user, required this.index});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProgramFoodController>();
    final isExpanded = controller.expandedMaHoChieu.contains(user.maHoChieu);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 2,
      child: InkWell(
        onTap: () => controller.toggleExpandedMHC(user.maHoChieu),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Collapsed View
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Rank
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index < 3
                          ? (index == 0
                              ? Colors.amber
                              : index == 1
                                  ? Colors.grey.shade400
                                  : Colors.brown.shade300)
                          : Colors.grey.shade300,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: index < 3 ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Avatar
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: user.anhDaiDien != null
                        ? NetworkImage(
                            'https://hochieudulichv2.huecit.com${user.anhDaiDien}')
                        : const AssetImage('assets/images/useravatar.png')
                            as ImageProvider,
                    backgroundColor: Colors.grey.shade200,
                    onBackgroundImageError: (exception, stackTrace) {
                      print('Error loading avatar: $exception');
                    },
                  ),
                  const SizedBox(width: 12),
                  // User Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.hoTen,
                          style: const TextStyle(
                            fontFamily: 'Mulish',
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, size: 16, color: Colors.red),
                            Text(
                              '${user.diemKinhNghiem} điểm',
                              style: const TextStyle(
                                fontFamily: 'Mulish',
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Row(
                              children: [
                                const Icon(Icons.fastfood,
                                    size: 16, color: Colors.yellow),
                                Text(
                                  ' ${user.tongSoMonAnCheckIn} món',
                                  style: const TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Expand/Collapse Indicator
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            // Expanded View
            if (isExpanded)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Món ăn đã check-in: ${user.tongSoMonAnCheckIn} món',
                      style: const TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Thời gian hoàn thành: ${user.thoiGianHoanThanh} ngày',
                      style: const TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Quốc tịch: ${user.quocTich}',
                      style: const TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Điểm kinh nghiệm: ${user.diemKinhNghiem} điểm',
                      style: const TextStyle(
                        fontFamily: 'Mulish',
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
