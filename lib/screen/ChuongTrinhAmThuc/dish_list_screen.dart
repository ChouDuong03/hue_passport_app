import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hue_passport_app/controller/program_food_controller.dart';
import 'package:hue_passport_app/models/program_time.dart';
import 'package:intl/intl.dart';
import 'package:hue_passport_app/screen/ChuongTrinhAmThuc/dish_detail_screen.dart';

class DishListScreen extends StatefulWidget {
  final int chuongTrinhID;
  final ProgramFoodController controller = Get.find<ProgramFoodController>();
  final ProgramTime time;

  DishListScreen({super.key, required this.chuongTrinhID, required this.time}) {
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
                  const SizedBox(width: 48),
                ],
              ),
            ),
          ),
          // Phần nội dung có thể cuộn
          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(top: 12),
                decoration: const BoxDecoration(
                  color: Color(0xFFFDF6FC),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  children: [
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
                          // Hiển thị thời gian
                          _buildDateRow(),
                          const SizedBox(height: 8),
                          // Hiển thị thông báo nếu chương trình đã hết hạn
                          if (widget.time.isExpired) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.orange[50], // Nền màu cam nhạt
                                border: Border.all(
                                    color: Colors.orange[200]!), // Viền cam
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.warning,
                                    color: Colors.orange,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Chương trình đã hết hạn',
                                    style: TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 14,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                          // Danh sách món ăn
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
                                    Get.to(() => DishDetailScreen(dish: dish));
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 24,
                                          backgroundImage: dish
                                                  .anhDaiDien.isNotEmpty
                                              ? NetworkImage(
                                                  'https://localhost:53963${dish.anhDaiDien}')
                                              : const AssetImage(
                                                      'assets/images/banhbeo.png')
                                                  as ImageProvider,
                                        ),
                                        const SizedBox(width: 12),
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
                                              // Kiểm tra trạng thái check-in và thời hạn chương trình
                                              if (dish.isCheckedIn) ...[
                                                const Text(
                                                  'Đã checkin',
                                                  style: TextStyle(
                                                    fontFamily: 'Mulish',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ] else if (widget
                                                  .time.isExpired) ...[
                                                // Nếu chương trình hết hạn, hiển thị nút "Chưa check in" màu xám
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color:
                                                            Colors.grey[400]!),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    color: Colors.grey[
                                                        300], // Nút màu xám
                                                  ),
                                                  child: const Text(
                                                    'Chưa check in',
                                                    style: TextStyle(
                                                      fontFamily: 'Mulish',
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ] else ...[
                                                // Nếu chưa hết hạn, hiển thị nút "Check in" màu cam
                                                GestureDetector(
                                                  onTapDown: (_) => setState(
                                                      () => _isPressed = true),
                                                  onTapUp: (_) => setState(
                                                      () => _isPressed = false),
                                                  onTapCancel: () => setState(
                                                      () => _isPressed = false),
                                                  onTap: () {
                                                    Get.to(() =>
                                                        DishDetailScreen(
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
                                                              0xFFFF5722)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      color: _isPressed
                                                          ? const Color(
                                                              0xFFFF5722)
                                                          : Colors.white,
                                                    ),
                                                    child: Text(
                                                      'Check in',
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
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.circle, color: Colors.orange, size: 10),
            const SizedBox(width: 4),
            Text(
              'Bắt đầu: ${DateFormat('dd/MM/yyyy').format(widget.time.thoiGianThamGia)}',
              style: const TextStyle(
                  fontSize: 12, fontFamily: 'Mulish', color: Colors.orange),
            ),
          ],
        ),
        const Icon(Icons.arrow_forward, color: Colors.black54, size: 16),
        Row(
          children: [
            const Icon(Icons.circle, color: Colors.green, size: 10),
            const SizedBox(width: 4),
            Text(
              'Kết thúc: ${DateFormat('dd/MM/yyyy').format(widget.time.thoiHanHoanThanh)}',
              style: const TextStyle(
                  fontSize: 12, fontFamily: 'Mulish', color: Colors.green),
            ),
          ],
        ),
      ],
    );
  }
}
