import 'package:get/get.dart';
import 'package:hue_passport_app/models/program_food_detail_model.dart';
import 'package:hue_passport_app/models/program_food_model.dart';
import 'package:hue_passport_app/services/program_food_api_service.dart';

class ProgramFoodController extends GetxController {
  var programs = <ProgramFoodModel>[].obs;
  var programDetailsCache = <int, ProgramFoodDetailModel>{}.obs;
  var isLoading = false.obs;
  var isLoadingDetail = false.obs;
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
}
