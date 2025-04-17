import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String gender = 'Nam'; // Default gender
  String nationality = 'Viet Nam'; // Default nationality

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 📸 Background là hình ảnh
          SizedBox.expand(
            child: Image.asset(
              'assets/images/imgbg1.png', // Đảm bảo thêm ảnh trong pubspec.yaml
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ← Back Button và "Tạo tài khoản" căn giữa
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Arrow back button
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                            width: 20), // Khoảng cách giữa icon và title
                        // Tạo tài khoản căn giữa
                        const Expanded(
                          child: Text(
                            "Tạo tài khoản",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontFamily: 'Mulish',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Khung trắng chứa nội dung
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 30),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Giới tính

                          const SizedBox(height: 20),

                          // Họ và tên

                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              hintText: "Họ và tên",
                              prefixIcon: const Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF3F6FA),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Email

                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              hintText: "Email",
                              prefixIcon: const Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF3F6FA),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Quốc tịch

                          // Nút Đăng ký
                          GestureDetector(
                            onTap: () {
                              // Xử lý đăng ký
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFA793F),
                                    Color(0xFFFFA345)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Center(
                                child: Text(
                                  "Đăng ký",
                                  style: TextStyle(
                                    fontFamily: 'Mulish',
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Đã có tài khoản
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Bạn đã có tài khoản? ",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Mulish',
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed('/login');
                                },
                                child: const Text(
                                  "ĐĂNG NHẬP",
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
            ),
          ),
        ],
      ),
    );
  }
}
