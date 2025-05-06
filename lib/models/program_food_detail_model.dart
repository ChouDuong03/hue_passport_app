class ProgramFoodDetailModel {
  final int chuongTrinhID;
  final String anhDaiDien;
  final int soNguoiThamGia;
  final List<ChillChuongTrinh> details;

  ProgramFoodDetailModel({
    required this.chuongTrinhID,
    required this.anhDaiDien,
    required this.soNguoiThamGia,
    required this.details,
  });

  factory ProgramFoodDetailModel.fromJson(Map<String, dynamic> json) {
    var detailList = (json['chillChuongTrinhAmThucs'] as List)
        .map((e) => ChillChuongTrinh.fromJson(e))
        .toList();
    return ProgramFoodDetailModel(
      chuongTrinhID: json['chuongTrinhID'] ?? 0,
      anhDaiDien: json['anhDaiDien'],
      soNguoiThamGia: json['soNguoiThamGia'],
      details: detailList,
    );
  }
}

class ChillChuongTrinh {
  final int noiDungID;
  final String gioiThieu;
  final String tenChuongTrinh;

  ChillChuongTrinh({
    required this.noiDungID,
    required this.gioiThieu,
    required this.tenChuongTrinh,
  });

  factory ChillChuongTrinh.fromJson(Map<String, dynamic> json) {
    return ChillChuongTrinh(
      noiDungID: json['noiDungID'],
      gioiThieu: json['gioiThieu'],
      tenChuongTrinh: json['tenChuongTrinh'],
    );
  }
}
