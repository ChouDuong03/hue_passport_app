import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hue_passport_app/screen/register/register_screen.dart';
import 'screen/splash/splash_screen.dart';
import 'screen/onboarding/onboarding_screen.dart';
import 'screen/login/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash', // ← Trang khởi đầu
      getPages: [
        GetPage(name: '/splash', page: () => const SplashScreen()),
        GetPage(name: '/onboarding', page: () => const OnboardingScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/register', page: () => const RegisterScreen()),
      ],
    );
  }
}
