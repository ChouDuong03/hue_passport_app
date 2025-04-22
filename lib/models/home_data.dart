class HomeData {
  final String userName;
  final int totalWinners;
  final int completePrograms;
  final int todayRegistration;
  final int totalPlaces;
  final String programTitle;
  final String programDescription;
  final double totalParticipants;

  HomeData({
    required this.userName,
    required this.totalWinners,
    required this.completePrograms,
    required this.todayRegistration,
    required this.totalPlaces,
    required this.programTitle,
    required this.programDescription,
    required this.totalParticipants,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) {
    return HomeData(
      userName: json['userName'],
      totalWinners: json['totalWinners'],
      completePrograms: json['completePrograms'], // fix key này
      todayRegistration: json['todayRegistration'],
      totalPlaces: json['totalPlaces'],
      programTitle: json['programTitle'],
      programDescription: json['programDescription'],
      totalParticipants: json['totalParticipants'].toDouble(),
    );
  }
}
