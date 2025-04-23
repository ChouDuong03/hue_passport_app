class ProgramData {
  final String title;
  final String imageUrl;
  final int locationCount;
  final int participants;
  final String description;
  final List<String> locationImages;

  ProgramData({
    required this.title,
    required this.imageUrl,
    required this.locationCount,
    required this.participants,
    required this.description,
    required this.locationImages,
  });

  factory ProgramData.fromJson(Map<String, dynamic> json) {
    return ProgramData(
      title: json['title'],
      imageUrl: json['imageUrl'],
      locationCount: json['locationCount'],
      participants: int.parse(json['participants'].toString()),
      description: json['description'],
      locationImages: List<String>.from(json['locationImages']),
    );
  }
}
