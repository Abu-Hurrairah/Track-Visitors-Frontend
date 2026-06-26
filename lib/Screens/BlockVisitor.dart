import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/APIHandler/api.dart';
import 'package:project/CommonUtils.dart/LogoutConfirmationDialog.dart';
import 'package:project/CustomWidgets/Widgets.dart';
import 'package:project/Global/AdminGlobal.dart';
import 'package:project/Model/BlockModel.dart';
import 'package:project/Model/VisitorModel.dart';
import 'package:project/Screens/Admin.dart';
import 'package:project/Screens/Login.dart';
import 'package:http/http.dart' as http;

class BlockVisitorScreen extends StatefulWidget {
  const BlockVisitorScreen({super.key});

  @override
  State<BlockVisitorScreen> createState() => _BlockVisitorScreenState();
}

class _BlockVisitorScreenState extends State<BlockVisitorScreen> {
  TextEditingController controller_visitorId=TextEditingController();
  TextEditingController controller_visitorName=TextEditingController();
  TextEditingController controller_contactInformation=TextEditingController();
  TextEditingController controller_startDate=TextEditingController();
  TextEditingController controller_endDate=TextEditingController();
  TextEditingController controller_searchVisitor=TextEditingController();
  String buttonState = 'Add';
  String? selectedVisitorId;
  bool _validate = false;

  var date = DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  Future<Null> _selectStartDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: _startDate,
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
  );

  if (picked != null && picked != _startDate) {
    print('Date selected: ${_startDate.toString()}');
    setState(() {
      _startDate = picked;
      controller_startDate.text = DateFormat('yyyy-MM-dd').format(_startDate);
      print(DateFormat('yyyy-MM-dd').format(_startDate));
    });
  } else {
    controller_startDate.text = '';
  }
}

