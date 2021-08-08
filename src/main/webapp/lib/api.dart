import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:tidraw/model/draw.dart';

// API_URL has to be specified when debugging or building the application using the argument "--dart-define=API_URL=<http://example.com>"
const String API_URL = String.fromEnvironment('API_URL');

Future<Draw> getDraw(String id) async {
  try {
    final response = await http.get(Uri.parse(API_URL + '/api/draws/' + id));
    if (response.statusCode == 200) {
      return Draw.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      throw ApiException('Draw not found');
    } else {
      // TODO
      throw Exception('Failed to load draw');
    }
  } on TimeoutException {
    throw ApiException('Connection timed out');
  } on SocketException {
    throw ApiException('Connection failed');
  }
}

Future<Draw> createDraw(Draw draw) async {
  try {
    final response = await http.post(
      Uri.parse(API_URL + '/api/draws'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(draw),
    );
    if (response.statusCode == 201) {
      return Draw.fromJson(jsonDecode(response.body));
    } else {
      // TODO
      throw ApiException('Failed to create draw');
    }
  } on TimeoutException {
    throw ApiException('Connection timed out');
  } on SocketException {
    throw ApiException('Connection failed');
  }
}

Future<Draw> updateDraw(Draw draw) async {
  try {
    assert (draw.id != null);
    final response = await http.put(
      Uri.parse(API_URL + '/api/draws/' + draw.id!.toString()),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(draw),
    );
    if (response.statusCode == 201) {
      return Draw.fromJson(jsonDecode(response.body));
    } else {
      // TODO
      throw ApiException('Failed to update draw');
    }
  } on TimeoutException {
    throw ApiException('Connection timed out');
  } on SocketException {
    throw ApiException('Connection failed');
  }
}

class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  @override
  String toString() {
    return message;
  }
}
