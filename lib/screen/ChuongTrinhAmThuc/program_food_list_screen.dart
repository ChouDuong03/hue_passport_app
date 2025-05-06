import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hue_passport_app/controller/program_food_controller.dart';
import 'package:hue_passport_app/widgets/program_card_widget.dart';

class ProgramListScreen extends StatelessWidget {
  final controller = Get.put(ProgramFoodController());
  final PageController _pageController = PageController();

  ProgramListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Ảnh nền phía sau (border2)
          Container(
            height: 250,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/border2.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Nội dung chính đè lên
          Column(
            children: [
              const SizedBox(height: 90), // để tránh che mất avatar + tiêu đề
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(top: 12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFDF6FC),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (controller.programs.isEmpty) {
                      return const Center(
                          child: Text('Không có chương trình nào.'));
                    }

                    return PageView.builder(
                      controller: _pageController,
                      itemCount: controller.programs.length,
                      itemBuilder: (context, index) {
                        final program = controller.programs[index];
                        return ProgramCardWidget(program: program);
                      },
                    );
                  }),
                ),
              ),
            ],
          ),

          // Avatar + tiêu đề nằm trên ảnh nền
          const Positioned(
            top: 30,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/images/useravatar.png'),
                ),
                Text(
                  'Ẩm thực',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 40), // Để cân layout
              ],
            ),
          )
        ],
      ),
    );
  }
}
