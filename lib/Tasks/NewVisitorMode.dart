import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project/APIHandler/api.dart';
import 'package:http/http.dart' as http;
import 'package:project/Tasks/VisitorDashBoard.dart';

class NewVisitorModeScreen extends StatefulWidget {
  const NewVisitorModeScreen({super.key});

  @override
  State<NewVisitorModeScreen> createState() => _NewVisitorModeScreenState();
}

class _NewVisitorModeScreenState extends State<NewVisitorModeScreen> {
  TextEditingController searchVisitor_controller=TextEditingController();
  bool isLoading=false;
  dynamic _dropdownValues;
  String? selectedVisitorId;
  String? selectedVisitorName;

  List<dynamic> currentVisitorsList = [];
  Future <void> getVisitors() async{
    try{
      // var request = http.MultipartRequest('GET',Uri.parse('${APIHandler.ip}/GetCurrentVisitors'),);
      // var response = await request.send();
      final response = await http.get(Uri.parse('${APIHandler.ip}/GetCurrentVisitors'));
      if (response.statusCode == 200) {
        // final List<dynamic> jsonResponse = json.decode(await response.stream.bytesToString());
        // print('jsonResponse: $jsonResponse');
        // if (jsonResponse.isNotEmpty) {
          setState(() {
            // visitors = jsonResponse.map((json) => Visitor.fromJson(json)).toList();
            // print(visitors);
            currentVisitorsList = json.decode(response.body);
            print('currentVisitorsList: $currentVisitorsList');
            _dropdownValues = currentVisitorsList.map((visitor) => visitor['name'].toString()).toList();
            print(_dropdownValues);
            print(_dropdownValues.runtimeType);
            isLoading = false; // Data is loaded, set loading state to false
            // print(jsonResponse);
          });
      //   } else {
      //     // Handle the case where jsonResponse is null
      //     print('Error: Response data is null');
      // }
      }
    }catch (e) {
      print('Error submitting form: $e');
      setState(() {
        isLoading = false; // Set loading state to false in case of exception
      });
    }
  }

  void _showVisitorDialog(BuildContext context) {
  final double dialogWidth = 300.0; // Set your desired width here
  final double dialogHeight = 200.0;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Select Visitor'),
        content: Container(
          width: dialogWidth,
          height: dialogHeight,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Divider(thickness: 1.5, color: Colors.blue),
                for (Map<String, dynamic> visitor in currentVisitorsList)
                  ListTile(
                    title: visitor['name'].isNotEmpty
                        ? Text(visitor['name'])
                        : Text(''),
                    onTap: () {
                      Navigator.pop(context, visitor['name']);
                      setState(() {
                        selectedVisitorId = visitor['id'].toString();
                        selectedVisitorName=visitor['name'];
                        print(selectedVisitorName);
                        print(selectedVisitorId);
                      });
                    },
                  ),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Cancel button
            },
            child: Text('Cancel'),
          ),
        ],
      );
    },
  ).then((selectedVisitor) {
    if (selectedVisitor != null) {
      setState(() {
        searchVisitor_controller.text = selectedVisitor;
      });
    }
  });
}

  @override
  void initState() {
    super.initState();
    print('aaaaa');
    getVisitors();   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Visitor Mode')),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            SizedBox(height: 10,),
              Container(
                child: TextFormField(
                  controller: searchVisitor_controller,
                  decoration: InputDecoration(
                    hintText: 'Select Visitor',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        searchVisitor_controller.clear();
                        setState(() {
                          // _filteredValues=[];
                        });
                      },
                    ),
                    prefixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: (){
                        setState(() {
                          _showVisitorDialog(context);
                          // getVisitors();
                        });
                      },
                    ),
                    border: OutlineInputBorder(),
                  ),
                  onTap: () {
                    // Show the dialog when the text field is tapped
                    if (_dropdownValues.isNotEmpty) {
                      _showVisitorDialog(context);
                      setState(() {
                        
                      });
                    } else {
                      // Handle case where there are no visitors
                      print('No visitors available.');
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('No Current Visitors'),
                            content: Text('There are currently no visitors.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
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
                    }
                  },
                ),
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: (){
                  if(selectedVisitorId==null || selectedVisitorName==null){
                    return;
                  }
                  else{
                    print(selectedVisitorId);
                    print(selectedVisitorName);
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context){
                        return VisitorDashBoardScreen(int.parse(selectedVisitorId!),selectedVisitorName!);
                      })
                    );
                  }
                }, 
                child: Text('Login As Visitor')
              )
          ],
        ),
      ),
    );
  }
}