import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hue_passport_app/models/program_data.dart';
import 'package:intl/intl.dart';
import 'package:hue_passport_app/controller/program_controller.dart';

class ProgramScreen extends StatefulWidget {
  @override
  State<ProgramScreen> createState() => _ProgramScreenState();
}

class _ProgramScreenState extends State<ProgramScreen> {
  final ProgramController controller = Get.put(ProgramController());
  RxList<bool> showFullDescriptionList = <bool>[].obs;

  @override
  void initState() {
    super.initState();
    ever<List<ProgramData>>(controller.programList, (list) {
      showFullDescriptionList.value = List.generate(list.length, (_) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F7FF),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final numberFormat = NumberFormat.compact(locale: 'en');

        return PageView.builder(
          itemCount: controller.programList.length,
          itemBuilder: (context, index) {
            final program = controller.programList[index];

            return SingleChildScrollView(
              child: Stack(
                children: [
                  // Background
                  SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: Image.asset(
                      'assets/images/border2.png',
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Main content
                  Column(
                    children: [
                      const SizedBox(height: 20),

                      // Header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Text(
                              'Chương trình',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Mulish',
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: const CircleAvatar(
                                  radius: 20,
                                  backgroundImage: AssetImage(
                                      'assets/images/avatar_user.png'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Card chương trình
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                    ),
                                    child: Image.network(
                                      program.imageUrl,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 180,
                                    ),
                                  ),
                                  // Nền đen chiều ngang full ảnh
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.4),
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(16),
                                          bottomRight: Radius.circular(16),
                                        ),
                                      ),
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      child: Text(
                                        program.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          fontFamily: 'Mulish',
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.location_on,
                                                color: Colors.red, size: 16),
                                            const SizedBox(width: 4),
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        '${program.locationCount} ',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                  const TextSpan(
                                                    text: 'Địa điểm',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFF008FFF)),
                                                  ),
                                                ],
                                                style: const TextStyle(
                                                    fontFamily: 'Mulish',
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Icon(Icons.people,
                                                color: Colors.green, size: 16),
                                            const SizedBox(width: 4),
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        '${numberFormat.format(program.participants)} ',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                  const TextSpan(
                                                    text: 'Tham gia',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFF008FFF)),
                                                  ),
                                                ],
                                                style: const TextStyle(
                                                    fontFamily: 'Mulish',
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Mô tả chương trình
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    // Hình tròn xanh nằm sau
                                    Positioned(
                                      left: 0,
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFB3E5FC),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                    // Dòng chữ đè lên, được đẩy nhẹ sang phải để lộ hình tròn
                                    const Padding(
                                      padding: EdgeInsets.only(left: 11),
                                      child: Text(
                                        'Giới thiệu chương trình',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF234874),
                                          fontFamily: 'Mulish',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Obx(() {
                              final isExpanded =
                                  controller.expandList.length > index
                                      ? controller.expandList[index].value
                                      : false;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    program.description,
                                    maxLines: isExpanded ? null : 3,
                                    overflow: isExpanded
                                        ? TextOverflow.visible
                                        : TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Color(0xFF234874)),
                                  ),
                                  const SizedBox(height: 4),
                                  GestureDetector(
                                    onTap: () => controller.toggleExpand(index),
                                    child: Text(
                                      isExpanded ? 'Thu gọn' : 'Xem thêm',
                                      style: const TextStyle(
                                        color: Color(0xFF008FFF),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Ảnh địa điểm
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal:
                                16), // cùng padding với các section khác
                        child: Row(
                          children: [
                            Stack(
                              alignment: Alignment.centerLeft,
                              children: [
                                // Hình tròn xanh
                                Positioned(
                                  left: 0,
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFB3E5FC),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                // Dòng chữ
                                const Padding(
                                  padding: EdgeInsets.only(left: 11),
                                  child: Text(
                                    'Địa điểm trong chương trình',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF234874),
                                      fontFamily: 'Mulish',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: program.locationImages.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(right: 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  program.locationImages[index],
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 16),

                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width *
                              0.8, // Chiếm 80% chiều rộng màn hình
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00C88F),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12), // bỏ horizontal
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            onPressed: () {
                              // Điều hướng hoặc show dialog
                            },
                            child: const Text(
                              'Xem chi tiết',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
