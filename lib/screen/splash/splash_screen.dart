import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hue_passport_app/controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());

    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // 🔁 Background là hình ảnh image.png
          SizedBox.expand(
            child: Image.asset(
              'assets/images/imgbg1.png',
              fit: BoxFit.cover,
            ),
          ),

          // Nội dung trên hình nền
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),

              // Tiêu đề
              const Text(
                'Hue city tourist',
                style: TextStyle(
                  fontFamily: 'UTMYenTu',
                  fontSize: 55,
                  color: Colors.white,
                ),
              ),
              const Text(
                'PASSPORT',
                style: TextStyle(
                  fontFamily: 'UTMCopperplate',
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 30),

              // Hình ảnh địa điểm du lịch
              SizedBox(
                height: 260,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 40,
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Image.asset('assets/images/place2.png',
                              width: screenWidth * 0.7),
                          Positioned(
                            bottom:
                                19, // 👈 đẩy pin ra ngoài viền 1 chút nếu muốn
                            left: 16,
                            child: Image.asset('assets/images/pin2.png',
                                width: 30),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 20,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Image.asset('assets/images/place1.png',
                              width: screenWidth * 0.4),
                          Positioned(
                            top: 8,
                            child: Image.asset('assets/images/pin1.png',
                                width: 30),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 20,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Image.asset('assets/images/place3.png',
                              width: screenWidth * 0.3),
                          Positioned(
                            top: 8,
                            child: Image.asset('assets/images/pin3.png',
                                width: 30),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Nhân vật hoạt hình
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Image.asset(
                    'assets/images/character.png',
                    height: 264,
                    width: 237,
                  ),
                ),
              ),
            ],
          ),

          // Thanh điều hướng iOS
          Positioned(
            bottom: 8,
            left: (screenWidth - 150) / 2,
            child: Container(
              height: 5,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
