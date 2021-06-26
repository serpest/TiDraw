class Draw {
  final String id;
  final String name;
	final DateTime creationInstant;
  final DateTime lastModifiedInstant;
  final DateTime? drawInstant;
  final int selectedElementsSize;
  final Set<String> raffleElements;
  final List<String>? selectedElements;

  Draw({
    required this.id,
    required this.name,
    required this.creationInstant,
    required this.lastModifiedInstant,
    required this.drawInstant,
    required this.selectedElementsSize,
    required this.raffleElements,
    required this.selectedElements,
  });

  factory Draw.fromJson(Map<String, dynamic> json) {
    return Draw(
      id: json['id'],
      name: json['name'],
      creationInstant: json['creationInstant'],
      lastModifiedInstant: json['lastModifiedInstant'],
      drawInstant: json['drawInstant'],
      selectedElementsSize: json['selectedElementsSize'],
      raffleElements: json['raffleElements'],
      selectedElements: json['selectedElements'],
    );
  }
}