class CameraLocationConnection {
  final int? cameraId;
  final String cameraName;
  final String connectedCameraName;
  // final int? locationId;
  final String locationName;
  // final String TimeToReach;

  CameraLocationConnection({
    this.cameraId,
    required this.cameraName,
    required this.connectedCameraName,
    // this.locationId,
    required this.locationName,
    // required this.TimeToReach,
  });

  factory CameraLocationConnection.fromJson(Map<String, dynamic> json) {
    return CameraLocationConnection(
      cameraId: json['id'],
      cameraName: json['CameraName'],
      connectedCameraName: json['ConnectedCameraNames'],
      // locationId: json['LocationIDs'],
      locationName: json['LocationNames'],
      // TimeToReach: json['TimeToReach'],
    );
  }
}