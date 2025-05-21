class DishModel {
  final int? id; // Có thể ánh xạ từ monAnID
  final int chuongTrinhID; // Thêm để theo chuongTrinhID
  final String tenMon;
  final int maLoai;
  final int kieuMon;
  final bool thucUong;
  final int amThucId;
  final String anhDaiDien;
  final int ngonNguID;
  final bool isCheckedIn; // Thêm trạng thái check-in từ API

  DishModel({
    this.id,
    required this.chuongTrinhID,
    required this.tenMon,
    required this.maLoai,
    required this.kieuMon,
    required this.thucUong,
    required this.amThucId,
    required this.anhDaiDien,
    required this.ngonNguID,
    required this.isCheckedIn,
  });

  factory DishModel.fromJson(Map<String, dynamic> json) {
    return DishModel(
      id: json['monAnID'] ?? json['id'], // Sử dụng monAnID làm id nếu có
      chuongTrinhID: json['chuongTrinhID'] as int,
      tenMon: json['ten'] as String, // Lấy từ 'ten' trong API
      maLoai: json['maLoai'] ?? 0, // Giả định mặc định nếu không có
      kieuMon: json['kieuMon'] ?? 0, // Giả định mặc định nếu không có
      thucUong: json['thucUong'] ?? false, // Giả định mặc định nếu không có
      amThucId: json['amThucId'] ?? 0, // Giả định mặc định nếu không có
      anhDaiDien: json['anhDaiDienQuanAn'] ??
          json['anhDaiDienChuongTrinh'] ??
          '', // Lấy từ API
      ngonNguID: json['ngonNguID'] ?? 1, // Lấy từ API hoặc mặc định
      isCheckedIn: json['isCheckedIn'] == true ||
          json['isCheckedIn'] == 1 ||
          json['isCheckedIn'] == 'true', // Xử lý trạng thái check-in
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chuongTrinhID': chuongTrinhID,
      'tenMon': tenMon,
      'maLoai': maLoai,
      'kieuMon': kieuMon,
      'thucUong': thucUong,
      'amThucId': amThucId,
      'anhDaiDien': anhDaiDien,
      'ngonNguID': ngonNguID,
      'isCheckedIn': isCheckedIn ? 1 : 0,
    };
  }
}
