// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:project/APIHandler/api.dart';

class GetAllDataScreen extends StatefulWidget {
  const GetAllDataScreen({super.key});

  @override
  State<GetAllDataScreen> createState() => _GetAllDataScreenState();
}

class _GetAllDataScreenState extends State<GetAllDataScreen> {
  List<GAllUser> user = [];
  List<dynamic> users = [];
  bool isLoading = true;

  Future<void> fetchUsers() async {
    final url = "${APIHandler.ip}/GetAllUsers"; // Replace with your actual API endpoint URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          users = json.decode(response.body);
          print('users: $users');
          isLoading = false;
          user = List.from(users.map((user) => GAllUser.fromJson(user)));
          print('user: $user');
        });
      } else {
        print("Failed to load users. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching users: $e");
    }
  }

// -------------------------------------------------------------------------------------------

  List<dynamic> guardsLocations = [];
  List<GAllGuardLocations> guardsLocation=[];

  Future<void> fetchGuardsLocations() async {
    final url = "${APIHandler.ip}/GetAllGuardsLocation"; // Replace with your actual API endpoint URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          guardsLocations = json.decode(response.body);
          print('guardsLocations: $guardsLocations');
          guardsLocation = guardsLocations.map((json) => GAllGuardLocations.fromJson(json)).toList();
          print('guardsLocation: $guardsLocation');
          isLoading = false;
        });
      } else {
        print("Failed to load guards locations. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching guards locations: $e");
    }
  }

// -------------------------------------------------------------------------------------------

  Map<String, dynamic> guardDutyLocation = {};
  int guardId = 2;

  Future<void> fetchGuardDutyLocation() async {
    final url = "${APIHandler.ip}/GetGuardDutyLocation/${guardId}"; // Replace with your actual API endpoint URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          guardDutyLocation = json.decode(response.body);
          print('guardDutyLocation: $guardDutyLocation');
          print(guardDutyLocation['username']);
          isLoading = false;
        });
      } else {
        print("Failed to load guard duty location. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching guard duty location: $e");
    }
  }

  // -------------------------------------------------------------------------------------------

  List<dynamic> userDetails = [];
  int userId = 1;

  Future<void> fetchUserDetails() async {
    final url = "${APIHandler.ip}/GetUser/${userId}"; // Replace with your actual API endpoint URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          userDetails = json.decode(response.body);
          print('userDetails: $userDetails');
          isLoading = false;
        });
      } else {
        print("Failed to load user details. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching user details: $e");
    }
  }

  // -------------------------------------------------------------------------------------------

  List<dynamic> floorsList = [];
  List<GAllFloor> floors = [];

  Future<void> fetchFloors() async {
    final url = "${APIHandler.ip}/GetAllFloors"; // Replace with your actual API endpoint URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          floorsList = json.decode(response.body);
          print('floorsList: $floorsList');
          floors = floorsList.map((json) => GAllFloor.fromJson(json)).toList();
          print('floors: $floors');
          isLoading = false;
        });
      } else {
        print("Failed to load floors. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching floors: $e");
    }
  }

  // -------------------------------------------------------------------------------------------

  List<dynamic> locationsList = [];
  List<GAllLocation> locations = [];

  Future<void> fetchLocations() async {
    final url = "${APIHandler.ip}/GetAllLocations"; // Replace with your actual API endpoint URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          locationsList = json.decode(response.body);
          print('locationsList: $locationsList');
          locations = locationsList.map((json) => GAllLocation.fromJson(json)).toList();
          print('locations: $locations');
          isLoading = false;
        });
      } else {
        print("Failed to load locations. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching locations: $e");
    }
  }

  // -------------------------------------------------------------------------------------------

  List<dynamic> locationDetails = [];
  int locationId = 1;

  Future<void> fetchLocationDetails() async {
    final url = "${APIHandler.ip}/GetLocation/${locationId}"; // Replace with your actual API endpoint URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          locationDetails = json.decode(response.body);
          print('locationDetails: $locationDetails');
          print(locationDetails[0]);
          isLoading = false;
        });
      } else {
        print("Failed to load location details. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching location details: $e");
    }
  }

  // -------------------------------------------------------------------------------------------

  List<dynamic> locationByFloor = [];
  List<GAllLocation> locationsByFloor = [];
  int floorId = 1;

  Future<void> fetchLocationsByFloor() async {
    final url = "${APIHandler.ip}/GetLocationsByFloor/${floorId}"; // Replace with your actual API endpoint URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          locationByFloor = json.decode(response.body);
          print('locationByFloor: $locationByFloor');
          locationsByFloor = GAllLocation.fromJsonList(locationByFloor);
          print('locationsByFloor: $locationsByFloor');
          isLoading = false;
        });
      } else {
        print("Failed to load locations. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching locations: $e");
    }
  }

  // -------------------------------------------------------------------------------------------

  List<dynamic> locationByCamera = [];
  String cameraName = 'Main Gate';

  Future<void> fetchLocationByCamera() async {
    final url = "${APIHandler.ip}/GetLocationByCamera/${cameraName}"; // Replace with your actual API endpoint URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          locationByCamera = json.decode(response.body);
          print('locationByCamera: $locationByCamera');
          dynamic locationByCameraName=locationByCamera[0];
          print('locationByCameraName: ${locationByCameraName['CameraName']}');
          isLoading = false;
        });
      } else {
        print("Failed to load location details. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching location details: $e");
    }
  }

  // -------------------------------------------------------------------------------------------

  List<dynamic> locationByCameraId = [];
  int cameraId = 26;

  Future<void> fetchLocationByCameraId() async {
    final url = "${APIHandler.ip}/GetLocationByCameraId/${cameraId}"; // Replace with your actual API endpoint URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          locationByCameraId = json.decode(response.body);
          print('locationByCameraId: $locationByCameraId');
          isLoading = false;
        });
      } else {
        print("Failed to load location details. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching location details: $e");
    }
  }

  // -------------------------------------------------------------------------------------------

  List<dynamic> camerasList = [];
  List<GAllCamera> cameras = [];

  Future<void> fetchAllCameras() async {
    final url = "${APIHandler.ip}/GetAllCameras"; // Replace with your actual API endpoint URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          camerasList = json.decode(response.body);
          print('camerasList: $camerasList');
          cameras = GAllCamera.fromJsonList(camerasList);
          print('cameras: $cameras');
          isLoading = false;
        });
      } else {
        print("Failed to load cameras. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching cameras: $e");
    }
  }

  // -------------------------------------------------------------------------------------------

  List<dynamic> camerasLocationsConnectionsList = [];
  List<GAllCameraLocationConnection> camerasLocationsConnections = [];

  Future<void> fetchCamerasLocationsConnections() async {
    final url = "${APIHandler.ip}/GetAllCamerasLocationsConnections"; // Replace with your actual API endpoint URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          camerasLocationsConnectionsList = json.decode(response.body);
          print('camerasLocationsConnectionsList: $camerasLocationsConnectionsList');
          camerasLocationsConnections = GAllCameraLocationConnection.fromJsonList(camerasLocationsConnectionsList);
          print('camerasLocationsConnections: $camerasLocationsConnections');
          isLoading = false;
        });
      } else {
        print("Failed to load cameras. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching cameras: $e");
    }
  }

  // body: isLoading
  //         ? Center(child: CircularProgressIndicator())
  //         : ListView.builder(
  //             itemCount: camerasLocationsConnectionsList.length,
  //             itemBuilder: (context, index) {
  //               final camera = camerasLocationsConnectionsList[index];
  //               return ListTile(
  //                 title: Text(camera['CameraName']), // Replace with your actual camera name field
  //                 subtitle: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text('Connected Locations: ${camera['LocationNames']}'),
  //                     Text('Connected Cameras: ${camera['ConnectedCameraNames']}'),
  //                     Text('Time to Reach: ${camera['TimeToReach']}'),
  //                   ],
  //                 ),
  //               );
  //             },
  //           ),

  // body: isLoading
  //   ? Center(child: CircularProgressIndicator())
  //   : ListView.builder(
  //       itemCount: camerasLocationsConnections.length,
  //       itemBuilder: (context, index) {
  //         final camera = camerasLocationsConnections[index];
  //         return ListTile(
  //           title: Text(camera.camera), // Replace with your actual camera name field
  //           subtitle: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text('Connected Locations: ${camera.locationNames}'),
  //               Text('Connected Cameras: ${camera.connectedCameraNames}'),
  //               Text('Time to Reach: ${camera.timeToReach}'),
  //             ],
  //           ),
  //         );
  //       },
  //     ),

  // -------------------------------------------------------------------------------------------

  List<dynamic> cameraByLocation = [];
  int locationIdd = 3;

  Future<void> fetchCameraByLocation() async {
    final url = "${APIHandler.ip}/GetCameraByLocation/${locationIdd}"; // Replace with your actual API endpoint URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          cameraByLocation = json.decode(response.body);
          print('cameraByLocation: $cameraByLocation');
          isLoading = false;
        });
      } else {
        print("Failed to load camera. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching camera: $e");
    }
  }

  // -------------------------------------------------------------------------------------------

  Map<String, dynamic> adjacencyMatrixData = {};
  late GAllCameraMatrixData cameraMatrixData; // Using 'late' keyword to delay initialization

  Future<void> fetchAdjacencyMatrix() async {
    final url = "${APIHandler.ip}/GetCameraMatrix"; // Replace with your actual API endpoint URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          adjacencyMatrixData = json.decode(response.body);
          print('adjacencyMatrixData: $adjacencyMatrixData');
          cameraMatrixData = GAllCameraMatrixData.fromJson(adjacencyMatrixData);
          print('cameraMatrixData: $cameraMatrixData');
          isLoading = false;
        });
      } else {
        print("Failed to load adjacency matrix. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching adjacency matrix: $e");
    }
  }

  // body: ListView(
  //       children: [
  //         SingleChildScrollView(
  //           scrollDirection: Axis.horizontal,
  //           child: DataTable(
  //             columns: [
  //               DataColumn(label: Text('')),
  //               for (var name in adjacencyMatrixData['columnNames'])
  //                 DataColumn(label: Text(name, style: TextStyle(fontWeight: FontWeight.bold))),
  //             ],
  //             rows: List.generate(
  //               adjacencyMatrixData['rowNames'].length,
  //               (rowIndex) {
  //                 return DataRow(
  //                   cells: List<DataCell>.generate(
  //                     adjacencyMatrixData['matrix'][rowIndex].length + 1,
  //                     (cellIndex) {
  //                       if (cellIndex == 0) {
  //                         // For the left-most column (camera names)
  //                         return DataCell(
  //                           Text(
  //                             adjacencyMatrixData['rowNames'][rowIndex],
  //                             style: TextStyle(fontWeight: FontWeight.bold),
  //                           ),
  //                         );
  //                       } else {
  //                         // For other cells
  //                         return DataCell(
  //                           InkWell(
  //                             onTap: () {
  //                               // Handle the click for other cells
  //                               print('Clicked on ${adjacencyMatrixData['rowNames'][rowIndex]} to ${adjacencyMatrixData['columnNames'][cellIndex - 1]}');
  //                             },
  //                             child: Text(adjacencyMatrixData['matrix'][rowIndex][cellIndex - 1].toString()),
  //                           ),
  //                         );
  //                       }
  //                     },
  //                   ),
  //                 );
  //               },
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),

  // Column(
  //             children: [
  //               DataTable(
  //                 columns: [for (var name in adjacencyMatrixData['columnNames']) DataColumn(label: Text(name))],
  //                 rows: List.generate(
  //                   adjacencyMatrixData['rowNames'].length,
  //                   (index) {
  //                     return DataRow(
  //                       cells: [
  //                         for (var timeToReach in adjacencyMatrixData['matrix'][index]) DataCell(Text(timeToReach.toString())),
  //                       ],
  //                     );
  //                   },
  //                 ),
  //               ),
  //             ],
  //           ),

  // -------------------------------------------------------------------------------------------

  List<dynamic> restrictedCamerasList = [];

  Future<void> fetchRestrictedCameras() async {
    final url = "${APIHandler.ip}/GetRestrictedCameras"; // Replace with your actual API endpoint URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          restrictedCamerasList = json.decode(response.body);
          print('restrictedCamerasList: $restrictedCamerasList');
          isLoading = false;
        });
      } else {
        print("Failed to load restricted cameras. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching restricted cameras: $e");
    }
  }

