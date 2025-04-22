import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/home_data.dart';

class HomeApiService {
  static Future<HomeData> fetchHomeData() async {
    final response = await http.get(Uri.parse(
        'https://run.mocky.io/v3/ff568805-5f13-4422-9bec-da45afa8726d'));

    if (response.statusCode == 200) {
      return HomeData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load home data');
    }
  }
}
