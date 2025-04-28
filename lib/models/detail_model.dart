class DetailModel {
  final String id;
  final String name;
  final String image;
  final String description;
  final List<Restaurant> restaurants;

  DetailModel({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.restaurants,
  });
}

class Restaurant {
  final String name;
  final String address;

  Restaurant({required this.name, required this.address});
}
