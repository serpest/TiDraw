import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:tidraw/model/draw.dart';
import 'package:tidraw/utils/constants.dart' as constants;

Future<Draw> getDraw(String id) async {
  try {
    final response = await http.get(Uri.parse(constants.API_URL + '/api/draws/' + id));
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

Future<DateTime> getNoEditableInstant(String id) async {
  try {
    final response = await http.get(Uri.parse(constants.API_URL + '/api/draws/' + id + '/no-editable-instant'));
    if (response.statusCode == 200) {
      return DateTime.parse(jsonDecode(response.body)['instant']);
    } else if (response.statusCode == 404) {
      throw ApiException('Draw not found');
    } else {
      // TODO
      throw Exception('Failed to check editability');
    }
  } on TimeoutException {
    throw ApiException('Connection timed out');
  } on SocketException {
    throw ApiException('Connection failed');
  }
}

Future<bool> deleteDraw(String id) async {
  try {
    final response = await http.delete(Uri.parse(constants.API_URL + '/api/draws/' + id));
    if (response.statusCode == 204) {
      return true;
    } else if (response.statusCode == 404) {
      throw ApiException('Draw not found');
    } else if (response.statusCode == 410) {
      throw ApiException('Draw no longer deletable');
    } else {
      // TODO
      throw Exception('Failed to check editability');
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
      Uri.parse(constants.API_URL + '/api/draws'),
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

Future<Draw> replaceDraw(Draw draw) async {
  try {
    assert (draw.id != null);
    final response = await http.put(
      Uri.parse(constants.API_URL + '/api/draws/' + draw.id!.toString()),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(draw),
    );
    if (response.statusCode == 201) {
      return Draw.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 410) {
      throw ApiException('Draw no longer editable');
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
