import 'package:get/get.dart';
import 'package:hue_passport_app/models/dish_model.dart';
import 'package:hue_passport_app/models/program_food_detail_model.dart';
import 'package:hue_passport_app/models/program_food_model.dart';
import 'package:hue_passport_app/services/program_food_api_service.dart';

class ProgramFoodController extends GetxController {
  var programs = <ProgramFoodModel>[].obs;
  var programDetailsCache = <int, ProgramFoodDetailModel>{}.obs;
  var dishesCache = <int, List<DishModel>>{}.obs; // Cache danh sách món ăn
  var isLoading = false.obs; // Loading cho danh sách chương trình
  var isLoadingDetail = false.obs; // Loading cho chi tiết chương trình
  var isLoadingDishes = false.obs; // Loading cho danh sách món ăn
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

  // Lấy danh sách món ăn theo chương trình
  Future<void> fetchDishesByProgram(int chuongTrinhID) async {
    if (dishesCache.containsKey(chuongTrinhID))
      return; // Tránh gọi lại nếu đã có
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
}
