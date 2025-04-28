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
//final String? quocTich;
  // final String? tinhThanh;

  ResultObj({
    this.accessToken,
    this.refreshToken,
    // this.quocTich,
    //   this.tinhThanh,
  });

  factory ResultObj.fromJson(Map<String, dynamic> json) {
    return ResultObj(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      // quocTich: json['quocTich'],
      //  tinhThanh: json['tinhThanh'],
    );
  }
}
