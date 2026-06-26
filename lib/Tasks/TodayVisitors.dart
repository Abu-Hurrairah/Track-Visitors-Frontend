import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:project/APIHandler/api.dart';
import 'package:project/CustomWidgets/Widgets.dart';
import 'package:project/Global/DirectorGlobal.dart';

class TodayVisitorsScreen extends StatefulWidget {
  const TodayVisitorsScreen({super.key});

  @override
  State<TodayVisitorsScreen> createState() => _TodayVisitorsScreenState();
}

class _TodayVisitorsScreenState extends State<TodayVisitorsScreen> {

  // int serialNumber = 0  ;
  int? visitorIdForUpdate;
  int directorId = DirectorGlobal.directorGlobalId!;

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
      } else {
        print('Failed to fetch visitors report. Status code: ${response.statusCode}');
        print(response.body);
      }
    } catch (e) {
      print('Error: $e');
    }
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

  String? formatTime(String? rawTime) {
    if (rawTime == null) {
      return 'N/A'; 
    }

    DateTime parsedTime = DateTime.parse('2022-01-01 $rawTime');

    String formattedTime = DateFormat('hh:mm a').format(parsedTime);

    return formattedTime;
  }


  Future<void> blockVisitor(String visitorId,String directorId)async {
    if(visitorId.isEmpty){
      print('NO selected');
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please fill in all fields.'),
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
      return ;
    }

    try {
      bool block=await checkVisitorBlocked(visitorId);
      if(block){
        print('Visitor Is Already Block');
      }
      else{
        final Uri uri = Uri.parse('${APIHandler.ip}/DayBlockVisitor'); // Adjust the URL accordingly

        // Define the request headers and body
        final Map<String, String> headers = {
          'Content-Type': 'application/x-www-form-urlencoded', // Adjust the content type if necessary
        };

        final Map<String, dynamic> requestBody = {
          'visitor_id': visitorId,
          'user_id': directorId,
        };
        print(requestBody);

        // Send a POST request with jsonEncode for the body
        final http.Response response = await http.post(
          uri,
          headers: headers,
          body: Uri(queryParameters: requestBody).query, // Use jsonEncode for the body
        );
        // final response = await http.post(
        //   Uri.parse('$uri'),
        //   headers: {'Content-Type': 'application/json'},
        //   body: jsonEncode({
        //     'visitor_id': visitorId,
        //     'start_date': startDate, // Change '-' to '/', // Keep the format as 'yyyy-MM-dd'
        //     'end_date': endDate,    // Keep the format as 'yyyy-MM-dd'
        //     'user_id': userId,
        //   }),
        // );

        if (response.statusCode == 200) {
          // Visitor blocked successfully
          final dynamic responseData = json.decode(response.body);
          print('Visitor blocked successfully: ${responseData['message']}');
          // Show dialog box for successful blocking
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Success'),
                content: Text('Visitor blocked successfully: ${responseData['message']}'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      // getBlockVisitor();
                      setState(() {
                        
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          // Failed to block visitor
          final dynamic errorData = json.decode(response.body);
          print('Failed to block visitor: ${errorData['error']}');
          // Show dialog box for failed blocking
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Failed to block visitor: ${errorData['error']}'),
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
      }
      
    } catch (error) {
      print('Error: $error');
      // Handle the error as needed
      // Show dialog box for generic error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An unexpected error occurred.'),
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
  }

  Future<bool> checkVisitorBlocked(String visitorId) async {

    try {
      final Uri uri = Uri.parse('${APIHandler.ip}/CheckVisitorBlocked/$visitorId'); // Include visitorId in the URL

      // Send a GET request
      final http.Response response = await http.get(uri);

      if (response.statusCode == 200) {
        // Parse the JSON response
        final dynamic responseData = json.decode(response.body);
        print(responseData);

        // Check if the visitor is blocked
        bool isBlocked = responseData['blocked'] ?? false;

        if (isBlocked) {
          // Show dialog based on the visitor status
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Visitor Status'),
                content: Text('Visitor is Blocked Already'),
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
        else{
          print('Visitor Is Not Block');
        }

        return isBlocked;
      } else {
        // Handle the case where the request fails
        print('Failed to check visitor status: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error: $error');
      // Handle the error as needed

      // Show an error dialog for network or other errors
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to check visitor status.$error'),
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

      return false;
    }
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
      appBar: AppBar(title: Text('Today Visitors'),),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: visitorsReportList.length,
          itemBuilder: (context, index) {
            final report = visitorsReportList[index];
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.blue
              ),
              child: Column(
                children: [
                  ListTile(
                    title: Text('Visit ID: ${report['VisitID']}',style: TextStyle(fontSize: 18,color: Colors.white),),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Visitor Name: ${report['VisitorName']}',style: TextStyle(fontSize: 18,color: Colors.white),),
                        Text('Visitor Phone: ${report['VisitorPhone']}',style: TextStyle(fontSize: 18,color: Colors.white),),
                        Text('Visit Date: ${report['VisitDate']}',style: TextStyle(fontSize: 18,color: Colors.white),),
                        Text('Entry Time: ${report['EntryTime']}',style: TextStyle(fontSize: 18,color: Colors.white),),
                        Text('Exit Time: ${report['ExitTime'] ?? 'Not available'}',style: TextStyle(fontSize: 18,color: Colors.white),),
                        Text('Locations Visited: ${report['LocationsVisited']}',style: TextStyle(fontSize: 18,color: Colors.white),),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  GestureDetector(
                    onTap: (){
                      print(directorId);
                      print(report['VisitorId']);
                      print(report['VisitorId'].runtimeType);
                      String vId=report['VisitorId'].toString();
                      print(vId.runtimeType);
                      String dId=directorId.toString();
                      print(dId.runtimeType);
                      blockVisitor(vId,dId);
                    },
                    child: Container(
                      height: 50,
                      width: 70,
                      color: Colors.red,
                      child: Center(child: Text('Block',style: TextStyle(color: Colors.white),),),
                    ),
                  ),
                  SizedBox(height: 10,)
                ],
              ),
            );
          },
        ),
      ),
      // body: Padding(
      //   padding: EdgeInsets.all(8),
      //   child: Column(
      //     children: [
            
      //       // SizedBox(height: 30,),
      //       //   Row(
      //       //     children: [
      //       //       Expanded(
      //       //         child: Text('Name',style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)
      //       //       ),
      //       //       Expanded(
      //       //         child: Text("Phone",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)
      //       //       ),
      //       //       Expanded(
      //       //         child: Text("Locations Visited",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)
      //       //       ),
      //       //       Expanded(
      //       //         child: Text("Visit Date",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)
      //       //       ),
      //       //       Expanded(
      //       //         child: Text("Entry Time",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)
      //       //       ),
      //       //       Expanded(
      //       //         child: Text("Exit Time",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)
      //       //       ),
      //       //       Expanded(
      //       //         child: Text("Image",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)
      //       //       )
      //       //     ],
      //       //   ),
      //       //   Divider(thickness: 2),
      //       //   Container(
      //       //     // height: double.maxFinite,
      //       //     // height: (filteredUsers.length*70),
      //       //     height: 430,
      //       //     child: ListView.builder(
      //       //       itemCount: visitorsReport.length,
      //       //       itemBuilder: (context, index){
      //       //         TodayVisitor visitor=visitorsReport[index];
      //       //         return Column(
      //       //           children: [
      //       //             Slidable(
      //       //               endActionPane: ActionPane(
      //       //                 motion: StretchMotion(), 
      //       //                 children: [
      //       //                   SlidableAction(
      //       //                     onPressed: (context){
      //       //                       // buttonState = 'Edit';
      //       //                       visitorIdForUpdate = visitor.visitorId; // Store the user ID
      //       //                       // controller_fullName.text=user.name;
      //       //                       // controller_userName.text=user.username;
      //       //                       // controller_password.text=user.Password;
      //       //                       // selectedValue=user.role;
      //       //                       setState(() {
                                    
      //       //                       });
      //       //                     },
      //       //                     icon: Icons.edit_square,
      //       //                     foregroundColor: Colors.blue,
      //       //                   ),
      //       //                 ]
      //       //               ),
      //       //               child: Container(
      //       //                 height: 40,
      //       //                 child: Row(
      //       //                   children: [
      //       //                     Expanded(
      //       //                       child: getText(visitor.visitorName.toString(),15)
      //       //                     ),
      //       //                     Expanded(
      //       //                       child: getText(visitor.visitorPhone,15)
      //       //                     ),
      //       //                     Expanded(
      //       //                       child: Text(visitor.locationsVisited)
      //       //                     ),
      //       //                     Expanded(
      //       //                       child: Text(visitor.visitDate)
      //       //                     ),
      //       //                     Expanded(
      //       //                       child: Text(formatTime(visitor.entryTime)!)
      //       //                     ),
      //       //                     Expanded(
      //       //                       child: Text(formatTime(visitor.exitTime)??'N/A')
      //       //                     ),
      //       //                     Expanded(
      //       //                       child: InkWell(
      //       //                         onTap: () {
      //       //                           _showImageDialog(context, visitor.image);
      //       //                         },
      //       //                         child: Image.memory(
      //       //                           base64Decode(visitor.image),
      //       //                           width: 50,
      //       //                           height: 50,
      //       //                         ),
      //       //                       ),
      //       //                     ),
      //       //                   ],
      //       //                 ),
      //       //               )
      //       //             ),
      //       //             Divider(thickness: 1.5),
      //       //           ],
      //       //         );
      //       //       }
              
      //       //     ),
      //       //   ),


      //       // SizedBox(height: 30,),
      //       // SingleChildScrollView(
      //       //   scrollDirection: Axis.vertical,
      //       //   child: SingleChildScrollView(
      //       //     scrollDirection: Axis.horizontal,
      //       //     child: DataTable(
      //       //       columnSpacing: 15,
      //       //       columns: [
      //       //         // DataColumn(label: Text('Visitor ID',style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)),
      //       //         // DataColumn(label: Text('S.No',style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)),
      //       //         DataColumn(label: Text("Name",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)),
      //       //         DataColumn(label: Text("Visitor Phone No.",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)),
      //       //         DataColumn(label: Text("Locations Visited",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)),
      //       //         DataColumn(label: Text("Visit Date",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)),
      //       //         DataColumn(label: Text("Entry Time",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)),
      //       //         DataColumn(label: Text("Exit Time",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)),
      //       //         DataColumn(label: Text('Image',style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)),
      //       //       ], 
      //       //       rows: visitorsReportList.map((visitor) {
      //       //         // serialNumber++;
      //       //         return DataRow(
      //       //           cells: [
      //       //             // DataCell(getText(serialNumber.toString(),20)),
      //       //             DataCell(Text('${visitor['VisitorName']}',style: TextStyle(fontSize: 20),)),
      //       //             DataCell(Text('${visitor['VisitorPhone']}',style: TextStyle(fontSize: 20),)),
      //       //             DataCell(Text('${visitor['LocationsVisited']}',style: TextStyle(fontSize: 20),)),
      //       //             DataCell(Text('${visitor['VisitDate']}',style: TextStyle(fontSize: 20),)),
      //       //             DataCell(Text('${formatTime(visitor['EntryTime'])}',style: TextStyle(fontSize: 20),)),
      //       //             DataCell(Text('${formatTime(visitor['ExitTime'])}',style: TextStyle(fontSize: 20),)),
      //       //             DataCell(
      //       //               Row(
      //       //                 children: [
      //       //                   InkWell(
      //       //                     onTap: () {
      //       //                       _showImageDialog(context, visitor['image']);
      //       //                     },
      //       //                     child: Image.memory(
      //       //                       base64Decode(visitor['image']),
      //       //                       width: 50,
      //       //                       height: 50,
      //       //                     ),
      //       //                   ),
      //       //                   SizedBox(width: 25,),
      //       //                   IconButton(
      //       //                     onPressed: (){
      //       //                       print(visitor['VisitorId']);
      //       //                       // blockVisitor(visitor['VisitorId']);
      //       //                     }, 
      //       //                     icon: Icon(Icons.lock_open,color: Colors.blue,)
      //       //                   )
      //       //                 ],
      //       //               ),
      //       //             ),
      //       //             // DataCell(Text('${TimeOfDay.fromDateTime(DateTime.parse('2022-01-01 ${visitor['EntryTime']}')).format(context)}')),
      //       //             // DataCell(Text('${TimeOfDay.fromDateTime(DateTime.parse('2022-01-01 ${visitor['ExitTime']}')).format(context) ?? 'N/A'}')),
      //       //           ]
      //       //         );
      //       //       }
      //       //       ).toList(),
      //       //     ),
      //       //   ),
      //       // )
      //     ],
      //   ),
      // ),
    );
  }
}





class TodayVisitor {
  final String entryTime;
  final String? exitTime;
  final String locationsVisited;
  final String visitDate;
  final int visitID;
  final String visitorName;
  final String visitorPhone;
  final int visitorId;
  final String image;

  TodayVisitor({
    required this.entryTime,
    required this.exitTime,
    required this.locationsVisited,
    required this.visitDate,
    required this.visitID,
    required this.visitorName,
    required this.visitorPhone,
    required this.visitorId,
    required this .image,
  });

  factory TodayVisitor.fromJson(Map<String, dynamic> json) {
    return TodayVisitor(
      entryTime: json['EntryTime'],
      exitTime: json['ExitTime'],
      locationsVisited: json['LocationsVisited'],
      visitDate: json['VisitDate'],
      visitID: json['VisitID'],
      visitorName: json['VisitorName'],
      visitorPhone: json['VisitorPhone'],
      visitorId: json['VisitorId'],
      image: json['image'],
    );
  }

  static List<TodayVisitor> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => TodayVisitor.fromJson(json)).toList();
  }
}