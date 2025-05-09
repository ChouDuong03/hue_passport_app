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
    final tienDoParts = progress.tienDo.split('/');
    final completed = int.parse(tienDoParts[0]);
    final total = int.parse(tienDoParts[1]);
    final milestones = _generateMilestones(total);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildContent(context, completed, total, milestones),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
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
                fontFamily: 'Mulish',
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          const Icon(Icons.more_vert, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, int completed, int total, List<int> milestones) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateRow(),
          const SizedBox(height: 16),
          _buildProgressRow(milestones, completed, total),
          const SizedBox(height: 16),
          _buildCheckInText(completed, total),
          if (progress.isFinished)
            _buildStatusMessage('Chúc mừng! Bạn đã hoàn thành chương trình!',
                Colors.green, Icons.check_circle),
          if (time.isExpired)
            _buildStatusMessage(
                'Chương trình đã hết hạn!', Colors.red, Icons.warning),
        ],
      ),
    );
  }

  Widget _buildDateRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.circle, color: Colors.orange, size: 10),
            const SizedBox(width: 4),
            Text(
              'Bắt đầu: ${DateFormat('dd/MM/yyyy').format(time.thoiGianThamGia)}',
              style: const TextStyle(
                  fontSize: 12, fontFamily: 'Mulish', color: Colors.orange),
            ),
          ],
        ),
        const Icon(Icons.arrow_forward, color: Colors.black54, size: 16),
        Row(
          children: [
            const Icon(Icons.circle, color: Colors.green, size: 10),
            const SizedBox(width: 4),
            Text(
              'Kết thúc: ${DateFormat('dd/MM/yyyy').format(time.thoiHanHoanThanh)}',
              style: const TextStyle(
                  fontSize: 12, fontFamily: 'Mulish', color: Colors.green),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressRow(List<int> milestones, int completed, int total) {
    return SizedBox(
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (milestones.length > 1)
            CustomPaint(
              painter: ProgressLinePainter(
                milestones: milestones,
                completed: completed,
              ),
              size: const Size(double.infinity, 60),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: milestones.map((milestone) {
              return _buildStepCircle(milestone, total, completed >= milestone);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckInText(int completed, int total) {
    return Container(
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
                  fontFamily: 'Mulish',
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
    );
  }

  Widget _buildStatusMessage(String message, Color color, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Mulish',
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<int> _generateMilestones(int total) {
    if (total <= 0) return [1];

    // Luôn có mốc 1 và mốc total
    List<int> milestones = [1];

    // Tùy vào total mà chèn thêm mốc ở giữa
    if (total > 2) {
      int middleCount = total >= 10 ? 2 : (total >= 5 ? 1 : 0);
      double step = (total - 1) / (middleCount + 1);
      for (int i = 1; i <= middleCount; i++) {
        milestones.add((1 + (i * step)).round());
      }
    }

    if (total != 1) {
      milestones.add(total);
    }

    // Đảm bảo không bị trùng mốc và sắp xếp đúng thứ tự
    return milestones.toSet().toList()..sort();
  }

  Widget _buildStepCircle(int current, int total, bool completed) {
    return Column(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: completed ? Colors.blue : Colors.grey[300],
          child: Text(
            current.toString(),
            style: const TextStyle(
              fontFamily: 'Mulish',
              color: Colors.white,
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
            color: completed ? Colors.blue : Colors.grey[400],
          ),
        ),
      ],
    );
  }
}

class ProgressLinePainter extends CustomPainter {
  final List<int> milestones;
  final int completed;

  ProgressLinePainter({required this.milestones, required this.completed});

  @override
  void paint(Canvas canvas, Size size) {
    if (milestones.length <= 1) return;

    final totalWidth = size.width;
    final lineY =
        size.height / 7; // Đặt đường thẳng ở giữa chữ số trong CircleAvatar

    // Tìm mốc đầu tiên chưa hoàn thành
    int firstUncompletedIndex = milestones.length - 1;
    for (int i = 0; i < milestones.length; i++) {
      if (completed < milestones[i]) {
        firstUncompletedIndex = i;
        break;
      }
    }

    // Tính điểm phân chia màu dựa trên tiến độ
    final progressRatio = firstUncompletedIndex / (milestones.length - 1);
    final splitX = progressRatio * totalWidth;

    // Vẽ đường thẳng duy nhất với hiệu ứng màu sắc
    final path = Path()
      ..moveTo(0, lineY) // Bắt đầu từ mốc đầu
      ..lineTo(totalWidth, lineY); // Kết thúc tại mốc cuối

    // Paint cho đoạn đã hoàn thành (màu xanh)
    final completedPaint = Paint()
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..color = Colors.blue;

    // Paint cho đoạn chưa hoàn thành (màu xám)
    final uncompletedPaint = Paint()
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..color = Colors.grey[300]!;

    // Vẽ toàn bộ đường thẳng với màu xám trước
    canvas.drawPath(path, uncompletedPaint);

    // Vẽ phần đã hoàn thành (màu xanh) từ đầu đến điểm phân chia
    if (firstUncompletedIndex > 0) {
      final completedPath = Path()
        ..moveTo(0, lineY)
        ..lineTo(splitX, lineY);
      canvas.drawPath(completedPath, completedPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
