import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hue_passport_app/screen/quoctich/quoctich_model.dart';
import 'package:hue_passport_app/screen/quoctich/quoctich_service.dart';
import 'package:hue_passport_app/screen/register/register_service_api.dart';
import 'package:hue_passport_app/screen/tinhthanh/province_model.dart';
import 'package:hue_passport_app/screen/tinhthanh/province_api_service.dart';
import 'package:hue_passport_app/widgets/register_success_diaglog.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final dobController = TextEditingController();

  var gender = 'Nam'.obs;
  var nationalities = <Nationality>[].obs;
  var provinces = <Province>[].obs;

  var selectedNationality = Rxn<Nationality>();
  var selectedProvince = Rxn<Province>();

  var showProvinceField = true.obs;

  final RegisterApiService registerApiService = RegisterApiService();

  @override
  void onInit() {
    super.onInit();
    fetchNationalities();
  }

  Future<void> fetchNationalities() async {
    try {
      final fetched = await NationalityApi.fetchNationalities();
      nationalities.assignAll(fetched);

      final vn =
          fetched.firstWhereOrNull((n) => n.quocTichID == 1); // ID của Việt Nam

      if (vn != null) {
        selectedNationality.value = vn;
        showProvinceField.value = true;
        fetchProvinces();
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải quốc tịch');
    }
  }

  Future<void> fetchProvinces() async {
    try {
      final fetched = await ProvinceApiService.fetchProvinces();
      provinces.assignAll(fetched);
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải tỉnh thành');
    }
  }

  void onSelectNationality(Nationality? nationality) {
    selectedNationality.value = nationality;
    if (nationality != null) {
      bool isVietnamese = nationality.quocTichID == 1;
      showProvinceField.value = isVietnamese;
      if (isVietnamese) {
        fetchProvinces();
      }
    }
  }

  Future<void> register() async {
    try {
      if (nameController.text.trim().isEmpty ||
          emailController.text.trim().isEmpty ||
          dobController.text.trim().isEmpty ||
          selectedNationality.value == null ||
          (showProvinceField.value && selectedProvince.value == null)) {
        Get.snackbar('Lỗi', 'Vui lòng nhập đầy đủ thông tin');
        return;
      }

      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final result = await registerApiService.register(
        hoTen: nameController.text.trim(),
        gioiTinh: gender.value == 'Nam' ? 0 : 1,
        ngaySinh: dobController.text.trim(),
        hopThu: emailController.text.trim(),
        quocTichID: selectedNationality.value!.quocTichID,
        tinhThanhID:
            showProvinceField.value ? selectedProvince.value?.id ?? 0 : 0,
      );

      Get.back(); // đóng loading

      if (result != null) {
        showSuccessDialog(emailController.text.trim());
      } else {
        Get.snackbar('Thất bại', 'Đăng ký không thành công, vui lòng thử lại');
      }
    } catch (e) {
      Get.back(); // đóng loading nếu lỗi
      Get.snackbar('Đăng ký thất bại', e.toString());
    }
  }

  void showSuccessDialog(String email) {
    Get.dialog(
      RegisterSuccessDialog(
        email: email,
        onClose: () {
          Get.back(); // Đóng dialog
          Get.offAllNamed('/login'); // Chuyển về màn login
        },
      ),
      barrierDismissible: false,
    );
  }
}
