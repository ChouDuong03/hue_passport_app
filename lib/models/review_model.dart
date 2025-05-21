// review_model.dart
class ReviewModel {
  final int chuongTrinhID;
  final int quanAnID;
  final int monAnID;
  final int ngonNguID;
  final String noiDungDanhGia;

  ReviewModel({
    required this.chuongTrinhID,
    required this.quanAnID,
    required this.monAnID,
    required this.ngonNguID,
    required this.noiDungDanhGia,
  });

  // Chuyển từ JSON sang ReviewModel
  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      chuongTrinhID: json['chuongTrinhID'] ?? 0,
      quanAnID: json['quanAnID'] ?? 0,
      monAnID: json['monAnID'] ?? 0,
      ngonNguID: json['ngonNguID'] ?? 0,
      noiDungDanhGia: json['noiDungDanhGia'] ?? '',
    );
  }

  // Chuyển từ ReviewModel sang JSON
  Map<String, dynamic> toJson() {
    return {
      'chuongTrinhID': chuongTrinhID,
      'quanAnID': quanAnID,
      'monAnID': monAnID,
      'ngonNguID': ngonNguID,
      'noiDungDanhGia': noiDungDanhGia,
    };
  }
}
