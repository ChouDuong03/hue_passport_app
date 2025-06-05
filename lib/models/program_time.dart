class ProgramTime {
  final DateTime? thoiGianThamGia;
  final DateTime? thoiHanHoanThanh;
  final bool? isExpired;

  ProgramTime({
    required this.thoiGianThamGia,
    required this.thoiHanHoanThanh,
    required this.isExpired,
  });

  factory ProgramTime.fromJson(Map<String, dynamic> json) {
    final thoiGianThamGia = DateTime.parse(json['thoiGianThamGia'] as String);
    final thoiHanHoanThanh = DateTime.parse(json['thoiGianKetThuc'] as String);
    final isExpired = DateTime.now()
        .isAfter(thoiHanHoanThanh); // Kiểm tra dựa trên ngày hiện tại
    return ProgramTime(
      thoiGianThamGia: thoiGianThamGia,
      thoiHanHoanThanh: thoiHanHoanThanh,
      isExpired: isExpired,
    );
  }
}
