import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hue_passport_app/controller/visitor_controller.dart';
import 'package:hue_passport_app/models/visitor_data.dart';

class VisitorListView extends StatelessWidget {
  final VisitorController controller = Get.put(VisitorController());

  VisitorListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return ListView.builder(
        shrinkWrap: true, // Giúp ListView chỉ chiếm đúng kích thước cần thiết
        physics:
            const NeverScrollableScrollPhysics(), // Tắt scroll riêng của ListView để tránh xung đột với SingleChildScrollView
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: controller.visitorList.length,
        itemBuilder: (context, index) {
          final visitor = controller.visitorList[index];
          return _buildVisitorCard(visitor, index);
        },
      );
    });
  }

  Widget _buildVisitorCard(Visitor visitor, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${index + 1}.',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(width: 10),
            CircleAvatar(
              backgroundImage: visitor.avatarUrl.isNotEmpty
                  ? NetworkImage(visitor.avatarUrl)
                  : null,
              child:
                  visitor.avatarUrl.isEmpty ? const Icon(Icons.person) : null,
              radius: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(visitor.name,
                      style: const TextStyle(
                          fontFamily: 'Mulish',
                          fontWeight: FontWeight.bold,
                          color: Colors.blue)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/iconcccd.png',
                        width: 14,
                        height: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        visitor.mhc,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          fontFamily: 'Mulish',
                          color: Color(0xFF234874),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/iconplace.png',
                        width: 14,
                        height: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        visitor.program,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          fontFamily: 'Mulish',
                          color: Color(0xFF234874),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.public, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        visitor.country,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          fontFamily: 'Mulish',
                          color: Color(0xFF234874),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        visitor.location,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          fontFamily: 'Mulish',
                          color: Color(0xFF234874),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
