import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/APIHandler/api.dart';
import 'package:project/CommonUtils.dart/LogoutConfirmationDialog.dart';
import 'package:project/Model/VisitorModel.dart';
import 'package:project/Screens/Guard.dart';
import 'package:project/Screens/Login.dart';
import 'package:http/http.dart' as http;

class EndVisitScreen extends StatefulWidget {
  const EndVisitScreen({super.key});

  @override
  State<EndVisitScreen> createState() => _EndVisitScreenState();
}

class _EndVisitScreenState extends State<EndVisitScreen> {
  TextEditingController searchVisitor_controller=TextEditingController();
  dynamic _dropdownValues;
  List<String> _filteredValues = [];
  bool _showDropdown = false;
  String? selectedVisitorId;
  bool isLoading = true; // Track loading state

  List<Visitor> visitors = [];
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
            print(visitors);
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

  @override
  void initState() {
    super.initState();
    print('aaaaa');
    getVisitors();   // This Function Has CircularProgressIndicator()
    // searchVisitor_controller.addListener(() {
    //   setState(() {
    //     _showDropdown = searchVisitor_controller.text.isNotEmpty;
    //     if(_dropdownValues.isNotEmpty){
    //       _filteredValues = _dropdownValues
    //         .where((value) =>
    //             value.toLowerCase().contains(searchVisitor_controller.text.toLowerCase()))
    //         .toList();
    //     }
    //     else{
    //       print('object');
    //     }
    //   });
    // });
  }

  List<Visitor> filteredVisitors = [];
  void filterVisitors(String query) {
    // setState(() {
    //   filteredVisitors = visitors.where((visitor) =>
    //       visitor.name.toLowerCase().contains(query.toLowerCase())).toList();
    // });
    setState(() {
      if (query.isEmpty) {
        // If the query is empty, display all visitors
        filteredVisitors = List.from(visitors);
      } else {
        // Filter the visitors based on the query
        filteredVisitors = visitors.where((visitor) =>
          visitor.name.toLowerCase().contains(query.toLowerCase())
        ).toList();
      }
    });
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



  // void _showVisitorDialog(BuildContext context) {
  //   final double dialogWidth = 300.0; // Set your desired width here
  //   final double dialogHeight = 200.0;

  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Select Visitor'),
  //         content: Container(
  //           width: dialogWidth,
  //           height: dialogHeight,
  //           child: SingleChildScrollView(
  //             child: Column(
  //               children: [
  //                 Divider(thickness: 1.5,color: Colors.blue,),
  //                 for (Visitor visitor in visitors) // Use Visitor model
  //                   ListTile(
  //                     title: visitor.name.isNotEmpty?Text(visitor.name):Text(''),
  //                     onTap: () {
  //                       Navigator.pop(context,visitor.name);
  //                       setState(() {
  //                         selectedVisitorId = visitor.id.toString();
  //                         print(selectedVisitorId);
  //                       });
  //                     },
  //                   ),
  //               ],
  //             ),
  //           ),
  //         ),
  //         actions: [
  //           ElevatedButton(
  //             onPressed: () {
  //               Navigator.pop(context); // Cancel button
  //             },
  //             child: Text('Cancel'),
  //           ),
  //         ],
  //       );
  //     },
  //   ).then((selectedVisitor) {
  //     if (selectedVisitor != null) {
  //       setState(() {
  //         searchVisitor_controller.text = selectedVisitor;
  //       });
  //     }
  //   });
  // }

  Future<void> endVisit(String visitorId) async {
    final String apiUrl = '${APIHandler.ip}/EndVisit'; // your actual API endpoint

    try {
      final Map<String, dynamic> requestData = {
        'visitor_id': visitorId,
      };

      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        print('Visit ended successfully');
        // Add any additional logic you want to perform after a successful visit end
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Visit ended successfully'),
              // content: Text('Visit ended successfully: ${response.body}'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    searchVisitor_controller.clear();
                    getVisitors();
                    Navigator.of(context).pop();
                    // Add any additional logic you want to perform after a successful visit end
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        print('Failed to end visit. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to end visit: ${response.body}'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Handle error response
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        // Handle error response
      }
    } catch (e) {
      print('Error ending visit: $e');
      // Handle general error
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Error ending visit: $e'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Handle general error
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: isLoading?Center(child: CircularProgressIndicator()) :SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.center,
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
              Text('End Visit',style: TextStyle(fontSize: 30,color: Colors.blue),),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '${DateFormat('EEEE - d MMMM y').format(DateTime.now())}',
                    style: TextStyle(fontSize: 20, color: Colors.blue,),
                  ),
                ],
              ),
              SizedBox(height: 50,),
              Align(
                alignment: FractionalOffset(0.08, 3.8), // Adjust dx and dy as needed
                child: Text(
                  'Select Visitor',
                  style: TextStyle(fontSize: 20,color: Colors.blue),
                ),
              ),
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
                          _filteredValues=[];
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
              // if (_filteredValues.isNotEmpty)
              //   Container(
              //     padding: EdgeInsets.symmetric(horizontal: 16.0),
              //     child: Column(
              //       children: [
              //         for (String value in _filteredValues)
              //           ListTile(
              //             title: Text(value),
              //             onTap: () {
              //               setState(() {
              //                 int id=visitors.firstWhere((visitor) => visitor.name == value).id;
              //                 searchVisitor_controller.text = visitors.firstWhere((visitor) => visitor.name == value).name;
              //                 _filteredValues.clear();
              //               });
              //             },
              //           ),
              //       ],
              //     ),
              //   ),
              // Container(
              //   height: 50,
              //   width: 400,
              //   child: TextFormField(
              //     controller: searchVisitor_controller,
              //     style: TextStyle(fontSize: 20),
              //     decoration: InputDecoration(
              //       // border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              //       hintText: 'Search Visitor',
              //       hintStyle: TextStyle(color: Colors.blue),
              //       // suffixIcon: Icon(Icons.search,color: Colors.blue,),
              //       suffixIcon: IconButton(
              //         icon: Icon(Icons.clear,color: Colors.blue,),
              //         onPressed: () {
              //           searchVisitor_controller.clear();
              //           getVisitors();
              //           setState(() {
                          
              //           });
              //         },
              //       ),
              //       prefixIcon: IconButton(
              //         icon: Icon(Icons.search,color: Colors.blue,),
              //         onPressed: () {
              //           // Perform the search here
              //           // searchUser(); // Call the searchUser method
              //         },
              //       ),
              //       enabledBorder: OutlineInputBorder(
              //         borderSide: BorderSide(
              //           color: Colors.blue,
              //           width: 1,
              //         ),
              //         borderRadius: BorderRadius.circular(30)
              //       ),
              //     ),
              //     onChanged: (query) {
              //       filterVisitors(query);
              //     },
              //   ),
              // ),
              SizedBox(height: 30,),
              GestureDetector(
                  onTap: (){
                    endVisit(selectedVisitorId!);
                    setState(() {
                      
                    });
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      height: 50,
                      width: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.blue,
                      ),
                      child: Center(
                        child: Text('End Visit',style: TextStyle(fontSize: 20,color: Colors.white),),
                      ),
                    ),
                  )
                ),
            ]
          ),
        )
      )
    );
  }
}