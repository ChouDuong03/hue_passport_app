import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hue_passport_app/controller/food_controller.dart';
import 'package:hue_passport_app/models/food_model.dart';
import 'package:intl/intl.dart';

class FoodScreen extends StatefulWidget {
  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  final FoodController controller = Get.put(FoodController());
  RxList<bool> showFullDescriptionList = <bool>[].obs;

  @override
  void initState() {
    super.initState();
    ever<List<FoodModel>>(controller.foodList, (list) {
      showFullDescriptionList.value = List.generate(list.length, (_) => false);
    });
  }

// THAY THẾ TOÀN BỘ build() TRONG _FoodScreenState:
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
          itemCount: controller.foodList.length,
          itemBuilder: (context, index) {
            final food = controller.foodList[index];

            return Stack(
              children: [
                // Nền đầu trang
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: Image.asset(
                    'assets/images/border2.png',
                    fit: BoxFit.cover,
                  ),
                ),

                // Nội dung chính
                SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 40),

                      // Header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Text(
                              'Ẩm thực',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Mulish',
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
                                  radius: 18,
                                  backgroundImage: AssetImage(
                                      'assets/images/avatar_user.png'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

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
                                      food.image,
                                      width: double.infinity,
                                      height: 180,
                                      fit: BoxFit.cover,
                                    ),
                                  ),

                                  // Dot indicator (giả lập, bạn có thể dùng package carousel)
                                  const Positioned(
                                    bottom: 40,
                                    left: 0,
                                    right: 0,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 4,
                                          backgroundColor: Colors.white,
                                        ),
                                        SizedBox(width: 4),
                                        CircleAvatar(
                                          radius: 4,
                                          backgroundColor: Colors.grey,
                                        ),
                                        SizedBox(width: 4),
                                        CircleAvatar(
                                          radius: 4,
                                          backgroundColor: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Nút "Tham gia trò chơi"
                                  Positioned(
                                    bottom: 12,
                                    left: 16,
                                    right: 16,
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFFF9966),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(24),
                                        ),
                                      ),
                                      child: const Text(
                                        'Tham gia trò chơi',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Mulish'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.restaurant,
                                            color: Colors.red, size: 16),
                                        const SizedBox(width: 4),
                                        Text('${food.dishCount} Món ăn',
                                            style: const TextStyle(
                                                color: Color(0xFF008FFF),
                                                fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.people,
                                            color: Colors.green, size: 16),
                                        const SizedBox(width: 4),
                                        Text(
                                            '${numberFormat.format(food.participantCount)} Tham gia',
                                            style: const TextStyle(
                                                color: Color(0xFF008FFF),
                                                fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  food.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Mulish',
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Obx(() {
                                  final isExpanded =
                                      controller.expandList.length > index
                                          ? controller.expandList[index].value
                                          : false;

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        food.description,
                                        maxLines: isExpanded ? null : 3,
                                        overflow: isExpanded
                                            ? TextOverflow.visible
                                            : TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Color(0xFF234874)),
                                      ),
                                      const SizedBox(height: 4),
                                      GestureDetector(
                                        onTap: () =>
                                            controller.toggleExpand(index),
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
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Tiêu đề ảnh món ăn
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                color: Color(0xFFB3E5FC),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Món ăn trong chương trình',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                fontFamily: 'Mulish',
                                color: Color(0xFF234874),
                              ),
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
                          itemCount: food.foodImages.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(right: 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  food.foodImages[index],
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

                      // Nút "Xem chi tiết"
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00C88F),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            onPressed: () {
                              // TODO: Chuyển trang chi tiết
                            },
                            child: const Text(
                              'Xem chi tiết',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      }),
    );
  }
}
