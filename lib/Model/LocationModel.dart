class Location {
  final int id;
  final String name;
  // final int floorId;
  final String floorName;
  final String type;
  final String isDestination;
  final bool restrict;

  Location({
    required this.id,
    required this.name,
    // required this.floorId,
    required this.floorName,
    required this.type,
    required this.isDestination,
    required this.restrict,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      name: json['name'],
      // floorId: json['floorId'],
      floorName: json['floor_name'],
      type: json['type'],
      isDestination: json['isDestination'],
      restrict: json['restrict'] == 'True',
    );
  }
}