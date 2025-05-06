import 'package:flutter/material.dart';

import 'package:hue_passport_app/models/program_food_model.dart';

class ProgramCardWidget extends StatelessWidget {
  final ProgramFoodModel program;
  final VoidCallback onTapDetail;
  final VoidCallback onToggleExpand;
  final bool isExpanded;
  final String? description;

  const ProgramCardWidget({
    super.key,
    required this.program,
    required this.onTapDetail,
    required this.onToggleExpand,
    required this.isExpanded,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tên chương trình
            Text(
              program.tenChuongTrinh,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Mô tả
            Text(
              isExpanded
                  ? (description ?? '')
                  : (description?.substring(0, 100) ?? ''),
              maxLines: isExpanded ? null : 3,
              overflow:
                  isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),

            GestureDetector(
              onTap: onToggleExpand,
              child: Text(
                isExpanded ? 'Thu gọn' : 'Xem thêm',
                style: const TextStyle(color: Colors.blue),
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.red, size: 18),
                Text('${program.soLuongMonAn} Món ăn  ',
                    style: const TextStyle(color: Colors.red)),
                const Icon(Icons.group, color: Colors.green, size: 18),
                Text(
                  '  ${program.soNguoiThamGia.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} Tham gia',
                  style: const TextStyle(color: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: onTapDetail,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('Xem chi tiết'),
            ),
          ],
        ),
      ),
    );
  }
}
