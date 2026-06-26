import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project/APIHandler/api.dart';
import 'package:project/CommonUtils.dart/LogoutConfirmationDialog.dart';
import 'package:project/Screens/DetectedCameras.dart';
import 'package:project/Screens/Guard.dart';
import 'package:project/Screens/Login.dart';
import 'package:http/http.dart' as http;

class DestinationPathsScreen extends StatefulWidget {
  List<List<String>> locationPaths;
  List<List<String>> paths;
  int visitorId;
  dynamic startTime;
  DestinationPathsScreen(this.locationPaths, this.paths, this.visitorId,this.startTime);

  @override
  State<DestinationPathsScreen> createState() => _DestinationPathsScreenState();
}

class _DestinationPathsScreenState extends State<DestinationPathsScreen> {
  List<dynamic> alerts = []; // Store alerts data here
  List<bool> isExpandedList = [];

  Future<void> fetchCurrentAlerts() async {
    final url = Uri.parse('${APIHandler.ip}/GetVisitorWithThreads'); // your actual server URL and endpoint
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

  @override
  void initState() {
    super.initState();
    // fetchCurrentAlerts(); // Fetch data when the screen loads
    // fetchCurrentAlerts();
    // Initialize isExpandedList with false for each path
    isExpandedList = List<bool>.generate(widget.locationPaths.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
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
              SizedBox(height: 20,),
              Text('Destination Paths',style: TextStyle(fontSize: 30,color: Colors.blue),),
              SizedBox(height: 10,),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.locationPaths.length,
                itemBuilder: (context, index) {
                  final locationPath = widget.locationPaths[index];
                  final locationPathIndex = index + 1;
                  final isExpanded = isExpandedList[index];

                  return Card(
                    margin: EdgeInsets.all(16.0),
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Path $locationPathIndex:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue
                                ),
                              ),
                              IconButton(
                                icon: Icon(isExpanded ? Icons.fullscreen_exit_outlined : Icons.fullscreen_outlined),
                                onPressed: () {
                                  setState(() {
                                    isExpandedList[index] = !isExpanded;
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          isExpanded?
                            Container(
                              child: Wrap(
                                spacing: 15,
                                runSpacing: 4,
                                children: locationPath.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final step = entry.value;
                                  final isLast = index == locationPath.length - 1;
                                  return RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: isLast ? '$step' : '$step --> ',
                                          style: TextStyle(color: Colors.blue), // Change the color here
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList() ?? [],
                              ),
                            ):
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Wrap(
                                spacing: 15,
                                runSpacing: 4,
                                children: locationPath.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final step = entry.value;
                                  final isLast = index == locationPath.length - 1;
                                  return RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: isLast ? '$step' : '$step --> ',
                                          style: TextStyle(color: Colors.blue), // Change the color here
                                        ),
                                      ],
                                    ),
                                  );

                                  // return GestureDetector(
                                  //   onTap: () {
                                  //     List<String> c=cameraValue;
                                  //     print(cameraValue);
                                  //     print(c);
                                  //     c.removeWhere((item) => item == 'C1');
                                  //     print(cameraValue);
                                  //     print(c);
                                  //     if (step!='C1' && c.contains(step)){
                                  //       imageBytes!=null?Navigator.of(context).push(
                                  //         MaterialPageRoute(builder: (context){
                                  //           return ShowImageScreen(imageBytes);
                                  //         })
                                  //       ):showDialog(
                                  //         context: context,
                                  //         builder: (context) {
                                  //           return AlertDialog(
                                  //             title: Text('Path:${pathIndex}, $step'),
                                  //           );
                                  //         },
                                  //       );
                                  //     }
                                  //     if(step=='C1') {
                                  //       showDialog(
                                  //         context: context,
                                  //         builder: (context) {
                                  //           return AlertDialog(
                                  //             title: Text('Gate Position'),
                                  //           );
                                  //         },
                                  //       );
                                  //     }
                                  //     else{
                                  //       showDialog(
                                  //         context: context,
                                  //         builder: (context) {
                                  //           return AlertDialog(
                                  //             title: Text('Path:${pathIndex}, $step'),
                                  //           );
                                  //         },
                                  //       );
                                  //     }
                                  //   },
                                  //   child: Column(
                                  //     children: [
                                  //       step=='C1'?Text(widget.startTime,):SizedBox(height: 19.5,),
                                  //       step==camValue && result?Text(timeValue!):SizedBox(height: 19.5,),
                                  //       MouseRegion(
                                  //         cursor: SystemMouseCursors.click,
                                  //         child: Stack(
                                  //           children: [
                                  //             Chip(
                                  //               label: Text(step),
                                  //               backgroundColor: cameraValue.contains(step) ? Colors.blue[800] : Colors.blue,
                                  //               labelStyle: TextStyle(color: Colors.white),
                                  //             ),
                                  //             Positioned(
                                  //               top: 8,
                                  //               right: 5,
                                  //               child: Container(
                                  //                 width: 10,
                                  //                 height: 10,
                                  //                 decoration: BoxDecoration(
                                  //                   shape: BoxShape.circle,
                                  //                   color: cameraValue.contains(step) ? Colors.green[800] : Colors.red,
                                  //                 ),
                                  //               ),
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // );
                                }).toList() ?? [],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          return DetectedCamerasScreen(widget.paths,widget.visitorId!,widget.startTime);
                          // return DetectedCamerasScreen(paths,int.parse(_searchController.text),time_Controller.text);
                        }),
                      );
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        height: 50,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.blue,
                        ),
                        child: Center(
                          child: Text('Camera Paths',style: TextStyle(fontSize: 20,color: Colors.white),),
                        ),
                      ),
                    )
                  ),
                ],
              )
            ]
          ),
        )
      )
    );
  }
}