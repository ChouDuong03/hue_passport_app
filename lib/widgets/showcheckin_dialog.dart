import 'package:flutter/material.dart';

void showCheckinSuccessDialog(BuildContext context) {
  final TextEditingController reviewController = TextEditingController();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/success2.png',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 12),
            const Text(
              "Bạn đã check-in thành công",
              style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF05D48A),
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: reviewController,
              decoration: InputDecoration(
                hintText: "Bạn có thể gửi đánh giá về quán ăn này...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Gửi review ở đây nếu cần
                    Navigator.of(context).pop(); // đóng dialog
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor:
                        const Color(0xFF05D48A), // Màu chữ (màu trắng)
                  ),
                  child: const Text("Gửi Review"),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Gửi review ở đây nếu cần
                    Navigator.of(context).pop(); // đóng dialog
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.grey, // Màu chữ
                    backgroundColor: Colors.white, // Màu nền
                    side: const BorderSide(
                      color: Colors.grey, // Màu viền
                      width: 2, // Độ rộng viền
                    ),
                  ),
                  child: const Text("Bỏ qua"),
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}
