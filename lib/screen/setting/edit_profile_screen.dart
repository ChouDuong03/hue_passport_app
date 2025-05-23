import 'package:flutter/material.dart';
import 'package:hue_passport_app/services/program_food_api_service.dart';
import 'package:hue_passport_app/screen/quoctich/quoctich_model.dart';
import 'package:hue_passport_app/screen/quoctich/quoctich_service.dart';
import 'package:hue_passport_app/models/user_info_model.dart';
import 'package:hue_passport_app/screen/login/secure_storage_service.dart'; // Import SecureStorageService

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _birthDateController = TextEditingController();
  String? _gender;
  Nationality? _selectedNationality;
  late Future<List<Nationality>> _nationalitiesFuture;
  late Future<UserInfoModel> _userInfoFuture;

  final ProgramFoodApiService _apiService = ProgramFoodApiService();
  final SecureStorageService _storageService = SecureStorageService();

  @override
  void initState() {
    super.initState();

    // Lấy danh sách quốc tịch
    _nationalitiesFuture = NationalityApi.fetchNationalities();

    // Lấy thông tin người dùng
    _userInfoFuture = _apiService.getUserInfo();
    _userInfoFuture.then((userInfo) {
      final hoChieu = userInfo.hoChieuHanhKhach ?? HoChieuHanhKhach();
      setState(() {
        _nameController.text = hoChieu.hoTen ?? '';
        _phoneController.text = hoChieu.soDienThoai ?? '';
        _addressController.text = hoChieu.diaChi ?? '';
        _birthDateController.text = hoChieu.ngaySinh != null
            ? hoChieu.ngaySinh!.split('T')[0].split('-').reversed.join('/')
            : '';
        _gender = hoChieu.gioiTinh != null
            ? _getGenderString(hoChieu.gioiTinh!)
            : 'Nam';

        // Tìm quốc tịch tương ứng từ danh sách
        _nationalitiesFuture.then((nationalities) {
          setState(() {
            _selectedNationality = hoChieu.quocTichID != null
                ? nationalities.firstWhere(
                    (n) => n.quocTichID == hoChieu.quocTichID,
                    orElse: () => nationalities.firstWhere(
                      (n) => n.tenQuocTich == 'Việt Nam',
                      orElse: () => nationalities.first,
                    ),
                  )
                : nationalities.firstWhere(
                    (n) => n.tenQuocTich == 'Việt Nam',
                    orElse: () => nationalities.first,
                  );
          });
        });
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tải thông tin người dùng: $error')),
      );
    });
  }

  String _getGenderString(int? gender) {
    switch (gender) {
      case 0:
        return 'Nam';
      case 1:
        return 'Nữ';
      case 2:
        return 'Khác';
      default:
        return 'Nam';
    }
  }

  int _getGenderValue(String gender) {
    switch (gender) {
      case 'Nam':
        return 0;
      case 'Nữ':
        return 1;
      case 'Khác':
        return 2;
      default:
        return 0;
    }
  }

  String? _validateBirthDate(String? value) {
    if (value == null || value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập ngày sinh')),
      );
      return null;
    }
    final parts = value.split('/');
    if (parts.length != 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Định dạng phải là ngày/tháng/năm (DD/MM/YYYY)')),
      );
      return null;
    }
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ngày không hợp lệ')),
      );
      return null;
    }
    if (month < 1 || month > 12) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tháng không hợp lệ')),
      );
      return null;
    }
    if (day < 1 || day > 31) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ngày không hợp lệ')),
      );
      return null;
    }
    final date = DateTime(year, month, day);
    if (date.isAfter(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ngày sinh không được trong tương lai')),
      );
      return null;
    }
    return value; // Giữ nguyên định dạng DD/MM/YYYY
  }

  Future<void> _saveChanges() async {
    final birthDate = _validateBirthDate(_birthDateController.text);
    if (birthDate == null) return; // Exit if validation fails
    if (_selectedNationality == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn quốc tịch!')),
      );
      return;
    }
    if (_gender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn giới tính!')),
      );
      return;
    }

    final hoTen = _nameController.text.isEmpty ? '' : _nameController.text;
    final ngaySinh = birthDate ?? '';
    final diaChi =
        _addressController.text.isEmpty ? '' : _addressController.text;
    final soDienThoai =
        _phoneController.text.isEmpty ? '' : _phoneController.text;

    if (hoTen.isEmpty || ngaySinh.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Họ tên và ngày sinh không được để trống!')),
      );
      return;
    }

    try {
      print('Sending data to API:');
      print('hoTen: $hoTen');
      print('gioiTinh: ${_getGenderValue(_gender!)}');
      print('ngaySinh: $ngaySinh');
      print('quocTich: ${_selectedNationality!.quocTichID}');
      print('diaChi: $diaChi');
      print('soDienThoai: $soDienThoai');

      final isSuccess = await _apiService.updateUserInfo(
        hoTen: hoTen,
        gioiTinh: _getGenderValue(_gender!),
        ngaySinh: ngaySinh,
        quocTich: _selectedNationality!.quocTichID,
        diaChi: diaChi,
        soDienThoai: soDienThoai,
      );

      if (isSuccess) {
        // Refresh token after successful update
        final newAccessToken = await _storageService.refreshAccessToken();
        if (newAccessToken != null) {
          print('New access token saved: $newAccessToken');
        } else {
          print('Failed to refresh token');
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cập nhật thông tin thành công!')),
        );
        Navigator.pop(context); // Return to ProfileScreen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cập nhật thông tin thất bại!')),
        );
      }
    } catch (e) {
      print('Error during API call: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F7FF),
      appBar: AppBar(
        title: const Text('Chỉnh sửa thông tin cá nhân'),
        backgroundColor: const Color(0xFF0066FF),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<UserInfoModel>(
        future: _userInfoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Không có dữ liệu người dùng'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Họ và tên',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextFormField(controller: _nameController),
                  const SizedBox(height: 16),
                  const Text('Giới tính',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: ['Nam', 'Nữ', 'Khác'].map((value) {
                      return Row(
                        children: [
                          Radio<String>(
                            value: value,
                            groupValue: _gender,
                            onChanged: (newValue) {
                              setState(() {
                                _gender = newValue;
                              });
                            },
                          ),
                          Text(value),
                        ],
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text('Ngày sinh',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextFormField(
                    controller: _birthDateController,
                    decoration: const InputDecoration(
                      hintText: 'Định dạng: ngày/tháng/năm (DD/MM/YYYY)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.datetime,
                  ),
                  const SizedBox(height: 16),
                  const Text('Số điện thoại',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextFormField(controller: _phoneController),
                  const SizedBox(height: 16),
                  const Text('Địa chỉ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextFormField(controller: _addressController),
                  const SizedBox(height: 16),
                  const Text('Quốc tịch',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  FutureBuilder<List<Nationality>>(
                    future: _nationalitiesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Lỗi: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text('Không có dữ liệu quốc tịch');
                      }

                      final nationalities = snapshot.data!;
                      return DropdownButton<Nationality>(
                        value: _selectedNationality,
                        hint: const Text('Chọn quốc tịch'),
                        items: nationalities.map((Nationality nationality) {
                          return DropdownMenuItem<Nationality>(
                            value: nationality,
                            child: Text(nationality.tenQuocTich),
                          );
                        }).toList(),
                        onChanged: (Nationality? newValue) {
                          setState(() {
                            _selectedNationality = newValue;
                          });
                        },
                        isExpanded: true,
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _saveChanges,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00CC66),
                          ),
                          child: const Text('Đồng ý'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Hủy'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
