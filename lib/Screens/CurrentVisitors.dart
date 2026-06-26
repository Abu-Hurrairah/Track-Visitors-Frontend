import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/APIHandler/api.dart';
import 'package:project/CommonUtils.dart/LogoutConfirmationDialog.dart';
// import 'package:project/Global/VisitorVisitData.dart';
import 'package:project/Screens/Admin.dart';
import 'package:project/Screens/DestinationPaths.dart';
import 'package:project/Screens/Guard.dart';
import 'package:project/Screens/Login.dart';
import 'package:http/http.dart' as http;
import 'package:project/Screens/VisitPathHistory.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:provider/provider.dart';

class CurrentVisitorsScreen extends StatefulWidget {
  // const CurrentVisitorsScreen({super.key});
  final String sourceScreen;

  CurrentVisitorsScreen({required this.sourceScreen});

  @override
  State<CurrentVisitorsScreen> createState() => _CurrentVisitorsScreenState();
}

class _CurrentVisitorsScreenState extends State<CurrentVisitorsScreen> {
  TextEditingController controller_searchVisitor=TextEditingController();

  List<dynamic> alerts = []; // Store alerts data here
  bool isLoading = true; // Track whether data is still loading

  @override
  void initState() {
    super.initState();
    // fetchCurrentAlerts(); // Fetch data when the screen loads
    getCurrentVisitors();
  }

