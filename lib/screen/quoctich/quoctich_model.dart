class NationalityResponse {
  final bool isSuccessed;
  final String message;
  final List<Nationality> resultObj;

  NationalityResponse({
    required this.isSuccessed,
    required this.message,
    required this.resultObj,
  });

  factory NationalityResponse.fromJson(Map<String, dynamic> json) {
    return NationalityResponse(
      isSuccessed: json['isSuccessed'],
      message: json['message'],
      resultObj: List<Nationality>.from(
        json['resultObj'].map((x) => Nationality.fromJson(x)),
      ),
    );
  }
}

class Nationality {
  final int quocTichID;
  final String tenQuocTich;

  Nationality({
    required this.quocTichID,
    required this.tenQuocTich,
  });

  factory Nationality.fromJson(Map<String, dynamic> json) {
    return Nationality(
      quocTichID: json['quocTichID'],
      tenQuocTich: json['tenQuocTich'],
    );
  }
}
