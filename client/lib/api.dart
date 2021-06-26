import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tidraw/model/draw.dart';

Future<Draw> fetchDraw(String id) async {
  final response = await http.get(Uri.parse('http://localhost:8080/api/draws/' + id));
  if (response.statusCode == 200) {
    return Draw.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load draw');
  }
}
