class BlockModel {
  final int visitorId;
  final String visitorName;
  final String phone;
  final int userId;
  final String blockedByUser;
  final String startDate;
  final String endDate;

  BlockModel({
    required this.visitorId,
    required this.visitorName,
    required this.phone,
    required this.userId,
    required this.blockedByUser,
    required this.startDate,
    required this.endDate,
  });

  factory BlockModel.fromJson(Map<String, dynamic> json) {
    return BlockModel(
      visitorId: json['visitor_id'],
      visitorName: json['visitor_name'],
      phone: json['phone'],
      userId: json['user_id'],
      blockedByUser: json['blocked_by_user'],
      startDate: json['start_date'],
      endDate: json['end_date'],
    );
  }
}
