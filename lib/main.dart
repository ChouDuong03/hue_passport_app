import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hue_passport_app/screen/food/food_screen.dart';
import 'package:hue_passport_app/screen/home/home_screen.dart';
import 'package:hue_passport_app/screen/main/main_screen.dart';
import 'package:hue_passport_app/screen/register/register_screen.dart';
import 'screen/splash/splash_screen.dart';
import 'screen/onboarding/onboarding_screen.dart';
import 'screen/login/login_screen.dart';
import 'screen/program/program_screen.dart';
import 'screen/person/person_screen.dart';
import 'screen/setting/setting_screen.dart';
import 'ChuongTrinhAmThuc/ChuongTrinhAmThuc_Screen.dart';

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
        GetPage(name: '/register', page: () => RegisterScreen()),
        GetPage(name: '/home', page: () => HomeScreen()),
        GetPage(name: '/program', page: () => ProgramScreen()),
        GetPage(name: '/person', page: () => PersonScreen()),
        GetPage(name: '/setting', page: () => SettingScreen()),
        GetPage(name: '/food', page: () => FoodScreen()),
        GetPage(name: '/main', page: () => MainScreen()),
        GetPage(name: '/foodprogram', page: () => FoodProgramScreen()),
      ],
    );
  }
}
