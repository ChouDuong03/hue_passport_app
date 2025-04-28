import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hue_passport_app/ChuongTrinhAmThuc/ChuongTrinhAmThuc_Controller.dart';
import 'package:hue_passport_app/ChuongTrinhAmThuc/ChuongTrinhAmThuc_Card.dart';

class FoodProgramScreen extends StatelessWidget {
  final ChuongTrinhController controller = Get.put(ChuongTrinhController());

  FoodProgramScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return SizedBox(
        height: 350,
        child: PageView.builder(
          controller: PageController(viewportFraction: 0.85),
          itemCount: controller.programs.length,
          itemBuilder: (context, index) {
            final item = controller.programs[index];
            return FoodProgramCard(program: item);
          },
        ),
      );
    });
  }
}
