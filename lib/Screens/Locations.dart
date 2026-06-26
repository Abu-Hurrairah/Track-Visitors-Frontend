import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:project/APIHandler/api.dart';
import 'package:project/CommonUtils.dart/LogoutConfirmationDialog.dart';
import 'package:project/Model/FloorModel.dart';
import 'package:project/Model/LocationModel.dart';
import 'package:project/Screens/Admin.dart';
import 'package:project/Screens/Login.dart';
import 'package:http/http.dart' as http;
import '../CustomWidgets/Widgets.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  TextEditingController controller_locationName=TextEditingController();
  TextEditingController controller_searchLocation=TextEditingController();
  String? selectedValue;
  // List<String> dropdownOptions = ['Option 1', 'Option 2', 'Option 3'];
  List<String> dropdownOptions = [];
  Set<String> locationTypes= {}; // Use a Set instead of List
  String? selectLocationType;
  String buttonState = 'Add';
  bool isDestination=false;

  List<Location> locations = [];
  Future <void> getLocations() async{
    try{
      var request = http.MultipartRequest('GET',Uri.parse('${APIHandler.ip}/GetAllLocations'),);
      var response = await request.send();
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(await response.stream.bytesToString());
        setState(() {
          locations = jsonResponse.map((json) => Location.fromJson(json)).toList();
          // dropdownOptions = locations.map((location) => location.floorName).toList();
          // Clear the dropdownOptions Set
          locationTypes.clear();

          // Add unique floor names to dropdownOptions
          for (var location in locations) {
            locationTypes.add(location.type);
          }
          filteredLocations=locations;
          print(jsonResponse);
        });
      }
    }catch (e) {
      print('Error submitting form: $e');
    }
  }
  
  List<Floor> floors = [];
  Set<String> dropdownOptions1 = {}; // Use a Set instead of List
  Future <void> getFloors() async{
    try{
      var request = http.MultipartRequest('GET',Uri.parse('${APIHandler.ip}/GetAllFloors'),);
      var response = await request.send();
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(await response.stream.bytesToString());
        setState(() {
          floors = jsonResponse.map((json) => Floor.fromJson(json)).toList();
          // dropdownOptions = locations.map((location) => location.floorName).toList();
          // Clear the dropdownOptions Set
          dropdownOptions1.clear();

          // Add unique floor names to dropdownOptions
          for (var floor in floors) {
            dropdownOptions1.add(floor.name);
          }
          print(floors);
        });
      }
    }catch (e) {
      print('Error submitting form: $e');
    }
  }

  Future<void> addLocation(String name, int floorId, String type, bool Destination) async {
    if(name.isEmpty || type.isEmpty){
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
      Map<String, dynamic> data = {
        'name': name,
        'floor_id': floorId,
        'type': type,
        'isDestination': Destination,
      };

      var headers = {
        'Content-Type': 'application/json',
      };

      var response = await http.post(
        Uri.parse('${APIHandler.ip}/AddLocation'),
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        controller_locationName.clear();
        selectedValue=null;
        selectLocationType=null;
        // Location added successfully
        print('Location added successfully');
        final successMessage = json.decode(response.body)['message'];
        print('Location added successfully: $successMessage');
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text(successMessage),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    getLocations();
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
          controller_locationName.clear();
          selectedValue = null;
          selectLocationType = null;
          buttonState = 'Add';
          locationIdForUpdate = null;
          isDestination=false;
          getLocations();
        });
        // You can add any additional logic here upon successful addition.
      } else {
        // Failed to add location
        print('Failed to add location');
        final errorMessage = json.decode(response.body)['error'];
        print('Failed to add location: $errorMessage');
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to add location: $errorMessage'),
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
        // You can add any error handling logic here.
      }
    } catch (error) {
      print('Error: $error');
      // Handle the error as needed.
    }
  }

  int getFloorIdByName(String floorName) {
    final floor = floors.firstWhere(
      (floor) => floor.name == floorName,
      orElse: () => Floor(id: -1,name: ''), // Replace -1 with an appropriate default value
    );
    return floor.id!;
  }


  // int getLocationTypeIdByName(String locationName) {
  //   final location = locations.firstWhere((location) => location.name == locationName);
  //   return location.id;
  // }

  // Add a user ID variable to track the user being updated
  int? locationIdForUpdate;
  Future<void> updateLocation(int locationId, String name, int floorId, String type, bool Destination) async {
    try {
      Map<String, dynamic> data = {
        'name': name,
        'floor_id': floorId,
        'type': type,
        'isDestination': Destination
      };

      var headers = {
        'Content-Type': 'application/json',
      };

      var response = await http.put(
        Uri.parse('${APIHandler.ip}/UpdateLocation/$locationId'),
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        // Location updated successfully
        isDestination=false;
        print('Location updated successfully');
        final successMessage = json.decode(response.body)['message'];
        print('Location updated successfully: $successMessage');
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
          controller_locationName.clear();
          selectedValue = null;
          selectLocationType = null;
          locationIdForUpdate = null;
          isDestination=false;
          getLocations();
          buttonState = 'Add';
        });
        // You can add any additional logic here upon successful update.
      } else {
        // Failed to update location
        print('Failed to update location');
        final errorMessage = json.decode(response.body)['error'];
        print('Failed to update location: $errorMessage');
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to update location: $errorMessage'),
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
        // You can add any error handling logic here.
      }
    } catch (error) {
      print('Error: $error');
      // Handle the error as needed.
    }
  }

  // Function to display a confirmation dialog before deleting a location
  Future<void> deleteConfirmationDialog(int locationId) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Location'),
          content: Text('Are you sure you want to delete this Location?'),
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
      // Location confirmed the delete action
      deleteLocation(locationId);
    }
  }

  Future<void> deleteLocation(int locationId) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
      };

      var response = await http.delete(
        Uri.parse('${APIHandler.ip}/DeleteLocation/$locationId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        // Location deleted successfully
        print('Location deleted successfully');
        final successMessage = json.decode(response.body)['message'];
        print('Location deleted successfully: $successMessage');
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
          getLocations();
        });
        // You can add any additional logic here upon successful deletion.
      } else {
        // Failed to delete location
        print('Failed to delete location');
        final errorMessage = json.decode(response.body)['error'];
        print('Failed to delete location: $errorMessage');
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to delete location: $errorMessage'),
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
        // You can add any error handling logic here.
      }
    } catch (error) {
      print('Error: $error');
      // Handle the error as needed.
    }
  }

  List<Location> filteredLocations = [];
  void filterLocations(String query) {
    setState(() {
      if (query.isEmpty) {
        // If the query is empty, display all locations
        filteredLocations = locations;
      } else {
        // Filter the locations based on the query
        filteredLocations = locations.where((location) {
          final lowerCaseQuery = query.toLowerCase();
          final lowerCaseName = location.name.toLowerCase();
          final lowerCaseFloorName = location.floorName.toLowerCase();
          final lowerCaseType = location.type.toLowerCase();

          // Check if the name, floorName, or type contains the query
          return lowerCaseName.contains(lowerCaseQuery) ||
              lowerCaseFloorName.contains(lowerCaseQuery) ||
              lowerCaseType.contains(lowerCaseQuery);
        }).toList();
      }
    });
  }



  @override
  void initState() {
    super.initState();
    getLocations();
    getFloors();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Text('Locations',style: TextStyle(fontSize: 30,color: Colors.blue),),
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
                              controller_locationName.text = '';
                              selectedValue = null;
                              selectLocationType = null;
                            });
                          },
                          child: Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 10,),
                TextFormField(
                  controller: controller_locationName,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    hintText: 'Enter Location Name',
                    labelText: 'Location Name',
                    labelStyle: TextStyle(color: Colors.blue),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 1,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Location Floor',
                    style: TextStyle(fontSize: 20, color: Colors.blue),
                  ),
                ),
                // SizedBox(height: 5,),
                DropdownButton(
                  hint: Text('Select Floor',style: TextStyle(color: Colors.blue),),
                  icon: Icon(Icons.arrow_drop_down,color: Colors.blue,),
                  // icon: Icon(Icons.arrow_circle_down),
                  // underline: Text('__________'),
                  isExpanded: true,
                  // enableFeedback: true,
                  // dropdownColor: Colors.blue,
                  // borderRadius: BorderRadius.circular(10),
                  // menuMaxHeight: 60,
                  value: selectedValue,
                  items: dropdownOptions1.map((e) => DropdownMenuItem(
                    child: Text(e),
                    value: e,
                  )).toList(), 
                  onChanged: (String? value){
                    setState(() {
                      selectedValue=value;
                    });
                  }
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(
                      child: Text('Location Type',style: TextStyle(fontSize: 20,color: Colors.blue),),
                    ),
                    SizedBox(width: 20,),
                    Expanded(child: Text('Is Destination',style: TextStyle(fontSize: 20,color: Colors.blue),)),

                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButton(
                        hint: Text('Select Type',style: TextStyle(fontSize: 15,color: Colors.blue),),
                        icon: Icon(Icons.arrow_drop_down,color: Colors.blue,),
                        // icon: Icon(Icons.arrow_circle_down),
                        // underline: Text('__________'),
                        isExpanded: true,
                        // enableFeedback: true,
                        // dropdownColor: Colors.blue,
                        // borderRadius: BorderRadius.circular(10),
                        // menuMaxHeight: 60,
                        value: selectLocationType,
                        items: locationTypes.map((e) => DropdownMenuItem(
                          child: Text(e),
                          value: e,
                        )).toList(), 
                        onChanged: (String? value){
                          setState(() {
                            selectLocationType=value;
                          });
                        }
                      ),
                    ),
                    SizedBox(width: 20,),
                    Expanded(
                      child: CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        fillColor: MaterialStatePropertyAll(Colors.blue),
                        value: isDestination,
                        onChanged: (value) {
                          setState(() {
                            isDestination = !isDestination;
                          });
                        },
                        checkColor: Colors.white,
                      )
                    )
                  ],
                ),
                SizedBox(height: 30,),
                GestureDetector(
                  onTap: (){
                    String locationname=controller_locationName.text;
                    // String floor=selectedValue!;
                    int floor=getFloorIdByName(selectedValue ?? '');
                    String locationtype=selectLocationType ?? '';
                    print(locationname);
                    print(floor);
                    print(locationtype);
                    if(controller_locationName.text.isNotEmpty || selectLocationType!=''){
                      if(buttonState=='Add'){
                        addLocation(locationname,floor,locationtype,isDestination);
                      }
                      else if (buttonState == 'Edit' && locationIdForUpdate != null){
                        // Check if an update is in progress
                        // final name = controller_locationName.text;
                        // final locationfloor = selectedValue;
                        // final locationtype=selectLocationType;
                        updateLocation(locationIdForUpdate!, locationname, floor, locationtype, isDestination);
                      }
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
                        child: Text(buttonState=='Add'? 'Add Location' : 'Update Location',style: TextStyle(fontSize: 20,color: Colors.white),),
                      ),
                    ),
                  )
                ),
                SizedBox(height: 20,),
                Container(
                  height: 50,
                  width: 400,
                  child: TextFormField(
                    controller: controller_searchLocation,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      // border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                      hintText: 'Search Location',
                      hintStyle: TextStyle(color: Colors.blue),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear,color: Colors.blue,),
                        onPressed: () {
                          controller_searchLocation.clear();
                          getLocations();
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
                    onChanged: filterLocations,
                  ),
                ),
                SizedBox(height: 15,),
                Row(
                  children: [
                    Expanded(
                      child: Text('Loc Name',style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)
                    ),
                    Expanded(
                      child: Text("Floor",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)
                    ),
                    Expanded(
                      child: Text("Type",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)
                    )
                  ],
                ),
                Divider(thickness: 2),
                Container(
                  // height: double.maxFinite,
                  // height: (locations.length*7+20),
                  height: 450,
                  child: ListView.builder(
                    itemCount: filteredLocations.length,
                    itemBuilder: (context, index){
                      Location location=filteredLocations[index];
                      return Column(
                        children: [
                          Slidable(
                            endActionPane: ActionPane(
                              motion: StretchMotion(), 
                              children: [
                                SlidableAction(
                                  onPressed: (context){
                                    buttonState = 'Edit';
                                    locationIdForUpdate = location.id;
                                    controller_locationName.text=location.name;
                                    selectedValue=location.floorName;
                                    selectLocationType=location.type;
                                    setState(() {
                                      
                                    });
                                  },
                                  icon: Icons.edit_square,
                                  foregroundColor: Colors.blue,
                                ),
                                SlidableAction(
                                  onPressed: (context){
                                    setState(() {
                                      deleteConfirmationDialog(location.id ?? -1);
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
                                    child: getText(location.name.toString(),15)
                                  ),
                                  Expanded(
                                    child: getText(location.floorName,15)
                                  ),
                                  Expanded(
                                    child: Text(location.type)
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
                )
                // DataTable(
                //   columnSpacing: 15,
                //   columns: [
                //     DataColumn(label: Text('Loc Name',style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)),
                //     DataColumn(label: Text("Floor",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)),
                //     DataColumn(label: Text("Type",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)),
                //   ], 
                //   rows: locations.map((location) {
                //     return DataRow(
                //       cells: [
                //         DataCell(getText(location.name.toString(),15)),
                //         DataCell(getText(location.floorName,15)),
                //         DataCell(
                //           Row(
                //             children: [
                //               Text(location.type),
                //               SizedBox(width: 5),
                //               IconButton(
                //                 onPressed: () {
                //                   // Add your delete logic here for the user
                //                   // You can use user.id to identify the user to delete
                //                   buttonState = 'Edit';
                //                   locationIdForUpdate = location.id; // Store the user ID
                //                   controller_locationName.text=location.name;
                //                   selectedValue=location.floorName;
                //                   selectLocationType=location.type;
                //                   setState(() {
                                    
                //                   });
                //                 },
                //                 icon: Icon(Icons.edit_square, color: Colors.blue),
                //               ),
                //               IconButton(
                //                 onPressed: () {
                //                   // Add your delete logic here for the user
                //                   // You can use user.id to identify the user to delete
                //                   deleteConfirmationDialog(location.id ?? -1);
                //                 },
                //                 icon: Icon(Icons.delete_forever, color: Colors.red),
                //               ),
                //             ],
                //           )
                //         ),
                //       ]
                //     );
                //   }
                //   ).toList(),
                // ),

                // ShowLocation(),
                // DataTable(
                //   columnSpacing: 10,
                //   columns: [
                //     DataColumn(label: Text('Loc ID',style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)),
                //     DataColumn(label: Text("Loc Name",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)),
                //     DataColumn(label: Text("Floor",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),)),
                //   ], 
                //   rows: locations.map((location) {
                //     return DataRow(
                //       cells: [
                //         DataCell(getText(location.id.toString(),15)),
                //         DataCell(getText(location.name,15)),
                //         DataCell(
                //           Row(
                //             children: [
                //               Text(location.floorName),
                //               SizedBox(width: 8,),
                //               IconButton(
                //                 onPressed: (){
          
                //                 }, 
                //                 icon: Icon(Icons.delete_forever,color: Colors.blue,)
                //               ),
                //             ],
                //           )
                //         ),
                //       ]
                //     );
                //   }
                //   ).toList(),
                // ),
              ],
            ),
            ]
          ),
        ),
      ),
    );
  }
}