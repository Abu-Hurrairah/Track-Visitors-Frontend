import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/APIHandler/api.dart';
import 'package:http/http.dart' as http;

class LastWeekVisitorsScreen extends StatefulWidget {
  const LastWeekVisitorsScreen({super.key});

  @override
  State<LastWeekVisitorsScreen> createState() => _LastWeekVisitorsScreenState();
}

class _LastWeekVisitorsScreenState extends State<LastWeekVisitorsScreen> {

  List<dynamic> visitorsReportList = [];
  Future<void> getVisitorsReport() async {
    try {
      String apiUrl = '${APIHandler.ip}/GetLastWeekVisitorsReport';
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(await response.body);
        setState(() {
          visitorsReportList = jsonResponse.map((json) => Map<String, dynamic>.from(json)).toList();
          print(jsonResponse);
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
      return 'N/A'; // or any other default value you want to show for null time
    }

    // Parse the raw time string
    DateTime parsedTime = DateTime.parse('2022-01-01 $rawTime');

    // Format the time using intl package
    String formattedTime = DateFormat('hh:mm a').format(parsedTime);

    return formattedTime;
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
      appBar: AppBar(title: Text('Last Week Visitors'),),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30,),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 15,
                    columns: [
                      // DataColumn(label: Text('Visitor ID',style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)),
                      // DataColumn(label: Text('S.No',style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text("Name",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text("Visitor Phone No.",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text("Locations Visited",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text("Visit Date",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text("Entry Time",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text("Exit Time",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text('Image',style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)),
                    ], 
                    rows: visitorsReportList.map((visitor) {
                      // serialNumber++;
                      return DataRow(
                        cells: [
                          // DataCell(getText(serialNumber.toString(),20)),
                          DataCell(Text('${visitor['VisitorName']}',style: TextStyle(fontSize: 20),)),
                          DataCell(Text('${visitor['VisitorPhone']}',style: TextStyle(fontSize: 20),)),
                          DataCell(Text('${visitor['LocationsVisited']}',style: TextStyle(fontSize: 20),)),
                          DataCell(Text('${visitor['VisitDate']}',style: TextStyle(fontSize: 20),)),
                          DataCell(Text('${formatTime(visitor['EntryTime'])}',style: TextStyle(fontSize: 20),)),
                          DataCell(Text('${formatTime(visitor['ExitTime'])}',style: TextStyle(fontSize: 20),)),
                          DataCell(
                            InkWell(
                              onTap: () {
                                _showImageDialog(context, visitor['image']);
                              },
                              child: Image.memory(
                                base64Decode(visitor['image']),
                                width: 50,
                                height: 50,
                              ),
                            ),
                          ),
                          // DataCell(Text('${TimeOfDay.fromDateTime(DateTime.parse('2022-01-01 ${visitor['EntryTime']}')).format(context)}')),
                          // DataCell(Text('${TimeOfDay.fromDateTime(DateTime.parse('2022-01-01 ${visitor['ExitTime']}')).format(context) ?? 'N/A'}')),
                        ]
                      );
                    }
                    ).toList(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}