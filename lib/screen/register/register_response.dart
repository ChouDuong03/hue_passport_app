class RegisterResponse {
  final bool isSuccessed;
  final String message;
  final RegisterResultObj? resultObj;

  RegisterResponse({
    required this.isSuccessed,
    required this.message,
    this.resultObj,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      isSuccessed: json['isSuccessed'] ?? false,
      message: json['message'] ?? '',
      resultObj: json['resultObj'] != null
          ? RegisterResultObj.fromJson(json['resultObj'])
          : null,
    );
  }
}

class RegisterResultObj {
  final String? duKhachID;
  final String? hoTen;
  final String? maHoiChieu;
  final int? gioiTinh;
  final String? hopThu;
  final String? ngaySinh;
  final String? ngayTao;
  final String? ngayCapNhatCuoi;
  final String? tenQuocTich;
  final String? tenTinhThanh;
  final int? quocTichID;
  final String? token;
  final String? roles;
  final String? avatar;
  final String? anhDaiDien;
  final int? totalChuongTrinhThamGia;
  final int? totalDiaDiemDaCheckIn;
  final int? totalThamGiaQuay;
  final int? totalTrungThuong;
  final String? diaChi;
  final String? soDienThoai;
  final int? loaiTaiKhoan;

  RegisterResultObj({
    this.duKhachID,
    this.hoTen,
    this.maHoiChieu,
    this.gioiTinh,
    this.hopThu,
    this.ngaySinh,
    this.ngayTao,
    this.ngayCapNhatCuoi,
    this.tenQuocTich,
    this.tenTinhThanh,
    this.quocTichID,
    this.token,
    this.roles,
    this.avatar,
    this.anhDaiDien,
    this.totalChuongTrinhThamGia,
    this.totalDiaDiemDaCheckIn,
    this.totalThamGiaQuay,
    this.totalTrungThuong,
    this.diaChi,
    this.soDienThoai,
    this.loaiTaiKhoan,
  });

  factory RegisterResultObj.fromJson(Map<String, dynamic> json) {
    return RegisterResultObj(
      duKhachID: json['duKhachID'],
      hoTen: json['hoTen'],
      maHoiChieu: json['maHoiChieu'],
      gioiTinh: json['gioiTinh'],
      hopThu: json['hopThu'],
      ngaySinh: json['ngaySinh'],
      ngayTao: json['ngayTao'],
      ngayCapNhatCuoi: json['ngayCapNhatCuoi'],
      tenQuocTich: json['tenQuocTich'],
      tenTinhThanh: json['tenTinhThanh'],
      quocTichID: json['quocTichID'],
      token: json['token'],
      roles: json['roles'],
      avatar: json['avatar'],
      anhDaiDien: json['anhDaiDien'],
      totalChuongTrinhThamGia: json['totalChuongTrinhThamGia'],
      totalDiaDiemDaCheckIn: json['totalDiaDiemDaCheckIn'],
      totalThamGiaQuay: json['totalThamGiaQuay'],
      totalTrungThuong: json['totalTrungThuong'],
      diaChi: json['diaChi'],
      soDienThoai: json['soDienThoai'],
      loaiTaiKhoan: json['loaiTaiKhoan'],
    );
  }
}
