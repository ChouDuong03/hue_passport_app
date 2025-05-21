import 'package:flutter/material.dart';
import 'package:hue_passport_app/services/program_food_api_service.dart';
import 'package:hue_passport_app/models/review_model.dart';

void showCheckinSuccessDialog(
  BuildContext context, {
  required int chuongTrinhId,
  required int quanAnId,
  required int monAnId,
  required int ngonNguId,
}) {
  final TextEditingController reviewController = TextEditingController();
  final ProgramFoodApiService apiService = ProgramFoodApiService();

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
                  onPressed: () async {
                    if (reviewController.text.isNotEmpty) {
                      final review = ReviewModel(
                        chuongTrinhID: chuongTrinhId,
                        quanAnID: quanAnId,
                        monAnID: monAnId,
                        ngonNguID: ngonNguId,
                        noiDungDanhGia: reviewController.text,
                      );
                      final success =
                          await apiService.postReviewDiaDiem(review);
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Gửi đánh giá thành công!'),
                            backgroundColor: Color(0xFF05D48A),
                          ),
                        );
                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Gửi đánh giá thất bại!'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Vui lòng nhập đánh giá!'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF05D48A),
                  ),
                  child: const Text("Gửi Review"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.grey,
                    backgroundColor: Colors.white,
                    side: const BorderSide(
                      color: Colors.grey,
                      width: 2,
                    ),
                  ),
                  child: const Text("Bỏ qua"),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
