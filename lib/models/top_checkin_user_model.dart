class TopCheckInUserModel {
  final int ngonNguID;
  final String hoTen;
  final String tenQuan;
  final String anhDaiDien;

  TopCheckInUserModel({
    required this.ngonNguID,
    required this.hoTen,
    required this.tenQuan,
    required this.anhDaiDien,
  });

  factory TopCheckInUserModel.fromJson(Map<String, dynamic> json) {
    return TopCheckInUserModel(
      ngonNguID: json['ngonNguID'],
      hoTen: json['hoTen'],
      tenQuan: json['tenQuan'],
      anhDaiDien: json['anhDaiDien'],
    );
  }
}
