class UserInfoModel {
  final int? chuongTrinhThamGia; // Made nullable
  final int? diaDiemDaCheckIn; // Made nullable
  final int? thamGiaKyQuay; // Made nullable
  final int? trungThuong; // Made nullable
  final HoChieuHanhKhach? hoChieuHanhKhach; // Made nullable

  UserInfoModel({
    this.chuongTrinhThamGia,
    this.diaDiemDaCheckIn,
    this.thamGiaKyQuay,
    this.trungThuong,
    this.hoChieuHanhKhach,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      chuongTrinhThamGia: json['chuongTrinhThamGia'] as int?,
      diaDiemDaCheckIn: json['diaDiemDaCheckIn'] as int?,
      thamGiaKyQuay: json['thamGiaKyQuay'] as int?,
      trungThuong: json['trungThuong'] as int?,
      hoChieuHanhKhach: json['hoChieuHanhKhach'] != null
          ? HoChieuHanhKhach.fromJson(json['hoChieuHanhKhach'])
          : null,
    );
  }
}

class HoChieuHanhKhach {
  final String? duKhachID; // Made nullable
  final String? hoTen; // Made nullable
  final String? maHoChieu; // Made nullable
  final int? gioiTinh; // Made nullable
  final String? hopThu; // Made nullable
  final String? ngaySinh; // Made nullable
  final String? ngayTao; // Made nullable
  final String? ngayCapNhatCuoi; // Made nullable
  final String? tenQuocTich; // Made nullable
  final String? tenTinhThanh;
  final int? tinhThanhID;
  final int? quocTichID; // Made nullable
  final String? token;
  final List<dynamic>? roles;
  final String? avatar;
  final String? anhDaiDien; // Made nullable
  final int? totalChuongTrinhThamGia;
  final int? totalDiaDiemDaCheckIn;
  final int? totalThamGiaKyQuay;
  final int? totalTrungThuong;
  final String? diaChi;
  final String? soDienThoai;
  final int? loaiTaiKhoan; // Made nullable

  HoChieuHanhKhach({
    this.duKhachID,
    this.hoTen,
    this.maHoChieu,
    this.gioiTinh,
    this.hopThu,
    this.ngaySinh,
    this.ngayTao,
    this.ngayCapNhatCuoi,
    this.tenQuocTich,
    this.tinhThanhID,
    this.tenTinhThanh,
    this.quocTichID,
    this.token,
    this.roles,
    this.avatar,
    this.anhDaiDien,
    this.totalChuongTrinhThamGia,
    this.totalDiaDiemDaCheckIn,
    this.totalThamGiaKyQuay,
    this.totalTrungThuong,
    this.diaChi,
    this.soDienThoai,
    this.loaiTaiKhoan,
  });

  factory HoChieuHanhKhach.fromJson(Map<String, dynamic> json) {
    return HoChieuHanhKhach(
      duKhachID: json['duKhachID'] as String?,
      hoTen: json['hoTen'] as String?,
      maHoChieu: json['maHoChieu'] as String?,
      gioiTinh: json['gioiTinh'] as int?,
      hopThu: json['hopThu'] as String?,
      ngaySinh: json['ngaySinh'] as String?,
      ngayTao: json['ngayTao'] as String?,
      ngayCapNhatCuoi: json['ngayCapNhatCuoi'] as String?,
      tenQuocTich: json['tenQuocTich'] as String?,
      tenTinhThanh: json['tenTinhThanh'] as String?,
      tinhThanhID: json['tinhThanhID'] as int?,
      quocTichID: json['quocTichID'] as int?,
      token: json['token'] as String?,
      roles: json['roles'] as List<dynamic>?,
      avatar: json['avatar'] as String?,
      anhDaiDien: json['anhDaiDien'] as String?,
      totalChuongTrinhThamGia: json['totalChuongTrinhThamGia'] as int?,
      totalDiaDiemDaCheckIn: json['totalDiaDiemDaCheckIn'] as int?,
      totalThamGiaKyQuay: json['totalThamGiaKyQuay'] as int?,
      totalTrungThuong: json['totalTrungThuong'] as int?,
      diaChi: json['diaChi'] as String?,
      soDienThoai: json['soDienThoai'] as String?,
      loaiTaiKhoan: json['loaiTaiKhoan'] as int?,
    );
  }
}
