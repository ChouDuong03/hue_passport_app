import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/home_data.dart';

class ApiService {
  static Future<HomeData> fetchHomeData() async {
    final response = await http.get(Uri.parse(
        'https://run.mocky.io/v3/596d77ab-0bec-4781-b1c5-e0243ac8e242'));

    if (response.statusCode == 200) {
      return HomeData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load home data');
    }
  }
}