Future<Null> _selectEndDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: _endDate,
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
  );

  if (picked != null && picked != _endDate) {
    print('Date selected: ${_endDate.toString()}');
    setState(() {
      _endDate = picked;
      controller_endDate.text = DateFormat('yyyy-MM-dd').format(_endDate);
      print(DateFormat('yyyy-MM-dd').format(_endDate));
    });
  } else {
    controller_endDate.text = '';
  }
}

  Future<Null> _selectEnterTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );

    if(picked != null && picked != _time) {
      print('Time selected: ${_time.toString()}');
      setState((){
        _time = picked;
        controller_startDate.text=_time.format(context);
      });
    }
    else{
      controller_startDate.text='';
    }
  }
  
  Future<Null> _selectExitTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );

    if(picked != null && picked != _time) {
      print('Time selected: ${_time.toString()}');
      setState((){
        _time = picked;
        controller_endDate.text=_time.format(context);
      });
    }
    else{
      controller_endDate.text='';
    }
  }

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

  Future<void> blockVisitor(String visitorId, String startDate, String endDate, String userId) async {
    if(visitorId.isEmpty || startDate.isEmpty || endDate.isEmpty || userId.isEmpty){
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
        controller_visitorName.clear();
        controller_contactInformation.clear();
        controller_startDate.clear();
        controller_endDate.clear();
        controller_searchVisitor.clear();
        selectedVisitorId=null;
      }
      else{
        final Uri uri = Uri.parse('${APIHandler.ip}/BlockVisitor'); // Adjust the URL accordingly

        // Define the request headers and body
        final Map<String, String> headers = {
          'Content-Type': 'application/x-www-form-urlencoded', // Adjust the content type if necessary
        };

        final Map<String, dynamic> requestBody = {
          'visitor_id': visitorId,
          'start_date': startDate,
          'end_date': endDate,
          'user_id': userId,
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
        print(startDate);
        print(endDate);
        print(startDate.replaceAll('-', '/'));
        print(endDate.replaceAll('-', '/'));

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
                      getBlockVisitor();
                      controller_visitorName.clear();
                      controller_contactInformation.clear();
                      controller_startDate.clear();
                      controller_endDate.clear();
                      controller_searchVisitor.clear();
                      selectedVisitorId=null;
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

  int getBlockIdByName(String blockName) {
    final block = blockVisitors.firstWhere(
      (block) => block.visitorName == blockName, // Return null if no element is found
    );

    if (block != null) {
      return block.visitorId;
    } else {
      // Handle the case where no element is found, for example:
      throw StateError('Visitor with name $blockName not found');
    }
  }

  // Add a user ID variable to track the user being updated
  int? blockIdForUpdate;
  Future<void> unblockVisitor(String visitorId) async {
    try {
      final Uri uri = Uri.parse('${APIHandler.ip}/UnblockVisitor'); // Adjust the URL accordingly

      // Define the request headers and body
      final Map<String, String> headers = {
        'Content-Type': 'application/json', // Adjust the content type if necessary
      };

      final Map<String, dynamic> requestBody = {
        'visitor_id': visitorId,
      };
      print(requestBody);

      // Send a POST request
      final http.Response response = await http.post(
        uri,
        headers: headers,
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        // Visitor unblocked successfully
        final dynamic responseData = json.decode(response.body);
        print('Visitor unblocked successfully: ${responseData['message']}');
        // Show dialog box for successful unblocking
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Visitor unblocked successfully: ${responseData['message']}'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    getBlockVisitor();
                    buttonState = 'Add';
                    controller_visitorName.clear();
                    controller_contactInformation.clear();
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else if (response.statusCode == 400) {
        // Visitor is not currently blocked
        final dynamic errorData = json.decode(response.body);
        print('Visitor is not currently blocked: ${errorData['error']}');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Visitor is not currently blocked: ${errorData['error']}'),
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
      } else {
        // Failed to unblock visitor
        final dynamic errorData = json.decode(response.body);
        print('Failed to unblock visitor: ${errorData['error']}');
        // Show dialog box for failed unblocking
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to unblock visitor: ${errorData['error']}'),
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

  Future<void> extendBlock(String visitorId, String endDate) async {
    try {
      final Uri uri = Uri.parse('${APIHandler.ip}/ExtendBlock/$visitorId'); // Adjust the URL accordingly

      // Define the request headers and body as form data
      final Map<String, String> headers = {
        'Content-Type': 'application/x-www-form-urlencoded', // Adjust the content type for form data
      };

      final Map<String, String> requestBody = {
        'end_date': endDate,
      };

      // Send a POST request with http package's `post` method
      final http.Response response = await http.post(
        uri,
        headers: headers,
        body: Uri(queryParameters: requestBody).query, // Convert map to query parameters
      );

      if (response.statusCode == 200) {
        // Block extended successfully
        final dynamic responseData = json.decode(response.body);
        print('Block extended successfully: ${responseData['message']}');

        // Clear text fields or perform any other actions needed
        controller_visitorName.clear();
        // controller_startDate.clear();
        controller_endDate.clear();
        controller_contactInformation.clear();

        // Show dialog box for successful block extension
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Block extended successfully: ${responseData['message']}'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    getBlockVisitor();
                    buttonState='Add';
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else if (response.statusCode == 400) {
        // Visitor is not currently blocked
        final dynamic errorData = json.decode(response.body);
        print('This visitor is not blocked: ${errorData['error']}');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('This visitor is not blocked: ${errorData['error']}'),
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
      } else {
        // Failed to extend block
        final dynamic errorData = json.decode(response.body);
        print('Failed to extend block: ${errorData['error']}');
        // Show dialog box for failed block extension
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to extend block: ${errorData['error']}'),
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


  List<Visitor> visitors = [];
  Future <void> getVisitors() async{
    try{
      var request = http.MultipartRequest('GET',Uri.parse('${APIHandler.ip}/GetAllVisitors'),);
      var response = await request.send();
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(await response.stream.bytesToString());
        setState(() {
          visitors = jsonResponse.map((json) => Visitor.fromJson(json)).toList();
          // _dropdownValues = visitors.map((visitor) => visitor.name).toList();
          print(jsonResponse);
        });
      }
    }catch (e) {
      print('Error submitting form: $e');
    }
  }

  void _showVisitorDialog(BuildContext context) {
    final double dialogWidth = 300.0; // Set your desired width here
    final double dialogHeight = 300.0;

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
                  Divider(thickness: 1.5,color: Colors.blue,),
                  for (Visitor visitor in visitors) // Use Visitor model
                    ListTile(
                      title: Text(visitor.name),
                      onTap: () {
                        controller_visitorName.text=visitor.name;
                        controller_contactInformation.text=visitor.phone;
                        Navigator.pop(context,visitor.name);
                        selectedVisitorId=visitor.id.toString();
                        print(selectedVisitorId);
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
          controller_searchVisitor.text = selectedVisitor;
        });
      }
    });
  }


  @override
  void initState() {
    super.initState();
    getBlockVisitor();
    getVisitors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('')),
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
                          return Admin();
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
              Text('Block Visitor',style: TextStyle(fontSize: 30,color: Colors.blue),),
              SizedBox(height: 20,),
              if (buttonState == 'Edit')
                Container(
                  padding: EdgeInsets.all(10.0),
                  color: Colors.yellow,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Edit Mode Enabled',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            buttonState = 'Add';
                            controller_visitorName.text = '';
                            controller_contactInformation.text = '';
                            controller_startDate.text = '';
                            controller_endDate.text = '';
                          });
                        },
                        child: Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 20,),
              Container(
                height: 50,
                width: 400,
                child: TextField(
                  readOnly: buttonState=='Edit'?true:false,
                  controller: controller_searchVisitor,
                  decoration: InputDecoration(
                    hintText: 'Search Visitor',
                    hintStyle: TextStyle(color: Colors.blue),
                    // Add a clear button to the search bar
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear,color: Colors.blue,),
                      onPressed: () => controller_searchVisitor.clear(),
                    ),
                    // Add a search icon or button to the search bar
                    prefixIcon: IconButton(
                      icon: Icon(Icons.search,color: Colors.blue,),
                      onPressed: () {
                        // Perform the search here
                      },
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                        BorderSide(width: 1, color: Colors.blue), //<-- SEE HERE
                      borderRadius: BorderRadius.circular(30.0)
                    ),
                  ),
                  onTap: (){
                    buttonState=='Add'?_showVisitorDialog(context):null;
                  },
                ),
              ),
              SizedBox(height: 30,),
              // Row(
              //   children: [
              //     // Expanded(
              //     //   child: TextFormField(
              //     //     controller: controller_visitorId,
              //     //     decoration: InputDecoration(
              //     //       hintText: 'Visitor ID',
              //     //       labelText: 'Visitor ID',
              //     //       labelStyle: TextStyle(color: Colors.blue),
              //     //       enabledBorder: UnderlineInputBorder(
              //     //         borderSide: BorderSide(
              //     //           color: Colors.blue,
              //     //           width: 1,
              //     //         ),
              //     //       ),
              //     //     ),
              //     //   ),
              //     // ),
              //     // SizedBox(width: 20,),
                  TextFormField(
                    controller: controller_visitorName,
                    decoration: InputDecoration(
                      hintText: 'Visitor Name',
                      labelText: 'Visitor Name',
                      labelStyle: TextStyle(color: Colors.blue),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                // ]
              // ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller_contactInformation,
                      decoration: InputDecoration(
                        hintText: 'Contact Information',
                        labelText: 'Contact Information',
                        labelStyle: TextStyle(color: Colors.blue),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(width: 20,),
                  // Expanded(
                  //   child: TextFormField(
                  //     controller: controller_visitorName,
                  //     decoration: InputDecoration(
                  //       hintText: 'Visitor Name',
                  //       labelText: 'Visitor Name',
                  //       labelStyle: TextStyle(color: Colors.blue),
                  //       enabledBorder: UnderlineInputBorder(
                  //         borderSide: BorderSide(
                  //           color: Colors.blue,
                  //           width: 1,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ]
              ),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: (){
                      controller_startDate.text=_time.format(context);
                      setState(() {
                        _selectStartDate(context);  
                      });
                    }, 
                    child: Text("Start Date",style: TextStyle(fontSize: 15,color: Colors.blue),)
                  ),
                  SizedBox(width: 1,),
                  TextButton(
                    onPressed: (){
                      controller_endDate.text=_time.format(context);
                      setState(() {
                        _selectEndDate(context);  
                      });
                    }, 
                    child: Text("End Date",style: TextStyle(fontSize: 15,color: Colors.blue),)
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 150,
                    child: TextFormField(
                      controller: controller_startDate,
                      decoration: InputDecoration(
                        hintText: 'Start Date'
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: TextFormField(
                      controller: controller_endDate,
                      decoration: InputDecoration(
                        hintText: 'End Date'
                      ),
                    ),
                  )
                ],
              ),
              // Container(
              //   padding: EdgeInsets.zero,
              //   child: Align(
              //     alignment: Alignment.centerLeft,
              //     child: Padding(
              //       padding: EdgeInsets.all(0),
              //       child: TextButton(
              //         onPressed: (){
              //           controller_startDate.text=_time.format(context);
              //           setState(() {
              //             _selectEnterTime(context);  
              //           });
              //         }, 
              //         child: Text("Enter Time",style: TextStyle(fontSize: 20,color: Colors.blue),)
              //       ),
              //     ),
              //   ),
              // ),
              // TextFormField(
              //   controller: controller_startDate,
              //   style: TextStyle(fontSize: 20),
              //   decoration: InputDecoration(
              //     hintText: '9:30 AM',
              //     hintStyle: TextStyle(fontSize: 15,color: Colors.blue),
              //     enabledBorder: UnderlineInputBorder(
              //       borderSide: BorderSide(
              //         color: Colors.blue,
              //         width: 1,
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(height: 30,),
              // Container(
              //   padding: EdgeInsets.zero,
              //   child: Align(
              //     alignment: Alignment.centerLeft,
              //     child: Padding(
              //       padding: EdgeInsets.all(0),
              //       child: TextButton(
              //         onPressed: (){
              //           controller_endDate.text=_time.format(context);
              //           setState(() {
              //             _selectExitTime(context);  
              //           });
              //         }, 
              //         child: Text("Exit Time",style: TextStyle(fontSize: 20,color: Colors.blue),)
              //       ),
              //     ),
              //   ),
              // ),
              // TextFormField(
              //   controller: controller_endDate,
              //   style: TextStyle(fontSize: 20),
              //   decoration: InputDecoration(
              //     hintText: '11:00 AM',
              //     hintStyle: TextStyle(fontSize: 15,color: Colors.blue),
              //     enabledBorder: UnderlineInputBorder(
              //       borderSide: BorderSide(
              //         color: Colors.blue,
              //         width: 1,
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(height: 30,),
              GestureDetector(
                onTap: (){
                  String visitorname=controller_visitorName.text;
                  String visitorid=selectedVisitorId ?? ''; // Use an empty string as a default value;
                  // String visitorid=getBlockIdByName(visitorname).toString();
                  // String contactinfo=controller_contactInformation.text;
                  String startdate=controller_startDate.text;
                  String enddate=controller_endDate.text;
                  String userid=AdminGlobal.adminGlobalId.toString();
                  print(visitorid);
                  // print(contactinfo);
                  print(startdate);
                  print(enddate);
                  print(userid);
                  // if(controller_visitorName.text != '' || controller_contactInformation.text != '' || controller_startDate.text != '' || controller_endDate.text != ''){
                    if(buttonState=='Add'){
                      blockVisitor(visitorid,startdate,enddate,userid);
                    }
                    else if (buttonState == 'Edit' && blockIdForUpdate == null){
                      print('Id is null');
                    }
                    else{
                      // Check if an update is in progress
                      print(blockIdForUpdate);
                      unblockVisitor(blockIdForUpdate.toString());
                    }
                  // }
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
                      child: Text(buttonState=='Add'? 'Block' : 'Unblock',style: TextStyle(fontSize: 20,color: Colors.white),),
                    ),
                  ),
                )
              ),
              SizedBox(height: 10,),
              // if(buttonState=='Edit')
              //   GestureDetector(
              //     onTap: (){
              //       String enddate=controller_endDate.text;
              //       print(enddate);
                    
              //       // Check if an update is in progress
              //       print(blockIdForUpdate);
              //       extendBlock(blockIdForUpdate.toString(),enddate);
              //     },
              //     child: MouseRegion(
              //       cursor: SystemMouseCursors.click,
              //       child: Container(
              //         height: 50,
              //         width: 400,
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(40),
              //           color: Colors.blue,
              //         ),
              //         child: Center(
              //           child: Text('Block Extend Date',style: TextStyle(fontSize: 20,color: Colors.white),),
              //         ),
              //       ),
              //     )
              //   ),
              
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
                        DataCell(getText(blockVisitor.visitorName,15)),
                        // DataCell(Text(blockVisitor.startDate)),
                        DataCell(
                          Row(
                            children: [
                              Text(blockVisitor.endDate),
                              SizedBox(width: 5),
                                IconButton(
                                  onPressed: () {
                                    // Add your delete logic here for the user
                                    // You can use user.id to identify the user to delete
                                    buttonState = 'Edit';
                                    blockIdForUpdate = blockVisitor.visitorId; // Store the user ID
                                    print(blockIdForUpdate);
                                    controller_visitorName.text=blockVisitor.visitorName;
                                    controller_contactInformation.text=blockVisitor.phone;
                                    setState(() {
                                      
                                    });
                                  },
                                  icon: Icon(Icons.edit_square, color: Colors.blue),
                                ),
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
            ]
          ),
        )
      ),
    );
  }
}