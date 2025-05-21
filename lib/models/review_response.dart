// review_model.dart
class ReviewResponse {
  final bool isSuccessed;
  final String message;
  final List<ReviewModel2> resultObj;

  ReviewResponse({
    required this.isSuccessed,
    required this.message,
    required this.resultObj,
  });

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    return ReviewResponse(
      isSuccessed: json['isSuccessed'] ?? false,
      message: json['message'] ?? '',
      resultObj: (json['resultObj'] as List<dynamic>?)
              ?.map((item) => ReviewModel2.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class ReviewModel2 {
  final String danhGiaID;
  final String duKhachID;
  final String hoTen; // Thêm trường hoTen
  final int chuongTrinhID;
  final DateTime ngayDanhGia;
  final int quanAnID;
  final int monAnID;
  final int ngonNguID;
  final String noiDungDanhGia;

  ReviewModel2({
    required this.danhGiaID,
    required this.duKhachID,
    required this.hoTen,
    required this.chuongTrinhID,
    required this.ngayDanhGia,
    required this.quanAnID,
    required this.monAnID,
    required this.ngonNguID,
    required this.noiDungDanhGia,
  });

  factory ReviewModel2.fromJson(Map<String, dynamic> json) {
    return ReviewModel2(
      danhGiaID: json['danhGiaID'] ?? '',
      duKhachID: json['duKhachID'] ?? '',
      hoTen: json['hoTen'] ?? '', // Ánh xạ trường hoTen
      chuongTrinhID: json['chuongTrinhID'] ?? 0,
      ngayDanhGia: DateTime.parse(
          json['ngayDanhGia'] ?? DateTime.now().toIso8601String()),
      quanAnID: json['quanAnID'] ?? 0,
      monAnID: json['monAnID'] ?? 0,
      ngonNguID: json['ngonNguID'] ?? 0,
      noiDungDanhGia: json['noiDungDanhGia'] ?? '',
    );
  }
}
