import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project/APIHandler/api.dart';
import 'package:project/CustomWidgets/Widgets.dart';
import 'package:project/Model/BlockModel.dart';
import 'package:http/http.dart' as http;

class ShowBlockVisitorsScreen extends StatefulWidget {
  const ShowBlockVisitorsScreen({super.key});

  @override
  State<ShowBlockVisitorsScreen> createState() => _ShowBlockVisitorsScreenState();
}

class _ShowBlockVisitorsScreenState extends State<ShowBlockVisitorsScreen> {

  List<BlockModel> blockVisitors = [];
  Future <void> getBlockVisitor() async{
    try{
      var request = http.MultipartRequest('GET',Uri.parse('${APIHandler.ip}/GetBlockVisitors'),);
      var response = await request.send();
      if (response.statusCode == 200) {
        // print(response.stream.bytesToString());
        final List<dynamic> jsonResponse = json.decode(await response.stream.bytesToString());
        setState(() {
          print(jsonResponse);
          blockVisitors = jsonResponse.map((json) => BlockModel.fromJson(json)).toList();
          // dropdownOptions = users.map((user) => user.name).toList();
          print(blockVisitors);
        });
      }
    }catch (e) {
      print('Error submitting form: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getBlockVisitor();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Show Block Visitors')),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10,),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  // columnSpacing: 3,
                  columns: [
                    DataColumn(label: Text('Name',style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)),
                    // DataColumn(label: Text("Block Start",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)),
                    DataColumn(label: Text("Block till",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)),
                    // DataColumn(label: Text("Action",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)),
                  ], 
                  rows: blockVisitors.map((blockVisitor) {
                    return DataRow(
                      cells: [
                        DataCell(getText(blockVisitor.visitorName,20)),
                        // DataCell(Text(blockVisitor.startDate)),
                        DataCell(
                          Row(
                            children: [
                              Text(blockVisitor.endDate,style: TextStyle(fontSize: 20),),
                              SizedBox(width: 5),
                                // IconButton(
                                //   onPressed: () {
                                //     // Add your delete logic here for the user
                                //     // You can use user.id to identify the user to delete
                                //     // buttonState = 'Edit';
                                //     // blockIdForUpdate = blockVisitor.visitorId; // Store the user ID
                                //     // print(blockIdForUpdate);
                                //     // controller_visitorName.text=blockVisitor.visitorName;
                                //     // controller_contactInformation.text=blockVisitor.phone;
                                //     setState(() {
                                      
                                //     });
                                //   },
                                //   icon: Icon(Icons.edit_square, color: Colors.blue),
                                // ),
                                // IconButton(
                                //   onPressed: () {
                                //     // Add your delete logic here for the user
                                //     // You can use user.id to identify the user to delete
                                //     // deleteConfirmationDialog(user.id ?? -1);
                                //   },
                                //   icon: Icon(Icons.delete_forever, color: Colors.red),
                                // ),
                            ],
                          )
                        ),
                      ]
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}