//   -- Create Location table if not exists
// IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Location')
// BEGIN
//     CREATE TABLE Location (
//         id INT PRIMARY KEY,
//         name NVARCHAR(255) NOT NULL
//         -- Add more columns as needed
//     );
// END

// -- Create RestrictedLocation table
// CREATE TABLE RestrictedLocation (
//     id INT PRIMARY KEY,
//     location_id INT FOREIGN KEY REFERENCES Location(id) NOT NULL,
//     start_datetime DATETIME NOT NULL,
//     end_datetime DATETIME NOT NULL,
//     -- Add more columns as needed
// );

// -- Optionally, create an index on end_datetime for better performance
// CREATE INDEX idx_restricted_location_end_datetime ON RestrictedLocation (end_datetime);


  // -------------------------------------------------------------------------------------------

  List<dynamic> visitorsReportList = [];
  String startDate = '2023-11-01';
  String endDate = '2024-01-25';
  List<GAllVisitorReport> visitorsReport = [];

  Future<void> fetchVisitorsReport() async {
    final url = "${APIHandler.ip}/GetVisitorsReport"; // Replace with your actual API endpoint URL

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'start_date': startDate, 'end_date': endDate}),
      );

      if (response.statusCode == 200) {
        setState(() {
          visitorsReportList = json.decode(response.body);
          print('visitorsReportList: $visitorsReportList');
          visitorsReport = GAllVisitorReport.fromJsonList(json.decode(response.body));
          print('visitorsReport: $visitorsReport');
          isLoading = false;
        });
      } else {
        print("Failed to load visitors report. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching visitors report: $e");
    }
  }

  // body: isLoading
  //         ? Center(child: CircularProgressIndicator())
  //         : ListView.builder(
  //             itemCount: visitorsReportList.length,
  //             itemBuilder: (context, index) {
  //               final report = visitorsReportList[index];
  //               return ListTile(
  //                 title: Text('Visit ID: ${report['VisitID']}'),
  //                 subtitle: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text('Visitor Name: ${report['VisitorName']}'),
  //                     Text('Visitor Phone: ${report['VisitorPhone']}'),
  //                     Text('Visit Date: ${report['VisitDate']}'),
  //                     Text('Entry Time: ${report['EntryTime']}'),
  //                     Text('Exit Time: ${report['ExitTime'] ?? 'Not available'}'),
  //                     Text('Locations Visited: ${report['LocationsVisited']}'),
  //                   ],
  //                 ),
  //               );
  //             },
  //           ),

  // body: isLoading
  //         ? Center(child: CircularProgressIndicator())
  //         : ListView.builder(
  //             itemCount: visitorsReport.length,
  //             itemBuilder: (context, index) {
  //               final report = visitorsReport[index];
  //               return ListTile(
  //                 title: Text('Visit ID: ${report.visitID}'),
  //                 subtitle: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text('Visitor Name: ${report.visitorName}'),
  //                     Text('Visitor Phone: ${report.visitorPhone}'),
  //                     Text('Visit Date: ${report.visitDate}'),
  //                     Text('Entry Time: ${report.entryTime}'),
  //                     Text('Exit Time: ${report.exitTime ?? 'Not available'}'),
  //                     Text('Locations Visited: ${report.locationsVisited}'),
  //                   ],
  //                 ),
  //               );
  //             },
  //           ),

  // -------------------------------------------------------------------------------------------

  List<dynamic> alertCount=[];

  Future<void> fetchAlertCount() async {
    final url = "${APIHandler.ip}/GetAlertCount"; // Replace with your actual API endpoint URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          alertCount = json.decode(response.body);
          print('alertCount: $alertCount');
          int alertCounts = int.parse(alertCount[0]['alert_count'].toString());
          print('alertCounts: $alertCounts');
          isLoading = false;
        });
      } else {
        print("Failed to load alert count. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching alert count: $e");
    }
  }

  // Text(
  //   'Alert Count: ${alertCount.isNotEmpty ? alertCount[0]['alert_count'] : 'Loading...'}',
  //   style: TextStyle(fontSize: 16),
  // ),

  // -------------------------------------------------------------------------------------------

  List<dynamic> currentAlertsList = [];

  Future<void> fetchCurrentAlerts() async {
    final url = "${APIHandler.ip}/GetCurrentAlerts"; // Replace with your actual API endpoint URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          currentAlertsList = json.decode(response.body);
          print('currentAlertsList: $currentAlertsList');
          isLoading = false;
        });
      } else {
        print("Failed to load current alerts. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching current alerts: $e");
    }
  }

  // -------------------------------------------------------------------------------------------

  List<dynamic> allAlertsList = [];
  List<GAllAlert> allAlerts = [];

  Future<void> fetchAllAlerts() async {
    final url = "${APIHandler.ip}/GetAllAlerts"; // Replace with your actual API endpoint URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          allAlertsList = json.decode(response.body);
          print('allAlertsList: $allAlertsList');
          allAlerts = GAllAlert.fromJsonList(json.decode(response.body));
          print('allAlerts: $allAlerts');
          isLoading = false;
        });
      } else {
        print("Failed to load all alerts. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching all alerts: $e");
    }
  }

  // body: ListView.builder(
  //             itemCount: allAlertsList.length,
  //             itemBuilder: (context, index) {
  //               final alert = allAlertsList[index];
  //               return ListTile(
  //                 title: Text('Alert ID: ${alert['id']}'),
  //                 subtitle: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text('Type: ${alert['type']}'),
  //                     Text('Date: ${alert['date']}'),
  //                     Text('Time: ${alert['time']}'),
  //                     Text('Visit ID: ${alert['visit_id']}'),
  //                     Text('Visitor Name: ${alert['visitor_name']}'),
  //                     Text('Visitor Contact: ${alert['visitor_contact']}'),
  //                     Text('Camera ID: ${alert['camera_id']}'),
  //                     Text('Location ID: ${alert['location_id']}'),
  //                     Text('Destinations: ${alert['destinations']}'),
  //                     Text('Camera Name: ${alert['camera_name']}'),
  //                     Text('Current Location: ${alert['current_location']}'),
  //                   ],
  //                 ),
  //               );
  //             },
  //           ),

  // body: ListView.builder(
  //             itemCount: allAlerts.length,
  //             itemBuilder: (context, index) {
  //               final alert = allAlerts[index];
  //               return ListTile(
  //                 title: Text('Alert ID: ${alert.id}'),
  //                 subtitle: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text('Type: ${alert.type}'),
  //                     Text('Date: ${alert.date}'),
  //                     Text('Time: ${alert.time}'),
  //                     Text('Visit ID: ${alert.visitId}'),
  //                     Text('Visitor Name: ${alert.visitorName}'),
  //                     Text('Visitor Contact: ${alert.visitorContact}'),
  //                     Text('Camera ID: ${alert.cameraId}'),
  //                     Text('Location ID: ${alert.locationId}'),
  //                     Text('Destinations: ${alert.destinations}'),
  //                     Text('Camera Name: ${alert.cameraName}'),
  //                     Text('Current Location: ${alert.currentLocation}'),
  //                   ],
  //                 ),
  //               );
  //             },
  //           ),

  // -------------------------------------------------------------------------------------------

  List<dynamic> allVisitorsList = [];
  List<GAllVisitor> allVisitors = [];

  Future<void> fetchAllVisitors() async {
    final url = "${APIHandler.ip}/GetAllVisitors"; // Replace with your actual API endpoint URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          allVisitorsList = json.decode(response.body);
          print('allVisitorsList: $allVisitorsList');
          allVisitors = GAllVisitor.fromJsonList(json.decode(response.body));
          print('allVisitors: $allVisitors');
          isLoading = false;
        });
      } else {
        print("Failed to load all visitors. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching all visitors: $e");
    }
  }

  // body: ListView.builder(
  //             itemCount: allVisitorsList.length,
  //             itemBuilder: (context, index) {
  //               final visitor = allVisitorsList[index];
  //               return ListTile(
  //                 title: Text('Visitor ID: ${visitor['id']}'),
  //                 subtitle: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text('Name: ${visitor['name']}'),
  //                     Text('Phone: ${visitor['phone']}'),
  //                     Text('Email: ${visitor['email']}'),
  //                     Text('Block: ${visitor['block']}'),
  //                   ],
  //                 ),
  //               );
  //             },
  //           ),

  // body: ListView.builder(
  //             itemCount: allVisitors.length,
  //             itemBuilder: (context, index) {
  //               final GAllVisitor visitor = allVisitors[index];
  //               return ListTile(
  //                 title: Text(visitor.name),
  //                 subtitle: Text('Phone: ${visitor.phone} | Blocked: ${visitor.block}'),
  //                 // Add more fields as needed
  //                 // For example: Text('ID: ${visitor.id}'),
  //               );
  //             },
  //           ),

  // -------------------------------------------------------------------------------------------

  List<dynamic> currentVisitorsList = [];
  List<GAllCurrentVisitor> currentVisitors = [];

  Future<void> fetchCurrentVisitors() async {
    final url = "${APIHandler.ip}/GetCurrentVisitors"; // Replace with your actual API endpoint URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          currentVisitorsList = json.decode(response.body);
          print('currentVisitorsList: $currentVisitorsList');
          final List<GAllCurrentVisitor> visitors = currentVisitorsList.map((json) => GAllCurrentVisitor.fromJson(json)).toList();
          print('currentVisitors: $visitors');
          currentVisitors = visitors;
          isLoading = false;
        });
      } else {
        print("Failed to load current visitors. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching current visitors: $e");
    }
  }

  // body: isLoading
  //         ? Center(
  //             child: CircularProgressIndicator(),
  //           )
  //         : ListView.builder(
  //             itemCount: currentVisitorsList.length,
  //             itemBuilder: (context, index) {
  //               // Assuming each item in the list is a Map<String, dynamic>
  //               final Map<String, dynamic> visitorData = currentVisitorsList[index];
  //               return ListTile(
  //                 title: Text(visitorData['name']),
  //                 subtitle: Text(visitorData['phone']),
  //                 // Add more fields as needed
  //                 // For example: Text(visitorData['entry_time']),
  //               );
  //             },
  //           ),

  // body: isLoading
  //         ? Center(
  //             child: CircularProgressIndicator(),
  //           )
  //         : ListView.builder(
  //             itemCount: currentVisitors.length,
  //             itemBuilder: (context, index) {
  //               final Visitor visitor = currentVisitorsList[index];
  //               return ListTile(
  //                 title: Text(visitor.name),
  //                 subtitle: Text(visitor.phone),
  //                 // Add more fields as needed
  //                 // For example: Text(visitor.entry_time),
  //               );
  //             },
  //           ),

  // -------------------------------------------------------------------------------------------

  List<dynamic> blockedVisitorsList = [];

  Future<void> fetchBlockedVisitors() async {
    final url = "${APIHandler.ip}/GetBlockVisitors"; // Replace with your actual API endpoint URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          blockedVisitorsList = json.decode(response.body);
          print('blockedVisitorsList: $blockedVisitorsList');
          isLoading = false;
        });
      } else {
        print("Failed to load blocked visitors. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching blocked visitors: $e");
    }
  }

  // body: ListView.builder(
  //             itemCount: blockedVisitorsList.length,
  //             itemBuilder: (context, index) {
  //               final visitor = blockedVisitorsList[index];

  //               return ListTile(
  //                 title: Text('Visitor ID: ${visitor['visitor_id']}'),
  //                 subtitle: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text('Name: ${visitor['visitor_name']}'),
  //                     Text('Phone: ${visitor['phone']}'),
  //                     Text('Blocked By User: ${visitor['blocked_by_user']}'),
  //                     Text('Start Date: ${visitor['start_date']}'),
  //                     Text('End Date: ${visitor['end_date']}'),
  //                   ],
  //                 ),
  //               );
  //             },
  //           ),

  // -------------------------------------------------------------------------------------------

  File? imageFile;
  dynamic visitorData;

  Future<void> recognizeVisitorWithImage(File image) async {
    try {
      final uri = Uri.parse("${APIHandler.ip}/GetVisitorWithImage"); // Replace with your actual API endpoint URL
      var request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('image', image.path));

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      print('API Response: $responseBody'); // Print the response for debugging

      setState(() {
        visitorData = json.decode(responseBody);
        print('visitorData: $visitorData');
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error recognizing visitor: $e");
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery); // Use pickImage instead of getImage

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });

      await recognizeVisitorWithImage(imageFile!);
    }
  }

  // body: Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       if (imageFile != null)
  //         Image.file(
  //           imageFile!,
  //           height: 150,
  //         ),
  //       if (visitorData != null) ...{
  //         Expanded(
  //           child: ListView.builder(
  //             itemCount: visitorData.length,
  //             itemBuilder: (context, index) {
  //               return ListTile(
  //                 title: Text('Visitor ID: ${visitorData[index]['id']}'),
  //                 subtitle: Column(
  //                   children: [
  //                     Text('Name: ${visitorData[index]['name']}'),
  //                     Text('Phone: ${visitorData[index]['phone']}'),
  //                     Text('Block: ${visitorData[index]['block']}'),
  //                   ],
  //                 ),
  //                 // Add more fields as needed
  //               );
  //             },
  //           ),
  //         ),
  //       } else 
  //         imageFile != null?CircularProgressIndicator():Text('No visitor data available'),
  //       ElevatedButton(
  //         onPressed: pickImage,
  //         child: Text('Pick Image'),
  //       ),
  //     ],
  //   ),

  // -------------------------------------------------------------------------------------------

  dynamic image;
  int visitorId = 43;
  String cameraNamee='Waiting Area';

  Future<void> fetchDetectedFrame() async {
    try {
      final response = await http.get(
        Uri.parse('${APIHandler.ip}/GetDetectedFrame/$visitorId/$cameraNamee'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> detectedFrameJson = json.decode(response.body);
        print('detectedFrameJson: $detectedFrameJson');
        
        if (detectedFrameJson.containsKey("image")) {
          final String base64Image = detectedFrameJson["image"];
          
          if (isValidBase64(base64Image)) {
            setState(() {
              image = base64Decode(base64Image);
              print('Image received successfully');
            });
            return;
          } else {
            print('Invalid base64 data received: $base64Image');
          }
        } else {
          print('Missing "image" field in response');
        }
      } else {
        throw Exception('Failed to load detected frame');
      }
    } catch (e) {
      print('Error fetching detected frame: $e');
    }
  }

  bool isValidBase64(String data) {
    try {
      // Try to decode the data to check if it's a valid base64 string
      Base64Decoder().convert(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  // body: Center(
  //       child: image != null
  //           ? Image.memory(
  //               image,
  //               height: 300,
  //               width: 300,
  //             )
  //           : CircularProgressIndicator(),
  //     ),

  // -------------------------------------------------------------------------------------------

  List<Map<String, dynamic>> visitPathHistoryList=[];
  int visitorIdd=44;
  List<GAllVisitPathHistory> visitPathHistory = [];

  Future<void> fetchVisitPathHistory() async {
    final url = "${APIHandler.ip}/GetVisitPathHistory";
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'visitor_id': visitorIdd}),
      );

      if (response.statusCode == 200) {
        setState(() {
          List<dynamic> data = jsonDecode(response.body);
          visitPathHistoryList = List<Map<String, dynamic>>.from(data);
          print('visitPathHistoryList: $visitPathHistoryList');
          visitPathHistory = data.map((json) => GAllVisitPathHistory.fromJson(json)).toList();
          print('visitPathHistory: $visitPathHistory');
          isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch visit path history');
      }
    } catch (e) {
      print('Error fetching visit path history: $e');
    }
  }

  // body: ListView.builder(
  //       itemCount: visitPathHistoryList.length,
  //       itemBuilder: (context, index) {
  //         return ListTile(
  //           title: Text('Visit ID: ${visitPathHistoryList[index]['visit_id']}'),
  //           subtitle: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text('Time: ${visitPathHistoryList[index]['time']}'),
  //               Text('Camera ID: ${visitPathHistoryList[index]['camera_id']}'),
  //               Text('Camera Name: ${visitPathHistoryList[index]['camera_name']}'),
  //               Text('Floor Name: ${visitPathHistoryList[index]['floor_name']}'),
  //               Text('Locations: ${visitPathHistoryList[index]['locations']}'),
  //             ],
  //           ),
  //           // Add more details as needed
  //         );
  //       },
  //     ),

  // -------------------------------------------------------------------------------------------

  String entryTime = '';
  int visitorIddd = 44;

  Future<void> fetchVisitEntryTime() async {
    final url = "${APIHandler.ip}/GetVisitEntryTime/$visitorIddd";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          Map<String, dynamic> entryTimeData = json.decode(response.body);
          print('entryTimeData: $entryTimeData');
          entryTime = entryTimeData['entry_time'];
          print('entryTime: ${DateFormat.Hm().format(DateTime.parse("2022-01-01 $entryTime"))}');
          entryTime=DateFormat('hh:mm a').format(DateTime.parse("2022-01-01 $entryTime"));
        });
      } else {
        print("Failed to load entry time. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching entry time: $e");
    }
  }

  // body: Center(
  //       child: Text(entryTime),
  //     )

  // -------------------------------------------------------------------------------------------

  List<dynamic> paths = [];
  String source = '3';   //  'Main Gate'
  String destination = '4';   //  'Admin'

  Future<void> fetchPaths() async {
    final url = "${APIHandler.ip}/GetPaths"; // Replace with your actual API endpoint URL

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'source': source, 'destination': destination}),
      );

      if (response.statusCode == 200) {
        print(response.body);
        final List<dynamic> pathsJson = json.decode(response.body);
        print(pathsJson);

        setState(() {
          paths = pathsJson.cast<Map<String, dynamic>>();
          print('paths: $paths');
        });
      } else {
        print("Failed to load paths. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching paths: $e");
    }
  }

  // -------------------------------------------------------------------------------------------

  List<List<String>> locationPaths = [];
  String ssource = '3';  //  'Main Gate'
  List<String> destinations = ['4'];  //  'Admin'

  Future<void> fetchLocationPaths() async {
    final url = "${APIHandler.ip}"; // Replace with your actual API endpoint URL

    try {
      final response = await http.post(
        Uri.parse('$url/GetLocationPaths'),
        body: json.encode({'source': ssource, 'destinations': destinations}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> locationPathsJson = json.decode(response.body);
        print('locationPathsJson: $locationPathsJson');

        setState(() {
          locationPaths = locationPathsJson.map<List<String>>((pathJson) => List<String>.from(pathJson)).toList();
        });
      } else {
        print("Failed to load location paths. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching location paths: $e");
    }
  }


  // body: ListView.builder(
  //       itemCount: locationPaths.length,
  //       itemBuilder: (context, index) {
  //         final locationPath = locationPaths[index];
  //         return ListTile(
  //           title: Text("Location Path ${index+1}"),
  //           subtitle: Text("Locations:=> ${locationPath.join(', ')}"),
  //         );
  //       },
  //     ),

  // -------------------------------------------------------------------------------------------

  Map<String, dynamic> connectionMatrix = {};

  Future<void> fetchConnectionMatrix() async {
    final url = "${APIHandler.ip}"; // Replace with your actual API endpoint URL

    try {
      final response = await http.get(Uri.parse('$url/GetConnectionMatrix'));

      if (response.statusCode == 200) {
        final dynamic connectionMatrixJson = json.decode(response.body);
        print('connectionMatrixJson: $connectionMatrixJson');

        setState(() {
          // final Map<int, List<int>> connectionMatrixJson = convertJsonToConnectionMatrix(decodedData);
          connectionMatrix=connectionMatrixJson;
        });
      } else {
        print("Failed to load connection matrix. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching connection matrix: $e");
    }
  }

  // body: Padding(
  //       padding: EdgeInsets.all(8.0),
  //       child: ListView.builder(
  //         itemCount: connectionMatrix.length,
  //         itemBuilder: (context, index) {
  //           final cameraId = connectionMatrix.keys.elementAt(index);
  //           final timeToReachList = connectionMatrix[cameraId] ?? [];

  //           return ListTile(
  //             title: Text("Camera ID: $cameraId"),
  //             subtitle: Text("Time to Reach: ${timeToReachList.join(', ')}"),
  //           );
  //         },
  //       ),
  //     ),



  // body: SingleChildScrollView(
  //       scrollDirection: Axis.horizontal,
  //       child: SingleChildScrollView(
  //         scrollDirection: Axis.vertical,
  //         child: DataTable(
  //           columns: _buildColumns(),
  //           rows: _buildRows(context),
  //           columnSpacing: 20.0, // Adjust as needed
  //         ),
  //       ),
  //     ),

  // List<DataColumn> _buildColumns() {
  //   List<DataColumn> columns = [];
  //   // Empty cell at the top-left corner
  //   columns.add(DataColumn(
  //     label: Container(), // Empty container
  //   ));

  //   connectionMatrix.keys.forEach((key) {
  //     columns.add(DataColumn(
  //       label: Text('$key', style: TextStyle(fontWeight: FontWeight.bold)),
  //     ));
  //   });
  //   return columns;
  // }

  // List<DataRow> _buildRows(BuildContext context) {
  //   List<DataRow> rows = [];
  //   connectionMatrix.forEach((rowKey, values) {
  //     List<DataCell> cells = [];
  //     // Row header
  //     cells.add(DataCell(
  //       Text('$rowKey', style: TextStyle(fontWeight: FontWeight.bold)),
  //     ));

  //     values.forEach((value) {
  //       cells.add(DataCell(
  //         InkWell(
  //           onTap: () {
  //             // Handle cell click here
  //             print('Cell Clicked: $value');
  //           },
  //           child: Text('$value'),
  //         ),
  //       ));
  //     });
  //     rows.add(DataRow(
  //       cells: cells,
  //       color: MaterialStateProperty.resolveWith<Color?>(
  //         (Set<MaterialState> states) {
  //           // Highlight the header row
  //           if (states.contains(MaterialState.selected)) return Theme.of(context).colorScheme.primary.withOpacity(0.08);
  //           return null;
  //         },
  //       ),
  //     ));
  //   });
  //   return rows;
  // }


  // // List<DataColumn> _buildColumns() {
  // //   List<DataColumn> columns = [];
  // //   // Empty cell at the top-left corner
  // //   columns.add(DataColumn(label: Text('Cameras')));
    
  // //   connectionMatrix.keys.forEach((key) {
  // //     columns.add(DataColumn(label: Text('$key')));
  // //   });
  // //   return columns;
  // // }

  // // List<DataRow> _buildRows() {
  // //   List<DataRow> rows = [];
  // //   connectionMatrix.forEach((rowKey, values) {
  // //     List<DataCell> cells = [];
  // //     // Row header
  // //     cells.add(DataCell(Text('$rowKey')));
      
  // //     values.forEach((value) {
  // //       cells.add(DataCell(Text('$value')));
  // //     });
  // //     rows.add(DataRow(cells: cells));
  // //   });
  // //   return rows;
  // // }

  // -------------------------------------------------------------------------------------------

  List<Map<String, dynamic>> restrictedLocationsList = [];
  List<GAllRestrictedLocation> restrictedLocations = [];

  Future<void> fetchRestrictedLocations() async {
    final url = "${APIHandler.ip}"; // Replace with your actual API endpoint URL

    try {
      final response = await http.get(Uri.parse('$url/GetRestrictedLocations'));

      if (response.statusCode == 200) {
        setState(() {
          restrictedLocationsList = List<Map<String, dynamic>>.from(
              json.decode(response.body) as List<dynamic>);
          print('restrictedLocationsList: $restrictedLocationsList');
          restrictedLocations = (json.decode(response.body) as List)
            .map((json) => GAllRestrictedLocation.fromJson(json))
            .toList();
        print('restrictedLocations: $restrictedLocations');
          isLoading = false;
        });
      } else {
        print(
            "Failed to load restricted locations. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching restricted locations: $e");
    }
  }

  // body: restrictedLocations.isEmpty
  //         ? Center(
  //             child: CircularProgressIndicator(),
  //           )
  //         : ListView.builder(
  //             itemCount: restrictedLocations.length,
  //             itemBuilder: (context, index) {
  //               final location = restrictedLocations[index];

  //               return Card(
  //                 child: ListTile(
  //                   title: Text('Name: ${location.name}'),
  //                   subtitle: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text('Restricted ID: ${location.restrictedId}'),
  //                       Text('Location ID: ${location.locationId}'),
  //                       Text('Start Datetime: ${location.startDatetime}'),
  //                       Text('End Datetime: ${location.endDatetime}'),
  //                     ],
  //                   ),
  //                   onTap: () {
  //                     // Handle onTap event if needed
  //                   },
  //                 ),
  //               );
  //             },
  //           ),

  // -------------------------------------------------------------------------------------------

  List<GAllVisitorReport> visitorReport = [];
  int visitorIdddd = 45; // Replace with the actual visitor ID

  Future<void> fetchVisitorReport() async {
    final url = "${APIHandler.ip}/DownloadVisitorReport/$visitorIdddd"; 

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          // visitorsReport = GAllVisitorReport.fromJsonList(json.decode(response.body));
          // print('visitorsReport: $visitorsReport');
          final dynamic responseJson =response.body;
          print(responseJson.runtimeType);
          isLoading = false;
        });
      } else {
        print("Failed to load visitor report. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching visitor report: $e");
    }
  }

  // -------------------------------------------------------------------------------------------

  List<Map<String, dynamic>> dumpedImagesList = [];
  List<GAllDumpedImage> dumpedImages = [];

  Future<void> fetchDumpedImages() async {
    final url = "${APIHandler.ip}"; // Replace with your actual API endpoint URL

    try {
      final response = await http.get(Uri.parse('$url/GetDumpImages'));

      if (response.statusCode == 200) {
        setState(() {
          dumpedImagesList = List<Map<String, dynamic>>.from(
              json.decode(response.body)['images'] as List<dynamic>);
          print('dumpedImagesList: $dumpedImagesList');
          dumpedImages = (json.decode(response.body)['images'] as List)
            .map((json) => GAllDumpedImage.fromJson(json))
            .toList();
        print('dumpedImages: $dumpedImages');
          isLoading = false;
        });
      } else {
        print("Failed to load dumped images. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching dumped images: $e");
    }
  }

  Future<void> _showImageDialog(String base64Image) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: double.maxFinite,
            height: 500,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: MemoryImage(
                  base64Decode(base64Image),
                ),
                fit: BoxFit.fill,
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // body: isLoading
  //       ? Center(child: CircularProgressIndicator())
  //       : ListView.builder(
  //           itemCount: dumpedImagesList.length,
  //           itemBuilder: (context, index) {
  //             final imageInfo = dumpedImagesList[index];
  //             return ListTile(
  //               title: Text('Filename: ${imageInfo['filename']}'),
  //               subtitle: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text('Camera: ${imageInfo['camera']}'),
  //                   Text('Date: ${imageInfo['date']}'),
  //                   Text('Time: ${imageInfo['time']}'),
  //                 ],
  //               ),
  //               leading: GestureDetector(
  //                 onTap: () {
  //                   _showImageDialog(imageInfo['image']);
  //                 },
  //                 child: Image.memory(
  //                   base64Decode(imageInfo['image']),
  //                   width: 50,
  //                   height: 50,
  //                 ),
  //               ),
  //             );
  //           },
  //         ),

  // body: dumpedImages.isEmpty
  //         ? Center(
  //             child: CircularProgressIndicator(),
  //           )
  //         : ListView.builder(
  //             itemCount: dumpedImages.length,
  //             itemBuilder: (context, index) {
  //               final dumpedImage = dumpedImages[index];

  //               return Card(
  //                 child: ListTile(
  //                   leading: GestureDetector(
  //                     onTap: () {
  //                       _showImageDialog(dumpedImage.image);
  //                     },
  //                     child: Image.memory(
  //                       // Assuming the 'image' property contains base64-encoded image data
  //                       // If 'image' is a URL, you may want to use Image.network instead
  //                       base64Decode(dumpedImage.image),
  //                       width: 50,
  //                       height: 50,
  //                       fit: BoxFit.cover,
  //                     ),
  //                   ),
  //                   title: Text('Filename: ${dumpedImage.filename}'),
  //                   subtitle: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text('Camera: ${dumpedImage.camera}'),
  //                       Text('Date: ${dumpedImage.date}'),
  //                       Text('Time: ${dumpedImage.time}'),
  //                     ],
  //                   ),
  //                   onTap: () {
  //                     // Handle onTap event if needed
  //                   },
  //                 ),
  //               );
  //             },
  //           ),


  // -------------------------------------------------------------------------------------------

  TextEditingController startDatetimeController = TextEditingController();
  TextEditingController endDatetimeController = TextEditingController();
  List<String> selectedLocationNames = [];
  List<int> selectedLocationIds = [];

  Future<void> restrictLocation(List<int> locationIds, String startDatetime, String endDatetime) async {
    final url = "${APIHandler.ip}"; // Replace with your actual API endpoint URL

    try {
      final response = await http.post(
        Uri.parse('$url/RestrictLocation'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'locations': locationIds,
          'start_datetime': startDatetime,
          'end_datetime': endDatetime,
        }),
      );

      if (response.statusCode == 201) {
        // Successfully restricted location
        print('Location restricted successfully!');
      } else {
        // Failed to restrict location
        print('Failed to restrict location. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error restricting location: $e");
    }
  }

  Future<void> _selectDateTime(TextEditingController controller) async {
    DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDateTime != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        DateTime selectedDateTime = DateTime(
          pickedDateTime.year,
          pickedDateTime.month,
          pickedDateTime.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // controller.text = selectedDateTime.toLocal().toString();
        String formattedDateTime = DateFormat('yyyy-MM-dd hh:mm a').format(selectedDateTime);
        controller.text = formattedDateTime;
      }
    }
  }

  Future<void> _showLocationSelectionDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Select Locations'),
              content: SingleChildScrollView(
                child: Column(
                  children: locationsList.map((location) {
                    return CheckboxListTile(
                      title: Text(location['name']),
                      value: selectedLocationNames.contains(location['name']),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value != null) {
                            if (value) {
                              selectedLocationNames.add(location['name']);
                              selectedLocationIds.add(location['id']);
                              print(selectedLocationNames);
                              print(selectedLocationIds);
                            } else {
                              selectedLocationNames.remove(location['name']);
                              selectedLocationIds.remove(location['id']);
                              print(selectedLocationNames);
                              print(selectedLocationIds);
                            }
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    // Perform actions with the selected locations
                    print('Selected Locations: ${selectedLocationNames.join(', ')}');
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // body: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           TextField(
  //           controller: startDatetimeController,
  //           onTap: () {
  //             _selectDateTime(startDatetimeController);
  //           },
  //           decoration: InputDecoration(labelText: 'Start Datetime (YYYY-MM-DD HH:MM:SS)'),
  //         ),
  //         TextField(
  //           controller: endDatetimeController,
  //           onTap: () {
  //             _selectDateTime(endDatetimeController);
  //           },
  //           decoration: InputDecoration(labelText: 'End Datetime (YYYY-MM-DD HH:MM:SS)'),
  //         ),
  //         ElevatedButton(
  //           onPressed: (){_showLocationSelectionDialog(context);},
  //           child: Text('Select Locations'),
  //         ),
  //           ElevatedButton(
  //             onPressed: () {
  //               // Replace [1, 2, 3] with the actual list of location IDs you want to restrict
  //               // List<int> locationIds = [];
  //               // String startDatetime = startDatetimeController.text;
  //               // String endDatetime = endDatetimeController.text;
  //               // restrictLocation(locationIds, startDatetime, endDatetime);
  //               print(startDatetimeController.text);
  //               print(endDatetimeController.text);
  //             },
  //             child: Text('Restrict Location'),
  //           ),
  //         ],
  //       ),
  //     ),


  // -------------------------------------------------------------------------------------------

  List<Map<String, dynamic>> visitorReportById = [];

  Future<void> fetchVisitorReportById() async {
    final url = "${APIHandler.ip}"; 
    final visitorId = '44'; 

    try {
      final response = await http.get(Uri.parse('$url/GetVisitorReport?id=$visitorId'));

      if (response.statusCode == 200) {
        setState(() {
          visitorReportById = List<Map<String, dynamic>>.from(
              json.decode(response.body) as List<dynamic>);
          print('visitorReportById: $visitorReportById');
          print('Image data: ${visitorReportById[0]['image']}');
          isLoading = false;
        });
      } else {
        print("Failed to load visitor report. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching visitor report: $e");
    }
  }

  // body: isLoading
  //     ? Center(child: CircularProgressIndicator())
  //     : ListView.builder(
  //         itemCount: visitorReportById.length,
  //         itemBuilder: (context, index) {
  //           final visitInfo = visitorReportById[index];
  //           return ListTile(
  //             title: Text('Visit ID: ${visitInfo['VisitID'] ?? 'N/A'}'),
  //             subtitle: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text('Visitor ID: ${visitInfo['VisitorId'] ?? 'N/A'}'),
  //                 Text('Visitor Name: ${visitInfo['VisitorName'] ?? 'N/A'}'),
  //                 Text('Visitor Phone: ${visitInfo['VisitorPhone'] ?? 'N/A'}'),
  //                 Text('Locations Visited: ${visitInfo['LocationsVisited'] ?? 'N/A'}'),
  //                 Text('Visit Date: ${visitInfo['VisitDate'] ?? 'N/A'}'),
  //                 Text('Entry Time: ${visitInfo['EntryTime'] ?? 'N/A'}'),
  //                 Text('Exit Time: ${visitInfo['ExitTime'] ?? 'N/A'}'),
  //                 // Uncomment the following lines if you want to display the visitor's image
  //                 // visitInfo['image'] != null?Image.memory(
  //                 //   base64Decode(visitInfo['image'] ?? ''),
  //                 //   width: 50,
  //                 //   height: 50,
  //                 // ):Text('Image Not Found'),
  //               ],
  //             ),
  //           );
  //         },
  //       )


  // -------------------------------------------------------------------------------------------

  // TextEditingController visitorIdController = TextEditingController();
  Map<String, dynamic> visitData = {};

  Future<void> getVisitDestinations() async {
    final url = "${APIHandler.ip}"; // Replace with your actual API endpoint URL

    // final visitorId = visitorIdController.text;
    final visitorId = 44;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('$url/GetVisitDestinations?id=$visitorId'),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData);
        setState(() {
          visitData = responseData;
          isLoading = false;
        });
      } else {
        print("Failed to fetch visit destinations. Status code: ${response.statusCode}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching visit destinations: $e");
      setState(() {
        isLoading = false;
      });
    }
  }



  @override
  void initState() {
    super.initState();
    // fetchUsers();
    // fetchGuardsLocations();
    // fetchGuardDutyLocation();
    // fetchUserDetails();
    // fetchFloors();
    // fetchLocations();
    // fetchLocationDetails();
    // fetchLocationsByFloor();
    // fetchLocationByCamera();
    // fetchLocationByCameraId();
    // fetchAllCameras();
    // fetchCamerasLocationsConnections();
    // fetchCameraByLocation();
    // fetchAdjacencyMatrix();
    fetchRestrictedCameras();
    fetchVisitorsReport();
    // fetchAlertCount();
    fetchCurrentAlerts();
    // fetchAllAlerts();
    // fetchAllVisitors();
    fetchCurrentVisitors();
    // fetchBlockedVisitors();
    // recognizeVisitorWithImage();
    // fetchDetectedFrame();
    fetchVisitPathHistory();
    fetchVisitEntryTime();
    // fetchPaths();
    // fetchLocationPaths();
    // fetchConnectionMatrix();
    fetchRestrictedLocations();
    // fetchVisitorReport();   // Download Visitor report
    // fetchDumpedImages();
    // restrictLocation();
    // fetchVisitorReportById();
    getVisitDestinations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Get all data')),
      
    );
  }
}





class GAllUser {
  int id;
  String name;
  String username;
  String password;
  String role;
  int dutyLocation; // Assuming duty_location is an integer

  // Constructor
  GAllUser({
    required this.id,
    required this.name,
    required this.username,
    required this.password,
    required this.role,
    required this.dutyLocation,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'username': username,
      'password': password,
      'role': role,
      'dutyLocation': dutyLocation,
    };
  }

  // Factory method to create a GAllUser instance from a Map
  factory GAllUser.fromJson(Map<String, dynamic> json) {
    return GAllUser(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? '',
      dutyLocation: json['duty_location'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  // factory GAllUser.fromJson(String source) => GAllUser.fromMap(json.decode(source) as Map<String, dynamic>);
}


class GAllGuardLocations {
  final int id;
  final String name;
  final String username;
  final String password;
  final String role;
  final int dutyLocation;
  final int locationId;
  final String locationName;

  GAllGuardLocations({
    required this.id,
    required this.name,
    required this.username,
    required this.password,
    required this.role,
    required this.dutyLocation,
    required this.locationId,
    required this.locationName,
  });

  factory GAllGuardLocations.fromJson(Map<String, dynamic> json) {
    return GAllGuardLocations(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      password: json['password'],
      role: json['role'],
      dutyLocation: json['duty_location'],
      locationId: json['location_id'],
      locationName: json['location_name'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'username': username,
      'password': password,
      'role': role,
      'dutyLocation': dutyLocation,
      'locationId': locationId,
      'locationName': locationName,
    };
  }

  // factory GAllGuardLocations.fromMap(Map<String, dynamic> map) {
  //   return GAllGuardLocations(
  //     id: map['id'] as int,
  //     name: map['name'] as String,
  //     username: map['username'] as String,
  //     password: map['password'] as String,
  //     role: map['role'] as String,
  //     dutyLocation: map['dutyLocation'] as int,
  //     locationId: map['locationId'] as int,
  //     locationName: map['locationName'] as String,
  //   );
  // }

  String toJson() => json.encode(toMap());

  // factory GAllGuardLocations.fromJson(String source) => GAllGuardLocations.fromMap(json.decode(source) as Map<String, dynamic>);
}

class GAllFloor {
  final int id;
  final String name;

  GAllFloor({
    required this.id,
    required this.name,
  });

  factory GAllFloor.fromJson(Map<String, dynamic> json) {
    return GAllFloor(
      id: json['id'],
      name: json['name'],
    );
  }
}

class GAllLocation {
  final int id;
  final int? floorId;
  final String? floorName;
  // final int locationId;
  final String locationName;
  final String isDestination;
  final String typeName;

  GAllLocation({
    required this.id,
    required this.floorId,
    required this.floorName,
    // required this.locationId,
    required this.locationName,
    required this.isDestination,
    required this.typeName,
  });

  factory GAllLocation.fromJson(Map<String, dynamic> json) {
    return GAllLocation(
      id: json['id'],
      floorId: json['floor_id'],
      floorName: json['floor_name'],
      // locationId: json['location_id'],
      locationName: json['name'],
      isDestination: json['isDestination'],
      typeName: json['type'],
    );
  }

  static List<GAllLocation> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => GAllLocation.fromJson(json)).toList();
  }
}

class GAllCamera {
  final int id;
  final String? name;

  GAllCamera({
    required this.id,
    required this.name,
  });

  factory GAllCamera.fromJson(Map<String, dynamic> json) {
    return GAllCamera(
      id: json['id'],
      name: json['name'],
    );
  }

  static List<GAllCamera> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => GAllCamera.fromJson(json)).toList();
  }
}

class GAllCameraLocationConnection {
  final int id;
  // final GAllCamera camera;
  final String camera;
  final List<String?> connectedCameraNames;
  final List<int> locationIDs;
  final List<String?> locationNames;
  final List<int> timeToReach;

  GAllCameraLocationConnection({
    required this.id,
    required this.camera,
    required this.connectedCameraNames,
    required this.locationIDs,
    required this.locationNames,
    required this.timeToReach,
  });

  factory GAllCameraLocationConnection.fromJson(Map<String, dynamic> json) {
    return GAllCameraLocationConnection(
      id: json['id'],
      // camera: GAllCamera.fromJson(json),
      camera:  json['CameraName'] as String,
      connectedCameraNames: (json['ConnectedCameraNames'] as String?)?.split(',') ?? [],
      locationIDs: _parseLocationIDs(json['LocationIDs']),
      locationNames: (json['LocationNames'] as String?)?.split(',') ?? [],
      timeToReach: (json['TimeToReach'] as String?)?.split(',').map(int.parse).toList() ?? [],
    );
  }

  static List<int> _parseLocationIDs(dynamic locationIDs) {
    if (locationIDs is List<int>) {
      return locationIDs;
    } else if (locationIDs is String) {
      return locationIDs.split(',').map(int.tryParse).whereType<int>().toList();
    } else {
      return [];
    }
  }

  static List<GAllCameraLocationConnection> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => GAllCameraLocationConnection.fromJson(json)).toList();
  }
}


class GAllAdjacencyMatrix {
  final List<String> columnNames;
  final List<String> rowNames;
  final List<List<int>> matrix;

  GAllAdjacencyMatrix({
    required this.columnNames,
    required this.rowNames,
    required this.matrix,
  });

  factory GAllAdjacencyMatrix.fromJson(Map<String, dynamic> json) {
    return GAllAdjacencyMatrix(
      columnNames: List<String>.from(json['columnNames']),
      rowNames: List<String>.from(json['rowNames']),
      matrix: (json['matrix'] as List<dynamic>).map((row) => List<int>.from(row)).toList(),
    );
  }
}

class GAllCameraMatrixData {
  final GAllAdjacencyMatrix adjacencyMatrix;

  GAllCameraMatrixData({
    required this.adjacencyMatrix,
  });

  factory GAllCameraMatrixData.fromJson(Map<String, dynamic> json) {
    return GAllCameraMatrixData(
      adjacencyMatrix: GAllAdjacencyMatrix.fromJson(json),
    );
  }
}

class GAllVisitorReport {
  final String entryTime;
  final String? exitTime;
  final String locationsVisited;
  final String visitDate;
  final int visitID;
  final String visitorName;
  final String visitorPhone;

  GAllVisitorReport({
    required this.entryTime,
    required this.exitTime,
    required this.locationsVisited,
    required this.visitDate,
    required this.visitID,
    required this.visitorName,
    required this.visitorPhone,
  });

  factory GAllVisitorReport.fromJson(Map<String, dynamic> json) {
    return GAllVisitorReport(
      entryTime: json['EntryTime'],
      exitTime: json['ExitTime'],
      locationsVisited: json['LocationsVisited'],
      visitDate: json['VisitDate'],
      visitID: json['VisitID'],
      visitorName: json['VisitorName'],
      visitorPhone: json['VisitorPhone'],
    );
  }

  static List<GAllVisitorReport> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => GAllVisitorReport.fromJson(json)).toList();
  }
}

