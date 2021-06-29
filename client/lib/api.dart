import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tidraw/model/draw.dart';

Future<Draw> getDraw(String id) async {
  final response = await http.get(Uri.parse('http://localhost:8080/api/draws/' + id));
  if (response.statusCode == 200) {
    return Draw.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load draw');
  }
}

Future<Draw> putDraw(Draw draw) async {
  final response = await http.post(
    Uri.parse('http://localhost:8080/api/draws'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(draw),
  );
  if (response.statusCode == 200) {
    return Draw.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create draw');
  }
}
