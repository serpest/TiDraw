class Draw {
  final String? id;
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
    this.drawInstant,
    required this.selectedElementsSize,
    required this.raffleElements,
    this.selectedElements,
  });

  factory Draw.fromJson(Map<String, dynamic> json) {
    return Draw(
      id: json['id'],
      name: json['name'],
      creationInstant: (json['creationInstant'] != null) ? DateTime.parse(json['creationInstant']) : null,
      lastModifiedInstant: (json['lastModifiedInstant'] != null) ? DateTime.parse(json['lastModifiedInstant']) : null,
      drawInstant: (json['drawInstant'] != null) ? DateTime.parse(json['drawInstant']) : null,
      selectedElementsSize: json['selectedElementsSize'],
      raffleElements: json['raffleElements'].cast<String>(),
      selectedElements: (json['selectedElements'] != null) ? json['selectedElements'].cast<String>() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'creationInstant': (creationInstant != null) ? creationInstant!.toUtc().toIso8601String() : null,
      'lastModifiedInstant': (lastModifiedInstant != null) ? lastModifiedInstant!.toUtc().toIso8601String() : null,
      'drawInstant': (drawInstant != null) ? drawInstant!.toUtc().toIso8601String() : null,
      'selectedElementsSize': selectedElementsSize,
      'raffleElements': raffleElements,
      'selectedElements': selectedElements,
    };
  }
}
