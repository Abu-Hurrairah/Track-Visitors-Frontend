import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project/APIHandler/api.dart';
import 'package:http/http.dart' as http;
import 'package:project/Model/LocationModel.dart';

class ReRouteVisitorScreen extends StatefulWidget {
  const ReRouteVisitorScreen({super.key});

  @override
  State<ReRouteVisitorScreen> createState() => _ReRouteVisitorScreenState();
}

class _ReRouteVisitorScreenState extends State<ReRouteVisitorScreen> {

  dynamic selectedVisitor;
  int? selectedVisitorId;
  bool isLoading = true;

  List<dynamic> visitors = [];
  List<String> visitorsKeys = [];
  List<Map<String, dynamic>> visitorsList = [];
  Future<void> getCurrentVisitors() async {
    setState(() {
      isLoading = true; // Set loading to true when starting API call
    });
    final url = Uri.parse('${APIHandler.ip}/GetCurrentVisitors'); 
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          visitors = jsonResponse;
          visitorsList = List<Map<String, dynamic>>.from(jsonResponse);
          visitorsKeys = extractMapKeys(visitorsList);
          print('visitorsKeys: $visitorsKeys');
          isLoading = false; // Set loading to false when API call completes
          print('visitors: $visitors');
          print(visitors.runtimeType);
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

  List<String> locationDropdownOptions=[];
  List<int> locationIds = []; // Added list for location IDs
  String? selectedLocation;
  int? selectedLocationId;
  List<Location> locations = [];
  Future <void> getLocations() async{
    try{
      var request = http.MultipartRequest('GET',Uri.parse('${APIHandler.ip}/GetAllLocations'),);
      var response = await request.send();
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(await response.stream.bytesToString());
        setState(() {
          locations = jsonResponse.map((json) => Location.fromJson(json)).toList();
          locationDropdownOptions = locations.map((location) => location.name).toList();
          print(locationDropdownOptions);
          locationIds = locations.map((location) => location.id).toList(); // Added location IDs
          // Clear the dropdownOptions Set
          // locationTypes.clear();

          // Add unique floor names to dropdownOptions
          // for (var location in locations) {
          //   locationTypes.add(location.type);
          // }
          // filteredLocations=locations;
          print(jsonResponse);
        });
      }
    }catch (e) {
      print('Error submitting form: $e');
    }
  }

