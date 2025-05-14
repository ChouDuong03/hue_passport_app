import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hue_passport_app/controller/program_food_controller.dart';
import 'package:hue_passport_app/screen/ChuongTrinhAmThuc/dish_detail_screen.dart';

class DishListScreen extends StatefulWidget {
  final int chuongTrinhID;
  final ProgramFoodController controller = Get.find<ProgramFoodController>();

  DishListScreen({super.key, required this.chuongTrinhID}) {
    controller.fetchDishesByProgram(chuongTrinhID);
  }

  @override
  State<DishListScreen> createState() => _DishListScreenState();
}

final baseUrl = "https://localhost:51512";

class _DishListScreenState extends State<DishListScreen> {
  bool _isPressed = false;

  // Tìm chương trình dựa trên chuongTrinhID
  String getProgramName() {
    final program = widget.controller.programs
        .firstWhereOrNull((p) => p.chuongTrinhID == widget.chuongTrinhID);
    return program?.tenChuongTrinh ?? 'Danh sách món ăn';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // Phần tiêu đề với nút quay lại
                Container(
                  height: 60,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/border2.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFDF6FC),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Column(
                    children: [
                      // Danh sách món ăn
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() {
                              return Text(
                                getProgramName(),
                                style: const TextStyle(
                                  fontFamily: 'Mulish',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              );
                            }),
                            const SizedBox(height: 8),
                            Obx(() {
                              if (widget.controller.isLoadingDishes.value) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              final dishes = widget.controller
                                      .dishesCache[widget.chuongTrinhID] ??
                                  [];
                              if (dishes.isEmpty) {
                                return const Center(
                                    child: Text('Không có món ăn nào.'));
                              }

                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: dishes.length,
                                itemBuilder: (context, index) {
                                  final dish = dishes[index];
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // Số thứ tự
                                        Text(
                                          '${index + 1}.',
                                          style: const TextStyle(
                                            fontFamily: 'Mulish',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        // Ảnh đại diện
                                        CircleAvatar(
                                          radius: 12,
                                          backgroundImage: NetworkImage(
                                              "$baseUrl${dish.anhDaiDien}" // Không thêm dấu `/` nữa nếu chuỗi đã có
                                              ),
                                        ),
                                        const SizedBox(width: 8),
                                        // Tên món ăn và nút Check-in
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                dish.tenMon,
                                                style: const TextStyle(
                                                  fontFamily: 'Mulish',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              GestureDetector(
                                                onTapDown: (_) => setState(
                                                    () => _isPressed = true),
                                                onTapUp: (_) => setState(
                                                    () => _isPressed = false),
                                                onTapCancel: () => setState(
                                                    () => _isPressed = false),
                                                onTap: () {
                                                  // Điều hướng đến màn hình chi tiết món ăn
                                                  Get.to(() => DishDetailScreen(
                                                      dish: dish));
                                                },
                                                child: AnimatedContainer(
                                                  duration: const Duration(
                                                      milliseconds: 100),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: const Color(
                                                            0xFFFF5722),
                                                        width: 1.5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    color: _isPressed
                                                        ? const Color(
                                                            0xFFFF5722)
                                                        : Colors.white,
                                                  ),
                                                  child: Text(
                                                    'Check-in',
                                                    style: TextStyle(
                                                      fontFamily: 'Mulish',
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: _isPressed
                                                          ? Colors.white
                                                          : const Color(
                                                              0xFFFF5722),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20), // Khoảng cách dưới cùng
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Tiêu đề và nút quay lại
          Positioned(
            top: 20,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Get.back(),
                ),
                const Text(
                  'Chương trình',
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
