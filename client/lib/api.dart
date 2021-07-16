import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tidraw/model/draw.dart';

// API_URL has to be specified when debugging or building the application using the argument "--dart-define=API_URL=<http://example.com>"
const String API_URL = String.fromEnvironment('API_URL');

Future<Draw> getDraw(String id) async {
  final response = await http.get(Uri.parse(API_URL + '/api/draws/' + id));
  if (response.statusCode == 200) {
    return Draw.fromJson(jsonDecode(response.body));
  } else {
    // TODO
    throw Exception('Failed to load draw');
  }
}

Future<Draw> putDraw(Draw draw) async {
  final response = await http.post(
    Uri.parse(API_URL + '/api/draws'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(draw),
  );
  if (response.statusCode == 201) {
    return Draw.fromJson(jsonDecode(response.body));
  } else {
    // TODO
    throw Exception('Failed to create draw');
  }
}
