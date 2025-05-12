class LocationModel2 {
  final int chuongTrinhID;
  final int quanAnID;
  final int monAnID;
  final String soNha;
  final String duongPho;
  final String ten;
  final int ngonNguID;
  final bool isCheckedIn;

  LocationModel2({
    required this.chuongTrinhID,
    required this.quanAnID,
    required this.monAnID,
    required this.soNha,
    required this.duongPho,
    required this.ten,
    required this.ngonNguID,
    required this.isCheckedIn,
  });

  // Chuyển từ JSON sang CheckInRecordModel
  factory LocationModel2.fromJson(Map<String, dynamic> json) {
    return LocationModel2(
      chuongTrinhID: json['chuongTrinhID'] as int,
      quanAnID: json['quanAnID'] as int,
      monAnID: json['monAnID'] as int,
      soNha: json['soNha'] as String,
      duongPho: json['duongPho'] as String,
      ngonNguID: json['ngonNguID'] as int,
      ten: json['ten'] as String,
      isCheckedIn: json['isCheckedIn'] == 1, // Chuyển 1/0 thành true/false
    );
  }

  // Chuyển từ CheckInRecordModel sang JSON (nếu cần)
  Map<String, dynamic> toJson() {
    return {
      'chuongTrinhID': chuongTrinhID,
      'quanAnID': quanAnID,
      'monAnID': monAnID,
      'soNha': soNha,
      'duongPho': duongPho,
      'ten': ten,
      'ngonNguID': ngonNguID,
      'isCheckedIn': isCheckedIn ? 1 : 0,
    };
  }
}
