import 'package:get/get.dart';
import '../models/program_data.dart';
import '../services/program_api_service.dart';

class ProgramController extends GetxController {
  var isLoading = true.obs;
  var programList = <ProgramData>[].obs;
  var expandList = <RxBool>[].obs;

  @override
  void onInit() {
    fetchPrograms();
    super.onInit();
  }

  Future<void> fetchPrograms() async {
    try {
      isLoading.value = true;
      final result = await ProgramApiService.fetchPrograms();
      programList.value = result;
      expandList.value = List.generate(result.length, (_) => false.obs);
    } catch (e) {
      Get.snackbar("Lỗi", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void toggleExpand(int index) {
    if (index >= 0 && index < expandList.length) {
      expandList[index].toggle();
    }
  }
}
