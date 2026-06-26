class Picture {
  final int id;
  final String visitor_id;
  final String image_url;

  Picture({
    required this.id,
    required this.visitor_id,
    required this.image_url,
  });

  factory Picture.fromJson(Map<String, dynamic> json) {
    return Picture(
      id: json['id'],
      visitor_id: json['visitor_id'],
      image_url: json['image_url'],
    );
  }
}