import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:project/APIHandler/api.dart';
import 'package:project/CommonUtils.dart/LogoutConfirmationDialog.dart';
import 'package:project/Model/FloorModel.dart';
import 'package:project/Screens/Admin.dart';
import 'package:project/Screens/Login.dart';
import 'package:http/http.dart' as http;
import '../CustomWidgets/Widgets.dart';

class Floors extends StatefulWidget {
  const Floors({super.key});

  @override
  State<Floors> createState() => _FloorsState();
}

class _FloorsState extends State<Floors> {
  TextEditingController controller_floorName=TextEditingController();
  TextEditingController controller_searchFloor=TextEditingController();
  String buttonState = 'Add';
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _floorNameError; // Variable to store the error message.

  List<Floor> floors = [];
  Future <void> getFloors() async{
    try{
      var request = http.MultipartRequest('GET',Uri.parse('${APIHandler.ip}/GetAllFloors'),);
      var response = await request.send();
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(await response.stream.bytesToString());
        setState(() {
          floors = jsonResponse.map((json) => Floor.fromJson(json)).toList();
          // dropdownOptions = users.map((user) => user.name).toList();
          print(floors);
          filteredFloors=floors;
        });
      }
    }catch (e) {
      print('Error submitting form: $e');
    }
  }

  Future<void> addFloor() async {
    String floorname = controller_floorName.text;
    
    if (_formKey.currentState?.validate() == false) {
      // Form is not valid, show an error message
      setState(() {
        _floorNameError = 'Please enter a floor name';
      });
      return;
    }
    // Form is valid, continue with adding the floor
    _floorNameError = null; // Clear any previous error message

    if(floorname.isEmpty){
      print('NO selected');
      return ;
    }

    try {
      final newFloor = Floor(
        name: controller_floorName.text,
      );
      final response = await http.post(
        Uri.parse('${APIHandler.ip}/AddFloor'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(newFloor.toJson()),
      );

      if (response.statusCode == 201) {
        controller_floorName.clear();
        final successMessage = json.decode(response.body)['message'];
        print('Floor added successfully: $successMessage');
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text(successMessage),
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
        setState(() {
          getFloors();
        });
      } else {
        final errorMessage = json.decode(response.body)['error'];
        print('Failed to add floor: $errorMessage');
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to add floor: $errorMessage'),
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
      // if (response.statusCode == 201) {
      //   print('Floor added successfully!');
      //   setState(() {
          
      //   });
      // } else {
      //   final errorMessage = json.decode(response.body)['error'];
      //   print('Failed to add floor: $errorMessage');
      // }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Add a floor ID variable to track the floor being updated
  int? floorIdForUpdate;
  Future<void> updateFloor(int id, String name) async {
    try {
      final updatedFloor = {
        'name': name,
      };

      final response = await http.put(
        Uri.parse('${APIHandler.ip}/UpdateFloor/$id'), 
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedFloor),
      );

      if (response.statusCode == 200) {
        print('Floor updated successfully');
        final successMessage = json.decode(response.body)['message'];
        print('Floor updated successfully: $successMessage');
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text(successMessage),
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
        setState(() {
          // Clear the form fields and exit edit mode
          controller_floorName.clear();
          buttonState = 'Add';
          floorIdForUpdate = null;
          getFloors();
        });
      } else {
        final errorMessage = json.decode(response.body)['error'];
        print('Failed to update floor: $errorMessage');
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to add floor: $errorMessage'),
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
    } catch (e) {
      print('Error: $e');
    }
  }

  // Function to display a confirmation dialog before deleting a floor
  Future<void> deleteConfirmationDialog(int floorId) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Floor'),
          content: Text('Are you sure you want to delete this floor?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm delete
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel delete
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      // Floor confirmed the delete action
      deleteFloor(floorId);
    }
  }

  Future<void> deleteFloor(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${APIHandler.ip}/DeleteFloor/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final successMessage = json.decode(response.body)['message'];
        print('Floor deleted successfully: $successMessage');
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text(successMessage),
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
        setState(() {
          getFloors();
        });
      } else {
        final errorMessage = json.decode(response.body)['error'];
        print('Failed to delete floor: $errorMessage');
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to delete floor: $errorMessage'),
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
    } catch (e) {
      print('Error: $e');
    }
  }

  List<Floor> filteredFloors = [];
  void filterFloors(String query) {
    // setState(() {
    //   filteredFloors = floors.where((floor) =>
    //       floor.name.toLowerCase().contains(query.toLowerCase())).toList();
    // });
    setState(() {
      if (query.isEmpty) {
        // If the query is empty, display all floors
        filteredFloors = List.from(floors);
      } else {
        // Filter the floors based on the query
        filteredFloors = floors.where((floor) =>
          floor.name.toLowerCase().contains(query.toLowerCase())
        ).toList();
      }
    });
  }


  @override
  void initState() {
    super.initState();
    getFloors();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Form(
            key: _formKey, // Assign the form key
            child: ListView(
              children: [
                Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // SizedBox(height: 20,),
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
                  Text('Floors',style: TextStyle(fontSize: 30,color: Colors.blue),),
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
                                controller_floorName.text = '';
                              });
                            },
                            child: Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 10,),
                  TextFormField(
                    controller: controller_floorName,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      hintText: 'Enter Floor Name',
                      labelText: 'Floor Name',
                      labelStyle: TextStyle(color: Colors.blue),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 1,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a floor name';
                      }
                      return null;
                    },
                  ),
                  // Show an error message if _floorNameError is not null
                  if (_floorNameError != null)
                  Text(
                    _floorNameError!,
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        // addUser();
                        // Validate the form
                        if (_formKey.currentState?.validate() == true) {
                          if(buttonState=='Add'){
                            addFloor();
                          }
                          else if (buttonState == 'Edit' && floorIdForUpdate != null){
                            // Check if an update is in progress
                            final name = controller_floorName.text;
                            updateFloor(floorIdForUpdate!, name);
                          }
                        }
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
                          child: Text(buttonState=='Add'? 'Add Floor' : 'Update Floor',style: TextStyle(fontSize: 20,color: Colors.white),),
                        ),
                      ),
                    )
                  ),
                  SizedBox(height: 20,),
                  Container(
                    height: 50,
                    width: 400,
                    child: TextFormField(
                      controller: controller_searchFloor,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                        hintText: 'Search Floor',
                        hintStyle: TextStyle(color: Colors.blue),
                        // suffixIcon: Icon(Icons.search,color: Colors.blue,),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear,color: Colors.blue,),
                          onPressed: () {
                            controller_searchFloor.clear();
                            getFloors();
                            setState(() {
                              
                            });
                          },
                        ),
                        prefixIcon: IconButton(
                          icon: Icon(Icons.search,color: Colors.blue,),
                          onPressed: () {
                            // Perform the search here
                            // searchUser(); // Call the searchUser method
                          },
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(30)
                        ),
                      ),
                      onChanged: (query) {
                        filterFloors(query);
                      },
                    ),
                  ),
                  SizedBox(height: 30,),
                  // ShowLocation(),
                  Row(
                    children: [
                      Expanded(
                        child: Text('Floor Name',style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)
                      ),
                    ],
                  ),
                  Divider(thickness: 2),
                  Container(
                    // height: double.maxFinite,
                    // height: (filteredUsers.length*70),
                    height: 440,
                    child: ListView.builder(
                      itemCount: filteredFloors.length,
                      itemBuilder: (context, index){
                        Floor floor=filteredFloors[index];
                        return Column(
                          children: [
                            Slidable(
                              endActionPane: ActionPane(
                                motion: StretchMotion(), 
                                children: [
                                  SlidableAction(
                                    onPressed: (context){
                                      // Add your delete logic here for the user
                                      // You can use user.id to identify the user to delete
                                      buttonState = 'Edit';
                                      floorIdForUpdate = floor.id; // Store the user ID
                                      controller_floorName.text=floor.name;
                                      setState(() {
                                        
                                      });
                                    },
                                    icon: Icons.edit_square,
                                    foregroundColor: Colors.blue,
                                  ),
                                  SlidableAction(
                                    onPressed: (context){
                                      setState(() {
                                        deleteConfirmationDialog(floor.id ?? -1);
                                      });
                                    },
                                    icon: Icons.delete_forever,
                                    foregroundColor: Colors.red,
                                  ),
                                ]
                              ),
                              child: Container(
                                height: 40,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: getText(floor.name.toString(),15)
                                    ),
                                  ],
                                ),
                              )
                            ),
                            Divider(thickness: 1.5),
                          ],
                        );
                      }
                  
                    ),
                  )
                  // DataTable(
                  //   // columnSpacing: 120,
                  //   columns: [
                  //     // DataColumn(label: Text('Floor ID', style: TextStyle(fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold)),),
                  //     DataColumn(label: Text('Floor Name', style: TextStyle(fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold)),),
                  //   ],
                  //   rows: filteredFloors.map((floor) {
                  //     return DataRow(
                  //       cells: [
                  //         // DataCell(Text(floor.id.toString())), // Assuming id is an int, modify as needed
                  //         // DataCell(Text(floor.name)),
                  //         DataCell(
                  //           Row(
                  //             children: [
                  //               Text((floor.name)),
                  //               SizedBox(width: 55),
                  //               IconButton(
                  //                 onPressed: () {
                  //                   // Add your delete logic here for the user
                  //                   // You can use user.id to identify the user to delete
                  //                   buttonState = 'Edit';
                  //                   floorIdForUpdate = floor.id; // Store the user ID
                  //                   controller_floorName.text=floor.name;
                  //                   setState(() {
                                      
                  //                   });
                  //                 },
                  //                 icon: Icon(Icons.edit_square, color: Colors.blue),
                  //               ),
                  //               IconButton(
                  //                 onPressed: () {
                  //                   // Add your delete logic here for the floor
                  //                   // You can use floor.id to identify the floor to delete
                  //                   deleteConfirmationDialog(floor.id ?? -1);
                  //                 },
                  //                 icon: Icon(Icons.delete_forever, color: Colors.red),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ],
                  //     );
                  //   }).toList(),
                  // )
            
                ],
              ),
              ]
            ),
          ),
        ),
      ),
    );
  }
  
//   Widget ShowLocation() {
//     return Padding(
//       padding: EdgeInsets.all(15.0),
//       child: ListView.builder(
//         itemBuilder: (c,index){
          
//         }
//       ),
//     );
//   }
}