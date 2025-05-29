// tinhthanh_model.dart

class Province {
  final int id;
  final String tenDiaPhuong;

  Province({required this.id, required this.tenDiaPhuong});

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      id: json['id'],
      tenDiaPhuong: json['tenDiaPhuong'],
    );
  }
}

class ProvinceResponse {
  final bool isSuccessed;
  final String message;
  final List<Province> resultObj;

  ProvinceResponse({
    required this.isSuccessed,
    required this.message,
    required this.resultObj,
  });

  factory ProvinceResponse.fromJson(Map<String, dynamic> json) {
    return ProvinceResponse(
      isSuccessed: json['isSuccessed'],
      message: json['message'],
      resultObj: List<Province>.from(
        json['resultObj'].map((x) => Province.fromJson(x)),
      ),
    );
  }
}
