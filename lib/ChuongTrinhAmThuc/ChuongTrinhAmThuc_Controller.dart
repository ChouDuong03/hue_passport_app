import 'package:get/get.dart';
import 'package:hue_passport_app/ChuongTrinhAmThuc/ChuongTrinhAmThucModel.dart';
import 'package:hue_passport_app/ChuongTrinhAmThuc/ChuongTrinhAmThuc_Service.dart';

class ChuongTrinhController extends GetxController {
  var programs = <ChuongTrinhAmThuc>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  void fetchData() async {
    isLoading(true);
    try {
      var fetched = await ChuongTrinhAmThucService().fetchChuongTrinh();
      programs.value = fetched;
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }
}
