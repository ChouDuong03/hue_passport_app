import 'package:flutter/material.dart';
import 'package:hue_passport_app/models/program_progess.dart';
import 'package:hue_passport_app/models/program_time.dart';
import 'package:hue_passport_app/models/program_food_model.dart';
import 'package:hue_passport_app/screen/login/login_screen.dart';
import 'package:hue_passport_app/services/program_food_api_service.dart';
import 'package:get/get.dart';
import 'package:hue_passport_app/widgets/program_progess_card.dart';
import 'package:hue_passport_app/controller/nav_controller.dart';

class PersonScreen extends StatelessWidget {
  final int chuongTrinhID;

  const PersonScreen({Key? key, int? chuongTrinhID})
      : chuongTrinhID = chuongTrinhID ?? 1,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // Lấy NavController từ GetX
    final NavController navController = Get.find<NavController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              height: 60,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/border2.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        // Quay lại tab trước đó bằng NavController
                        navController.goBackToPreviousTab();
                      },
                    ),
                    const Text(
                      'Hộ chiếu du lịch',
                      style: TextStyle(
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
            // Body
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFFDF6FC),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      FutureBuilder<List<dynamic>>(
                        future: Future.wait([
                          ProgramFoodApiService()
                              .fetchProgramProgress(chuongTrinhID),
                          ProgramFoodApiService()
                              .fetchProgramTime(chuongTrinhID),
                          ProgramFoodApiService().fetchPrograms(),
                        ]),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Lỗi: ${snapshot.error}',
                                    style: const TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 16,
                                      color: Colors.red,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () =>
                                        Get.offAll(() => const LoginScreen()),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF234874),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text(
                                      'Đăng nhập lại',
                                      style: TextStyle(
                                        fontFamily: 'Mulish',
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else if (!snapshot.hasData) {
                            return const Center(
                              child: Text(
                                'Không có dữ liệu. Vui lòng đăng nhập!',
                                style: TextStyle(
                                  fontFamily: 'Mulish',
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          }

                          final progress = snapshot.data![0] as ProgramProgress;
                          final time = snapshot.data![1] as ProgramTime;
                          final programs =
                              snapshot.data![2] as List<ProgramFoodModel>;

                          final program = programs.firstWhere(
                            (p) => p.chuongTrinhID == chuongTrinhID,
                            orElse: () => ProgramFoodModel(
                              chuongTrinhID: chuongTrinhID,
                              tenChuongTrinh: 'Chương trình không xác định',
                              anhDaiDien: '',
                              soLuongMonAn: 0,
                              soNguoiThamGia: 0,
                            ),
                          );

                          return ProgramProgressCard(
                            title: program.tenChuongTrinh,
                            progress: progress,
                            time: time,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
