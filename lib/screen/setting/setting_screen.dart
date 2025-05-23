import 'package:flutter/material.dart';
import 'package:hue_passport_app/screen/setting/profile_screen.dart';

class SettingScreen extends StatelessWidget {
  final List<SettingItem> settings = [
    SettingItem(
      title: 'Thông tin cá nhân',
      icon: Icons.person,
      color: Color(0xFF0099FF),
      onTapMessage: 'Chuyển đến Thông tin cá nhân',
    ),
    SettingItem(
      title: 'Đổi ngôn ngữ',
      icon: Icons.language,
      color: Color(0xFF9933FF),
      onTapMessage: 'Chuyển đến Đổi ngôn ngữ',
    ),
    SettingItem(
      title: 'Hướng dẫn sử dụng',
      icon: Icons.menu_book,
      color: Color(0xFF9966CC),
      onTapMessage: 'Chuyển đến Hướng dẫn sử dụng',
    ),
    SettingItem(
      title: 'Thông tin ứng dụng',
      icon: Icons.info_outline,
      color: Color(0xFFFF9900),
      onTapMessage: 'Chuyển đến Thông tin ứng dụng',
    ),
    SettingItem(
      title: 'Đổi mật khẩu',
      icon: Icons.lock_outline,
      color: Color(0xFF33CC33),
      onTapMessage: 'Chuyển đến Đổi mật khẩu',
    ),
    SettingItem(
      title: 'Đăng xuất',
      icon: Icons.power_settings_new,
      color: Color(0xFFFF3300),
      onTapMessage: 'Đăng xuất',
      isLogout: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F7FF),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0066FF), Color(0xFF00CC66)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: Text(
                  'Thiết lập',
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // Danh sách cài đặt
            Expanded(
              child: ListView.separated(
                itemCount: settings.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = settings[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: item.color.withOpacity(0.15),
                      child: Icon(item.icon, color: item.color),
                    ),
                    title: Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Mulish',
                        fontWeight: FontWeight.bold, // In đậm
                      ),
                    ),
                    trailing: item.isLogout
                        ? null
                        : const Icon(Icons.arrow_forward_ios,
                            size: 16, color: Colors.grey),
                    onTap: () {
                      if (item.isLogout) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text(
                              'Xác nhận đăng xuất',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            content: const Text(
                              'Bạn có chắc chắn muốn đăng xuất không?',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  'Hủy',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Đã đăng xuất',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Đăng xuất',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        if (item.title == 'Thông tin cá nhân') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ProfileScreen()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                item.onTapMessage,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        }
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingItem {
  final String title;
  final IconData icon;
  final Color color;
  final String onTapMessage;
  final bool isLogout;

  SettingItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTapMessage,
    this.isLogout = false,
  });
}