class GAllVisitor {
  final String block;
  final int id;
  final String name;
  final String phone;

  GAllVisitor({
    required this.block,
    required this.id,
    required this.name,
    required this.phone,
  });

  factory GAllVisitor.fromJson(Map<String, dynamic> json) {
    return GAllVisitor(
      block: json['block'],
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
    );
  }

  static List<GAllVisitor> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => GAllVisitor.fromJson(json)).toList();
  }
}


class GAllCurrentVisitor {
  final int id;
  final String name;
  final String phone;
  final String entryTime;
  final String locationIds;
  final String locationNames;
  final String currentLocation;
  final String image;

  GAllCurrentVisitor({
    required this.id,
    required this.name,
    required this.phone,
    required this.entryTime,
    required this.locationIds,
    required this.locationNames,
    required this.currentLocation,
    required this.image,
  });

  factory GAllCurrentVisitor.fromJson(Map<String, dynamic> json) {
    return GAllCurrentVisitor(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      entryTime: json['entry_time'],
      locationIds: json['location_ids'],
      locationNames: json['location_names'],
      currentLocation: json['current_location'],
      image: json['image'],
    );
  }
}


class GAllAlert {
  final int id;
  final String type;
  final String date;
  final String time;
  final int visitId;
  final String visitorName;
  final String visitorContact;
  final int cameraId;
  final int locationId;
  final String destinations;
  final String cameraName;
  final String currentLocation;

