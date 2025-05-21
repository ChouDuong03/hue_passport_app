import 'package:flutter/material.dart';
import 'package:hue_passport_app/services/api_checkin_food_service.dart';
import 'package:hue_passport_app/widgets/showcheckin_dialog.dart';

void showCheckinDialog(
  BuildContext context, {
  required int monAnId,
  required int diadiemId,
  required int chuongTrinhId,
  required double viDo,
  required double kinhDo,
}) {
  bool isLoading = false;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/camerafood.png',
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          color: Colors.grey[300],
                          child: const Center(
                            child: Text(
                              'Không thể tải ảnh',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Thêm logic chọn và lưu ảnh (hỗ trợ tối đa 5 ảnh)
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Chức năng thêm ảnh đang phát triển!')),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Thêm ảnh"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade100,
                      foregroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text("Bạn chỉ có thể thêm tối đa được 5 ảnh"),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () async {
                              setState(() {
                                isLoading = true;
                              });

                              try {
                                // Gọi API check-in địa điểm
                                final diaDiemResult =
                                    await ApiCheckinFoodService
                                        .postCheckinDiaDiem(
                                  diaDiemId: diadiemId,
                                  chuongTrinhId: chuongTrinhId,
                                  viDo: viDo,
                                  kinhDo: kinhDo,
                                );

                                // Gọi API check-in món ăn (multipart, có thể thêm ảnh)
                                final multipartResult =
                                    await ApiCheckinFoodService
                                        .postCheckinMultipart(
                                  monAnId: monAnId,
                                  chuongTrinhId: chuongTrinhId,
                                  viDo: viDo,
                                  kinhDo: kinhDo,
                                );

                                // Kiểm tra kết quả của cả hai API
                                if (diaDiemResult.success &&
                                    multipartResult.success) {
                                  Navigator.of(context).pop();
                                  showCheckinSuccessDialog(
                                    context,
                                    chuongTrinhId: chuongTrinhId,
                                    quanAnId:
                                        diadiemId, // Sử dụng diadiemId làm quanAnId
                                    monAnId: monAnId,
                                    ngonNguId:
                                        1, // Giả sử ngonNguId là 1 (Tiếng Việt), có thể động hóa nếu cần
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Lỗi khi check-in: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } finally {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: const Color(0xFF05D48A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "Hoàn thành",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFFFFFFFF),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
