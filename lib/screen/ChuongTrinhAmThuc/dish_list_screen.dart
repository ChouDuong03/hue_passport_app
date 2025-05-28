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
          // Phần tiêu đề với nút quay lại (nằm cố định)
          Container(
            height: 60,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/border2.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Get.back(),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Chương trình',
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Để cân đối với IconButton
                ],
              ),
            ),
          ),
          // Phần nội dung có thể cuộn
          Padding(
            padding: const EdgeInsets.only(
                top: 60), // Đẩy nội dung xuống dưới tiêu đề
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(top: 12),
                decoration: const BoxDecoration(
                  color: Color(0xFFFDF6FC),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                                return GestureDetector(
                                  onTap: () {
                                    // Chuyển đến trang chi tiết khi bấm vào bất kỳ đâu trong widget
                                    Get.to(() => DishDetailScreen(dish: dish));
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // Ảnh đại diện
                                        CircleAvatar(
                                          radius: 24,
                                          backgroundImage: dish
                                                  .anhDaiDien.isNotEmpty
                                              ? NetworkImage(
                                                  'https://localhost:52126${dish.anhDaiDien}')
                                              : const AssetImage(
                                                      'assets/images/default_image.png')
                                                  as ImageProvider,
                                        ),
                                        const SizedBox(width: 12),
                                        // Tên món ăn và trạng thái check-in
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
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              dish.isCheckedIn
                                                  ? const Text(
                                                      'Đã checkin',
                                                      style: TextStyle(
                                                        fontFamily: 'Mulish',
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.green,
                                                      ),
                                                    )
                                                  : GestureDetector(
                                                      onTapDown: (_) =>
                                                          setState(() =>
                                                              _isPressed =
                                                                  true),
                                                      onTapUp: (_) => setState(
                                                          () => _isPressed =
                                                              false),
                                                      onTapCancel: () =>
                                                          setState(() =>
                                                              _isPressed =
                                                                  false),
                                                      onTap: () {
                                                        // Chuyển đến trang chi tiết khi bấm nút
                                                        Get.to(() =>
                                                            DishDetailScreen(
                                                                dish: dish));
                                                      },
                                                      child: AnimatedContainer(
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    100),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 12,
                                                                vertical: 4),
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color: const Color(
                                                                  0xFFFF5722),
                                                              width: 1.5),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          color: _isPressed
                                                              ? const Color(
                                                                  0xFFFF5722)
                                                              : Colors.white,
                                                        ),
                                                        child: Text(
                                                          'Check in',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Mulish',
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
                                        const SizedBox(width: 12),
                                      ],
                                    ),
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
            ),
          ),
        ],
      ),
    );
  }
}
