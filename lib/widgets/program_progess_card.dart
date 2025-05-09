import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hue_passport_app/models/program_progess.dart';
import 'package:hue_passport_app/models/program_time.dart';

class ProgramProgressCard extends StatelessWidget {
  final String title;
  final ProgramProgress progress;
  final ProgramTime time;

  const ProgramProgressCard({
    super.key,
    required this.title,
    required this.progress,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    // Tách tienDo thành completed và total
    final tienDoParts = progress.tienDo.split('/');
    final completed = int.parse(tienDoParts[0]);
    final total = int.parse(tienDoParts[1]);

    // Tạo danh sách mốc động dựa trên total
    List<int> generateMilestones(int total) {
      if (total <= 0) return [1, 1]; // Tránh lỗi nếu total không hợp lệ

      int milestoneCount;
      if (total >= 10) {
        milestoneCount = 4; // 4 mốc nếu total >= 10
      } else if (total >= 5) {
        milestoneCount = 3; // 3 mốc nếu 5 <= total < 10
      } else {
        milestoneCount =
            total == 1 ? 1 : 2; // 1 mốc nếu total = 1, 2 mốc nếu total < 5
      }

      if (milestoneCount == 1) {
        return [1]; // Chỉ hiển thị mốc 1 nếu total = 1
      } else if (milestoneCount == 2) {
        return [1, total]; // Chỉ có mốc 1 và total
      }

      // Tính bước nhảy từ 1 đến total và làm tròn để tạo mốc đẹp hơn
      final baseStep = (total - 1) / (milestoneCount - 1);
      return List.generate(milestoneCount, (index) {
        final milestone = 1 + (index * baseStep).round(); // Làm tròn mốc
        return milestone > total
            ? total
            : milestone; // Đảm bảo không vượt quá total
      })
        ..last = total; // Đảm bảo mốc cuối là total
    }

    final milestones = generateMilestones(total);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Phần tiêu đề với nền màu lightBlue
          Container(
            decoration: const BoxDecoration(
              color: Colors.lightBlue,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Icon(Icons.more_vert, color: Colors.white),
              ],
            ),
          ),
          // Phần còn lại với nền màu trắng
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.circle,
                            color: Colors.orange, size: 10),
                        const SizedBox(width: 4),
                        Text(
                          'Bắt đầu: ${DateFormat('dd/MM/yyyy').format(time.thoiGianThamGia)}',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.orange),
                        ),
                      ],
                    ),
                    const Icon(Icons.arrow_forward,
                        color: Colors.black54, size: 16),
                    Row(
                      children: [
                        const Icon(Icons.circle, color: Colors.green, size: 10),
                        const SizedBox(width: 4),
                        Text(
                          'Kết thúc: ${DateFormat('dd/MM/yyyy').format(time.thoiHanHoanThanh)}',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.green),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Progress dots (Step circles) với đường nối
                Stack(
                  alignment: Alignment.center,
                  children: [
                    if (milestones.length >
                        1) // Chỉ vẽ đường thẳng nếu có nhiều hơn 1 mốc
                      Positioned(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            milestones.length - 1,
                            (index) => Expanded(
                              child: Container(
                                height: 2,
                                color: Colors
                                    .grey[300], // Đường thẳng màu xám nhạt
                              ),
                            ),
                          ),
                        ),
                      ),
                    // Các vòng tròn tiến độ
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: milestones.map((milestone) {
                        return _buildStepCircle(
                            milestone, total, completed >= milestone);
                      }).toList(),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Check-in text
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.amber[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text.rich(
                      TextSpan(
                        text: 'Bạn đã check in ',
                        children: [
                          TextSpan(
                            text: '$completed/$total',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          const TextSpan(text: ' món ăn'),
                        ],
                      ),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),

                // Status messages (Finished or Expired)
                if (progress.isFinished) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Chúc mừng! Bạn đã hoàn thành chương trình!',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (time.isExpired) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.warning,
                          color: Colors.red,
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Chương trình đã hết hạn!',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCircle(int current, int total, bool completed) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: completed ? Colors.blue : Colors.grey[300],
          child: Text(
            current.toString(),
            style: TextStyle(
              fontFamily: 'Mulish',
              color: completed ? Colors.white : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$current/$total\nmón',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 12,
            color: completed ? Colors.blue : Colors.grey[300],
          ),
        ),
      ],
    );
  }
}
