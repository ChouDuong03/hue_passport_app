class ProgramFoodModel {
  final int chuongTrinhID;
  final String tenChuongTrinh;
  final String anhDaiDien;
  final int soLuongMonAn;
  final int soNguoiThamGia;

  ProgramFoodModel({
    required this.chuongTrinhID,
    required this.tenChuongTrinh,
    required this.anhDaiDien,
    required this.soLuongMonAn,
    required this.soNguoiThamGia,
  });

  factory ProgramFoodModel.fromJson(Map<String, dynamic> json) {
    return ProgramFoodModel(
      chuongTrinhID: json['chuongTrinhID'],
      tenChuongTrinh: json['tenChuongTrinh'],
      anhDaiDien: json['anhDaiDien'],
      soLuongMonAn: json['soLuongMonAn'],
      soNguoiThamGia: json['soNguoiThamGia'],
    );
  }
}
