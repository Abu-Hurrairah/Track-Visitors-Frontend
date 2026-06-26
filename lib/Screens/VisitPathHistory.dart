import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:project/APIHandler/api.dart';
import 'package:project/CommonUtils.dart/LogoutConfirmationDialog.dart';
import 'package:project/Screens/Guard.dart';

class VisitPathHistoryScreen extends StatefulWidget {
  int visitorId;
  String VisitorName;
  VisitPathHistoryScreen(this.visitorId,this.VisitorName);

  @override
  State<VisitPathHistoryScreen> createState() => _VisitPathHistoryScreenState();
}

class _VisitPathHistoryScreenState extends State<VisitPathHistoryScreen> {
  List<Map<String, dynamic>> visitPathHistory = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    // Call the function to get visit path history data
    // Replace 123 with the actual visitor ID
    int visitorId = widget.visitorId;
    Map<String, dynamic> result = await getVisitPathHistory(visitorId);

    if (result.containsKey('data')) {
      setState(() {
        // Update the state with the fetched data
        visitPathHistory = List<Map<String, dynamic>>.from(result['data']);
      });
    } else {
      // Handle error
      String errorMessage = result['error'];
      int statusCode = result['statusCode'];
      print('Error: $errorMessage, Status code: $statusCode');
    }
  }

  Future<Map<String, dynamic>> getVisitPathHistory(int visitorId) async {
    try {
      final response = await http.post(
        Uri.parse('${APIHandler.ip}/GetVisitPathHistory'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'visitor_id': visitorId}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        print(jsonResponse);
        return {'data': jsonResponse, 'statusCode': 200};
      } else {
        print('Failed to fetch visit path history. Status code: ${response.statusCode}');
        return {'error': 'Failed to fetch visit path history.', 'statusCode': response.statusCode};
      }
    } catch (e) {
      print('Error fetching visit path history: $e');
      return {'error': 'Failed to fetch visit path history.', 'statusCode': 500};
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Visit Path History'),
      // ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: OrientationBuilder(
          builder: (context, orientation) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  orientation == Orientation.portrait ?SizedBox(height: 35,):SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context){
                              return GuardScreen();
                            })
                          );
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue,width: 2),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(Icons.arrow_back,color: Colors.blue,)
                            ),
                          ),
                        )
                      ),
                      // SizedBox(width: 800),
                      GestureDetector(
                        onTap: () {
                          showLogoutConfirmationDialog(context);
                          // Navigator.of(context).pushReplacement(
                          //   MaterialPageRoute(builder: (context){
                          //     return Login();
                          //   })
                          // );
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Container(
                            height: 25,
                            // width: 200,
                            // width: double.infinity,
                            child: Text('Logout',style: TextStyle(fontSize: 20,color: Colors.blue),textAlign: TextAlign.right,)
                          ),
                        )
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Text('Visit Current Path',style: TextStyle(fontSize: 30,color: Colors.blue),),
                  orientation == Orientation.portrait ?SizedBox(height: 30,):SizedBox(height: 15,),
                  Align(alignment: Alignment.centerLeft,child: Text('    ${widget.VisitorName}',style: TextStyle(fontSize: 20),)),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: orientation == Orientation.portrait ? 200 : 180,  // Adjust the height based on orientation
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: visitPathHistory.length * 2 - 1, // Double the itemCount to account for separators
                            itemBuilder: (context,index){
                              if (index.isOdd) {
                                // Separator
                                return Icon(Icons.arrow_forward,size: 30, color: Colors.blue); // Change this to your desired icon
                              }
                              // Actual item
                              final dataIndex = index ~/ 2;
                              dynamic data = visitPathHistory[dataIndex];
                              // Use null-aware operators to handle null values
                              String cameraName = data['camera_name']?.toString() ?? 'N/A';
                              String floorName = data['floor_name']?.toString() ?? 'N/A';
                              // Format the time
                              String time = data['time']?.toString() ?? 'N/A';
                              if (time != 'N/A') {
                                // Parse the time string into a DateTime object
                                DateTime dateTime = DateTime.parse('2022-01-01 $time');

                                // Format the DateTime object as a string with the desired format
                                time = DateFormat('hh:mm a').format(dateTime);
                              }
                              return Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                                // color: Color(int.parse((data['ColorCode'] as String))),
                                child: Container(
                                  // width: 180,  // Set a specific width for each card (adjust according to your needs)
                                  width: orientation == Orientation.portrait ? 180 : 200,  // Adjust the width based on orientation
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      orientation == Orientation.portrait ?Text("${data['locations']}", style: TextStyle(fontSize: 20,)):Text("${data['locations']}", style: TextStyle(fontSize: 20,)),
                                      orientation == Orientation.portrait ?SizedBox(height: 20,):SizedBox(height: 10,),
                                      orientation == Orientation.portrait ?Text("${cameraName}", style: TextStyle(fontSize: 19,)):Text("${cameraName}", style: TextStyle(fontSize: 19,)),
                                      orientation == Orientation.portrait ?SizedBox(height: 20,):SizedBox(height: 10,),
                                      orientation == Orientation.portrait ?Text("${floorName}", style: TextStyle(fontSize: 18,)):Text("${floorName}", style: TextStyle(fontSize: 18,)),
                                      orientation == Orientation.portrait ?SizedBox(height: 20,):SizedBox(height: 10,),
                                      orientation == Orientation.portrait ?Text("${time}", style: TextStyle(fontSize: 17,)):Text("${time}", style: TextStyle(fontSize: 17,)),
                                      // ListTile(
                                      //   leading: Text("Locations : ${data['locations']}", style: TextStyle(fontWeight: FontWeight.bold)),
                                      //   title: Text("Camera Name: ${cameraName}"),
                                      //   subtitle: Column(
                                      //     children: [
                                      //       Text("Floor Name : ${floorName}"),
                                      //       SizedBox(height: 10,),
                                      //       Text("Time : ${time}"),
                                      //     ],
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          }
        ),
      )
      // body: ListView.builder(
      //   itemCount: visitPathHistory.length,
      //   itemBuilder: (context, index) {
      //     Map<String, dynamic> visitData = visitPathHistory[index];
      //     return ListTile(
      //       title: Text('Visit ID: ${visitData['visit_id']}'),
      //       subtitle: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           // Text('Visitor Name: ${widget.VisitorName}'),
      //           Text('Time: ${DateFormat.jm().format(DateTime(2000, 1, 1, int.parse(visitData['time'].split(':')[0]), int.parse(visitData['time'].split(':')[1]), int.parse(visitData['time'].split(':')[2].split('.')[0])))}'),
      //           // Text('Time: ${visitData['time']}'),
      //           Text('Camera ID: ${visitData['camera_id']}'),
      //           Text('Camera Name: ${visitData['camera_name']}'),
      //           Text('Floor Name: ${visitData['floor_name']}'),
      //           Text('Locations: ${visitData['locations']}'),
      //           // Add more fields as needed
      //         ],
      //       ),
      //     );
      //   },
      // // body: ListView.builder(
      // //   itemCount: visitPathHistory.length,
      // //   itemBuilder: (context, index) {
      // //     Map<String, dynamic> visitData = visitPathHistory[index];
      // //     return ListTile(
      // //       title: Text('Visit ID: ${visitData['visit_id']}'),
      // //       subtitle: Text('Time: ${visitData['time']}'),
      // //     );
      // //   },
      // ),
    );
  }
}