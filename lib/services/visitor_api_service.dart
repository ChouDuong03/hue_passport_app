import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/visitor_data.dart';

class VisitorApiService {
  static Future<List<Visitor>> fetchVisitors() async {
    final url = Uri.parse(
        'https://run.mocky.io/v3/92817796-ea2e-49d4-91f0-c7c89be71556'); // thay bằng link mocky thật
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<Visitor> visitors = (jsonData['visitors'] as List)
          .map((item) => Visitor.fromJson(item))
          .toList();
      return visitors;
    } else {
      throw Exception('Failed to load visitor list');
    }
  }
}
