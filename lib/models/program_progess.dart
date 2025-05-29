class ProgramProgress {
  final String tienDo;
  final bool isFinished;
  final List<int> listMocHanhTrinh;

  ProgramProgress({
    required this.tienDo,
    required this.isFinished,
    required this.listMocHanhTrinh,
  });

  factory ProgramProgress.fromJson(Map<String, dynamic> json) {
    return ProgramProgress(
      tienDo: json['tienDo'] as String,
      isFinished: json['isFinished'] as bool,
      listMocHanhTrinh: List<int>.from(json['listSoMonToiThieu'] as List),
    );
  }
}