  Widget buildLocationDropdown() {
    // Display location names
    if (locationDropdownOptions.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Text('Locations', style: TextStyle(fontSize: 20, color: Colors.white)),
          Divider(height: 10, thickness: 2, color: Colors.white),
          DropdownButton<String>(
            hint: Text('Select Location'),
            value: selectedLocation,
            items: locationDropdownOptions
                .map<DropdownMenuItem<String>>((String location) {
              return DropdownMenuItem<String>(
                value: location,
                child: Text(location),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedLocation = newValue;
                print(selectedLocation);
                int index = locationDropdownOptions.indexOf(selectedLocation!);
                if (index != -1 && index < locationIds.length) {
                  selectedLocationId = locationIds[index];
                  print('Selected Location ID: $selectedLocationId');
                }
              });
            },
          ),
        ],
      );
    } else {
      // Return an empty container if the condition is not met
      return Container();
    }
  }

  List<String> extractMapKeys(List<Map<String, dynamic>> maps) {
    List<String> keys = [];
    for (var map in maps) {
      keys.addAll(map.keys);
    }
    return keys;
  }

  Map<String,dynamic> destinations = {};
  List<String> destinationNames = [];
  List<int> destinationIds = []; // Added list for destination IDs
  List<String> destinationKeys = [];
  Future<void> getVisitorDestinations(int visitorId) async {
    final url = Uri.parse('${APIHandler.ip}/GetVisitDestinations?id=$visitorId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData);
        setState(() {
          destinations = responseData;
          destinationNames = List<String>.from(responseData['visit_destinations_names']);
          print('destinationNames: $destinationNames');
          destinationIds = List<int>.from(responseData['visit_destinations']); // Added destination IDs
          print('destinationIds: $destinationIds');
          destinationKeys = destinations.keys.toList();
          print('destinationKeys: $destinationKeys');
          print(destinations);
        });
      } else {
        print('Failed to fetch visitor destinations: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching visitor destinations: $e');
    }
  }

  String? selectedDestination;
  List<String> destinationDropdownItems = [];
  void updateDestinationDropdownItems() {
    // Update destinationDropdownItems based on the selectedVisitorId
    // You can fetch destination names or use the existing data based on your logic.
    // For simplicity, I'll assume you want to use the existing destinationNames.
    setState(() {
      destinationDropdownItems = List<String>.from(destinationNames);
    });
    print('destinationDropdownItems: $destinationDropdownItems');
    setState(() {
      
    });
  }

  int? selectedDestinationId; // Added variable to store selected destination ID
  void onDestinationSelected(String? newValue) {
    setState(() {
      selectedDestination = newValue;
      int index = destinationNames.indexOf(selectedDestination!);
      if (index != -1 && index < destinationIds.length) {
        selectedDestinationId = destinationIds[index];
        print('Selected Destination ID: $selectedDestinationId');
      }
    });
  }

  Widget buildDestinationNames() {
    // Display destination names
    if (destinationNames.isNotEmpty) {
      setState(() {
      
    });
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Text('Current Destinations',style: TextStyle(fontSize: 20,color: Colors.white),),
          // SizedBox(height: 5,),
          Divider(height: 10,thickness: 2,color: Colors.white,),
          // SizedBox(height: 5,),
          Text(
            '${destinationNames.join(', ')}',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          // for (String destinationName in destinationNames)
          //   Text('$destinationName, ',style: TextStyle(fontSize: 15,color: Colors.blue),),
        ],
      );
    } else {
      // Return an empty container if the condition is not met
      return Container();
    }
  }


  @override
  void initState() {
    super.initState();
    getCurrentVisitors();
    getLocations();
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: const EdgeInsets.all(25.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DropdownButton<dynamic>(
                    hint: Text('Select Visitor'),
                    value: selectedVisitor,
                    items: visitors.map<DropdownMenuItem<dynamic>>(
                      (dynamic visitor) {
                        return DropdownMenuItem<dynamic>(
                          value: visitor,
                          child: Text('${visitor['name']}'), // Change this to match your visitor data structure
                        );
                      },
                    ).toList(),
                    onChanged: (dynamic newValue) async{
                      setState(() {
                        selectedVisitor = newValue;
                        print(selectedVisitor);
                        print(selectedVisitor.runtimeType);
                        selectedVisitorId = newValue['id'];
                        print(selectedVisitorId);
                        
                      });
                      await getVisitorDestinations(selectedVisitorId!); // Fetch destinations for the selected visitor
                      updateDestinationDropdownItems();
                      print('s');
                    },
                  ),
                  Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: buildDestinationNames(),
                    ),// Display destination names
                  ),
                  // // Display destinations
                  // if (destinations.isNotEmpty)
                  //   Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       SizedBox(height: 20),
                  //       Text('Destinations for $selectedVisitor:'),
                  //       for (var entry in destinations.entries)
                  //         Text('${entry.key}: ${entry.value}'),
                  //     ],
                  //   ),

                  SizedBox(height: 20),
                  DropdownButton<String>(
                    hint: Text('Select Destination'),
                    value: selectedDestination,
                    items: destinationDropdownItems
                        .map<DropdownMenuItem<String>>(
                            (String destination) {
                          return DropdownMenuItem<String>(
                            value: destination,
                            child: Text(destination),
                          );
                        }).toList(),
                    onChanged: onDestinationSelected,
                    // onChanged: (String? newValue) {
                    //   setState(() {
                    //     selectedDestination = newValue;
                    //   });
                    // },
                  ),
                  SizedBox(height: 20,),
                  Text('Locations'),
                  buildLocationDropdown(),
                  SizedBox(height: 25,),
                  ElevatedButton(
                    onPressed: (){}, 
                    child: Text('Re Route')
                  )
                ],
              ),
            ),
          ),
    );
  }
}