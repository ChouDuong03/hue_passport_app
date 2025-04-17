import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController passportController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 📸 Background là hình ảnh
          SizedBox.expand(
            child: Image.asset(
              'assets/images/imgbg1.png',
              fit: BoxFit.cover,
            ),
          ),

          // 📦 Nội dung chính
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Đăng nhập",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Mulish',
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                // Giảm kích thước khung trắng
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height *
                          0.5, // Thu nhỏ chiều cao
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        padding: const EdgeInsets.all(16), // Giảm padding
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
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/images/loginavatar.png",
                                height: 150,
                              ),
                              const SizedBox(height: 20),

                              // Mã hộ chiếu
                              TextField(
                                controller: passportController,
                                decoration: InputDecoration(
                                  hintText: 'Mã hộ chiếu',
                                  prefixIcon: const Icon(Icons.credit_card),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFFF3F6FA),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Mật khẩu
                              TextField(
                                controller: passwordController,
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  hintText: 'Mật khẩu',
                                  prefixIcon: const Icon(Icons.lock),
                                  suffixIcon: IconButton(
                                    icon: Icon(_obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFFF3F6FA),
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Quên mật khẩu
                              Align(
                                alignment: Alignment.centerLeft,
                                child: GestureDetector(
                                  onTap: () {
                                    // TODO: Điều hướng quên mật khẩu
                                  },
                                  child: const Text(
                                    "Quên mật khẩu?",
                                    style: TextStyle(
                                      fontFamily: 'Mulish',
                                      color: Color(0xFF008FFF),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Nút đăng nhập
                              GestureDetector(
                                onTap: () {
                                  // TODO: Xử lý đăng nhập
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
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
                              const SizedBox(height: 20),

                              // Chưa có tài khoản?
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Bạn không có tài khoản? ",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Mulish',
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Get.toNamed('/register');
                                    },
                                    child: const Text(
                                      "ĐĂNG KÝ",
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
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
