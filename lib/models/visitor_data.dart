class Visitor {
  final String name;
  final String mhc;
  final String program;
  final String country;
  final String location;
  final String avatarUrl;

  Visitor({
    required this.name,
    required this.mhc,
    required this.program,
    required this.country,
    required this.location,
    required this.avatarUrl,
  });

  factory Visitor.fromJson(Map<String, dynamic> json) {
    return Visitor(
      name: json['name'],
      mhc: json['mhc'],
      program: json['program'],
      country: json['country'],
      location: json['location'],
      avatarUrl: json['avatarUrl'] ?? '',
    );
  }
}
