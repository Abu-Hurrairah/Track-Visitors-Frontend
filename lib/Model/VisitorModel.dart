class Visitor {
  final int id;
  final String name;
  final String phone;
  final String block;

  Visitor({
    required this.id,
    required this.name,
    required this.phone,
    required this.block,
  });

  factory Visitor.fromJson(Map<String, dynamic> json) {
    return Visitor(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      block: json['block'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'block':block,
    };
  }
}