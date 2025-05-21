import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hue_passport_app/models/program_progess.dart';
import 'package:hue_passport_app/models/program_time.dart';
import 'package:hue_passport_app/services/program_food_api_service.dart';
import 'package:intl/intl.dart';

class ProgramProgressCard extends StatefulWidget {
  final String title;
  final ProgramProgress progress;
  final ProgramTime time;
  final int chuongTrinhID; // chuongTrinhID là int

  const ProgramProgressCard({
    super.key,
    required this.title,
    required this.progress,
    required this.time,
    required this.chuongTrinhID,
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
      showCongratulationPopup(context, widget.title, widget.chuongTrinhID);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tienDoParts = widget.progress.tienDo.split('/');
    final completed = int.parse(tienDoParts[0]);
    final total = int.parse(tienDoParts[1]);
    final milestones = _generateMilestones(widget.progress.listMocHanhTrinh);

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
            _buildStatusMessage(
              'Chúc mừng! Bạn đã hoàn thành chương trình!',
              Colors.green,
              Icons.check_circle,
            ),
          if (widget.time.isExpired)
            _buildStatusMessage(
              'Chương trình đã quá hạn',
              Colors.red,
              Icons.warning,
            ),
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
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Mulish',
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<int> _generateMilestones(List<int> listMocHanhTrinh) {
    if (listMocHanhTrinh == null || listMocHanhTrinh.isEmpty) {
      int total = int.parse(widget.progress.tienDo.split('/')[1]);
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
    } else {
      return listMocHanhTrinh.toSet().toList()..sort();
    }
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

class CongratulationPopup extends StatefulWidget {
  final String message;
  final int chuongTrinhID; // Đổi từ String sang int
  final ProgramFoodApiService apiService;

  const CongratulationPopup({
    super.key,
    required this.message,
    required this.chuongTrinhID,
    required this.apiService,
  });

  @override
  _CongratulationPopupState createState() => _CongratulationPopupState();
}

class _CongratulationPopupState extends State<CongratulationPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _checkConfirmationStatus();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkConfirmationStatus() async {
    try {
      final isConfirmed =
          await widget.apiService.checkConfirmationStatus(widget.chuongTrinhID);
      if (isConfirmed) {
        Get.back();
      }
    } catch (e) {
      print('Error checking confirmation status: $e');
    }
  }

  Future<void> _confirmReward() async {
    setState(() => _isLoading = true);
    try {
      final result =
          await widget.apiService.confirmReward(widget.chuongTrinhID);
      if (result['isSuccessed']) {
        Get.back();
        Get.snackbar('Thành công', 'Bạn đã nhận thưởng!',
            snackPosition: SnackPosition.TOP);
      } else {
        Get.snackbar('Lỗi',
            result['message'] ?? 'Không thể nhận thưởng. Vui lòng thử lại!',
            snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Đã có lỗi xảy ra. Vui lòng thử lại!',
          snackPosition: SnackPosition.TOP);
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.blue, Colors.lightBlueAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'CHÚC MỪNG',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Mulish',
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: IconButton(
                    icon:
                        const Icon(Icons.close, color: Colors.white, size: 20),
                    onPressed: () => Get.back(),
                  ),
                ),
                const SizedBox(height: 16),
                AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Image.asset(
                        'assets/images/present.png',
                        width: 80,
                        height: 80,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  widget.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                    fontFamily: 'Mulish',
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Bạn đã hoàn thành chương trình đề xuất thưởng!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green,
                    fontFamily: 'Mulish',
                  ),
                ),
                const SizedBox(height: 16),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: _isLoading ? null : _confirmReward,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ).copyWith(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                        overlayColor: MaterialStateProperty.all(
                            Colors.green.withOpacity(0.2)),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.green, Colors.lightGreen],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              child: const Text(
                                'Xác nhận',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Mulish',
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _isLoading ? null : () => Get.back(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Colors.grey, width: 1),
                        ),
                      ),
                      child: const Text(
                        'Bỏ qua',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontFamily: 'Mulish',
                        ),
                      ),
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

Future<void> showCongratulationPopup(
    BuildContext context, String programTitle, int chuongTrinhID) async {
  final apiService = ProgramFoodApiService();
  try {
    final isConfirmed = await apiService.checkConfirmationStatus(chuongTrinhID);
    if (!isConfirmed) {
      Get.dialog(
        CongratulationPopup(
          message:
              'Bạn đã check in đủ các món ăn trong chương trình "$programTitle".',
          chuongTrinhID: chuongTrinhID,
          apiService: apiService,
        ),
      );
    }
  } catch (e) {
    print('Error checking confirmation status: $e');
  }
}
