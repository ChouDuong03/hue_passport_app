import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/nav_controller.dart';

class BottomNavBar extends StatelessWidget {
  final NavController navController = Get.put(NavController());

  BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => BottomNavigationBar(
          currentIndex: navController.selectedIndex.value,
          onTap: navController.changeTabIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF00C896),
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.route),
              label: 'Chương trình',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Cá nhân',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Thiết lập',
            ),
          ],
        ));
  }
}
