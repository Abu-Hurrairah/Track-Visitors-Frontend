import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:project/APIHandler/api.dart';
import 'package:project/CustomWidgets/Widgets.dart';
import 'package:project/Tasks/TodayVisitors.dart';
import 'package:http/http.dart' as http;

class SearchTodayVisitorScreen extends StatefulWidget {
  const SearchTodayVisitorScreen({super.key});

  @override
  State<SearchTodayVisitorScreen> createState() => _SearchTodayVisitorScreenState();
}

class _SearchTodayVisitorScreenState extends State<SearchTodayVisitorScreen> {
  TextEditingController controller_searchVisitor=TextEditingController();

  List<dynamic> visitorsReportList = [];
  List<TodayVisitor> visitorsReport = [];
  Future<void> getVisitorsReport() async {
    try {
      String apiUrl = '${APIHandler.ip}/GetTodayVisitorsReport';
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(await response.body);
        setState(() {
          visitorsReportList = jsonResponse.map((json) => Map<String, dynamic>.from(json)).toList();
          print(jsonResponse);
          visitorsReport = TodayVisitor.fromJsonList(json.decode(response.body));
          print('Today Visitor: $visitorsReport');
        });
        print('aaaaaa');
        filteredVisitors=visitorsReport;
      } else {
        print('Failed to fetch visitors report. Status code: ${response.statusCode}');
        print(response.body);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  List<TodayVisitor> filteredVisitors = [];
  void filterUsers(String query) {
    // setState(() {
    //   filteredUsers = users.where((user) =>
    //       user.name.toLowerCase().contains(query.toLowerCase())).toList();
    // });
    setState(() {
      if (query.isEmpty) {
        // If the query is empty, display all users
        filteredVisitors = List.from(visitorsReport);
      } else {
        // Filter the users based on the query
        filteredVisitors = visitorsReport.where((user) =>
          user.visitorName.toLowerCase().contains(query.toLowerCase()) ||
          user.locationsVisited.toLowerCase().contains(query.toLowerCase()) ||
          user.visitorPhone.toLowerCase().contains(query.toLowerCase()) ||
          user.visitDate.toLowerCase().contains(query.toLowerCase()) ||
          user.entryTime.toLowerCase().contains(query.toLowerCase()) 
        ).toList();
      }
    });
  }

  String? formatTime(String? rawTime) {
    if (rawTime == null) {
      return 'N/A'; 
    }

    DateTime parsedTime = DateTime.parse('2022-01-01 $rawTime');

    String formattedTime = DateFormat('hh:mm a').format(parsedTime);

    return formattedTime;
  }

  void _showImageDialog(BuildContext context, String imageBase64) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height * 0.7,
            child: Image.memory(
              base64Decode(imageBase64),
              fit: BoxFit.contain,
            ),
          ),
          actions: [
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

  @override
  void initState() {
    super.initState();
    // getVisitors();
    getVisitorsReport();
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search Today Visitors')),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 50,
                width: 400,
                child: TextField(
                  controller: controller_searchVisitor,
                  decoration: InputDecoration(
                    hintText: 'Search User',
                    hintStyle: TextStyle(color: Colors.blue),
                    // Add a clear button to the search bar
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear,color: Colors.blue,),
                      onPressed: () {
                        controller_searchVisitor.clear();
                        getVisitorsReport();
                        setState(() {
                          
                        });
                      },
                    ),
                    // Add a search icon or button to the search bar
                    prefixIcon: IconButton(
                      icon: Icon(Icons.search,color: Colors.blue,),
                      onPressed: () {
                        // Perform the search here
                        // searchUser(); // Call the searchUser method
                      },
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                        BorderSide(width: 1, color: Colors.blue), //<-- SEE HERE
                      borderRadius: BorderRadius.circular(30.0)
                    ),
                  ),
                  onChanged: (query) {
                    filterUsers(query);
                  },
                ),
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  Expanded(
                    child: Text('Name',style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)
                  ),
                  // Expanded(
                  //   child: Text("Phone",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)
                  // ),
                  Expanded(
                    child: Text("Locations Visited",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)
                  ),
                  Expanded(
                    child: Text("Visit Date",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)
                  ),
                  // Expanded(
                  //   child: Text("Entry Time",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)
                  // ),
                  // Expanded(
                  //   child: Text("Exit Time",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)
                  // ),
                  Expanded(
                    child: Text("Image",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)
                  )
                ],
              ),
              Divider(thickness: 2),
              Container(
                // height: double.maxFinite,
                // height: (filteredUsers.length*70),
                height: 430,
                child: ListView.builder(
                  itemCount: filteredVisitors.length,
                  itemBuilder: (context, index){
                    TodayVisitor visitor=filteredVisitors[index];
                    return Column(
                      children: [
                        Container(
                          height: 40,
                          child: Row(
                            children: [
                              Expanded(
                                child: getText(visitor.visitorName.toString(),15)
                              ),
                              // Expanded(
                              //   child: getText(visitor.visitorPhone,15)
                              // ),
                              Expanded(
                                child: Text(visitor.locationsVisited)
                              ),
                              Expanded(
                                child: Text(visitor.visitDate)
                              ),
                              // Expanded(
                              //   child: Text(formatTime(visitor.entryTime)!)
                              // ),
                              // Expanded(
                              //   child: Text(formatTime(visitor.exitTime)??'N/A')
                              // ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    _showImageDialog(context, visitor.image);
                                  },
                                  child: Image.memory(
                                    base64Decode(visitor.image),
                                    width: 50,
                                    height: 50,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(thickness: 1.5),
                      ],
                    );
                  }
                ),
              ),
              // SizedBox(height: 30,),
              // Row(
              //   children: [
              //     Expanded(
              //       child: Text('Name',style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)
              //     ),
              //     Expanded(
              //       child: Text("Username",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)
              //     ),
              //     Expanded(
              //       child: Text("Role",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)
              //     )
              //   ],
              // ),
              // Divider(thickness: 2),
              // Container(
              //   // height: double.maxFinite,
              //   // height: (filteredUsers.length*70),
              //   height: 430,
              //   child: ListView.builder(
              //     itemCount: filteredVisitors.length,
              //     itemBuilder: (context, index){
              //       TodayVisitor visitor=filteredVisitors[index];
              //       return Column(
              //         children: [
              //           Container(
              //             height: 40,
              //             child: Row(
              //               children: [
              //                 Expanded(
              //                   child: getText(visitor.name.toString(),15)
              //                 ),
              //                 Expanded(
              //                   child: getText(visitor.username,15)
              //                 ),
              //                 Expanded(
              //                   child: Text(visitor.role)
              //                 )
              //               ],
              //             ),
              //           ),
              //           Divider(thickness: 1.5),
              //         ],
              //       );
              //     }
              
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}