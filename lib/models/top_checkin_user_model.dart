class TopCheckInUserModel {
  final String duKhachID;
  final int ngonNguID;
  final String hoTen;
  final String tenQuan;
  final String anhDaiDien;
  // Thêm thuộc tính duKhachID kiểu String

  TopCheckInUserModel({
    required this.duKhachID,
    required this.ngonNguID,
    required this.hoTen,
    required this.tenQuan,
    required this.anhDaiDien,
    // Yêu cầu duKhachID trong constructor
  });

  factory TopCheckInUserModel.fromJson(Map<String, dynamic> json) {
    return TopCheckInUserModel(
      duKhachID: json['duKhachID'] ?? '',
      ngonNguID: json['ngonNguID'] ?? 0, // Thêm giá trị mặc định nếu null
      hoTen: json['hoTen'] ?? '', // Thêm giá trị mặc định nếu null
      tenQuan: json['tenQuan'] ?? '', // Thêm giá trị mặc định nếu null
      anhDaiDien: json['anhDaiDien'] ?? '', // Thêm giá trị mặc định nếu null
      // Lấy duKhachID từ JSON, mặc định là chuỗi rỗng nếu null
    );
  }
}
