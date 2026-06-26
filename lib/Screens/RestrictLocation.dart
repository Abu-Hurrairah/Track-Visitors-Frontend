import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:project/APIHandler/api.dart';
import 'package:project/CommonUtils.dart/LogoutConfirmationDialog.dart';
import 'package:project/CustomWidgets/Widgets.dart';
import 'package:project/Model/LocationModel.dart';
import 'package:project/Screens/Guard.dart';
import 'package:http/http.dart' as http;

class RestrictLocationScreen extends StatefulWidget {
  const RestrictLocationScreen({super.key});

  @override
  State<RestrictLocationScreen> createState() => _RestrictLocationScreenState();
}

class _RestrictLocationScreenState extends State<RestrictLocationScreen> {
  TextEditingController controller_searchLocation=TextEditingController();
  String? selectedValue;
  int? selectedValueId;
  String? selectLocationType;
  String buttonState = 'Add';
  List<String> dropdownOptions = [];
  Set<String> locationTypes= {}; // Use a Set instead of List
  DateTime? startDate;
  DateTime? endDate;
  bool isLoading=true;
  
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
          // Clear the dropdownOptions Set
          locationTypes.clear();

          // Add unique floor names to dropdownOptions
          for (var location in locations) {
            locationTypes.add(location.type);
          }
          // filteredLocations=locations;
          print(jsonResponse);
        });
      }
    }catch (e) {
      print('Error submitting form: $e');
    }
  }

  List<Map<String, dynamic>> restrictedLocations = [];
  Future<void> fetchRestrictedLocations() async {
    final url = "${APIHandler.ip}"; // Replace with your actual API endpoint URL

    try {
      final response = await http.get(Uri.parse('$url/GetRestrictedLocations'));

      if (response.statusCode == 200) {
        setState(() {
          restrictedLocations = List<Map<String, dynamic>>.from(
              json.decode(response.body) as List<dynamic>);
          print(restrictedLocations);
          filteredLocations=restrictedLocations;
          isLoading = false;
        });
      } else {
        print(
            "Failed to load restricted locations. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching restricted locations: $e");
    }
  }

  // List<Location> filteredLocations = [];
  // void filterLocations(String query) {
  //   setState(() {
  //     if (query.isEmpty) {
  //       // If the query is empty, display all locations
  //       filteredLocations = locations;
  //     } else {
  //       // Filter the locations based on the query
  //       filteredLocations = locations.where((location) {
  //         final lowerCaseQuery = query.toLowerCase();
  //         final lowerCaseName = location.name.toLowerCase();
  //         // final lowerCaseFloorName = location.floorName.toLowerCase();
  //         final lowerCaseType = location.type.toLowerCase();

  //         // Check if the name, floorName, or type contains the query
  //         return lowerCaseName.contains(lowerCaseQuery) ||
  //             // lowerCaseFloorName.contains(lowerCaseQuery) ||
  //             lowerCaseType.contains(lowerCaseQuery);
  //       }).toList();
  //     }
  //   });
  // }

  List<Map<String, dynamic>> filteredLocations = [];

  void filterLocations(String query) {
    setState(() {
      filteredLocations.clear(); // Clear existing filtered locations

      // Add regular locations to the filteredLocations
      // filteredLocations.addAll(locations.map((location) => location.toJson()));

      // Add restricted locations to the filteredLocations
      filteredLocations.addAll(restrictedLocations);

      if (query.isNotEmpty) {
        // Filter the locations based on the query
        filteredLocations = filteredLocations.where((location) {
          final lowerCaseQuery = query.toLowerCase();
          final lowerCaseName = location['name'].toLowerCase();
          final lowerCaseType = location['type'].toLowerCase();

          // Check if the name or type contains the query
          return lowerCaseName.contains(lowerCaseQuery) || lowerCaseType.contains(lowerCaseQuery);
        }).toList();
      }
    });
  }

  DateTime? selectedStartDateTime;
  String? selectedStartDate;
  String? selectedStartTime;

  Future<void> _selectStartDateTime(BuildContext context) async {
    DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDateTime != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        selectedStartDateTime = DateTime(
          pickedDateTime.year,
          pickedDateTime.month,
          pickedDateTime.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // Format and save date and time separately
        selectedStartDate = DateFormat('yyyy-MM-dd').format(selectedStartDateTime!);
        // selectedTime = DateFormat('HH:mm').format(selectedDateTime!);
        selectedStartTime = DateFormat('hh:mm a').format(selectedStartDateTime!);

        // Format the selectedDateTime using intl package
        String formattedDateTime = DateFormat('yyyy-MM-dd hh:mm a').format(selectedStartDateTime!);
        
        print('Selected Start Date and Time: $formattedDateTime');

        // Print or use the selected date and time
        print('Selected Start Date and Time: $selectedStartDateTime');
        print('Selected Start Date: $selectedStartDate');
        print('Selected Start Time: $selectedStartTime');
      }
    }
  }

  DateTime? selectedEndDateTime;
  String? selectedEndDate;
  String? selectedEndTime;

  Future<void> _selectEndDateTime(BuildContext context) async {
    DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDateTime != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        selectedEndDateTime = DateTime(
          pickedDateTime.year,
          pickedDateTime.month,
          pickedDateTime.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // Format and save date and time separately
        selectedEndDate = DateFormat('yyyy-MM-dd').format(selectedEndDateTime!);
        // selectedTime = DateFormat('HH:mm').format(selectedDateTime!);
        selectedEndTime = DateFormat('hh:mm a').format(selectedEndDateTime!);

        // Format the selectedDateTime using intl package
        String formattedDateTime = DateFormat('yyyy-MM-dd hh:mm a').format(selectedEndDateTime!);
        
        print('Selected End Date and Time: $formattedDateTime');

        // Print or use the selected date and time
        print('Selected End Date and Time: $selectedEndDateTime');
        print('Selected End Date: $selectedEndDate');
        print('Selected End Time: $selectedEndTime');
      }
    }
  }
  
  @override
  void initState() {
    super.initState();
    getLocations();
    fetchRestrictedLocations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
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
              SizedBox(height: 10,),
              Text('Restrict Location',style: TextStyle(fontSize: 30,color: Colors.blue),),
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
                            // controller_locationName.text = '';
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
              Align(alignment: Alignment.topLeft,child: Text('Location',style: TextStyle(fontSize: 20,color: Colors.blue),)),
              DropdownButton(
                hint: Text('Select Location',style: TextStyle(fontSize: 15,color: Colors.blue),),
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
                    selectedValue=value;
                    // Find the corresponding location ID
                    Location selectedLocation = locations.firstWhere((location) => location.name == value);
                    selectedValueId = selectedLocation.id;

                    print("Selected Value: $selectedValue");
                    print("Selected Location ID: $selectedValueId");
                  });
                }
              ),
              // SizedBox(height: 20,),
              // Align(alignment: Alignment.topLeft,child: Text('Location Type',style: TextStyle(fontSize: 20,color: Colors.blue),)),
              // DropdownButton(
              //   hint: Text('Select Type',style: TextStyle(fontSize: 15,color: Colors.blue),),
              //   icon: Icon(Icons.arrow_drop_down,color: Colors.blue,),
              //   // icon: Icon(Icons.arrow_circle_down),
              //   // underline: Text('__________'),
              //   isExpanded: true,
              //   // enableFeedback: true,
              //   // dropdownColor: Colors.blue,
              //   // borderRadius: BorderRadius.circular(10),
              //   // menuMaxHeight: 60,
              //   value: selectLocationType,
              //   items: locationTypes.map((e) => DropdownMenuItem(
              //     child: Text(e),
              //     value: e,
              //   )).toList(), 
              //   onChanged: (String? value){
              //     setState(() {
              //       selectLocationType=value;
              //     });
              //   }
              // ),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () {
                  _selectStartDateTime(context);
                },
                child: Text('Select Start Date and Time'),
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () {
                  _selectEndDateTime(context);
                },
                child: Text('Select End Date and Time'),
              ),
              SizedBox(height: 30,),
              GestureDetector(
                onTap: (){
                  // String locationname=controller_locationName.text;
                  // String floor=selectedValue!;
                  String locationtype=selectLocationType ?? '';
                  print(selectedValue);
                  print(locationtype);
                  // if(selectLocationType!=''){
                    if(buttonState=='Add'){
                      // restrictLocation(selectedValue,locationtype);
                    }
                    // else if (buttonState == 'Edit' && locationIdForUpdate != null){
                    //   // Check if an update is in progress
                    //   // final name = controller_locationName.text;
                    //   // final locationfloor = selectedValue;
                    //   // final locationtype=selectLocationType;
                    //   updateLocation(locationIdForUpdate!, locationname, floor, locationtype, isDestination);
                    // }
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
                      child: Text(buttonState=='Add'? 'Restrict' : 'Update Location',style: TextStyle(fontSize: 20,color: Colors.white),),
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
                    hintText: 'Search',
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
                    child: Text('Location', style: TextStyle(fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    height: 30,  
                    width: 1,    
                    color: Colors.blue,
                  ),
                  VerticalDivider(
                    color: Colors.blue,
                    thickness: 1, 
                    width: 20,   
                  ),
                  Expanded(
                    child: Text("Restricted till", style: TextStyle(fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    height: 30,  
                    width: 1,    
                    color: Colors.blue,
                  ),
                  VerticalDivider(
                    color: Colors.blue,
                    thickness: 1, 
                    width: 20,   
                  ),
                  Expanded(
                    child: Text("Action", style: TextStyle(fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              Divider(thickness: 2),
              Container(
                height: 450,
                child: ListView.builder(
                  itemCount: filteredLocations.length,
                  itemBuilder: (context, index) {
                    var item = filteredLocations[index];

                    if (item is Map<String, dynamic>) {
                      // Handle the case where the item is a Map<String, dynamic>
                      // Example:
                      String name = item['name'];
                      // String floorName = item['floorName'];
                      String type = item['type'];

                      return Column(
                        children: [
                          Slidable(
                            endActionPane: ActionPane(
                              motion: StretchMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    buttonState = 'Edit';
                                    // selectedValue = floorName;
                                    selectLocationType = type;
                                    setState(() {});
                                  },
                                  icon: Icons.edit_square,
                                  foregroundColor: Colors.blue,
                                ),
                                SlidableAction(
                                  onPressed: (context) {
                                    setState(() {
                                      // deleteConfirmationDialog(location.id ?? -1);
                                    });
                                  },
                                  icon: Icons.delete_forever,
                                  foregroundColor: Colors.red,
                                ),
                              ],
                            ),
                            child: Container(
                              height: 40,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: getText(name.toString(), 15),
                                  ),
                                  Container(
                                    height: 30,
                                    width: 1,
                                    color: Colors.blue,
                                  ),
                                  VerticalDivider(
                                    color: Colors.white,
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: getText('floorName', 15),
                                  ),
                                  Container(
                                    height: 30,
                                    width: 1,
                                    color: Colors.blue,
                                  ),
                                  VerticalDivider(
                                    color: Colors.white,
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: Text(type),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Divider(thickness: 1.5),
                        ],
                      );
                    }

                    return SizedBox.shrink(); // Handle other cases or return an empty widget
                  },
                ),
              ),


              // Container(
              //   // height: double.maxFinite,
              //   // height: (locations.length*7+20),
              //   height: 450,
              //   child: ListView.builder(
              //     itemCount: filteredLocations.length,
              //     itemBuilder: (context, index){
              //       Location location=filteredLocations[index];
              //       return Column(
              //         children: [
              //           Slidable(
              //             endActionPane: ActionPane(
              //               motion: StretchMotion(), 
              //               children: [
              //                 SlidableAction(
              //                   onPressed: (context){
              //                     buttonState = 'Edit';
              //                     // locationIdForUpdate = location.id;
              //                     selectedValue=location.floorName;
              //                     selectLocationType=location.type;
              //                     setState(() {
                                    
              //                     });
              //                   },
              //                   icon: Icons.edit_square,
              //                   foregroundColor: Colors.blue,
              //                 ),
              //                 SlidableAction(
              //                   onPressed: (context){
              //                     setState(() {
              //                       // deleteConfirmationDialog(location.id ?? -1);
              //                     });
              //                   },
              //                   icon: Icons.delete_forever,
              //                   foregroundColor: Colors.red,
              //                 ),
              //               ]
              //             ),
              //             child: Container(
              //               height: 40,
              //               child: Row(
              //                 children: [
              //                   Expanded(
              //                     child: getText(location.name.toString(),15)
              //                   ),
              //                   Container(
              //                     height: 30,  
              //                     width: 1,    
              //                     color: Colors.blue,
              //                   ),
              //                   VerticalDivider(
              //                     color: Colors.white,
              //                     // thickness: 1, 
              //                     width: 20,   
              //                   ),
              //                   Expanded(
              //                     child: getText(location.floorName,15)
              //                   ),
              //                   Container(
              //                     height: 30,  
              //                     width: 1,    
              //                     color: Colors.blue,
              //                   ),
              //                   VerticalDivider(
              //                     color: Colors.white,
              //                     // thickness: 1, 
              //                     width: 20,   
              //                   ),
              //                   Expanded(
              //                     child: Text(location.type)
              //                   )
              //                 ],
              //               ),
              //             )
              //           ),
              //           Divider(thickness: 1.5),
              //         ],
              //       );
              //     }
              
              //   ),
              // ),


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
              
            ]
          )
        )
      )
    );
  }
}



