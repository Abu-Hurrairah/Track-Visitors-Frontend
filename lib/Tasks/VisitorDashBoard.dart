import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project/APIHandler/api.dart';
import 'package:http/http.dart' as http;
import 'package:project/CommonUtils.dart/LogoutConfirmationDialog.dart';

class VisitorDashBoardScreen extends StatefulWidget {
  String VisitorName;
  int VisitorId;
  VisitorDashBoardScreen(this.VisitorId,this.VisitorName);

  @override
  State<VisitorDashBoardScreen> createState() => _VisitorDashBoardScreenState();
}

class _VisitorDashBoardScreenState extends State<VisitorDashBoardScreen> {

  bool isLoading=false;
  Map<String, dynamic> visitorAlerts = {};

  Future<void> getVisitorAlerts() async {
    final url = "${APIHandler.ip}"; 
    int visitorId=widget.VisitorId;
    // final visitorId = visitorIdController.text;
    // final visitorId = 44;
    print(widget.VisitorId.runtimeType);

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('$url/GetVisitorAlerts?id=$visitorId'),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData);
        setState(() {
          visitorAlerts = responseData;
          isLoading = false;
        });
      } else {
        print("Failed to fetch visitor Alerts. Status code: ${response.statusCode}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching visitor Alerts: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getVisitorAlerts();
    startTimer();
  }

  void startTimer() {
    Timer.periodic(Duration(minutes: 1), (timer) {
      if (mounted) {
        getVisitorAlerts();
        setState(() {
          
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Visitor DashBoard')),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
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
              //       child: Text('Logout',style: TextStyle(fontSize: 20,color: Colors.blue),textAlign: TextAlign.right,)
              //     ),
              //   )
              // ),
              SizedBox(height: 15,),
              Text('  Welcome, ${widget.VisitorName}',style: TextStyle(fontSize: 30,color: Colors.blue),),
              SizedBox(height: 5,),
              Text('   Visitor',style: TextStyle(fontSize: 20,color: Colors.blue),),
              SizedBox(height: 20,),
              Container(
                decoration: BoxDecoration(
                  color: visitorAlerts['type'] == 'warning' ? Color(0xFFFFD9D9) : Color(0xFFFFAC7B), // Set the background color to red
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
                            child: Text('Destination: ${visitorAlerts['destinations']}',style: TextStyle(fontSize: 17,color: Colors.black),)
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Text('${visitorAlerts['time']}',style: TextStyle(fontSize: 17,color: Colors.black),)
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
                      Align(alignment: Alignment.centerRight,child: Text('Camera-- ${visitorAlerts['camera_name']}',style: TextStyle(fontSize: 16,color: Colors.black))),
                      // Text('Visitor deviated from path',style: TextStyle(fontSize: 20,color: Colors.white),),
                      SizedBox(height: 10,),
                      Text('Visitor Name: ${visitorAlerts['visitor_name']}',style: TextStyle(fontSize: 16,color: Colors.black),),
                      SizedBox(height: 5,),
                      Text('Contact: ${visitorAlerts['visitor_contact']}',style: TextStyle(fontSize: 16,color: Colors.black),),
                      SizedBox(height: 5,),
                      Text('Current Location: ${visitorAlerts['current_location']}',style: TextStyle(fontSize: 16,color: Colors.black),),
                      SizedBox(height: 5,),
                      Text('Move towards: ${visitorAlerts['next_moves']}',style: TextStyle(fontSize: 16,color: Colors.black),),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}