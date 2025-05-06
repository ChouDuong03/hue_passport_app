// tinhthanh_model.dart

class Province {
  final int id;
  final String tenDiaPhuong;
  final String moTa;

  Province({required this.id, required this.tenDiaPhuong, required this.moTa});

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
        id: json['id'], tenDiaPhuong: json['tenDiaPhuong'], moTa: json['moTa']);
  }
}

class ProvinceResponse {
  final List<Province> resultObj;

  ProvinceResponse({required this.resultObj});

  factory ProvinceResponse.fromJson(Map<String, dynamic> json) {
    return ProvinceResponse(
      resultObj: List<Province>.from(
          json['resultObj'].map((x) => Province.fromJson(x))),
    );
  }
}
