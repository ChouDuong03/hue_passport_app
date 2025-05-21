// experience_stats_model.dart
class ExperienceStatsResponse {
  final bool isSuccessed;
  final String message;
  final List<ExperienceStatsModel> resultObj;

  ExperienceStatsResponse({
    required this.isSuccessed,
    required this.message,
    required this.resultObj,
  });

  factory ExperienceStatsResponse.fromJson(Map<String, dynamic> json) {
    return ExperienceStatsResponse(
      isSuccessed: json['isSuccessed'] ?? false,
      message: json['message'] ?? '',
      resultObj: (json['resultObj'] as List<dynamic>?)
              ?.map((item) => ExperienceStatsModel.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class ExperienceStatsModel {
  final String duKhachID;
  final String hoTen;
  final int diemKinhNghiem;
  final String anhDaiDien;
  final int chuongTrinhID;
  final int monAnID;
  final int quanAnID;

  ExperienceStatsModel({
    required this.duKhachID,
    required this.hoTen,
    required this.diemKinhNghiem,
    required this.anhDaiDien,
    required this.chuongTrinhID,
    required this.monAnID,
    required this.quanAnID,
  });

  factory ExperienceStatsModel.fromJson(Map<String, dynamic> json) {
    return ExperienceStatsModel(
      duKhachID: json['duKhachID'] ?? '',
      hoTen: json['hoTen'] ?? '',
      diemKinhNghiem: json['diemKinhNghiem'] ?? 0,
      anhDaiDien: json['anhDaiDien'] ?? '',
      chuongTrinhID: json['chuongTrinhID'] ?? 0,
      monAnID: json['monAnID'] ?? 0,
      quanAnID: json['quanAnID'] ?? 0,
    );
  }
}
