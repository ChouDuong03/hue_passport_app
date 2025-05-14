import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hue_passport_app/controller/food_checkin_controller.dart';
import 'package:hue_passport_app/widgets/checkin_dialog.dart';

class FakeCameraScreen extends StatelessWidget {
  final int monAnId;
  final int diadiemId;
  final int chuongTrinhId;

  FakeCameraScreen({
    Key? key,
    required this.monAnId,
    required this.diadiemId,
    required this.chuongTrinhId,
  }) : super(key: key);

  final CheckinController checkinController = Get.put(CheckinController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return checkinController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  // Background là ảnh giả lập camera
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/camerafood.png',
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Nút chụp ảnh
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: GestureDetector(
                        onTap: () {
                          showCheckinDialog(
                            context,
                            monAnId: monAnId,
                            diadiemId: diadiemId,
                            chuongTrinhId: chuongTrinhId,
                            viDo: 2,
                            kinhDo: 3,
                          );
                        },
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
      }),
    );
  }
}
