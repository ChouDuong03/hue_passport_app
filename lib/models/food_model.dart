class FoodModel {
  final String name;
  final String description;
  final String image;
  final int participantCount;
  final int dishCount;
  final List<String> foodImages;

  FoodModel({
    required this.name,
    required this.description,
    required this.image,
    required this.participantCount,
    required this.dishCount,
    required this.foodImages,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      name: json['name'],
      description: json['description'],
      image: json['image'],
      participantCount: json['participant_count'] ?? 0,
      dishCount: json['dish_count'] ?? 0,
      foodImages: List<String>.from(json['foodImages']),
    );
  }
}
