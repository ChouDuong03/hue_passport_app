import 'package:get/get.dart';
import 'package:hue_passport_app/models/dish_model.dart';
import 'package:hue_passport_app/models/dish_detail_model.dart';
import 'package:hue_passport_app/models/program_food_detail_model.dart';
import 'package:hue_passport_app/models/program_food_model.dart';
import 'package:hue_passport_app/models/top_checkin_user_model.dart';
import 'package:hue_passport_app/models/location_model.dart';
import 'package:hue_passport_app/services/program_food_api_service.dart';

class ProgramFoodController extends GetxController {
  var programs = <ProgramFoodModel>[].obs;
  var programDetailsCache = <int, ProgramFoodDetailModel>{}.obs;
  var dishesCache = <int, List<DishModel>>{}.obs;
  var dishDetailCache = <int, DishDetailModel>{}.obs;
  var topCheckInUsers = <TopCheckInUserModel>[].obs;
  var locationsCache = <int, List<LocationModel>>{}.obs; // Cache theo dishId
  var isLoading = false.obs;
  var isLoadingDetail = false.obs;
  var isLoadingDishes = false.obs;
  var isLoadingTopUsers = false.obs;
  var isLoadingDishDetail = false.obs;
  var isLoadingLocations = false.obs;
  final expandedProgramIds = <int>{}.obs;

  void toggleExpanded(int programId) {
    if (expandedProgramIds.contains(programId)) {
      expandedProgramIds.remove(programId);
    } else {
      expandedProgramIds.add(programId);
    }
  }

  @override
  void onInit() {
    fetchPrograms();
    fetchTop5CheckInUsers();
    super.onInit();
  }

  void fetchPrograms() async {
    isLoading.value = true;
    try {
      final data = await ProgramFoodApiService.fetchPrograms();
      programs.assignAll(data);
    } catch (e) {
      print('Error loading programs: $e');
    }
    isLoading.value = false;
  }

  Future<void> fetchProgramDetail(int id) async {
    if (programDetailsCache.containsKey(id)) return;
    isLoadingDetail.value = true;
    try {
      final detail = await ProgramFoodApiService.fetchProgramDetail(id);
      programDetailsCache[id] = detail;
    } catch (e) {
      print('Error loading program detail: $e');
    }
    isLoadingDetail.value = false;
  }

  Future<void> fetchDishDetail(int id) async {
    if (dishDetailCache.containsKey(id)) return;
    isLoadingDishDetail.value = true;
    try {
      final detail = await ProgramFoodApiService.fetchDishDetail(id);
      dishDetailCache[id] = detail;
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải chi tiết món ăn: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoadingDishDetail.value = false;
    }
  }

  Future<void> fetchDishesByProgram(int chuongTrinhID) async {
    if (dishesCache.containsKey(chuongTrinhID)) return;
    isLoadingDishes.value = true;
    try {
      final dishes =
          await ProgramFoodApiService.fetchDishesByProgram(chuongTrinhID);
      dishesCache[chuongTrinhID] = dishes;
    } catch (e) {
      print('Error loading dishes: $e');
    }
    isLoadingDishes.value = false;
  }

  Future<void> fetchTop5CheckInUsers() async {
    if (topCheckInUsers.isNotEmpty) return;
    isLoadingTopUsers.value = true;
    try {
      final users = await ProgramFoodApiService.fetchTop5CheckInUsers();
      topCheckInUsers.assignAll(users);
    } catch (e) {
      print('Error loading top check-in users: $e');
    }
    isLoadingTopUsers.value = false;
  }

  // Sửa để lấy danh sách địa điểm theo dishId
  Future<void> fetchLocationsByDish(int dishId) async {
    if (locationsCache.containsKey(dishId)) return;
    isLoadingLocations.value = true;
    try {
      final locations =
          await ProgramFoodApiService.fetchLocationsByDish(dishId);
      locationsCache[dishId] = locations;
    } catch (e) {
      print('Error loading locations: $e');
      Get.snackbar('Lỗi', 'Không thể tải danh sách địa điểm: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoadingLocations.value = false;
    }
  }
}
