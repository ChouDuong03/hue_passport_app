import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hue_passport_app/controller/home_controller.dart';
import 'package:intl/intl.dart';
import 'package:hue_passport_app/widgets/custom_alert.dart';

class HomeScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F7FF),
      body: Obx(() {
        final data = controller.homeData.value;
        if (data == null) {
          return const Center(child: CircularProgressIndicator());
        }

        // Sử dụng NumberFormat để định dạng số
        final enFormat = NumberFormat.compact(locale: 'en');
        final numberFormat = NumberFormat('#,###'); // Định dạng với dấu phẩy
        final formattedNumber = numberFormat.format(data.completePrograms);
        return SingleChildScrollView(
          child: Stack(
            children: [
              // Background image
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.25,
                child: Image.asset(
                  'assets/images/border2.png',
                  fit: BoxFit.cover,
                ),
              ),

              // Nội dung chính
              Column(
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              AssetImage('assets/images/avatar_user.png'),
                        ),
                        const SizedBox(width: 12),
                        RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Chào bạn ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Mulish',
                                  fontSize: 14,
                                ),
                              ),
                              TextSpan(
                                text: data.userName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Mulish',
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Card chương trình
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Ảnh chương trình
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            child: Image.asset(
                              'assets/images/hueanh.png',
                              height: 160,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.programTitle,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    fontFamily: 'Mulish',
                                    color: Color(0xFF234874),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  data.programDescription,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Mulish',
                                    color: Color(0xFF234874),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on,
                                            color: Colors.red, size: 16),
                                        const SizedBox(width: 4),
                                        RichText(
                                          text: TextSpan(
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Mulish',
                                            ),
                                            children: [
                                              TextSpan(
                                                text: '${data.totalPlaces} ',
                                                style: const TextStyle(
                                                    fontFamily: 'Mulish',
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red),
                                              ),
                                              const TextSpan(
                                                text: 'Địa điểm',
                                                style: TextStyle(
                                                    fontFamily: 'Mulish',
                                                    color: Color(0xFF008FFF)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.people,
                                            color: Colors.green, size: 16),
                                        const SizedBox(width: 4),
                                        RichText(
                                          text: TextSpan(
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Mulish',
                                            ),
                                            children: [
                                              TextSpan(
                                                text:
                                                    '${enFormat.format(data.totalParticipants)} ',
                                                style: const TextStyle(
                                                    fontFamily: 'Mulish',
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green),
                                              ),
                                              const TextSpan(
                                                text: 'Tham gia',
                                                style: TextStyle(
                                                    fontFamily: 'Mulish',
                                                    color: Color(0xFF008FFF)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Card trúng thưởng
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: const Color(0xFF00D7A3),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'assets/images/luckyicon.png',
                                  width: 60,
                                  height: 60,
                                ),
                                const SizedBox(width: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${data.totalWinners}',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Mulish',
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Tổng người trúng thưởng kỳ quay\nmới nhất',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Mulish',
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                CustomAlert.show(
                                  message:
                                      "Bạn cần đăng nhập để xem chi tiết chương trình.",
                                  confirmText: "Đăng nhập",
                                  cancelText: "Đóng",
                                  onConfirm: () {
                                    // Ví dụ: chuyển sang màn hình đăng nhập
                                    Get.toNamed('/login');
                                  },
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFA793F),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'Chi tiết',
                                  style: TextStyle(
                                    fontFamily: 'Mulish',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Hai card nằm ngang (cam và xanh dương)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Card cam
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFA793F),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/icon1.png',
                                      width: 24,
                                      height: 24,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      formattedNumber,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const Text(
                                  'Người hoàn thành chương trình\ntrong tháng',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Card xanh dương
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00A4BA),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/icon2.png',
                                      width: 24,
                                      height: 24,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${data.todayRegistration}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const Text(
                                  'Số hộ chiếu đăng ký\ntrong ngày',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          // Hình tròn xanh nằm sau
                          Positioned(
                            left: 0,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                color: Color(0xFFB3E5FC),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          // Dòng chữ đè lên, được đẩy nhẹ sang phải để lộ hình tròn
                          const Padding(
                            padding: EdgeInsets.only(left: 11),
                            child: Text(
                              'Du khách check in gần đây',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF234874),
                                fontFamily: 'Mulish',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // <-- Thêm dòng này
                  const SizedBox(height: 80),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
