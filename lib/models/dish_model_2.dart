class DishModel2 {
  final int chuongTrinhID;
  final int monAnID;
  final String tenMon;
  final int ngonNguID;
  final bool isCheckedIn;

  DishModel2({
    required this.chuongTrinhID,
    required this.monAnID,
    required this.tenMon,
    required this.ngonNguID,
    required this.isCheckedIn,
  });

  // Chuyển từ JSON sang DishModel2
  factory DishModel2.fromJson(Map<String, dynamic> json) {
    return DishModel2(
      chuongTrinhID: json['chuongTrinhID'] as int,
      monAnID: json['monAnID'] as int,
      ngonNguID: json['ngonNguID'] as int,
      tenMon: json['ten'] as String, // Lấy từ 'ten' trong API
      isCheckedIn: json['isCheckedIn'] == true ||
          json['isCheckedIn'] == 1 ||
          json['isCheckedIn'] == 'true', // Xử lý trạng thái check-in
    );
  }

  // Chuyển từ DishModel2 sang JSON
  Map<String, dynamic> toJson() {
    return {
      'chuongTrinhID': chuongTrinhID,
      'monAnID': monAnID,
      'tenMon': tenMon,
      'ngonNguID': ngonNguID,
      'isCheckedIn': isCheckedIn ? 1 : 0,
    };
  }
}
