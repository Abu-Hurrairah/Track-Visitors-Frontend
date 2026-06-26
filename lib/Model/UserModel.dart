class User {
  final int? id;
  final String name;
  final String username;
  final String Password;
  final String role;
  final int? dutyLocation;

  User({
    this.id,
    required this.name,
    required this.username,
    required this.Password,
    required this.role,
    this.dutyLocation,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      Password: json['password'],
      role: json['role'],
      dutyLocation: json['duty_location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': username,
      'password': Password,
      'role': role,
      'duty_location':dutyLocation,
    };
  }
}