  GAllAlert({
    required this.id,
    required this.type,
    required this.date,
    required this.time,
    required this.visitId,
    required this.visitorName,
    required this.visitorContact,
    required this.cameraId,
    required this.locationId,
    required this.destinations,
    required this.cameraName,
    required this.currentLocation,
  });

  factory GAllAlert.fromJson(Map<String, dynamic> json) {
    return GAllAlert(
      id: json['id'],
      type: json['type'],
      date: json['date'],
      time: json['time'],
      visitId: json['visit_id'],
      visitorName: json['visitor_name'],
      visitorContact: json['visitor_contact'],
      cameraId: json['camera_id'],
      locationId: json['location_id'],
      destinations: json['destinations'],
      cameraName: json['camera_name'],
      currentLocation: json['current_location'],
    );
  }

  static List<GAllAlert> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => GAllAlert.fromJson(json)).toList();
  }
}


class GAllVisitPathHistory {
  final int visitId;
  final String time;
  final int cameraId;
  final int isViolated;
  final String cameraName;
  final String floorName;
  final String locations;

  GAllVisitPathHistory({
    required this.visitId,
    required this.time,
    required this.cameraId,
    required this.isViolated,
    required this.cameraName,
    required this.floorName,
    required this.locations,
  });

  factory GAllVisitPathHistory.fromJson(Map<String, dynamic> json) {
    return GAllVisitPathHistory(
      visitId: json['visit_id'] ?? 0,
      time: json['time'] ?? '',
      cameraId: json['camera_id'] ?? 0,
      isViolated: json['is_violated'] ?? false,
      cameraName: json['camera_name'] ?? '',
      floorName: json['floor_name'] ?? '',
      locations: json['locations'] ?? '',
    );
  }
}


class GAllDumpedImage {
  final String filename;
  final String camera;
  final String fullPath;
  final String date;
  final String time;
  final String image;

  GAllDumpedImage({
    required this.filename,
    required this.camera,
    required this.fullPath,
    required this.date,
    required this.time,
    required this.image,
  });

  factory GAllDumpedImage.fromJson(Map<String, dynamic> json) {
    return GAllDumpedImage(
      filename: json['filename'] ?? '',
      camera: json['camera'] ?? '',
      fullPath: json['full_path'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      image: json['image'] ?? '',
    );
  }
}



class GAllRestrictedLocation {
  final int restrictedId;
  final int locationId;
  final String name;
  final String startDatetime;
  final String endDatetime;

  GAllRestrictedLocation({
    required this.restrictedId,
    required this.locationId,
    required this.name,
    required this.startDatetime,
    required this.endDatetime,
  });

  factory GAllRestrictedLocation.fromJson(Map<String, dynamic> json) {
    return GAllRestrictedLocation(
      restrictedId: json['restricted_id'] ?? 0,
      locationId: json['location_id'] ?? 0,
      name: json['name'] ?? '',
      startDatetime: json['start_datetime'] ?? '',
      endDatetime: json['end_datetime'] ?? '',
    );
  }
}
