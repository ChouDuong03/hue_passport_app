class ProgramProgress {
  final String tienDo;
  final bool isFinished;

  ProgramProgress({required this.tienDo, required this.isFinished});

  factory ProgramProgress.fromJson(Map<String, dynamic> json) {
    return ProgramProgress(
      tienDo: json['tienDo'] as String,
      isFinished: json['isFinished'] as bool,
    );
  }
}
