class DishModel {
  final int? id;
  final String tenMon;
  final int maLoai;
  final int kieuMon;
  final bool thucUong;
  final int amThucId;
  final String anhDaiDien;
  final int ngonNguID;

  DishModel({
    required this.id,
    required this.tenMon,
    required this.maLoai,
    required this.kieuMon,
    required this.thucUong,
    required this.amThucId,
    required this.anhDaiDien,
    required this.ngonNguID,
  });

  factory DishModel.fromJson(Map<String, dynamic> json) {
    return DishModel(
      id: json['id'],
      tenMon: json['tenMon'],
      maLoai: json['maLoai'],
      kieuMon: json['kieuMon'],
      thucUong: json['thucUong'],
      amThucId: json['amThucId'],
      anhDaiDien: json['anhDaiDien'],
      ngonNguID: json['ngonNguID'],
    );
  }
}
