import 'package:flutter/material.dart';
import 'package:hue_passport_app/screen/setting/edit_profile_screen.dart';
import 'package:hue_passport_app/services/program_food_api_service.dart';
import 'package:hue_passport_app/models/user_info_model.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<UserInfoModel> _userInfoFuture;

  @override
  void initState() {
    super.initState();
    _userInfoFuture = ProgramFoodApiService().getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6FF), // Xanh dương nhạt
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Thông tin cá nhân',
            style: TextStyle(fontWeight: FontWeight.bold)),
        leading: const BackButton(color: Colors.white),
      ),
      body: FutureBuilder<UserInfoModel>(
        future: _userInfoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error loading user info: ${snapshot.error}');
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Không có dữ liệu'));
          }

          final userInfo = snapshot.data!;
          final hoChieu = userInfo.hoChieuHanhKhach ??
              HoChieuHanhKhach(
                duKhachID: null,
                hoTen: null,
                maHoChieu: null,
                gioiTinh: null,
                hopThu: null,
                ngaySinh: null,
                ngayTao: null,
                ngayCapNhatCuoi: null,
                tenQuocTich: null,
                quocTichID: null,
                anhDaiDien: null,
                loaiTaiKhoan: null,
              );

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: hoChieu.anhDaiDien != null &&
                            hoChieu.anhDaiDien!.isNotEmpty
                        ? NetworkImage(
                            'https://localhost:53963${hoChieu.anhDaiDien}')
                        : const AssetImage('assets/images/useravatar.png')
                            as ImageProvider,
                    onBackgroundImageError: (exception, stackTrace) {
                      print('Error loading avatar: $exception');
                    },
                    backgroundColor: Colors.grey.shade200,
                  ),
                  const SizedBox(height: 8),

                  // Họ tên + icon chỉnh sửa
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        hoChieu.hoTen ?? 'Chưa có thông tin',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const EditProfileScreen()),
                          ).then((_) {
                            setState(() {
                              _userInfoFuture =
                                  ProgramFoodApiService().getUserInfo();
                            });
                          });
                        },
                        child: Image.asset(
                          'assets/images/edit_icon.png',
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 30),

                  // Thông tin check-in
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Thông tin check in:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.orange)),
                  ),
                  _buildInfoRow(Icons.event, 'Chương trình tham gia:',
                      '${userInfo.chuongTrinhThamGia ?? 0}'),
                  _buildInfoRow(Icons.location_on, 'Địa điểm đã check in:',
                      '${userInfo.diaDiemDaCheckIn ?? 0}'),
                  _buildInfoRow(Icons.cameraswitch, 'Tham gia kỳ quay:',
                      '${userInfo.thamGiaKyQuay ?? 0}'),
                  _buildInfoRow(Icons.card_giftcard, 'Trúng thưởng:',
                      '${userInfo.trungThuong ?? 0}'),

                  const Divider(height: 30),

                  // Thông tin cá nhân
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Thông tin cá nhân:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.orange)),
                  ),
                  _buildInfoRow(Icons.badge, 'Mã hộ chiếu:',
                      hoChieu.maHoChieu?.trim() ?? 'Chưa có'),
                  _buildInfoRow(
                      Icons.person, 'Họ tên:', hoChieu.hoTen ?? 'Chưa có'),
                  _buildInfoRow(
                      Icons.male,
                      'Giới tính:',
                      hoChieu.gioiTinh != null
                          ? (hoChieu.gioiTinh == 0
                              ? 'Nam'
                              : hoChieu.gioiTinh == 1
                                  ? 'Nữ'
                                  : 'Khác')
                          : 'Chưa có'),
                  _buildInfoRow(
                      Icons.cake,
                      'Ngày sinh:',
                      hoChieu.ngaySinh != null
                          ? hoChieu.ngaySinh!
                              .split('T')[0]
                              .split('-')
                              .reversed
                              .join('/')
                          : 'Chưa có'),
                  _buildInfoRow(
                      Icons.email, 'Email:', hoChieu.hopThu ?? 'Chưa có'),
                  _buildInfoRow(Icons.flag, 'Quốc tịch:',
                      hoChieu.tenQuocTich ?? 'Chưa có'),
                  _buildInfoRow(Icons.home, 'Tỉnh thành:',
                      hoChieu.tenTinhThanh ?? 'Chưa có'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          const SizedBox(width: 8),
          Expanded(
              child: Text(title,
                  style: const TextStyle(fontWeight: FontWeight.bold))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
