import 'package:get/get.dart';
import '../models/detail_model.dart';

class FoodDetailController extends GetxController {
  final detail = Rxn<DetailModel>();

  void loadDetail(DetailModel data) {
    detail.value = data;
  }
}
