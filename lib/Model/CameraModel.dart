class Camera {
  final int id;
  final String name;

  Camera({
    required this.id,
    required this.name,
  });

  factory Camera.fromJson(Map<String, dynamic> json) {
    return Camera(
      id: json['id'],
      name: json['name'],
    );
  }
}