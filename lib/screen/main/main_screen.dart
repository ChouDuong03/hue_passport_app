import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hue_passport_app/controller/nav_controller.dart';
import 'package:hue_passport_app/ChuongTrinhAmThuc/ChuongTrinhAmThuc_Screen.dart';
import 'package:hue_passport_app/screen/program/program_screen.dart';
import 'package:hue_passport_app/screen/person/person_screen.dart';
import 'package:hue_passport_app/screen/setting/setting_screen.dart';

class MainScreen extends StatelessWidget {
  final NavController navController = Get.put(NavController());

  final List<Widget> screens = [
    ProgramScreen(),
    FoodProgramScreen(),
    PersonScreen(),
    SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: IndexedStack(
          index: navController.selectedIndex.value,
          children: screens,
        ),
        bottomNavigationBar: Container(
          height: MediaQuery.of(context).size.height * 0.08,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF6384AA),
                blurRadius: 5,
                offset: Offset(0, -1),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: BottomNavigationBar(
              currentIndex: navController.selectedIndex.value,
              onTap: navController.changeTabIndex,
              items: [
                BottomNavigationBarItem(
                  icon: Image.asset(
                    navController.selectedIndex.value == 1
                        ? 'assets/images/iconplace.png'
                        : 'assets/images/iconplace2.png',
                    width: 24,
                    height: 24,
                  ),
                  label: 'Chương trình',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    navController.selectedIndex.value == 1
                        ? 'assets/images/foodicon.png'
                        : 'assets/images/foodicon2.png',
                    width: 24,
                    height: 24,
                  ),
                  label: 'Ẩm thực',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                    size: 24,
                  ),
                  label: 'Cá nhân',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(
                    Icons.settings,
                    size: 24,
                  ),
                  label: 'Thiết lập',
                ),
              ],
              selectedLabelStyle: const TextStyle(
                fontFamily: 'Mulish',
                fontWeight: FontWeight.bold,
                color: Color(0xFF234874),
              ),
              unselectedLabelStyle: const TextStyle(
                fontFamily: 'Mulish',
                color: Color(0xFFA5B7CD),
              ),
              selectedItemColor: const Color(0xFF06AC80),
              unselectedItemColor: const Color(0xFFA5B7CD),
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
            ),
          ),
        ),
      );
    });
  }
}
