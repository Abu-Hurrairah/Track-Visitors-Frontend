import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project/APIHandler/api.dart';
import 'package:project/CommonUtils.dart/LogoutConfirmationDialog.dart';
import 'package:project/Screens/Admin.dart';
import 'package:project/Screens/Guard.dart';
import 'package:project/Screens/Login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AllAlertsScreen extends StatefulWidget {
  const AllAlertsScreen({super.key});

  @override
  State<AllAlertsScreen> createState() => _AllAlertsScreenState();
}

class _AllAlertsScreenState extends State<AllAlertsScreen> {
  List<dynamic> alerts = []; // Store alerts data here
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    fetchAlerts(); // Fetch data when the screen loads  // This Function Has CircularProgressIndicator()
    startTimer(); // Start the timer for periodic data fetch
  }

  void startTimer() {
    // Fetch data every minute (60 seconds)
    Timer.periodic(Duration(minutes: 1), (timer) {
      if (mounted) {
        // Check if the widget is still mounted before calling fetchAlerts
        fetchAlerts();
        setState(() {
          
        });
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
            Text('All Alerts',style: TextStyle(fontSize: 30,color: Colors.blue),),
            SizedBox(height: 20,),
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
                    // TimeOfDay _time = new TimeOfDay.now();
                    return Container(
                      decoration: BoxDecoration(
                        color: alert['type'] == 'warning' ? Color(0xFFFFD9D9) : Color(0xFFFFAC7B), // Set the background color to red
                        borderRadius: BorderRadius.circular(10.0), // Set border radius to make it circular
                      ),
                      padding: EdgeInsets.all(16), // Add padding to create space
                      margin: EdgeInsets.symmetric(vertical: 8), // Add margin for spacing between alerts
                      child: ListTile(
                        title: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text('Destination: ${alert['destinations']}',style: TextStyle(fontSize: 17,color: Colors.black),)
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Text('${alert['time']}',style: TextStyle(fontSize: 17,color: Colors.black),)
                                ),
                              ],
                            ),
                            SizedBox(height: 4,),
                            Container(
                              height: 2,
                              color: Colors.white,
                            )
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10,),
                            Align(alignment: Alignment.centerRight,child: Text('Camera-- ${alert['camera_name']}',style: TextStyle(fontSize: 16,color: Colors.black))),
                            // Text('Visitor deviated from path',style: TextStyle(fontSize: 20,color: Colors.white),),
                            SizedBox(height: 10,),
                            Text('Visitor Name: ${alert['visitor_name']}',style: TextStyle(fontSize: 16,color: Colors.black),),
                            SizedBox(height: 5,),
                            Text('Contact: ${alert['visitor_contact']}',style: TextStyle(fontSize: 16,color: Colors.black),),
                            SizedBox(height: 5,),
                            Text('Current Location: ${alert['current_location']}',style: TextStyle(fontSize: 16,color: Colors.black),),
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
          ],
        ),
      ),
    );
  }
}