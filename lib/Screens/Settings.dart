import 'dart:convert';
// import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:project/APIHandler/api.dart';
import 'package:project/CommonUtils.dart/LogoutConfirmationDialog.dart';
import 'package:project/Global/GuardGlobal.dart';
import 'package:project/Model/LocationModel.dart';
import 'package:project/Screens/Guard.dart';
import 'package:project/Screens/Login.dart';
import 'package:http/http.dart' as http;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? selectedLocation;
  int? guardId=GuardGlobal.guardGlobalId;
  int? locationId= GuardGlobal.guardGlobalDutyLocation;
  String location='';
  List<String> dropdownOptions=[];
  int? selectedLocationId;
  String ButtonState='Add';
  
  // List<String> locations = [
  //   'Back Door',
  //   'Front Door',
  // ];

  List<Location> locations = [];
  Future <void> getLocations() async{
    try{
      var request = http.MultipartRequest('GET',Uri.parse('${APIHandler.ip}/GetAllLocations'),);
      var response = await request.send();
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(await response.stream.bytesToString());
        setState(() {
          locations = jsonResponse
              .map((json) => Location.fromJson(json))
              .where((location) => location.type == 'Gate') // Filter by type
              .toList();
          dropdownOptions =
              locations.map((location) => location.name).toList();
          print(jsonResponse);
          print(locations);
          getLocationName();
        });
      }
    }catch (e) {
      print('Error submitting form: $e');
    }
  }

  void getLocationName() {
    int? locationId = GuardGlobal.guardGlobalDutyLocation;
    print(locationId);
    print(locations);

    // Ensure locations is not empty before trying to find the selected location
    if (locations.isNotEmpty) {
      Location? selectedLocation = locations.firstWhere(
        (location) => location.id == locationId,
      );
      print(selectedLocation);
      if (selectedLocation != null) {
        setState(() {
          location = selectedLocation.name;
          print(location);
          if(location==Null){
            ButtonState="Add";
            print('Add');
          }
          else{
            print('Update');
            ButtonState="Update";
          }
        });
      } else {
        print('Location not found for ID: $locationId');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getLocations();
    
  }

  Future<Map<String, dynamic>> allocateDutyLocation(int id, int locationId) async {
    try {
      final response = await http.put(
        Uri.parse('${APIHandler.ip}/AllocateDutyLocation/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'location_id': locationId}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        GuardGlobal.guardGlobalDutyLocation=locationId;
        showSuccessDialog();
        return jsonResponse;
      } else {
        print('Failed to update guard duty location. Status code: ${response.statusCode}');
        showErrorDialog('Failed to update guard duty location.');
        return {'error': 'Failed to update guard duty location.'};
      }
    } catch (e) {
      print('Error updating guard duty location: $e');
      showErrorDialog('Error updating guard duty location.: $e');
      return {'error': 'Failed to update guard duty location.'};
    }
  }

  void showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Duty location updated successfully!'),
          actions: [
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
  void showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(errorMessage),
          actions: [
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
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
              Text('Settings',style: TextStyle(fontSize: 25,color: Colors.blue),),
              SizedBox(height: 25,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Container(
                    // width: double.infinity, // Make the dropdown full-width
                    // child: DropdownButton<String>(
                      DropdownButton<String>(
                      value: selectedLocation,
                      hint: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Allocated Location',
                            style: TextStyle( color: Colors.black),
                          ),
                          SizedBox(width: 135,),
                          Text(
                            '${location}',
                            style: TextStyle( color: Colors.black),
                          ),
                        ],
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedLocation = newValue;
                          print(selectedLocation);
                          // location=newValue!;
                          // Find the selected location by name
                          Location? selectedLocationObj = locations.firstWhere(
                            (location) => location.name == selectedLocation,
                          );

                          if (selectedLocationObj != null) {
                            // Store the selected location ID in a separate variable
                            selectedLocationId = selectedLocationObj.id;
                            print(selectedLocationId);
                          }

                          // Update the location variable
                          // location = newValue!;
                        });
                      },
                      isExpanded: true,
                      icon: Icon(Icons.keyboard_arrow_down_rounded,color: Colors.black,),
                      items: dropdownOptions.map((String location) {
                        return DropdownMenuItem<String>(
                          value: location,
                          child: Text(location),
                        );
                      }).toList(),
                    ),
                  // ),
                ],
              ),
              Divider(
                thickness: .5,
                color: Colors.grey,
              ),
              SizedBox(height: 15,),
              GestureDetector(
                  onTap: (){
                    allocateDutyLocation(guardId!,selectedLocationId!);
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
                        child: Text(ButtonState=='Add'? 'Add Guard Location': 'Update Guard Location',style: TextStyle(fontSize: 20,color: Colors.white),),
                      ),
                    ),
                  )
                )
            ],
          ),
        ),
      ),
    );
  }
}