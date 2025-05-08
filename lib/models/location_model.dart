class LocationModel {
  final int id;
  final String? anhDaiDien;
  final String tenDiaDiem;
  final int hangSao;
  final int dienTichMatBang;
  final int soTang;
  final String? soDienThoai;
  final String? fax;
  final String? email;
  final String? website;
  final String? hoTenNguoiDaiDien;
  final String? thoiDiemBatDauKinhDoanh;
  final String gioDongCua;
  final String gioMoCua;
  final int toaDoX;
  final int toaDoY;
  final int banKinhQuyUoc;
  final int phuongXaId;
  final int quanHuyenId;
  final int tinhThanhId;
  final String? maDoanhNghiep;
  final int ngonNguID;
  final String soNha;
  final String duongPho;

  LocationModel({
    required this.id,
    this.anhDaiDien,
    required this.tenDiaDiem,
    required this.hangSao,
    required this.dienTichMatBang,
    required this.soTang,
    this.soDienThoai,
    this.fax,
    this.email,
    this.website,
    this.hoTenNguoiDaiDien,
    this.thoiDiemBatDauKinhDoanh,
    required this.gioDongCua,
    required this.gioMoCua,
    required this.toaDoX,
    required this.toaDoY,
    required this.banKinhQuyUoc,
    required this.phuongXaId,
    required this.quanHuyenId,
    required this.tinhThanhId,
    this.maDoanhNghiep,
    required this.ngonNguID,
    required this.soNha,
    required this.duongPho,
  });

  // Chuyển từ JSON sang LocationModel
  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] as int,
      anhDaiDien: json['anhDaiDien'] as String?,
      tenDiaDiem: json['tenDiaDiem'] as String,
      hangSao: json['hangSao'] as int,
      dienTichMatBang: json['dienTichMatBang'] as int,
      soTang: json['soTang'] as int,
      soDienThoai: json['soDienThoai'] as String?,
      fax: json['fax'] as String?,
      email: json['email'] as String?,
      website: json['website'] as String?,
      hoTenNguoiDaiDien: json['hoTenNguoiDaiDien'] as String?,
      thoiDiemBatDauKinhDoanh: json['thoiDiemBatDauKinhDoanh'] as String?,
      gioDongCua: json['gioDongCua'] as String,
      gioMoCua: json['gioMoCua'] as String,
      toaDoX: json['toaDoX'] as int,
      toaDoY: json['toaDoY'] as int,
      banKinhQuyUoc: json['banKinhQuyUoc'] as int,
      phuongXaId: json['phuongXaId'] as int,
      quanHuyenId: json['quanHuyenId'] as int,
      tinhThanhId: json['tinhThanhId'] as int,
      maDoanhNghiep: json['maDoanhNghiep'] as String?,
      ngonNguID: json['ngonNguID'] as int,
      soNha: json['soNha'] as String,
      duongPho: json['duongPho'] as String,
    );
  }

  // Chuyển từ LocationModel sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'anhDaiDien': anhDaiDien,
      'tenDiaDiem': tenDiaDiem,
      'hangSao': hangSao,
      'dienTichMatBang': dienTichMatBang,
      'soTang': soTang,
      'soDienThoai': soDienThoai,
      'fax': fax,
      'email': email,
      'website': website,
      'hoTenNguoiDaiDien': hoTenNguoiDaiDien,
      'thoiDiemBatDauKinhDoanh': thoiDiemBatDauKinhDoanh,
      'gioDongCua': gioDongCua,
      'gioMoCua': gioMoCua,
      'toaDoX': toaDoX,
      'toaDoY': toaDoY,
      'banKinhQuyUoc': banKinhQuyUoc,
      'phuongXaId': phuongXaId,
      'quanHuyenId': quanHuyenId,
      'tinhThanhId': tinhThanhId,
      'maDoanhNghiep': maDoanhNghiep,
      'ngonNguID': ngonNguID,
      'soNha': soNha,
      'duongPho': duongPho,
    };
  }
}
