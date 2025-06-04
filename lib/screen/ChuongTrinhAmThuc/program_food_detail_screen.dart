import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hue_passport_app/controller/program_food_controller.dart';

class ProgramDetailScreen extends StatelessWidget {
  final int programId;
  final controller = Get.find<ProgramFoodController>();
  final baseUrl = "https://hochieudulichv2.huecit.com";
  ProgramDetailScreen({required this.programId}) {
    // Kiểm tra nếu chương trình chi tiết đã có trong cache rồi mới gọi API
    if (!controller.programDetailsCache.containsKey(programId)) {
      controller.fetchProgramDetail(programId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết chương trình')),
      body: Obx(() {
        if (controller.isLoadingDetail.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final detail = controller.programDetailsCache[programId];
        if (detail == null) {
          return const Center(child: Text('Không tìm thấy chi tiết'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                "$baseUrl${detail.anhDaiDien}",
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),
              Text('Số người tham gia: ${detail.soNguoiThamGia}',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              ...detail.details.map((e) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.tenChuongTrinh,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      Text(e.gioiThieu),
                      const SizedBox(height: 12),
                    ],
                  )),
            ],
          ),
        );
      }),
    );
  }
}
