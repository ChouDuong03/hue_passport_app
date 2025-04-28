import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hue_passport_app/screen/quoctich/quoctich_model.dart';
import 'package:hue_passport_app/screen/register/register_controller.dart';
import 'package:hue_passport_app/screen/tinhthanh/province_model.dart';

class RegisterScreen extends StatelessWidget {
  final RegisterController controller = Get.put(RegisterController());

  RegisterScreen({super.key});

  InputDecoration inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: const Color(0xFFF3F6FA),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF2FF),
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              'assets/images/imgbg1.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    // Back & Title
                    Row(
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Get.back(),
                        ),
                        const Expanded(
                          child: Text(
                            "Tạo tài khoản",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Mulish',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 48), // chừa chỗ icon back
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Giới tính - Radio
                          Obx(() => Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Giới tính: ",
                                    style: TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Radio<String>(
                                        value: 'Nam',
                                        groupValue: controller.gender.value,
                                        onChanged: (value) =>
                                            controller.gender.value = value!,
                                      ),
                                      const Text('Nam'),
                                      Radio<String>(
                                        value: 'Nữ',
                                        groupValue: controller.gender.value,
                                        onChanged: (value) =>
                                            controller.gender.value = value!,
                                      ),
                                      const Text('Nữ'),
                                      Radio<String>(
                                        value: 'Khác',
                                        groupValue: controller.gender.value,
                                        onChanged: (value) =>
                                            controller.gender.value = value!,
                                      ),
                                      const Text('Khác'),
                                    ],
                                  )
                                ],
                              )),
                          const SizedBox(height: 16),

                          // Họ và tên
                          TextField(
                            controller: controller.nameController,
                            decoration:
                                inputDecoration("Họ và tên", Icons.person),
                          ),
                          const SizedBox(height: 16),

                          // Ngày sinh
                          TextField(
                            controller: controller.dobController,
                            decoration: inputDecoration(
                                "Ngày sinh", Icons.calendar_today),
                            keyboardType: TextInputType.datetime,
                          ),
                          const SizedBox(height: 16),

                          // Email
                          TextField(
                            controller: controller.emailController,
                            decoration: inputDecoration("Email", Icons.email),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 16),

                          // Quốc tịch
                          Obx(() => DropdownButtonFormField<Nationality>(
                                value: controller.selectedNationality.value,
                                items: controller.nationalities.map((n) {
                                  return DropdownMenuItem<Nationality>(
                                    value: n,
                                    child: Text(n.tenQuocTich),
                                  );
                                }).toList(),
                                onChanged: controller.onSelectNationality,
                                decoration:
                                    inputDecoration("Quốc tịch", Icons.public),
                              )),
                          const SizedBox(height: 16),

                          // Tỉnh thành
                          Obx(() => controller.showProvinceField.value
                              ? DropdownButtonFormField<Province>(
                                  value: controller.selectedProvince.value,
                                  items: controller.provinces.map((p) {
                                    return DropdownMenuItem<Province>(
                                      value: p,
                                      child: Text(p.name),
                                    );
                                  }).toList(),
                                  onChanged: (p) =>
                                      controller.selectedProvince.value = p,
                                  decoration: inputDecoration(
                                      "Chọn tỉnh thành", Icons.location_city),
                                )
                              : const SizedBox()),

                          const SizedBox(height: 30),

                          // Button Đăng ký
                          GestureDetector(
                            onTap: controller.register,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFF8040),
                                    Color(0xFFFFA347)
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
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Đăng nhập
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
                                onTap: () => Get.toNamed('/login'),
                                child: const Text(
                                  "ĐĂNG NHẬP",
                                  style: TextStyle(
                                    fontFamily: 'Mulish',
                                    color: Color(0xFF008FFF),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
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
          ),
        ],
      ),
    );
  }
}
