import 'package:get/get.dart';
import '../models/visitor_data.dart';
import '../services/visitor_api_service.dart';

class VisitorController extends GetxController {
  var isLoading = true.obs;
  var visitorList = <Visitor>[].obs;

  @override
  void onInit() {
    fetchVisitors();
    super.onInit();
  }

  void fetchVisitors() async {
    try {
      isLoading(true);
      final visitors = await VisitorApiService.fetchVisitors();
      visitorList.value = visitors;
    } finally {
      isLoading(false);
    }
  }
}
