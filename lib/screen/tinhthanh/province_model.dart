// tinhthanh_model.dart

class Province {
  final int id;
  final String name;

  Province({required this.id, required this.name});

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      id: json['tinhThanhID'],
      name: json['tenTinhThanh'],
    );
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
