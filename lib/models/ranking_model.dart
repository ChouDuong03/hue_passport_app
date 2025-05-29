class RankingModel {
  final int ngonNguID;
  final String maHoChieu;
  final String hoTen;
  final String tenDiaDiem;
  final String quocTich;
  final int diemKinhNghiem;
  final String? anhDaiDien;
  final int tongSoMonAnCheckIn;
  final int thoiGianHoanThanh;

  RankingModel({
    required this.ngonNguID,
    required this.maHoChieu,
    required this.hoTen,
    required this.tenDiaDiem,
    required this.quocTich,
    required this.diemKinhNghiem,
    this.anhDaiDien,
    required this.tongSoMonAnCheckIn,
    required this.thoiGianHoanThanh,
  });

  factory RankingModel.fromJson(Map<String, dynamic> json) {
    return RankingModel(
      ngonNguID: json['ngonNguID'] as int,
      maHoChieu: json['maHoChieu'] as String,
      hoTen: json['hoTen'] as String,
      tenDiaDiem: json['tenDiaDiem'] as String,
      quocTich: json['quocTich'] as String,
      diemKinhNghiem: json['diemKinhNghiem'] as int,
      anhDaiDien: json['anhDaiDien'] as String?,
      tongSoMonAnCheckIn: json['tongSoMonAnCheckIn'] as int,
      thoiGianHoanThanh: json['thoiGianHoanThanh'] as int,
    );
  }
}
