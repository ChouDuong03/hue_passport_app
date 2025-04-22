import 'package:get/get.dart';
import '../models/home_data.dart';
import '../services/home_api_service.dart';

class HomeController extends GetxController {
  var isLoading = true.obs;
  var homeData = Rxn<HomeData>();

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  void fetchData() async {
    try {
      isLoading(true);
      var data = await HomeApiService.fetchHomeData();
      homeData.value = data;
    } catch (e) {
      print('Error loading data: $e');
    } finally {
      isLoading(false);
    }
  }
}
