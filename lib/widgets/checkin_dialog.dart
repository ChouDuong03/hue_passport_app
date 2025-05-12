import 'package:flutter/material.dart';
import 'package:hue_passport_app/services/api_checkin_food_service.dart';
import 'package:hue_passport_app/widgets/showcheckin_dialog.dart';

void showCheckinDialog(
  BuildContext context, {
  required int monAnId,
  required int chuongTrinhId,
  required double viDo,
  required double kinhDo,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Phần ảnh (có thể thay bằng Carousel/List ảnh thực tế)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child:
                    Image.asset('assets/images/camerafood.png'), // ảnh minh họa
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  // xử lý thêm ảnh
                },
                icon: Icon(Icons.add),
                label: Text("Thêm ảnh"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade100,
                  foregroundColor: Colors.blue,
                ),
              ),
              const SizedBox(height: 8),
              const Text("Bạn chỉ có thể thêm tối đa được 5 ảnh"),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity, // full width của dialog
                child: ElevatedButton(
                  onPressed: () async {
                    final result =
                        await ApiCheckinFoodService.postCheckinMultipart(
                      monAnId: monAnId,
                      chuongTrinhId: chuongTrinhId,
                      viDo: viDo,
                      kinhDo: kinhDo,
                    );

                    Navigator.of(context).pop(); // đóng dialog này

                    if (result.success) {
                      showCheckinSuccessDialog(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Check-in thất bại')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: const Color(0xFF05D48A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    "Hoàn thành",
                    style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFFFFFFF),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
