class ChuongTrinhAmThuc {
  final int chuongTrinhID;
  final String tenChuongTrinh;
  final String anhDaiDien;
  final int soLuongMonAn;
  final int soNguoiThamGia;

  ChuongTrinhAmThuc({
    required this.chuongTrinhID,
    required this.tenChuongTrinh,
    required this.anhDaiDien,
    required this.soLuongMonAn,
    required this.soNguoiThamGia,
  });

  factory ChuongTrinhAmThuc.fromJson(Map<String, dynamic> json) {
    return ChuongTrinhAmThuc(
      chuongTrinhID: json['chuongTrinhID'],
      tenChuongTrinh: json['tenChuongTrinh'],
      anhDaiDien: json['anhDaiDien'],
      soLuongMonAn: json['soLuongMonAn'],
      soNguoiThamGia: json['soNguoiThamGia'],
    );
  }
}
