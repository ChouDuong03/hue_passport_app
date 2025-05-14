import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hue_passport_app/models/location_model.dart';
import 'package:hue_passport_app/screen/Camera/camera_screen.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final LocationModel restaurant;
  final int monAnId;
  final int chuongTrinhId;
  final bool isCheckedIn;
  final baseUrl = "https://localhost:51512";
  const RestaurantDetailScreen({
    super.key,
    required this.restaurant,
    required this.monAnId,
    required this.chuongTrinhId,
    required this.isCheckedIn,
  });

  @override
  Widget build(BuildContext context) {
    final detail = restaurant.getDetailByLanguage(1) ??
        (restaurant.childGetDiaDiemByMonAns.isNotEmpty
            ? restaurant.childGetDiaDiemByMonAns.first
            : null);

    if (detail == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Không thể tải thông tin địa điểm.',
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00C853),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Quay lại',
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 60,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/border2.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Get.back(),
                    ),
                    Text(
                      detail.tenDiaDiem,
                      style: const TextStyle(
                        fontFamily: 'Mulish',
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),
            Container(
              height: 200,
              width: double.infinity,
              child: ClipRRect(
                child: Image.network(
                  "$baseUrl${restaurant.anhDaiDien}",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              detail.tenDiaDiem,
              style: const TextStyle(
                fontFamily: 'Mulish',
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Địa chỉ: ${restaurant.soNha ?? ''} ${detail.duongPho}',
              style: const TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Số điện thoại: ${restaurant.soDienThoai ?? 'Không có thông tin'}',
              style: const TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Mở cửa: ${restaurant.gioMoCua ?? 'Không rõ'} - ${restaurant.gioDongCua ?? 'Không rõ'}',
              style: const TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Giới thiệu',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              detail.gioiThieu.isNotEmpty
                  ? detail.gioiThieu
                  : 'Không có thông tin giới thiệu.',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 14,
                color: detail.gioiThieu.isEmpty ? Colors.grey : null,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: isCheckedIn
                        ? null
                        : () {
                            Get.to(() => FakeCameraScreen(
                                  chuongTrinhId: chuongTrinhId,
                                  monAnId: monAnId,
                                  diadiemId: restaurant.id,
                                ));
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isCheckedIn ? Colors.grey : Colors.orange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      isCheckedIn ? 'Đã check-in' : 'Chụp ảnh để check-in',
                      style: const TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Get.snackbar(
                          'Thông báo', 'Chức năng đánh giá đang phát triển!');
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF00C853)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'Đánh giá và review',
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 14,
                        color: Color(0xFF00C853),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
