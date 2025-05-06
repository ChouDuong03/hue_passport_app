class LoginResponse {
  final bool isSuccessed;
  final String message;
  final ResultObj? resultObj;

  LoginResponse({
    required this.isSuccessed,
    required this.message,
    this.resultObj,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      isSuccessed: json['isSuccessed'] ?? false,
      message: json['message'] ?? '',
      resultObj: json['resultObj'] != null
          ? ResultObj.fromJson(json['resultObj'])
          : null,
    );
  }
}

class ResultObj {
  final String? accessToken;
  final String? refreshToken;
  final int? tinhThanhID;
  final int? quocTichID;

  ResultObj({
    this.accessToken,
    this.refreshToken,
    this.tinhThanhID,
    this.quocTichID,
  });

  factory ResultObj.fromJson(Map<String, dynamic> json) {
    return ResultObj(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      tinhThanhID: json['tinhThanhID'],
      quocTichID: json['quocTichID'],
    );
  }
}
