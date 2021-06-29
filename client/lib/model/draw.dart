import 'package:intl/intl.dart';

class Draw {
  final int? id;
  final String name;
	final DateTime? creationInstant;
  final DateTime? lastModifiedInstant;
  final DateTime? drawInstant;
  final int selectedElementsSize;
  final List<String> raffleElements;
  final List<String>? selectedElements;

  Draw({
    this.id,
    required this.name,
    this.creationInstant,
    this.lastModifiedInstant,
    required this.drawInstant,
    required this.selectedElementsSize,
    required this.raffleElements,
    this.selectedElements,
  });

  factory Draw.fromJson(Map<String, dynamic> json) {
    return Draw(
      id: json['id'],
      name: json['name'],
      creationInstant: DateTime.parse(json['creationInstant']),
      lastModifiedInstant: DateTime.parse(json['lastModifiedInstant']),
      drawInstant: (json['drawInstant'] != null) ? DateTime.parse(json['drawInstant']) : null,
      selectedElementsSize: json['selectedElementsSize'],
      raffleElements: json['raffleElements'].map<String>((element) => element as String).toList(),
      selectedElements: (json['selectedElements'] != null) ? json['selectedElements'].map<String>((element) => element as String).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'creationInstant': (creationInstant != null) ? DateFormat('YYYY-MM-DD''T''HH:mm:ss.SSS''Z').format(creationInstant!) : null,
      'lastModifiedInstant': (lastModifiedInstant != null) ? DateFormat('YYYY-MM-DD''T''HH:mm:ss.SSS''Z').format(lastModifiedInstant!) : null,
      'drawInstant': (drawInstant != null) ? DateFormat('YYYY-MM-DD''T''HH:mm:ss.SSS''Z').format(drawInstant!) : null,
      'selectedElementsSize': selectedElementsSize,
      'raffleElements': raffleElements,
      'selectedElements': selectedElements,
    };
  }
}