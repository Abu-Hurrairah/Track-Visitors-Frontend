import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:project/APIHandler/api.dart';
import 'package:project/CommonUtils.dart/LogoutConfirmationDialog.dart';
import 'package:project/Model/CameraLocationConnectionModel.dart';
import 'package:project/Model/CameraModel.dart';
import 'package:project/Model/LocationModel.dart';
import 'package:project/Screens/Admin.dart';
import 'package:project/Screens/Login.dart';
import 'package:http/http.dart' as http;
import '../CustomWidgets/Widgets.dart';

class AddCamera extends StatefulWidget {
  const AddCamera({super.key});

  @override
  State<AddCamera> createState() => _AddCameraState();
}

class _AddCameraState extends State<AddCamera> {
  TextEditingController controller_cameraName=TextEditingController();
  TextEditingController controller_location=TextEditingController();
  TextEditingController controller_cameraLocation=TextEditingController();
  TextEditingController controller_searchCamera=TextEditingController();
  String? selectedValue;
  List<String> selectedLocations = [];
  List<int> selectedLocationsIds=[];
  String? selectedValueCamera;
  List<String> selectedCameras=[];
  List<int> selectedCamerasIds=[];
  List<int> selectedCamerasTime=[];
  // List<String> dropdownOptions = ['Option 1', 'Option 2', 'Option 3','Option 4'];
  List<String> dropdownOptions = [];
  List<String> dropdownCameras=[];
  String buttonState = 'Add';