// class RestrictedLocation {
//   final int restrictedId;
//   final int locationId;
//   final String locationName;
//   final String startDatetime;
//   final String endDatetime;

//   RestrictedLocation({
//     required this.restrictedId,
//     required this.locationId,
//     required this.locationName,
//     required this.startDatetime,
//     required this.endDatetime,
//   });

//   factory RestrictedLocation.fromJson(Map<String, dynamic> json) {
//     return RestrictedLocation(
//       restrictedId: json['restricted_id'] ?? 0,
//       locationId: json['location_id'] ?? 0,
//       locationName: json['location_name'] ?? '',
//       startDatetime: json['start_datetime'] ?? '',
//       endDatetime: json['end_datetime'] ?? '',
//     );
//   }
// }

// Future<void> fetchRestrictedLocations() async {
//   final url = "${APIHandler.ip}"; // Replace with your actual API endpoint URL

//   try {
//     final response = await http.get(Uri.parse('$url/GetRestrictedLocations'));

//     if (response.statusCode == 200) {
//       setState(() {
//         restrictedLocations = (json.decode(response.body) as List)
//             .map((json) => RestrictedLocation.fromJson(json))
//             .toList();
//         print(restrictedLocations);
//         filteredLocations = restrictedLocations;
//         isLoading = false;
//       });
//     } else {
//       print("Failed to load restricted locations. Status code: ${response.statusCode}");
//     }
//   } catch (e) {
//     print("Error fetching restricted locations: $e");
//   }
// }
