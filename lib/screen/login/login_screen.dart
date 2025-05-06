import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hue_passport_app/screen/login/login_api_service.dart';
import 'package:hue_passport_app/screen/tinhthanh/province_api_service.dart';
import 'package:hue_passport_app/screen/tinhthanh/province_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController passportController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false; // thêm loading

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/images/imgbg1.png',
              fit: BoxFit.cover,
            ),
          ),
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
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        padding: const EdgeInsets.all(16),
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

                              // Passport
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

                              // Password
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

                              Align(
                                alignment: Alignment.centerLeft,
                                child: GestureDetector(
                                  onTap: () {},
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

                              GestureDetector(
                                onTap: _handleLogin,
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

          // Loading overlay
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.orange),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await LoginApiService().login(
        passportNumber: passportController.text,
        password: passwordController.text,
      );
      if (result!.quocTichID == 1 &&
          (result.tinhThanhID == 0 || result.tinhThanhID == null)) {
        // Người dùng Việt Nam nhưng chưa có tỉnh thành -> hiển thị dialog
        final provinces = await ProvinceApiService.fetchProvinces();
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => ProvinceDialog(
            provinces: provinces,
            onConfirm: (selectedProvince) async {
              try {
                await ProvinceApiService.updateProvince(
                  passportNumber: passportController.text.trim(),
                  provinceID: selectedProvince.id.toString(),
                );
                _showMessage(
                    "Cập nhật thành công: ${selectedProvince.tenDiaPhuong}");
                // TODO: Chuyển hướng sau khi cập nhật
                // Get.offAllNamed('/home');
              } catch (e) {
                _showMessage('Cập nhật thất bại: $e');
              }
            },
          ),
        );
      } else {
        _showMessage('Đăng nhập thành công!');
        Get.offAllNamed('/main');
      }
    } catch (e) {
      _showMessage('Lỗi: ${e.toString().replaceAll('Exception: ', '')}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
