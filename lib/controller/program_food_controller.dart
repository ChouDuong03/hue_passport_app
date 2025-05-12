import 'package:get/get.dart';
import 'package:hue_passport_app/models/dish_model.dart';
import 'package:hue_passport_app/models/dish_detail_model.dart';
import 'package:hue_passport_app/models/location_model_2.dart';
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
  var locationsCache = <int, List<LocationModel>>{}.obs;
  var locationsCache2 = <int, List<LocationModel2>>{}.obs; // Cache theo dishId
  var isLoading = false.obs;
  var isLoadingDetail = false.obs;
  var isLoadingDishes = false.obs;
  var isLoadingTopUsers = false.obs;
  var isLoadingDishDetail = false.obs;
  var isLoadingLocations = false.obs;
  final expandedProgramIds = <int>{}.obs;

  // Khởi tạo instance của ProgramFoodApiService
  final ProgramFoodApiService apiService = ProgramFoodApiService();

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

  Future<void> fetchPrograms() async {
    isLoading.value = true;
    try {
      final data = await apiService.fetchPrograms();
      programs.assignAll(data);
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải danh sách chương trình: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchProgramDetail(int id) async {
    if (programDetailsCache.containsKey(id)) return;
    isLoadingDetail.value = true;
    try {
      final detail = await apiService.fetchProgramDetail(id);
      if (detail != null) {
        programDetailsCache[id] = detail;
      } else {
        throw Exception('Không tìm thấy chi tiết chương trình');
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải chi tiết chương trình: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoadingDetail.value = false;
    }
  }

  Future<void> fetchDishDetail(int id) async {
    if (dishDetailCache.containsKey(id)) return;
    isLoadingDishDetail.value = true;
    try {
      final detail = await apiService.fetchDishDetail(id);
      if (detail != null) {
        dishDetailCache[id] = detail;
      } else {
        throw Exception('Không tìm thấy chi tiết món ăn');
      }
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
      final dishes = await apiService.fetchDishesByProgram(chuongTrinhID);
      if (dishes != null && dishes.isNotEmpty) {
        dishesCache[chuongTrinhID] = dishes;
      } else {
        throw Exception('Không tìm thấy danh sách món ăn');
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải danh sách món ăn: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoadingDishes.value = false;
    }
  }

  Future<void> fetchTop5CheckInUsers() async {
    if (topCheckInUsers.isNotEmpty) return;
    isLoadingTopUsers.value = true;
    try {
      final users = await apiService.fetchTop5CheckInUsers();
      if (users != null && users.isNotEmpty) {
        topCheckInUsers.assignAll(users);
      } else {
        throw Exception('Không tìm thấy danh sách người dùng check-in');
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải danh sách người dùng check-in: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoadingTopUsers.value = false;
    }
  }

  Future<void> fetchLocationsByDish(int dishId) async {
    if (locationsCache.containsKey(dishId)) return;
    isLoadingLocations.value = true;
    try {
      final locations = await apiService.fetchLocationsByDish(dishId);
      if (locations != null && locations.isNotEmpty) {
        locationsCache[dishId] = locations;
      } else {
        throw Exception('Không tìm thấy danh sách địa điểm');
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải danh sách địa điểm: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoadingLocations.value = false;
    }
  }

  Future<void> fetchLocationsByDish2(int dishId) async {
    if (locationsCache2.containsKey(dishId)) return;
    isLoadingLocations.value = true;
    try {
      final locations = await apiService.fetchLocationsByDish2(dishId);
      if (locations != null && locations.isNotEmpty) {
        locationsCache2[dishId] = locations;
      } else {
        throw Exception('Không tìm thấy danh sách địa điểm');
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải danh sách địa điểm: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoadingLocations.value = false;
    }
  }
}
