import 'dart:convert';
// import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:project/APIHandler/api.dart';
import 'package:http/http.dart' as http;
import 'package:project/Tasks/VisitorDashBoard.dart';

class VisitorModeScreen extends StatefulWidget {
  const VisitorModeScreen({super.key});

  @override
  State<VisitorModeScreen> createState() => _VisitorModeScreenState();
}

class _VisitorModeScreenState extends State<VisitorModeScreen> {

  bool isLoading = true;
  dynamic selectedVisitor;
  int? selectedVisitorId;
  String? selectedVisitorName;

  List<dynamic> visitors = [];
  Future<void> getCurrentVisitors() async {
    setState(() {
      isLoading = true;
    });
    final url = Uri.parse('${APIHandler.ip}/GetCurrentVisitors'); 
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          visitors = jsonResponse;
          print(visitors);
          // visitors=visitors[0];
          print(visitors);
          isLoading = false;
          print(visitors);
          // if(visitors.isEmpty)
            // showNoVisitorsDialog(context);
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

  @override
  void initState() {
    super.initState();
    getCurrentVisitors();
    selectedVisitorName=null;
    selectedVisitorId=null;
    selectedVisitor='';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Visitor Mode')),
      body: Padding(
        padding: EdgeInsets.all(18),
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select Visitor',style: TextStyle(fontSize: 20,color: Colors.blue),),
              SizedBox(height: 10,),
              DropdownButton(
                  hint: Text('Select Visitor',style: TextStyle(color: Colors.blue),),
                  icon: Icon(Icons.arrow_drop_down,color: Colors.blue,),
                  // icon: Icon(Icons.arrow_circle_down),
                  // underline: Text('__________'),
                  isExpanded: true,
                  // enableFeedback: true,
                  // dropdownColor: Colors.blue,
                  // borderRadius: BorderRadius.circular(10),
                  // menuMaxHeight: 60,
                  value: selectedVisitor,
                  items: visitors.map<DropdownMenuItem<dynamic>>(
                    (dynamic visitor) {
                      return DropdownMenuItem<dynamic>(
                        value: visitor,
                        child: Text('${visitor['name']}'),
                      );
                    },
                  ).toList(),  
                  onChanged: (value) { 
                    setState(() {
                      selectedVisitor = value;
                      print(selectedVisitor);
                      print(selectedVisitor.runtimeType);
                      selectedVisitorId = value['id'];
                      print(selectedVisitorId);
                      print(value['name']);
                      selectedVisitorName=value['name'];

                    });
                  }, 
                ),
              // DropdownButton(
              //   hint: Text('Select Visitor',style: TextStyle(color: Colors.blue),),
              //   icon: Icon(Icons.arrow_drop_down,color: Colors.blue,),
              //   // icon: Icon(Icons.arrow_circle_down),
              //   // underline: Text('__________'),
              //   isExpanded: true,
              //   value: selectedVisitor,
              //   items: visitors.map<DropdownMenuItem<dynamic>>(
              //     (dynamic visitor) {
              //     return DropdownMenuItem<dynamic>(
              //       value: visitor,
              //       child: Text('${visitor['name']}'),
              //     );
              //   },
              // ).toList(), 
              // onChanged: (value) { 
              //   setState(() {
              //     selectedVisitor = value;
              //     print(selectedVisitor);
              //     print(selectedVisitor.runtimeType);
              //     selectedVisitorId = value['id'];
              //     print(selectedVisitorId);
              //     print(value['name']);
              //     selectedVisitorName=value['name'];

              //   });
              //   }, 
              // ),
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
                        return VisitorDashBoardScreen(selectedVisitorId!,selectedVisitorName!);
                      })
                    );
                  }
                }, 
                child: Text('Login As Visitor')
              )
            ],
          ),
        ),
      ),
    );
  }
}