  Future<void> fetchCurrentAlerts() async {
    final url = Uri.parse('${APIHandler.ip}/GetCurrentAlerts'); // Replace with your actual server URL and endpoint
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          alerts = jsonResponse;
          print(alerts);
        });
      } else {
        print('Failed to fetch current alerts: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  List<dynamic> visitors = [];
  Future<void> getCurrentVisitors() async {
    setState(() {
      isLoading = true; // Set loading to true when starting API call
    });
    final url = Uri.parse('${APIHandler.ip}/GetCurrentVisitors'); 
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          visitors = jsonResponse;
          isLoading = false; // Set loading to false when API call completes
          print(visitors);
          if(visitors.isEmpty)
            showNoVisitorsDialog(context);
        });
      } else {
        print('Failed to fetch current alerts: ${response.statusCode}');
        isLoading = false; // Set loading to false in case of an error
      }
    } catch (e) {
      print('Error fetching data: $e');
      isLoading = false; // Set loading to false in case of an exception
    }
  }

  String formatTime(String rawTime) {
    // Split the raw time string into hours, minutes, and seconds
    List<String> timeParts = rawTime.split(':');

    // Parse each part into integers
    int hours = int.parse(timeParts[0]);
    int minutes = int.parse(timeParts[1]);
    int seconds = int.parse(timeParts[2].split('.')[0]); // Extract seconds and remove milliseconds

    // Create a DateTime object with the current date and the parsed time
    DateTime time = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, hours, minutes, seconds);

    // Format the DateTime object to "05:11 PM"
    String formattedTime = DateFormat.jm().format(time);

    return formattedTime;
  }

  showNoVisitorsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No Current Visitors'),
          content: Text('There are currently no visitors.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> getVisitorData(int visitorId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String visitorKey = 'visitor_$visitorId';
    
    // Retrieve the JSON response from shared preferences
    String? jsonResponse = prefs.getString('$visitorKey.jsonResponse');
    // Convert the JSON response back to a Map<String, dynamic>
    Map<String, dynamic> jsonData = jsonDecode(jsonResponse!);

    // Access the nested lists or other data as needed
    List<List<String>> savedPaths = [];
    if (jsonData.containsKey('paths')) {
      savedPaths = (jsonData['paths'] as List)
          .map((path) => List<String>.from(path))
          .toList();
    }

    List<List<String>> savedLocationPaths = [];
    if (jsonData.containsKey('locationPaths')) {
      savedLocationPaths = (jsonData['locationPaths'] as List)
          .map((locationPath) => List<String>.from(locationPath))
          .toList();
    }
    int? savedVisitorId = prefs.getInt('$visitorKey.visitorId');
    String? savedVisitTime = prefs.getString('$visitorKey.visitTime');
    print(visitorKey);
    print(savedPaths);
    print(savedLocationPaths);
    print(savedVisitorId);
    print(savedVisitTime);
    if(savedPaths==null || savedLocationPaths==null || savedVisitorId==null || savedVisitTime==null){
      print('Visitor ${visitorId} Visit Data Not Found');
      return;
    }
    else{
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context)=>DestinationPathsScreen(savedLocationPaths,savedPaths,savedVisitorId,savedVisitTime))
      );
    }
    // Use the retrieved data as needed
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigate back to the appropriate screen based on sourceScreen
                    if (widget.sourceScreen == 'Guard') {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => GuardScreen())
                      );
                    } else if (widget.sourceScreen == 'Admin') {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => Admin())
                      );
                    }
                    // Pop the Current Visitors Screen and go back to the previous screen
                    // Navigator.of(context).popUntil(ModalRoute.withName('/'));
                    //  Navigator.of(context).pushReplacement(
                    //    MaterialPageRoute(builder: (context){
                    //      return GuardScreen();
                    //    })
                    //  );
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
                    //  Navigator.of(context).pushReplacement(
                    //    MaterialPageRoute(builder: (context){
                    //      return Login();
                    //    })
                    //  );
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
            Text('Current Visitor',style: TextStyle(fontSize: 30,color: Colors.blue),),
            // SizedBox(height: 30,),
            // Container(
            //   height: 50,
            //   width: 400,
            //   child: TextField(
            //     controller: controller_searchVisitor,
            //     decoration: InputDecoration(
            //       hintText: 'Search Visitor',
            //       hintStyle: TextStyle(color: Colors.blue),
            //       // Add a clear button to the search bar
            //       suffixIcon: IconButton(
            //         icon: Icon(Icons.clear,color: Colors.blue,),
            //         onPressed: () => controller_searchVisitor.clear(),
            //       ),
            //       // Add a search icon or button to the search bar
            //       prefixIcon: IconButton(
            //         icon: Icon(Icons.search,color: Colors.blue,),
            //         onPressed: () {
            //           // Perform the search here
            //         },
            //       ),
            //       enabledBorder: OutlineInputBorder(
            //         borderSide:
            //           BorderSide(width: 1, color: Colors.blue), //<-- SEE HERE
            //         borderRadius: BorderRadius.circular(30.0)
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(height: 20,),
            // DataTable(
            //   columnSpacing: 2,
            //   columns: [
            //     DataColumn(label: Text('Name', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            //     DataColumn(label: Text('Entry Time', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            //     DataColumn(label: Text('Destination', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            //   ],
            //   rows: visitors.map((visitor) {
            //     return DataRow(cells: [
            //       DataCell(Text(visitor['name'], style: TextStyle(fontSize: 18))),
            //       DataCell(Text(visitor['entry_time'], style: TextStyle(fontSize: 18))),
            //       DataCell(Text(visitor['location_names'], style: TextStyle(fontSize: 18))),
            //     ]);
            //   }).toList(),
            // )
          
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.8, // Set a specific height constraint
                child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(), // Show a loading indicator
                        )
                      : visitors.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('No current visitors.'),
                                
                              ],
                            ),
                          )
                      : ListView.builder(
                  shrinkWrap: true,
                  // itemCount: alerts.length,
                  itemCount: visitors.length,
                  itemBuilder: (context, index) {
                    // final alert = alerts[index];
                    final visitor = visitors[index];
                    return GestureDetector(
                      onTap: (){
                        getVisitorData(visitor['id']);

                        // Navigate to the next screen with the specific visitor id
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => VisitPathHistoryScreen(visitor['id'],visitor['name']),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4, // Set the elevation
                        color: Colors.white, // Set the background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Container(
                          // decoration: BoxDecoration(
                          //   color: Colors.white, // Set the background color to red
                          //   borderRadius: BorderRadius.circular(10.0), // Set border radius to make it circular
                          // ),
                          padding: EdgeInsets.all(16), // Add padding to create space
                          margin: EdgeInsets.symmetric(vertical: 8), // Add margin for spacing between alerts
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('${visitor['name']}',style: TextStyle(fontSize: 18,color: Colors.blue),),
                                        SizedBox(height: 10,),
                                        RichText(
                                          text: TextSpan(
                                            style: DefaultTextStyle.of(context).style,
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: 'Entry Time: ',
                                                style: TextStyle(fontSize: 15, color: Colors.blue),
                                              ),
                                              TextSpan(
                                                text: '${formatTime(visitor['entry_time'])}',
                                                style: TextStyle(fontSize: 18, color: Colors.blue),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Text('Entry Time: ${formatTime(visitor['entry_time'])}',style: TextStyle(fontSize: 18,color: Colors.blue),),
                                        SizedBox(height: 8,),
                                        RichText(
                                          text: TextSpan(
                                            style: DefaultTextStyle.of(context).style,
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: 'Current Location: ',
                                                style: TextStyle(fontSize: 15, color: Colors.blue),
                                              ),
                                              TextSpan(
                                                text: '${visitor['location_names']}',
                                                style: TextStyle(fontSize: 18, color: Colors.blue),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Text('Current Location: ${visitor['location_names']}',style: TextStyle(fontSize: 18,color: Colors.blue),),
                                        SizedBox(height: 20,),
                                        
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          radius: 50,
                                          backgroundImage: visitor['image'] != null
                                            ? MemoryImage(base64Decode(visitor['image']))
                                            : null,
                                          child: visitor['image'] == null
                                            ? Icon(Icons.person, size: 100)
                                            : null,
                                        ),
                                        SizedBox(height: 10,), // Adjust this value based on your preference
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text('Current Location',style: TextStyle(fontSize: 18,color: Colors.blue,fontWeight: FontWeight.bold),),
                                  // Spacer(), // Use Spacer widget to occupy the space
                                  // SizedBox(width: 70,),
                                  Text('${visitor['current_location']}',style: TextStyle(fontSize: 18,color: Colors.blue,fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ],
                          ),
                          //  child: ListTile(
                          //    // title: Align(
                          //    //   alignment: Alignment.topCenter, // Align the title to the top center
                          //    //   // child: Text('Destination: ${alert['destinations']}',style: TextStyle(fontSize: 25,color: Colors.white),),
                          //    //   // child: Text('Destination: ${visitor['location_names']}',style: TextStyle(fontSize: 25,color: Colors.blue),),
                          //    //   child: Text('${visitor['name']}',style: TextStyle(fontSize: 25,color: Colors.blue),),
                          //    // ),
                          //    title: Text('${visitor['name']}',style: TextStyle(fontSize: 18,color: Colors.blue),),
                          //    subtitle: Column(
                          //      crossAxisAlignment: CrossAxisAlignment.start,
                          //      children: [
                          //        SizedBox(height: 10,),
                          //        // Text('Visitor Name: ${alert['visitor_name']}',style: TextStyle(fontSize: 18,color: Colors.white),),
                          //        // Text('Visitor Name: ${visitor['name']}',style: TextStyle(fontSize: 18,color: Colors.blue),),
                          //        // SizedBox(height: 5,),
                          //        // Text('Contact: ${alert['visitor_contact']}',style: TextStyle(fontSize: 18,color: Colors.white),),
                          //        // Text('Contact: ${visitor['phone']}',style: TextStyle(fontSize: 18,color: Colors.blue),),
                          //        // SizedBox(height: 5,),
                          //        // Text('Current Location: ${alert['current_location']}',style: TextStyle(fontSize: 18,color: Colors.white),),
                          //        // Text('Current Location: ${visitor['location_name']}',style: TextStyle(fontSize: 18,color: Colors.white),),
                          //        // SizedBox(height: 5,),
                          //        // Text('Visit Date: ${alert['VisitDate']}',style: TextStyle(fontSize: 18,color: Colors.white),),
                          //        // SizedBox(height: 5,),
                          //        // Text('Entry Time: ${alert['EntryTime']}',style: TextStyle(fontSize: 18,color: Colors.white),),
                          //        Text('${formatTime(visitor['entry_time'])}',style: TextStyle(fontSize: 18,color: Colors.blue),),
                          //        SizedBox(height: 8,),
                          //        Text('${visitor['destination']}',style: TextStyle(fontSize: 18,color: Colors.blue),),
                          //        SizedBox(height: 15,),
                          //        Row(
                          //          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //          children: [
                          //            Text('Current Location',style: TextStyle(fontSize: 18,color: Colors.blue,fontWeight: FontWeight.bold),),
                          //            Spacer(), // Use Spacer widget to occupy the space
                          //            Text('${visitor['current_location']}',style: TextStyle(fontSize: 18,color: Colors.blue,fontWeight: FontWeight.bold),),
                          //          ],
                          //        ),
                          //      ],
                          //    ),
                          //  ),
                          // child: ListTile(
                          //   title: Text('Date: ${alert['date']}'),
                          //   subtitle: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       Text('Time: ${alert['time']}'),
                          //       Text('Visitor: ${alert['visitor_name']}'),
                          //       Text('Location: ${alert['current_location']}'),
                          //       Text('Destinations: ${alert['destinations']}'),
                          //       Text('Camera: ${alert['camera_name']}'),
                          //       Text('Contact: ${alert['visitor_contact']}'),
                          //     ],
                          //   ),
                          // ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ]
        )
      )
    );
  }
}