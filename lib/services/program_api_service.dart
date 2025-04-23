import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/program_data.dart';

class ProgramApiService {
  static Future<List<ProgramData>> fetchPrograms() async {
    final response = await http.get(Uri.parse(
        'https://run.mocky.io/v3/ac0eff64-0fe9-4bac-a994-69852ee0a460'));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => ProgramData.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load programs');
    }
  }
}