  List<Location> locations = [];
  Future <void> getLocations() async{
    try{
      var request = http.MultipartRequest('GET',Uri.parse('${APIHandler.ip}/GetAllLocations'),);
      var response = await request.send();
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(await response.stream.bytesToString());
        setState(() {
          locations = jsonResponse.map((json) => Location.fromJson(json)).toList();
          dropdownOptions = locations.map((location) => location.name).toList();
          print(jsonResponse);
        });
      }
    }catch (e) {
      print('Error submitting form: $e');
    }
  }


  List<Camera> cameras = [];
  Future <void> getCameras() async{
    try{
      var request = http.MultipartRequest('GET',Uri.parse('${APIHandler.ip}/GetAllCameras'),);
      var response = await request.send();
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(await response.stream.bytesToString());
        setState(() {
          cameras = jsonResponse.map((json) => Camera.fromJson(json)).toList();
          dropdownCameras = cameras.map((camera) => camera.name).toList();
          print(dropdownCameras);
        });
      }
    }catch (e) {
      print('Error submitting form: $e');
    }
  }

  List<CameraLocationConnection> cameraLocations = [];
  Future <void> getCameraLocationConnection() async{
    try{
      var request = http.MultipartRequest('GET',Uri.parse('${APIHandler.ip}/GetAllCamerasLocationsConnections'),);
      var response = await request.send();
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(await response.stream.bytesToString());
        setState(() {
          cameraLocations = jsonResponse.map((json) => CameraLocationConnection.fromJson(json)).toList();
          // dropdownCameras = cameras.map((camera) => camera.name).toList();
          filteredCameraLocations=cameraLocations;
          print(jsonResponse);
        });
      }
    }catch (e) {
      print('Error submitting form: $e');
    }
  }

  Future<void> addCamera(String name, List<int> cameraLocations, List<int> connectedCameras, List<int> time) async {
    try {
      Map<String, dynamic> data = {
        'name': name,
        'cameraLocations': cameraLocations,
        'connectedCameras': connectedCameras,
        'time': time,
      };

      var headers = {
        'Content-Type': 'application/json',
      };

      var response = await http.post(
        Uri.parse('${APIHandler.ip}/AddCamera'),
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        print('Camera added successfully');
        controller_cameraName.clear();
        selectedValue=null;
        selectedValueCamera=null;
        selectedLocations.clear();
        selectedLocationsIds.clear();
        selectedCameras.clear();
        selectedCamerasIds.clear();
        selectedCamerasTime.clear();
        final successMessage = json.decode(response.body)['message'];
        print('Camera added successfully: $successMessage');
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
          getCameraLocationConnection();
        });
      } else {
        print('Failed to add camera');
        final errorMessage = json.decode(response.body)['error'];
        print('Failed to add camera: $errorMessage');
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to add camera: $errorMessage'),
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
      // Handle the error
    }
  }


  int getCameraIdByName(String cameraName) {
    final camera = cameras.firstWhere((camera) => camera.name == cameraName, orElse: () => Camera(id: 0, name: ''));
    return camera.id;
  }

  // Add a user ID variable to track the user being updated
  int? cameraLocationIdForUpdate;
  Future<void> updateCamera(int cameraId, String name, List<int> cameraLocations, List<int> connectedCameras, List<int> time) async {
    print('up');
    try {
      Map<String, dynamic> data = {
        'name': name,
        'cameraLocations': cameraLocations,
        'connectedCameras': connectedCameras,
        'time': time,
      };

      var headers = {
        'Content-Type': 'application/json',
      };

      var response = await http.put(
        Uri.parse('${APIHandler.ip}/UpdateCamera/$cameraId'), // Replace with your API endpoint
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print('Camera updated successfully');
        // Handle success as needed (e.g., show a success message)
        final successMessage = json.decode(response.body)['message'];
        print('Camera updated successfully: $successMessage');
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
          controller_cameraName.clear();
          selectedValue=null;
          selectedValueCamera=null;
          selectedLocations.clear();
          selectedLocationsIds.clear();
          selectedCameras.clear();
          selectedCamerasIds.clear();
          selectedCamerasTime.clear();
          buttonState = 'Add';
          cameraLocationIdForUpdate = null;
          getCameraLocationConnection();
        });
      } else {
        print('Failed to update camera');
        // Handle the failure (e.g., show an error message)
        final errorMessage = json.decode(response.body)['error'];
        print('Failed to update camera: $errorMessage');
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to update camera: $errorMessage'),
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
      // Handle any exceptions that occur during the request
    }
  }

  // Function to display a confirmation dialog before deleting a camera
  Future<void> deleteConfirmationDialog(int cameraId) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Camera'),
          content: Text('Are you sure you want to delete this camera?'),
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
      // Camera confirmed the delete action
      deleteCamera(cameraId);
    }
  }

  Future<void> deleteCamera(int cameraId) async {
    try {
      var response = await http.delete(
        Uri.parse('${APIHandler.ip}/DeleteCamera/$cameraId'), // Replace with your API endpoint
      );

      if (response.statusCode == 200) {
        print('Camera deleted successfully');
        // Handle success as needed (e.g., show a success message)
        final successMessage = json.decode(response.body)['message'];
        print('Camera deleted successfully: $successMessage');
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
          getCameraLocationConnection();
        });
      } else {
        print('Failed to delete camera');
        // Handle the failure (e.g., show an error message)
        final errorMessage = json.decode(response.body)['error'];
        print('Failed to delete camera: $errorMessage');
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to delete camera: $errorMessage'),
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
      // Handle any exceptions that occur during the request
    }
  }

  List<CameraLocationConnection> filteredCameraLocations = [];
  void filterCameraLocations(String query) {
    // setState(() {
    //   filteredCameraLocations = cameraLocations.where((cameraLocation) =>
    //       cameraLocation.name.toLowerCase().contains(query.toLowerCase())).toList();
    // });
    setState(() {
      if (query.isEmpty) {
        // If the query is empty, display all cameraLocations
        filteredCameraLocations = List.from(cameraLocations);
      } else {
        // Filter the cameraLocations based on the query
        // Filter the cameraLocations based on the query
      filteredCameraLocations = cameraLocations.where((cameraLocation) {
        final lowerCaseQuery = query.toLowerCase();
        final lowerCaseCameraName = cameraLocation.cameraName.toLowerCase();
        final lowerCaseLocationName = cameraLocation.locationName.toLowerCase();
        final lowerCaseConnectedCameraName = cameraLocation.connectedCameraName.toLowerCase();

        // Check if any field contains the query
        return lowerCaseCameraName.contains(lowerCaseQuery) ||
            lowerCaseLocationName.contains(lowerCaseQuery) ||
            lowerCaseConnectedCameraName.contains(lowerCaseQuery);}
        ).toList();
      }
      // if (query.isEmpty) {
      //   // If the query is empty, display all cameraLocations
      //   filteredCameraLocations = List.from(cameraLocations);
      // } else {
      //   // Filter the cameraLocations based on the query
      //   filteredCameraLocations = cameraLocations.where((cameraLocation) {
      //     final cameraName = cameraLocation.cameraName.toLowerCase();

      //     // Check if the camera name contains the query
      //     final result = cameraName.contains(query.toLowerCase());
      //     print('Camera Name: $cameraName, Query: $query, Result: $result');
      //     return result;
      //   }).toList();
      // }
    });
  }

  Future<void> showConnectedCameraTimeDialog(String cameraName) async {
    int enteredTime = 0; // Initialize the entered time to 0
    TextEditingController timeController = TextEditingController();
    bool showError = false;

    await showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissal by clicking outside
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            // Disable the back button during the dialog
            return false;
          },
          child: AlertDialog(
            title: Text('Enter Connected Camera Time for $cameraName'),
            content: Column(
              children: [
                TextField(
                  controller: timeController,
                  decoration: InputDecoration(labelText: 'Connected Time',hintText: showError?'Please Enter A Value':''),
                  keyboardType: TextInputType.number,
                  // inputFormatters: <TextInputFormatter>[
                  //   FilteringTextInputFormatter.digitsOnly, // Accept only digits
                  // ],
                  onChanged: (time) {
                    enteredTime = int.tryParse(time) ?? 0;
                    // Reset the showError flag when the user types
                    setState(() {
                      showError = false;
                    });
                  },
                ),
                if (showError && timeController.text.isEmpty)
                  Text(
                    'Please enter a value.',
                    style: TextStyle(color: Colors.red),
                  )
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Save'),
                onPressed: () {
                  // Check if the entered time is greater than or equal to 0
                  if (timeController.text.isNotEmpty && enteredTime >= 0) {
                    selectedCamerasTime.add(enteredTime);
                    print(enteredTime);
                    print(selectedCameras);
                    print(selectedCamerasTime);
                    Navigator.of(context).pop();
                  }
                  else{
                    // Show error if enteredTime is less than 0 or text field is empty
                    setState(() {
                      showError = true;
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Future <void> _showDropDownDialog(BuildContext context) async {
  //   await showDialog(
  //     context: context,
  //     barrierDismissible: false, // Set to false to disable closing on tap outside
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           return AlertDialog(
  //             title: Text("Select Locations"),
  //             content: Container(
  //               width: double.maxFinite,
  //               child: SingleChildScrollView(
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: <Widget>[
  //                     for (String location in dropdownOptions)
  //                       CheckboxListTile(
  //                         title: Text(location),
  //                         value: selectedLocations.contains(location),
  //                         onChanged: (bool? value) {
  //                           setState(() {
  //                             if (value != null) {
  //                               var loc;
  //                               if (value) {
  //                                 setState(() {
  //                                   loc = locations.firstWhere((l) => l.name == location);
  //                                   selectedValue=location;
  //                                   if (location != null && !selectedLocations.contains(location)) {
  //                                     selectedLocations.add(location);
  //                                     selectedLocationsIds.add(loc.id); // Store the location ID
  //                                     selectedValue = location; // Reset the dropdown selection
  //                                   }
  //                                   print(loc);
  //                                   print(selectedLocations);
  //                                   print(selectedLocationsIds);
  //                                   print(selectedValue);
  //                                 });
  //                                 // selectedDestinations.add(location);
  //                                 // selectDestinations.add(location);
  //                                 // selectedDestination = '$destination, ';
  //                                 // setState((){});
  //                                 // print(selectDestinations);
  //                               } else {
  //                                 selectedLocations.remove(location);
  //                                 selectedLocationsIds.remove(loc.id);
  //                               }
  //                             }
  //                           });
  //                         },
  //                       ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             actions: [
  //               // TextButton(
  //               //   onPressed: () {
  //               //     setState((){});
  //               //     Navigator.pop(context);
  //               //   },
  //               //   child: Text("Cancel"),
  //               // ),
  //               TextButton(
  //                 onPressed: () {
  //                   setState(() {
  //                     // selectedValue = selectedLocations.isNotEmpty ? selectedLocations.join(', ') : null;
  //                     print(selectedLocations);
  //                     print(selectedValue);
  //                   });
  //                   Navigator.pop(context);
  //                 },
  //                 child: Text("OK"),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   );
  // }



  @override
  void initState() {
    super.initState();
    getLocations();
    getCameras();
    getCameraLocationConnection();
    // Initialize selectedCamerasTime here
    // selectedCamerasTime = List<int>.generate(dropdownCameras.length, (index) => 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('')),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
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
                Text('Cameras',style: TextStyle(fontSize: 30,color: Colors.blue),),
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
                              controller_cameraName.text = '';
                              selectedValue = null;
                              controller_cameraLocation.text = '';
                              selectedValueCamera=null;
                              selectedLocations.clear();
                              selectedLocationsIds.clear();
                              selectedCameras.clear();
                              selectedCamerasIds.clear();
                              selectedCamerasTime.clear();
                            });
                          },
                          child: Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller_cameraName,
                        decoration: InputDecoration(
                          hintText: 'Camera Name',
                          labelText: 'Camera Name',
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
                    SizedBox(width: 20,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Location Name',style: TextStyle(fontSize: 18,color: Colors.blue),),
                          // GestureDetector(
                          //   onTap: () async {
                          //     await _showDropDownDialog(context);
                          //     setState(() {
                                
                          //     });
                          //   },
                          //   child: Container(
                          //     height: 60,
                          //     decoration: BoxDecoration(
                          //       border: Border.all(color: Colors.black),
                          //     ),
                          //     child: Padding(
                          //       padding: const EdgeInsets.all(4.0),
                          //       child: Row(
                          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //         children: [
                          //           Expanded(child: Text(selectedValue?.isNotEmpty == true ? selectedValue! : 'Select Location')),
                          //           // Text(selectedDestination ?? 'Select Destination'),
                          //           Icon(Icons.arrow_drop_down),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          DropdownButton(
                            hint: Text('Select Location',style: TextStyle(color: Colors.blue),),
                            icon: Icon(Icons.arrow_drop_down,color: Colors.blue,),
                            // icon: Icon(Icons.arrow_circle_down),
                            // underline: Text('__________'),
                            isExpanded: true,
                            // enableFeedback: true,
                            // dropdownColor: Colors.blue,
                            // borderRadius: BorderRadius.circular(10),
                            // menuMaxHeight: 60,
                            value: selectedValue,
                            items: dropdownOptions.map((e) => DropdownMenuItem(
                              child: Text(e),
                              value: e,
                            )).toList(), 
                            onChanged: (String? value){
                              setState(() {
                                final location = locations.firstWhere((location) => location.name == value);
                                selectedValue=value;
                                if (value != null && !selectedLocations.contains(value)) {
                                  selectedLocations.add(value);
                                  selectedLocationsIds.add(location.id); // Store the location ID
                                  selectedValue = value; // Reset the dropdown selection
                                }
                              });
                              // setState(() {
                              //   selectedValue=value;
                              // });
                            }
                          ),
                        ],
                      ),
                    ),
                  ]
                ),
                SizedBox(height: 20,),
                if(selectedLocations.isNotEmpty)
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue[200],
                  ),
                  child: Wrap(
                    spacing: 25.0, // Spacing between chips
                    runSpacing: 1.0, // Spacing between chip rows
                    children: selectedLocations.asMap().entries.map((entry) {
                      final index = entry.key;
                      final location = entry.value;
                      return Chip(
                        backgroundColor: Colors.blue[200],
                        label: Text(location, style: TextStyle(color: Colors.white)),
                        deleteIcon: Icon(Icons.cancel_outlined, color: Colors.white),
                        onDeleted: () {
                          selectedValue=null;
                          setState(() {
                            selectedLocations.removeAt(index);
                            // Remove the corresponding location ID
                            if (index < selectedLocationsIds.length) {
                              selectedLocationsIds.removeAt(index);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
          
                // Container(
                //   height: 70,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(10),
                //     color: Colors.blue[200],
                //   ),
                //   child: ListView.builder(
                //     scrollDirection: Axis.horizontal,
                //     itemCount: selectedLocations.length,
                //     itemBuilder: (context, index) {
                //       return Padding(
                //         padding: EdgeInsets.all(8.0),
                //         child: Chip(
                //           backgroundColor: Colors.blue[200],
                //           label: Text(selectedLocations[index],style: TextStyle(color: Colors.white),),
                //           deleteIcon: Icon(Icons.cancel_outlined,color: Colors.white,),
                //           onDeleted: () {
                //             setState(() {
                //               selectedLocations.removeAt(index);
                //             });
                //           },
                //         ),
                //       );
                //     },
                //   ),
                // ),
          
                SizedBox(height: 20,),
                Align(
                  alignment: Alignment.centerLeft, // Align text to the start (left)
                  child: Text(
                    'Connected Cameras',
                    style: TextStyle(fontSize: 18, color: Colors.blue),
                  ),
                ),
                DropdownButton(
                  hint: Text('Connected Cameras', style: TextStyle(color: Colors.blue),),
                  icon: Icon(Icons.arrow_drop_down, color: Colors.blue),
                  isExpanded: true,
                  value: selectedValueCamera,
                  items: dropdownCameras.map((cameraName) {
                    return DropdownMenuItem(
                      child: Text(cameraName),
                      value: cameraName,
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      selectedValueCamera = value;
                      if (value != null && !selectedCameras.contains(value)) {
                        selectedCameras.add(value);
                        selectedCamerasIds.add(getCameraIdByName(value));
                        print(value);
                        print(selectedCameras);
                        print(selectedCamerasIds);
                        showConnectedCameraTimeDialog(value);
                      }
                    });
                  },
                ),
//                 DropdownButton(
//   hint: Text('Connected Cameras', style: TextStyle(color: Colors.blue)),
//   icon: Icon(Icons.arrow_drop_down, color: Colors.blue),
//   isExpanded: true,
//   value: selectedValueCamera,
//   items: cameraLocations.map((cameraLocation) {
//     return DropdownMenuItem(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(cameraLocation.cameraName, style: TextStyle(color: Colors.black)),  // Adjust the style as needed
//           Expanded(
//             child: Text(
//               cameraLocation.locationName,
//               textAlign: TextAlign.right,
//               style: TextStyle(color: Colors.black),  // Adjust the style as needed
//             ),
//           ),
//         ],
//       ),
//       value: cameraLocation,
//     );
//   }).toList(),
//   onChanged: (dynamic value) {
//     setState(() {
//       selectedValueCamera = value;
//       if (value != null && value is CameraLocationConnection && !selectedCameras.contains(value.cameraName)) {
//         selectedCameras.add(value.cameraName);
//         selectedCamerasIds.add(value.cameraId!);
//         print(value.cameraName);
//         print(selectedCameras);
//         print(selectedCamerasIds);
//         showConnectedCameraTimeDialog(value.cameraName);
//       }
//     });
//   },
// ),


                // DropdownButton(
                //   hint: Text('Connected Cameras', style: TextStyle(color: Colors.blue),),
                //   icon: Icon(Icons.arrow_drop_down, color: Colors.blue),
                //   isExpanded: true,
                //   value: selectedValueCamera,
                //   items: dropdownCameras.asMap().entries.map((entry) {
                //     final index = entry.key;
                //     final cameraName = entry.value;
                //     return DropdownMenuItem(
                //       child: Row(
                //         children: [
                //           Expanded(child: Text(cameraName)),
                //           SizedBox(width: 20),
                //           Flexible(
                //             child: TextField(
                //               decoration: InputDecoration(labelText: 'Connected Time'),
                //               onChanged: (time) {
                //                 print("Entered Time: $time"); // Add this line
                //                 // Extract the entered time (e.g., convert it to an integer)
                //                 final enteredTime = int.tryParse(time) ?? 0;
                //                 print(enteredTime);
                //                 print(selectedCamerasTime);

                //                 // Ensure the selectedCamerasTime list has enough items
                //                 while (selectedCamerasTime.length <= index) {
                //                   selectedCamerasTime.add(0);
                //                 }

                //                 // Update the selectedCamerasTime list with the entered time
                //                 if (enteredTime >= 0) {
                //                   selectedCamerasTime[index] = enteredTime;
                //                   print(selectedCamerasTime[index]);
                //                 }
                //                 // Handle the time change for the selected camera here
                //               },
                //             ),
                //           ),
                //         ],
                //       ),
                //       value: cameraName,
                //     );
                //   }).toList(),
                //   onChanged: (String? value) {
                //     setState(() {
                //       selectedValueCamera = value;
                //       if (value != null && !selectedCameras.contains(value)) {
                //         selectedCameras.add(value);
                //         selectedCamerasIds.add(getCameraIdByName(value)); // Function to get camera ID by name
                //         selectedCamerasTime.add(0); // Initialize the time for the selected camera
                //         selectedValueCamera = value; // Reset the dropdown selection
                //         print(selectedCamerasTime);
                //       }
                //     });
                //   },
                // ),

                // DropdownButton(
                //   hint: Text('Connected Cameras',style: TextStyle(color: Colors.blue),),
                //   icon: Icon(Icons.arrow_drop_down,color: Colors.blue,),
                //   // icon: Icon(Icons.arrow_circle_down),
                //   // underline: Text('__________'),
                //   isExpanded: true,
                //   // enableFeedback: true,
                //   // dropdownColor: Colors.blue,
                //   // borderRadius: BorderRadius.circular(10),
                //   // menuMaxHeight: 60,
                //   value: selectedValueCamera,
                //   items: dropdownCameras.map((e) => DropdownMenuItem(
                //     child: Text(e),
                //     value: e,
                //   )).toList(), 
                //   onChanged: (String? value){
                //     setState(() {
                //       selectedValueCamera = value;
                //       if (value != null && !selectedCameras.contains(value)) {
                //         selectedCameras.add(value);
                //         selectedValueCamera = value; // Reset the dropdown selection
                //       }
                //     });
                //     // setState(() {
                //     //   selectedValue=value;
                //     // });
                //   }
                // ),
                SizedBox(height: 20,),
                if(selectedCameras.isNotEmpty)
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue[200],
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: selectedCameras.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Chip(
                          backgroundColor: Colors.blue[200],
                          label: Text(selectedCameras[index],style: TextStyle(color: Colors.white),),
                          deleteIcon: Icon(Icons.cancel_outlined,color: Colors.white,),
                          onDeleted: () {
                            selectedValueCamera=null;
                            setState(() {
                              selectedCameras.removeAt(index);
                              selectedCamerasIds.removeAt(index);
                              selectedCamerasTime.removeAt(index);
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 30,),
                GestureDetector(
                  onTap: (){
                    String cameraName = controller_cameraName.text;
                    List<int> cameraLocations = selectedLocationsIds;
                    List<int> connectedCameras = selectedCamerasIds;
                    List<int> time = selectedCamerasTime;
                    print(cameraName);
                    print(cameraLocations);
                    print(connectedCameras);
                    print(time);
                    print(cameraLocationIdForUpdate);
                    // Call the addCamera function to send the data to the server
                    if(buttonState=='Add'){
                      addCamera(cameraName, cameraLocations, connectedCameras, time);
                    }
                    else if (buttonState == 'Edit' && cameraLocationIdForUpdate != null){
                      // Check if an update is in progress
                      String cameraName = controller_cameraName.text;
                      List<int> cameraLocations = selectedLocationsIds;
                      List<int> connectedCameras = selectedCamerasIds;
                      List<int> time = selectedCamerasTime;
                      print(cameraName);
                      print(cameraLocations);
                      print(connectedCameras);
                      print(time);
                      print(cameraLocationIdForUpdate);
                      updateCamera(cameraLocationIdForUpdate!, cameraName, cameraLocations, connectedCameras, time);
                    }
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
                        child: Text(buttonState=='Add'? 'Add Camera' : 'Update Camera',style: TextStyle(fontSize: 20,color: Colors.white),),
                      ),
                    ),
                  )
                ),
                SizedBox(height: 30,),
                Container(
                  height: 50,
                  width: 400,
                  child: TextField(
                    controller: controller_searchCamera,
                    decoration: InputDecoration(
                      hintText: 'Search Camera',
                      hintStyle: TextStyle(color: Colors.blue),
                      // Add a clear button to the search bar
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear,color: Colors.blue,),
                        // onPressed: () => controller_searchCamera.clear(),
                        onPressed: () {
                          controller_searchCamera.clear();
                          getCameraLocationConnection();
                          setState(() {
                            
                          });
                        },
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
                    onChanged: (query) {
                      filterCameraLocations(query);
                    },
                  ),
                ),
                SizedBox(height: 30,),
                Row(
                  children: [
                    Expanded(
                      child: Text('C Name',style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)
                    ),
                    Expanded(
                      child: Text("Locations",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)
                    ),
                    Expanded(
                      child: Text("Connect with",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)
                    )
                  ],
                ),
                Divider(thickness: 2),
                Container(
                  // height: double.maxFinite,
                  // height: (filteredUsers.length*70),
                  height: 430,
                  child: ListView.builder(
                    itemCount: filteredCameraLocations.length,
                    itemBuilder: (context, index){
                      CameraLocationConnection cameraLocation=filteredCameraLocations[index];
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
                                    controller_cameraName.text=cameraLocation.cameraName;
                                    print(cameraLocation.cameraId);
                                    cameraLocationIdForUpdate = cameraLocation.cameraId; // Store the cameraLocation ID
                                    // controller_cameraLocation.text=cameraLocation.locationName;
                                    // for (var cameraLocation in cameraLocations) {
                                    //   selectedLocations.add(cameraLocation.locationName);
                                    // }
                                    // selectedLocations = [cameraLocation.locationName];
                                    // selectedCameras = [cameraLocation.connectedCameraName];
                                    setState(() {
                                      
                                    });
                                  },
                                  icon: Icons.edit_square,
                                  foregroundColor: Colors.blue,
                                ),
                                SlidableAction(
                                  onPressed: (context){
                                    setState(() {
                                      // Add your delete logic here for the cameraLocation
                                      // You can use cameraLocation.id to identify the cameraLocation to delete
                                      deleteConfirmationDialog(cameraLocation.cameraId ?? -1);
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
                                    child: getText(cameraLocation.cameraName.toString(),15)
                                  ),
                                  Expanded(
                                    child: SingleChildScrollView(child: getText(cameraLocation.locationName,15))
                                  ),
                                  Expanded(
                                    child: SingleChildScrollView(child: Text(cameraLocation.connectedCameraName))
                                  )
                                ],
                              ),
                            )
                          ),
                          Divider(thickness: 1.5),
                        ],
                      );
                    }
                
                  ),
                ),
                // SingleChildScrollView(
                //   scrollDirection: Axis.vertical,
                //   child: SingleChildScrollView(
                //     scrollDirection: Axis.horizontal,
                //     child: DataTable(
                //       columnSpacing: 25.0,
                //       columns: [
                //         DataColumn(label: Text('C Name',style: TextStyle(fontSize: 17,color: Colors.blue,fontWeight: FontWeight.bold),)),
                //         DataColumn(label: Text("Locations",style: TextStyle(fontSize: 17,color: Colors.blue,fontWeight: FontWeight.bold),)),
                //         DataColumn(label: Text("Connect with",style: TextStyle(fontSize: 17,color: Colors.blue,fontWeight: FontWeight.bold),)),
                //       ], 
                //       rows: filteredCameraLocations.map((cameraLocation) {
                //         return DataRow(
                //           cells: [
                //             DataCell(getText(cameraLocation.cameraName,15)),
                //             DataCell(Text(cameraLocation.locationName,style: TextStyle(fontSize: 15),)),
                //             DataCell(
                //               Row(
                //                 children: [
                //                   Flexible(
                //                     child: Text(
                //                       cameraLocation.connectedCameraName,style: TextStyle(fontSize: 15),
                //                       overflow: TextOverflow.ellipsis,
                //                     ),
                //                   ),
                //                   // Text(cameraLocation.connectedCameraName),
                //                   SizedBox(width: 5),
                //                   IconButton(
                //                     onPressed: () {
                //                       // Add your delete logic here for the user
                //                       // You can use user.id to identify the user to delete
                //                       buttonState = 'Edit';
                //                       controller_cameraName.text=cameraLocation.cameraName;
                //                       cameraLocationIdForUpdate = cameraLocation.cameraId; // Store the cameraLocation ID
                //                       // controller_cameraLocation.text=cameraLocation.locationName;
                //                       // for (var cameraLocation in cameraLocations) {
                //                       //   selectedLocations.add(cameraLocation.locationName);
                //                       // }
                //                       // selectedLocations = [cameraLocation.locationName];
                //                       // selectedCameras = [cameraLocation.connectedCameraName];
                //                       setState(() {
                                        
                //                       });
                //                     },
                //                     icon: Icon(Icons.edit_square, color: Colors.blue),
                //                   ),
                //                   IconButton(
                //                     onPressed: () {
                //                       // Add your delete logic here for the cameraLocation
                //                       // You can use cameraLocation.id to identify the cameraLocation to delete
                //                       deleteConfirmationDialog(cameraLocation.cameraId ?? -1);
                //                     },
                //                     icon: Icon(Icons.delete_forever, color: Colors.red),
                //                   ),
                //                 ],
                //               )
                //             ),
                //           ]
                //         );
                //       }
                //     ).toList(),
                //     ),
                //   ),
                // )
              ]
            ),
            ]
          )
        )
      ),
    );
  }
}