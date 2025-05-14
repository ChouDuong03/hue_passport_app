import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hue_passport_app/controller/program_food_controller.dart';
import 'package:hue_passport_app/models/dish_detail_model.dart';
import 'package:hue_passport_app/models/dish_model.dart';
import 'package:hue_passport_app/models/location_model.dart';
import 'package:hue_passport_app/models/location_model_2.dart';
import 'package:hue_passport_app/screen/Camera/camera_screen.dart';
import 'package:hue_passport_app/screen/ChuongTrinhAmThuc/restaurant_detail_screen.dart';

class DishDetailScreen extends StatefulWidget {
  final DishModel dish;
  final ProgramFoodController controller = Get.find<ProgramFoodController>();

  DishDetailScreen({super.key, required this.dish}) {
    final int id = dish.id ?? 1;
    controller.fetchDishDetail(id);
    controller.fetchLocationsByDish2(id); // Lấy danh sách check-in
    controller.fetchLocationsByDish(id); // Lấy danh sách chi tiết địa điểm
  }

  @override
  State<DishDetailScreen> createState() => _DishDetailScreenState();
}

final baseUrl = "https://localhost:51512";

class _DishDetailScreenState extends State<DishDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.white),
                            onPressed: () => Get.back(),
                          ),
                          const Text(
                            'Món ăn trong chương trình',
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
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFDF6FC),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Obx(() {
                    if (widget.controller.isLoadingDishDetail.value ||
                        widget.controller.isLoadingLocations.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final detail =
                        widget.controller.dishDetailCache[widget.dish.id ?? 1];
                    if (detail == null || detail.childMonAnChiTiets.isEmpty) {
                      return const Center(
                          child: Text('Không thể tải chi tiết món ăn.'));
                    }

                    final childDetail = detail.childMonAnChiTiets.first;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.width * 0.5,
                                child: Image.network(
                                  "$baseUrl${widget.dish.anhDaiDien}",
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black.withOpacity(0.5),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 16,
                                left: 8,
                                child: Text(
                                  detail.tenMon,
                                  style: const TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black87,
                                        offset: Offset(2, 2),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        TabBar(
                          controller: _tabController,
                          labelColor: Colors.blue[700],
                          unselectedLabelColor: Colors.grey,
                          labelStyle: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          unselectedLabelStyle: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 16,
                          ),
                          indicatorColor: Colors.blue[700],
                          indicatorWeight: 3,
                          tabs: const [
                            Tab(text: 'Giới thiệu'),
                            Tab(text: 'Danh sách quán ăn'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${detail.tenMon} Huế',
                                      style: const TextStyle(
                                        fontFamily: 'Mulish',
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Loại món ăn: ${childDetail.tenLoai}',
                                      style: const TextStyle(
                                        fontFamily: 'Mulish',
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'Mô tả',
                                      style: TextStyle(
                                        fontFamily: 'Mulish',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      childDetail.moTa.trim(),
                                      style: const TextStyle(
                                        fontFamily: 'Mulish',
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'Thành phần',
                                      style: TextStyle(
                                        fontFamily: 'Mulish',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    ..._parseIngredients(childDetail.thanhPhan)
                                        .map((ingredient) => Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    '• ',
                                                    style: TextStyle(
                                                      fontFamily: 'Mulish',
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      ingredient.trim(),
                                                      style: const TextStyle(
                                                        fontFamily: 'Mulish',
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'Cách chế biến',
                                      style: TextStyle(
                                        fontFamily: 'Mulish',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    ..._parseSteps(childDetail.cachLam)
                                        .map((step) => Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    '• ',
                                                    style: TextStyle(
                                                      fontFamily: 'Mulish',
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      step,
                                                      style: const TextStyle(
                                                        fontFamily: 'Mulish',
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                    const SizedBox(height: 16),
                                    if (childDetail
                                        .khuyenNghiKhiDung.isNotEmpty) ...[
                                      const Text(
                                        'Khuyến nghị khi dùng',
                                        style: TextStyle(
                                          fontFamily: 'Mulish',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        childDetail.khuyenNghiKhiDung.trim(),
                                        style: const TextStyle(
                                          fontFamily: 'Mulish',
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                  ],
                                ),
                              ),
                              Obx(() {
                                final locations = widget.controller
                                        .locationsCache2[widget.dish.id ?? 1] ??
                                    [];
                                final locations1 = widget.controller
                                        .locationsCache[widget.dish.id ?? 1] ??
                                    [];

                                if (locations.isEmpty && locations1.isEmpty) {
                                  return const Center(
                                      child: Text('Không có địa điểm nào.'));
                                }

                                if (locations.length != locations1.length) {
                                  return const Center(
                                      child: Text(
                                          'Dữ liệu địa điểm không đồng bộ. Vui lòng thử lại sau.'));
                                }

                                return SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 8),
                                      ...locations.asMap().entries.map((entry) {
                                        int index = entry.key;
                                        var location = entry.value;
                                        var correspondingLocation =
                                            locations1[index];
                                        final detail = correspondingLocation
                                                .getDetailByLanguage(1) ??
                                            correspondingLocation
                                                .childGetDiaDiemByMonAns.first;
                                        return RestaurantItem(
                                          name: detail.tenDiaDiem,
                                          soNha:
                                              correspondingLocation.soNha ?? '',
                                          duongPho: detail.duongPho,
                                          hasCheckedIn: location.isCheckedIn,
                                          location: correspondingLocation,
                                          monAnId: location.monAnID,
                                          chuongTrinhId: location.chuongTrinhID,
                                          quanAnId: location.quanAnID,
                                        );
                                      }),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                        const SizedBox(height: 80),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<String> _parseSteps(String text) {
    final steps = text.split('\r\nBước ').where((s) => s.isNotEmpty).toList();
    if (steps.isNotEmpty) {
      steps[0] = steps[0].replaceFirst('\r\n', '');
      for (int i = 0; i < steps.length; i++) {
        if (!steps[i].trim().startsWith('Bước ')) {
          steps[i] = 'Bước ${steps[i].trim()}';
        }
      }
    }
    return steps.map((s) => s.trim()).toList();
  }

  List<String> _parseIngredients(String text) {
    return text.split(';').map((s) => s.trim()).toList();
  }
}

class RestaurantItem extends StatelessWidget {
  final String name;
  final String soNha;
  final String duongPho;
  final bool hasCheckedIn;
  final LocationModel location;
  final int monAnId;
  final int chuongTrinhId;
  final int quanAnId;

  const RestaurantItem({
    super.key,
    required this.name,
    required this.soNha,
    required this.duongPho,
    required this.hasCheckedIn,
    required this.location,
    required this.monAnId,
    required this.chuongTrinhId,
    required this.quanAnId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.to(() => RestaurantDetailScreen(
                                restaurant: location,
                                monAnId: monAnId,
                                chuongTrinhId: chuongTrinhId,
                                isCheckedIn: hasCheckedIn,
                              ));
                        },
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    if (!hasCheckedIn)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: ElevatedButton(
                          onPressed: () {
                            Get.toNamed('/fake-camera', parameters: {
                              'monAnId': monAnId.toString(),
                              'diadiemId': quanAnId.toString(),
                              'chuongTrinhId': chuongTrinhId.toString(),
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00C853),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(100, 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            'Check-in',
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    if (hasCheckedIn)
                      const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Icon(
                          Icons.check_circle,
                          color: Color(0xFF00C853),
                          size: 20,
                        ),
                      ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    Get.to(() => RestaurantDetailScreen(
                          restaurant: location,
                          monAnId: monAnId,
                          chuongTrinhId: chuongTrinhId,
                          isCheckedIn: hasCheckedIn,
                        ));
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '$soNha $duongPho',
                          style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CheckInPlaceholderScreen extends StatelessWidget {
  final DishModel dish;

  const CheckInPlaceholderScreen({super.key, required this.dish});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-in'),
        backgroundColor: const Color(0xFF00C853),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Trang Check-in cho món: ${dish.tenMon}',
              style: const TextStyle(
                fontFamily: 'Mulish',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Đây là placeholder. Bạn có thể phát triển chức năng check-in tại đây.',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C853),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'Quay lại',
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
