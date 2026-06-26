import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project/APIHandler/api.dart';
import 'package:project/CommonUtils.dart/LogoutConfirmationDialog.dart';
import 'package:project/Model/LocationModel.dart';
import 'package:project/Screens/Admin.dart';
import 'package:http/http.dart' as http;

class PathsScreen extends StatefulWidget {
  const PathsScreen({super.key});

  @override
  State<PathsScreen> createState() => _PathsScreenState();
}

class _PathsScreenState extends State<PathsScreen> {
  TextEditingController controller_source=TextEditingController();
  TextEditingController controller_destination=TextEditingController();
  String? selectedSourceValue;
  String? selectedDestinationValue;
  List<String> selectDestinations=[];
  Set<String> locationTypes= {};
  bool result=false;
  List<bool> isExpandedList = [];
  List<List<String>> locationPaths = [];

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
            locationTypes.add(location.name);
          }
          print(jsonResponse);
        });
      }
    }catch (e) {
      print('Error submitting form: $e');
    }
  }

  int getLocationIdByName(String name) {
    print('g');
    final location = locations.firstWhere((loc) => loc.name == name);
    print(location);
    return location != null ? location.id : -1; // Return -1 if not found (handle error)
  }

  List<int> getLocationIdsByNames(List<String> names) {
    print('s');
    List<int> ids = [];
    selectDestinations=names;
    print(selectDestinations);
    for (String name in selectDestinations) {
      final location = locations.firstWhere((loc) => loc.name == name);
      if (location != null) {
        ids.add(location.id);
        print('starting');
      } else {
        // Handle the case where a location name is not found
        ids.add(-1); // Or any other error handling logic
      }
    }

    return ids;
  }

  void getLocationPaths(String source, List<String> destinations) async {
    print(source);
    print(destinations);
    int selectSourceId=getLocationIdByName(source);
    List<int> selectedDestinationIds = getLocationIdsByNames(destinations);
    try {
      var data = {
        'source': selectSourceId,
        'destinations': selectedDestinationIds,
      };

      var headers = {
        'Content-Type': 'application/json',
      };

      var response = await http.post(
        Uri.parse('${APIHandler.ip}/GetLocationPaths'),
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        print(jsonData);
        
        if (jsonData is List) {
          locationPaths = jsonData
              .map((locationPath) => List<String>.from(locationPath))
              .toList();
        }
        isExpandedList = List<bool>.generate(locationPaths.length, (index) => false);
        print('Location Paths: $locationPaths');
        result=true;
        setState(() {
          
        });
      } else {
        // Handle error cases, you might want to throw an exception or print an error message
        print('API request failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle exceptions
      print('Error: $error');
    }
  }

  Future <void> _showDropDownDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false, // Set to false to disable closing on tap outside
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Select Destinations"),
              content: Container(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      for (String destination in locationTypes)
                        CheckboxListTile(
                          title: Text(destination),
                          value: selectDestinations!.contains(destination),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value != null) {
                                if (value) {
                                  selectDestinations!.add(destination);
                                  // selectDestinations.add(destination);
                                  // selectedDestination = '$destination, ';
                                  // setState((){});
                                  // print(selectDestinations);
                                } else {
                                  selectDestinations!.remove(destination);
                                  // selectDestinations.remove(destination);
                                }
                              }
                            });
                          },
                        ),
                    ],
                  ),
                ),
              ),
              actions: [
                // TextButton(
                //   onPressed: () {
                //     setState((){});
                //     Navigator.pop(context);
                //   },
                //   child: Text("Cancel"),
                // ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedDestinationValue = selectDestinations!.isNotEmpty ? selectDestinations!.join(', ') : null;
                      print(selectDestinations);
                      print(selectDestinations);
                    });
                    Navigator.pop(context);
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getLocations();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Text('Paths',style: TextStyle(fontSize: 30,color: Colors.blue),),
              SizedBox(height: 30,),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Source',
                  style: TextStyle(fontSize: 20, color: Colors.blue),
                ),
              ),
              // SizedBox(height: 5,),
              DropdownButton(
                hint: Text('Select Source',style: TextStyle(color: Colors.blue),),
                icon: Icon(Icons.arrow_drop_down,color: Colors.blue,),
                // icon: Icon(Icons.arrow_circle_down),
                // underline: Text('__________'),
                isExpanded: true,
                // enableFeedback: true,
                // dropdownColor: Colors.blue,
                // borderRadius: BorderRadius.circular(10),
                // menuMaxHeight: 60,
                value: selectedSourceValue,
                items: locationTypes.map((e) => DropdownMenuItem(
                  child: Text(e),
                  value: e,
                )).toList(), 
                onChanged: (String? value){
                  setState(() {
                    selectedSourceValue=value;
                  });
                }
              ),
              SizedBox(height: 10,),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Destination',
                  style: TextStyle(fontSize: 20, color: Colors.blue),
                ),
              ),
              SizedBox(height: 5,),
              GestureDetector(
                onTap: () async {
                  await _showDropDownDialog(context);
                  setState(() {
                    
                  });
                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(selectedDestinationValue?.isNotEmpty == true ? selectedDestinationValue! : 'Select Destination')),
                        // Text(selectedDestination ?? 'Select Destination'),
                        Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
              ),
              // DropdownButton(
              //   hint: Text('Select Destination',style: TextStyle(color: Colors.blue),),
              //   icon: Icon(Icons.arrow_drop_down,color: Colors.blue,),
              //   // icon: Icon(Icons.arrow_circle_down),
              //   // underline: Text('__________'),
              //   isExpanded: true,
              //   // enableFeedback: true,
              //   // dropdownColor: Colors.blue,
              //   // borderRadius: BorderRadius.circular(10),
              //   // menuMaxHeight: 60,
              //   value: selectedDestinationValue,
              //   items: locationTypes.map((e) => DropdownMenuItem(
              //     child: Text(e),
              //     value: e,
              //   )).toList(), 
              //   onChanged: (String? value){
              //     setState(() {
              //       selectedDestinationValue=value;
              //     });
              //   }
              // ),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  setState(() {
                    if(selectedSourceValue==null || selectedDestinationValue==null){
                      return;
                    }
                    else {
                      getLocationPaths(selectedSourceValue!,selectDestinations!);
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
                      child: Text('Possible Paths',style: TextStyle(fontSize: 20,color: Colors.white),),
                    ),
                  ),
                )
              ),
              SizedBox(height: 20,),
              if (result)
                Text('Destination Paths',style: TextStyle(fontSize: 30,color: Colors.blue),),
              SizedBox(height: 10,),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: locationPaths.length,
                itemBuilder: (context, index) {
                  final locationPath = locationPaths[index];
                  final locationPathIndex = index + 1;
                  final isExpanded = isExpandedList[index];

                  return Card(
                    margin: EdgeInsets.all(16.0),
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Path $locationPathIndex:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue
                                ),
                              ),
                              IconButton(
                                icon: Icon(isExpanded ? Icons.fullscreen_exit_outlined : Icons.fullscreen_outlined),
                                onPressed: () {
                                  setState(() {
                                    isExpandedList[index] = !isExpanded;
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          isExpanded?
                            Container(
                              child: Wrap(
                                spacing: 15,
                                runSpacing: 4,
                                children: locationPath.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final step = entry.value;
                                  final isLast = index == locationPath.length - 1;
                                  return RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: isLast ? '$step' : '$step --> ',
                                          style: TextStyle(color: Colors.blue), // Change the color here
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList() ?? [],
                              ),
                            ):
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Wrap(
                                spacing: 15,
                                runSpacing: 4,
                                children: locationPath.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final step = entry.value;
                                  final isLast = index == locationPath.length - 1;
                                  return RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: isLast ? '$step' : '$step --> ',
                                          style: TextStyle(color: Colors.blue), // Change the color here
                                        ),
                                      ],
                                    ),
                                  );

                                  // return GestureDetector(
                                  //   onTap: () {
                                  //     List<String> c=cameraValue;
                                  //     print(cameraValue);
                                  //     print(c);
                                  //     c.removeWhere((item) => item == 'C1');
                                  //     print(cameraValue);
                                  //     print(c);
                                  //     if (step!='C1' && c.contains(step)){
                                  //       imageBytes!=null?Navigator.of(context).push(
                                  //         MaterialPageRoute(builder: (context){
                                  //           return ShowImageScreen(imageBytes);
                                  //         })
                                  //       ):showDialog(
                                  //         context: context,
                                  //         builder: (context) {
                                  //           return AlertDialog(
                                  //             title: Text('Path:${pathIndex}, $step'),
                                  //           );
                                  //         },
                                  //       );
                                  //     }
                                  //     if(step=='C1') {
                                  //       showDialog(
                                  //         context: context,
                                  //         builder: (context) {
                                  //           return AlertDialog(
                                  //             title: Text('Gate Position'),
                                  //           );
                                  //         },
                                  //       );
                                  //     }
                                  //     else{
                                  //       showDialog(
                                  //         context: context,
                                  //         builder: (context) {
                                  //           return AlertDialog(
                                  //             title: Text('Path:${pathIndex}, $step'),
                                  //           );
                                  //         },
                                  //       );
                                  //     }
                                  //   },
                                  //   child: Column(
                                  //     children: [
                                  //       step=='C1'?Text(widget.startTime,):SizedBox(height: 19.5,),
                                  //       step==camValue && result?Text(timeValue!):SizedBox(height: 19.5,),
                                  //       MouseRegion(
                                  //         cursor: SystemMouseCursors.click,
                                  //         child: Stack(
                                  //           children: [
                                  //             Chip(
                                  //               label: Text(step),
                                  //               backgroundColor: cameraValue.contains(step) ? Colors.blue[800] : Colors.blue,
                                  //               labelStyle: TextStyle(color: Colors.white),
                                  //             ),
                                  //             Positioned(
                                  //               top: 8,
                                  //               right: 5,
                                  //               child: Container(
                                  //                 width: 10,
                                  //                 height: 10,
                                  //                 decoration: BoxDecoration(
                                  //                   shape: BoxShape.circle,
                                  //                   color: cameraValue.contains(step) ? Colors.green[800] : Colors.red,
                                  //                 ),
                                  //               ),
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // );
                                }).toList() ?? [],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ]
          ),
        )
      ),
    );
  }
}