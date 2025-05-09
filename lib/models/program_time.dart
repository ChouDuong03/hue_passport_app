class ProgramTime {
  final DateTime thoiGianThamGia;
  final DateTime thoiHanHoanThanh;
  final bool isExpired;

  ProgramTime({
    required this.thoiGianThamGia,
    required this.thoiHanHoanThanh,
    required this.isExpired,
  });

  factory ProgramTime.fromJson(Map<String, dynamic> json) {
    return ProgramTime(
      thoiGianThamGia: DateTime.parse(json['thoiGianThamGia'] as String),
      thoiHanHoanThanh: DateTime.parse(json['thoiHanHoanThanh'] as String),
      isExpired: json['isExpired'] as bool,
    );
  }
}
