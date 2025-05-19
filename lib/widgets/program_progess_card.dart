import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hue_passport_app/models/program_progess.dart';
import 'package:hue_passport_app/models/program_time.dart';
import 'package:confetti/confetti.dart';
import 'package:intl/intl.dart';

class ProgramProgressCard extends StatefulWidget {
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
  _ProgramProgressCardState createState() => _ProgramProgressCardState();
}

class _ProgramProgressCardState extends State<ProgramProgressCard> {
  bool _hasShownPopup = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowCongratulationPopup();
    });
  }

  void _checkAndShowCongratulationPopup() {
    final tienDoParts = widget.progress.tienDo.split('/');
    final completed = int.parse(tienDoParts[0]);
    final total = int.parse(tienDoParts[1]);

    if (completed == total && widget.progress.isFinished && !_hasShownPopup) {
      setState(() {
        _hasShownPopup = true;
      });
      showCongratulationPopup(context, widget.title);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tienDoParts = widget.progress.tienDo.split('/');
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
              widget.title,
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
          if (widget.progress.isFinished)
            _buildStatusMessage('Chúc mừng! Bạn đã hoàn thành chương trình!',
                Colors.green, Icons.check_circle),
          if (widget.time.isExpired)
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
              'Bắt đầu: ${DateFormat('dd/MM/yyyy').format(widget.time.thoiGianThamGia)}',
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
              'Kết thúc: ${DateFormat('dd/MM/yyyy').format(widget.time.thoiHanHoanThanh)}',
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

    List<int> milestones = [1];

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
    final lineY = size.height / 7;

    int firstUncompletedIndex = milestones.length - 1;
    for (int i = 0; i < milestones.length; i++) {
      if (completed < milestones[i]) {
        firstUncompletedIndex = i;
        break;
      }
    }

    final progressRatio = firstUncompletedIndex / (milestones.length - 1);
    final splitX = progressRatio * totalWidth;

    final path = Path()
      ..moveTo(0, lineY)
      ..lineTo(totalWidth, lineY);

    final completedPaint = Paint()
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..color = Colors.blue;

    final uncompletedPaint = Paint()
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..color = Colors.grey[300]!;

    canvas.drawPath(path, uncompletedPaint);

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

// Định nghĩa CongratulationPopup (đã thu nhỏ)
class CongratulationPopup extends StatefulWidget {
  final String message;
  final VoidCallback onConfirm;
  final VoidCallback onDismiss;

  const CongratulationPopup({
    super.key,
    required this.message,
    required this.onConfirm,
    required this.onDismiss,
  });

  @override
  _CongratulationPopupState createState() => _CongratulationPopupState();
}

class _CongratulationPopupState extends State<CongratulationPopup> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Giảm độ cong để gọn hơn
      ),
      child: Container(
        padding: const EdgeInsets.all(12), // Giảm padding
        width: MediaQuery.of(context).size.width * 0.75, // Thu nhỏ chiều rộng
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            // Hiệu ứng confetti
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirection: 3.14 / 2,
                emissionFrequency: 0.05,
                numberOfParticles: 30, // Giảm số lượng hạt để gọn hơn
                gravity: 0.2,
                colors: const [
                  Colors.red,
                  Colors.blue,
                  Colors.yellow,
                  Colors.green,
                  Colors.purple,
                ],
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Banner "CHÚC MỪNG" nằm trên cùng
                Stack(
                  children: [
                    Container(
                      height: 50, // Giảm chiều cao banner
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/chucmung.png'),
                          fit: BoxFit.fitWidth,
                        ),
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(12)),
                      ),
                    ),
                    Positioned(
                      right: 4, // Giảm khoảng cách nút đóng
                      top: 4,
                      child: IconButton(
                        icon: const Icon(Icons.close,
                            color: Colors.white,
                            size: 20), // Giảm kích thước icon
                        onPressed: () => Get.back(),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Icon(Icons.star,
                              color: Colors.yellow,
                              size: 20), // Giảm kích thước sao
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 8),
                          child:
                              Icon(Icons.star, color: Colors.yellow, size: 20),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12), // Giảm khoảng cách
                // Hình ảnh hộp quà
                Image.asset(
                  'assets/images/present.png',
                  width: 60, // Thu nhỏ kích thước hộp quà
                  height: 60,
                ),
                const SizedBox(height: 12), // Giảm khoảng cách
                // Văn bản chúc mừng
                Text(
                  widget.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14, // Giảm kích thước chữ
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 4), // Giảm khoảng cách
                const Text(
                  'Bạn đã hoàn thành chương trình đề xuất thưởng.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12, // Giảm kích thước chữ
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 12), // Giảm khoảng cách
                // Hai nút "Xác nhận" và "Bỏ qua"
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: widget.onConfirm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6), // Giảm padding nút
                      ),
                      child: const Text('Xác nhận',
                          style: TextStyle(fontSize: 14, color: Colors.white)),
                    ),
                    TextButton(
                      onPressed: widget.onDismiss,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6), // Giảm padding nút
                      ),
                      child: const Text('Bỏ qua',
                          style: TextStyle(fontSize: 14, color: Colors.grey)),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void showCongratulationPopup(BuildContext context, String programTitle) {
  Get.dialog(
    CongratulationPopup(
      message:
          'Bạn đã check in đủ các món ăn trong chương trình "$programTitle".',
      onConfirm: () {
        Get.back();
        Get.snackbar('Thành công', 'Bạn đã xác nhận!');
      },
      onDismiss: () {
        Get.back();
      },
    ),
  );
}
