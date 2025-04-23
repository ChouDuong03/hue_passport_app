import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/home_data.dart';

class HomeApiService {
  static Future<HomeData> fetchHomeData() async {
    final response = await http.get(Uri.parse(
        'https://run.mocky.io/v3/40327d98-ee17-4d7d-8bd1-b383c84f8a4b'));

    if (response.statusCode == 200) {
      return HomeData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load home data');
    }
  }
}
