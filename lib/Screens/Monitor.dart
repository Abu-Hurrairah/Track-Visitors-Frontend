import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project/APIHandler/api.dart';
import 'package:project/CommonUtils.dart/LogoutConfirmationDialog.dart';
import 'package:project/Global/MonitorGlobal.dart';
import 'package:project/Screens/Login.dart';
import 'package:project/Screens/MonitorDashBoard.dart';

class MonitorScreen extends StatefulWidget {
  const MonitorScreen({super.key});

  @override
  State<MonitorScreen> createState() => _MonitorScreenState();
}

class _MonitorScreenState extends State<MonitorScreen> {
  String monitorName = MonitorGlobal.monitorGlobal;

  List<dynamic> alerts = []; // Store alerts data here
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    fetchAlerts(); // Fetch data when the screen loads
    startTimer(); // Start the timer for periodic data fetch
  }

  void startTimer() {
    // Fetch data every minute (60 seconds)
    Timer.periodic(Duration(minutes: 1), (timer) {
      if (mounted) {
        // Check if the widget is still mounted before calling fetchAlerts
        fetchAlerts();
      }
    });
  }

  Future<void> fetchAlerts() async {
    try {
      var response = await APIHandler.getAllAlerts();
      // if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        setState(() {
          alerts = response;
          print(alerts);
          isLoading = false; // Data is loaded, set loading state to false
        });
      // } else {
        // If the server did not return a 200 OK response,
        // throw an exception or handle the error as needed
        // print('Failed to load alerts: ${response.statusCode}');
        // setState(() {
        //   isLoading = false; // Set loading state to false even in case of error
        // });
      // }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false; // Set loading state to false in case of exception
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Alerts'),),
      body: Padding(
        padding: EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(height: 20,),
            // GestureDetector(
            //   onTap: () {
            //     setState(() {
            //       showLogoutConfirmationDialog(context);
            //       // Navigator.of(context).pushReplacement(
            //       //   MaterialPageRoute(builder: (context){
            //       //     return Login();
            //       //   })
            //       // );
            //     });
            //   },
            //   child: MouseRegion(
            //     cursor: SystemMouseCursors.click,
            //     child: Container(
            //       height: 25,
            //       width: double.infinity,
            //       child: Text('Logout',style: TextStyle(fontSize: 20,color: Colors.blue),)
            //     ),
            //   )
            // ),
            // SizedBox(height: 15,),
            // Text('Welcome, ${monitorName}',style: TextStyle(fontSize: 30,color: Colors.blue),),
            // SizedBox(height: 5,),
            // Text('Monitor',style: TextStyle(fontSize: 20,color: Colors.blue),),
            // SizedBox(height: 30,),
            if (isLoading)
            CircularProgressIndicator()
          else if (alerts.isEmpty)
            Text('No alerts available.')
          else
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: alerts.length,
                itemBuilder: (context, index) {
                  final alert = alerts[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: alert['type'] == 'warning' ? Color(0xFFFFD9D9) : Color(0xFFFFAC7B), // Set the background color to red
                      borderRadius: BorderRadius.circular(10.0), // Set border radius to make it circular
                    ),
                    padding: EdgeInsets.all(16), // Add padding to create space
                    margin: EdgeInsets.symmetric(vertical: 8), // Add margin for spacing between alerts
                    child: ListTile(
                      title: Align(
                        alignment: Alignment.topCenter, // Align the title to the top center
                        child: Text('Destination: ${alert['destinations']}',style: TextStyle(fontSize: 25,color: Colors.black),),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 15,),
                          // Text('Visitor deviated from path',style: TextStyle(fontSize: 20,color: Colors.white),),
                          // SizedBox(height: 10,),
                          Text('Visitor Name: ${alert['visitor_name']}',style: TextStyle(fontSize: 18,color: Colors.black),),
                          SizedBox(height: 5,),
                          Text('Contact: ${alert['visitor_contact']}',style: TextStyle(fontSize: 18,color: Colors.black),),
                          SizedBox(height: 5,),
                          Text('Current Location: ${alert['current_location']}',style: TextStyle(fontSize: 18,color: Colors.black),),
                          SizedBox(height: 5,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('${alert['type']}',style: TextStyle(fontSize: 18,color: Colors.black),),
                            ],
                          ),
                        ],
                      ),
                    ),
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
                  );
                },
              ),
            ),
          ]
        )
      )
    );
  }
}