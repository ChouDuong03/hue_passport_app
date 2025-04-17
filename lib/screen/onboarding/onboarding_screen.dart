import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hue_passport_app/controller/onboarding_controller.dart';
import 'onboarding_page.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());

    return Scaffold(
      backgroundColor: const Color(0xFFF0F7FF),
      body: SafeArea(
        child: Column(
          children: [
            // Ngôn ngữ chọn
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text("Chọn ngôn ngữ",
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Mulish',
                          fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF99D4FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Image.asset("assets/images/vn_flag.png", width: 30),
                        const Icon(Icons.keyboard_arrow_down_rounded),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Nội dung onboarding
            Expanded(
              child: PageView(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                physics: const BouncingScrollPhysics(),
                children: [
                  const OnboardingPage(
                    imagePath: "assets/images/imgonboard1.png",
                    title: "Khám phá danh lam thắng cảnh\n Cố đô Huế.",
                  ),
                  const OnboardingPage(
                    imagePath: "assets/images/imgonboard2.png",
                    title: "Cùng chụp ảnh Check in các địa điểm\n bạn đã đến",
                  ),
                  const OnboardingPage(
                    imagePath: "assets/images/imgonboard3.png",
                    title:
                        "Hoàn thành để nhận giấy chứng nhận và\n phần quà hấp dẫn từ Sở Du lịch Huế, sau\n khi bạn Check in đủ tất cả các điểm đến\n trong chương trình.",
                  ),
                  OnboardingPage(
                    imagePath: "assets/images/imgonboard4.png",
                    title:
                        "Sẵn sàng khám phá hành trình của bạn\n Hãy bắt đầu ngay thôi!",
                    extraContent: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.toNamed('/login');
                          },
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(horizontal: 120),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFA793F), Color(0xFFFFA345)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 9),
                            child: const Center(
                              child: Text(
                                "Đăng nhập",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Mulish',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Bạn chưa có tài khoản? ",
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Mulish',
                                color: Colors.black87,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.toNamed('/register');
                              },
                              child: const Text(
                                "Đăng ký",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Mulish',
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF008FFF),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Điều hướng dưới cùng: Bỏ qua - chấm tròn - Tiếp tục/Hoàn thành
            Obx(() => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: controller.skip,
                        child: const Text(
                          "Bỏ qua",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Mulish',
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF234874),
                          ),
                        ),
                      ),
                      Row(
                        children: List.generate(
                          4,
                          (index) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: index == controller.currentIndex.value
                                    ? const Color(0xFF008FFF)
                                    : const Color(0xFFB4DEFF),
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: controller.nextPage,
                        child: Text(
                          controller.currentIndex.value == 3
                              ? "Hoàn thành"
                              : "Tiếp tục",
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Mulish',
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF008FFF),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
