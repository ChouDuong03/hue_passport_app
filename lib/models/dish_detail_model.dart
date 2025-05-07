class DishDetailModel {
  final String tenMon;
  final int kieuMon;
  final bool thucUong;
  final List<ChildMonAnChiTiet> childMonAnChiTiets;

  DishDetailModel({
    required this.tenMon,
    required this.kieuMon,
    required this.thucUong,
    required this.childMonAnChiTiets,
  });

  factory DishDetailModel.fromJson(Map<String, dynamic> json) {
    final resultObj = json['resultObj'] as Map<String, dynamic>?;
    if (resultObj == null) {
      throw Exception('resultObj is null');
    }
    return DishDetailModel(
      tenMon: resultObj['tenMon'] ?? '',
      kieuMon: resultObj['kieuMon'] ?? 0,
      thucUong: resultObj['thucUong'] ?? false,
      childMonAnChiTiets: (resultObj['childMonAnChiTiets'] as List? ?? [])
          .map((e) => ChildMonAnChiTiet.fromJson(e))
          .toList(),
    );
  }
}

class ChildMonAnChiTiet {
  final String moTa;
  final String cachLam;
  final String thanhPhan;
  final String khuyenNghiKhiDung;
  final String tenLoai;
  final int? ngonNguID;

  ChildMonAnChiTiet({
    required this.moTa,
    required this.cachLam,
    required this.thanhPhan,
    required this.khuyenNghiKhiDung,
    required this.tenLoai,
    required this.ngonNguID,
  });

  factory ChildMonAnChiTiet.fromJson(Map<String, dynamic> json) {
    return ChildMonAnChiTiet(
      moTa: json['moTa'] ?? '',
      cachLam: json['cachLam'] ?? '',
      thanhPhan: json['thanhPhan'] ?? '',
      khuyenNghiKhiDung: json['khuyenNghiKhiDung'] ?? '',
      tenLoai: json['tenLoai'] ?? '',
      ngonNguID: json['ngonNguID'],
    );
  }
}
