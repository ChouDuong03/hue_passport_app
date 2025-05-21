import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hue_passport_app/models/location_model.dart';
import 'package:hue_passport_app/models/review_response.dart';
import 'package:hue_passport_app/screen/Camera/camera_screen.dart';
import 'package:hue_passport_app/widgets/showcheckin_dialog.dart';
import 'package:hue_passport_app/services/program_food_api_service.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final LocationModel restaurant;
  final int monAnId;
  final int chuongTrinhId;
  final bool isCheckedIn;

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
                  "${restaurant.anhDaiDien}",
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
                      showCheckinSuccessDialog(
                        context,
                        chuongTrinhId: chuongTrinhId,
                        quanAnId: restaurant.id,
                        monAnId: monAnId,
                        ngonNguId: 1,
                      );
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
            const SizedBox(height: 20),
            const Text(
              'Review về quán',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            FutureBuilder<List<ReviewModel2>>(
              future:
                  ProgramFoodApiService().fetchReviewsByLocation(restaurant.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Text('Không thể tải đánh giá.');
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('Chưa có đánh giá nào.');
                }

                final reviews = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    final review = reviews[index];
                    final userName = review.hoTen.isNotEmpty
                        ? review.hoTen
                        : 'Người dùng ẩn danh';
                    final date =
                        review.ngayDanhGia.toLocal().toString().split(' ')[0];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                userName,
                                style: const TextStyle(
                                  fontFamily: 'Mulish',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                date,
                                style: const TextStyle(
                                  fontFamily: 'Mulish',
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            review.noiDungDanhGia,
                            style: const TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
