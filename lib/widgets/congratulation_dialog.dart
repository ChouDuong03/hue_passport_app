import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:confetti/confetti.dart'; // Import thư viện confetti

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
  late ConfettiController
      _confettiController; // Khai báo controller cho confetti

  @override
  void initState() {
    super.initState();
    // Khởi tạo controller với thời gian phát confetti là 3 giây
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    // Tự động phát confetti khi popup xuất hiện
    _confettiController.play();
  }

  @override
  void dispose() {
    // Hủy controller khi widget bị hủy
    _confettiController.dispose();
    super.dispose();
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
        ),
        child: Stack(
          children: [
            // Hiệu ứng confetti
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirection: 3.14 / 2, // Hướng rơi (rơi từ trên xuống)
                emissionFrequency: 0.05, // Tần suất phát hạt
                numberOfParticles: 50, // Số lượng hạt
                gravity: 0.2, // Trọng lực (tốc độ rơi)
                colors: const [
                  Colors.red,
                  Colors.blue,
                  Colors.yellow,
                  Colors.green,
                  Colors.purple,
                ], // Màu sắc của confetti
                blastDirectionality:
                    BlastDirectionality.explosive, // Hạt phát ra mọi hướng
                shouldLoop: false, // Không lặp lại hiệu ứng
              ),
            ),
            // Nội dung chính của popup
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Banner "CHÚC MỪNG" (dùng hình ảnh PNG)
                Stack(
                  children: [
                    Container(
                      height: 50,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      child: Image.asset(
                        'assets/images/chucmung.png',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Get.back(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Hộp quà
                Image.asset(
                  'assets/images/present.png', // Thay bằng asset hộp quà của bạn
                  width: 80,
                  height: 80,
                ),
                const SizedBox(height: 16),
                // Văn bản chúc mừng
                Text(
                  'Bạn đã check in đủ các món ăn trong chương trình "Đến đơm món bánh Huế".',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue[900],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Bạn đã hoàn thành chương trình đề xuất thưởng.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Xem danh sách địa điểm thưởng.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(height: 16),
                // Hai nút "Xác nhận" và "Bỏ qua"
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: widget.onConfirm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Xác nhận',
                          style: TextStyle(color: Colors.white)),
                    ),
                    TextButton(
                      onPressed: widget.onDismiss,
                      child: const Text('Bỏ qua',
                          style: TextStyle(color: Colors.grey)),
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

// Cách sử dụng popup
void showCongratulationPopup(BuildContext context) {
  Get.dialog(
    CongratulationPopup(
      message:
          'Bạn đã check in đủ các món ăn trong chương trình "Đến đơm món bánh Huế".',
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
